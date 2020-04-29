//
// Copyright (c) 2016 OnePoint Global Ltd. All rights reserved.
//
// This code is licensed under the OnePoint Global License.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//

#import "OPGMediaPickerAndPreviewPlugin.h"
#import "OPGJpegHeaderWriter.h"
#import "NSArray+Comparisons.h"
#import "NSData+OPGBase64.h"
#import "NSDictionary+Extensions.h"
#import <ImageIO/CGImageProperties.h>
#import <AssetsLibrary/ALAssetRepresentation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <ImageIO/CGImageSource.h>
#import <ImageIO/CGImageProperties.h>
#import <ImageIO/CGImageDestination.h>
#import <MobileCoreServices/UTCoreTypes.h>
#import "OPGSBJSON.h"
#import "NSObject+OPGSBJSON.h"
#import "NSString+OPGSBJSON.h"
#import "UIImage+CropScaleOrientation.h"
#define CDV_PHOTO_PREFIX @"cdv_photo_"
#define CDV_AUDIO_PREFIX @"cdv_audio_"
#import "OPGFile.h"
#import "OPGJSON.h"
#import "OPGAvailability.h"
#import <objc/message.h>
#ifndef __CORDOVA_4_0_0
#import "NSData+OPGBase64.h"
#endif

#define kW3CMediaFormatHeight @"height"
#define kW3CMediaFormatWidth @"width"
#define kW3CMediaFormatCodecs @"codecs"
#define kW3CMediaFormatBitrate @"bitrate"
#define kW3CMediaFormatDuration @"duration"
#define kW3CMediaModeType @"type"
#define MEDIA_MODE_CAPTURE 1
#define MEDIA_MODE_GALLERY 2
#define PluginLocalizedString(plugin, key, comment) [[NSBundle pluginBundle:(plugin)] localizedStringForKey:(key) value:nil table:nil]

static NSSet* org_apache_cordova_validArrowDirections;

static NSString* toBase64(NSData* data) {
    SEL s1 = NSSelectorFromString(@"cdv_base64EncodedString");
    SEL s2 = NSSelectorFromString(@"base64EncodedString");
    SEL s3 = NSSelectorFromString(@"base64EncodedStringWithOptions:");
    
    if ([data respondsToSelector:s1]) {
        NSString* (*func)(id, SEL) = (void *)[data methodForSelector:s1];
        return func(data, s1);
    } else if ([data respondsToSelector:s2]) {
        NSString* (*func)(id, SEL) = (void *)[data methodForSelector:s2];
        return func(data, s2);
    } else if ([data respondsToSelector:s3]) {
        NSString* (*func)(id, SEL, NSUInteger) = (void *)[data methodForSelector:s3];
        return func(data, s3, 0);
    } else {
        return nil;
    }
}
@implementation NSBundle (PluginExtensions)

+ (NSBundle*) pluginBundle:(OPGPlugin*)plugin {
    NSBundle* bundle = [NSBundle bundleWithPath: [[NSBundle mainBundle] pathForResource:NSStringFromClass([plugin class]) ofType: @"bundle"]];
    return bundle;
}
@end


@implementation OPGPictureOptionsNew

+ (instancetype) createFromTakePictureArguments:(OPGInvokedUrlCommand*)command
{
    OPGPictureOptionsNew* pictureOptions = [[OPGPictureOptionsNew alloc] init];
    
    pictureOptions.quality = @50;
    pictureOptions.destinationType = DestinationTypeFileUri;
    pictureOptions.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    NSNumber* targetWidth = [command argumentAtIndex:3 withDefault:nil];
    NSNumber* targetHeight = [command argumentAtIndex:4 withDefault:nil];
    pictureOptions.targetSize = CGSizeMake(0, 0);
    if ((targetWidth != nil) && (targetHeight != nil)) {
        pictureOptions.targetSize = CGSizeMake([targetWidth floatValue], [targetHeight floatValue]);
    }
    pictureOptions.encodingType = EncodingTypeJPEG;
    pictureOptions.mediaType = MediaTypePicture;
    pictureOptions.allowsEditing = NO;
    pictureOptions.correctOrientation = YES;
    pictureOptions.saveToPhotoAlbum = NO;
    pictureOptions.popoverOptions = [command argumentAtIndex:10 withDefault:nil];
    pictureOptions.cameraDirection =UIImagePickerControllerCameraDeviceRear;
    
    return pictureOptions;
}

@end

@implementation OPGImagePickerNew

@synthesize quality;
@synthesize callbackId;
@synthesize mimeType;

- (uint64_t)accessibilityTraits
{
    NSString* systemVersion = [[UIDevice currentDevice] systemVersion];
    
    if (([systemVersion compare:@"4.0" options:NSNumericSearch] != NSOrderedAscending)) { // this means system version is not less than 4.0
        return UIAccessibilityTraitStartsMediaSession;
    }
    
    return UIAccessibilityTraitNone;
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (UIViewController*)childViewControllerForStatusBarHidden {
    return nil;
}

- (void)viewWillAppear:(BOOL)animated {
    SEL sel = NSSelectorFromString(@"setNeedsStatusBarAppearanceUpdate");
    if ([self respondsToSelector:sel]) {
        [self performSelector:sel withObject:nil afterDelay:0];
    }
    
    [super viewWillAppear:animated];
}

@end
@interface OPGMediaPickerAndPreviewPlugin ()

@property (readwrite, assign) BOOL hasPendingOperation;

@end
static AVAudioRecorder* avRecorder=nil;
static AVAudioSession* avSession=nil;
static AVAudioPlayer* avPlayer=nil;
@implementation OPGMediaPickerAndPreviewPlugin
@synthesize inUse;
UIActivityIndicatorView *spinner;
- (void)pluginInitialize
{
    self.inUse = NO;
}

+ (void)initialize
{
    org_apache_cordova_validArrowDirections = [[NSSet alloc] initWithObjects:[NSNumber numberWithInt:UIPopoverArrowDirectionUp], [NSNumber numberWithInt:UIPopoverArrowDirectionDown], [NSNumber numberWithInt:UIPopoverArrowDirectionLeft], [NSNumber numberWithInt:UIPopoverArrowDirectionRight], [NSNumber numberWithInt:UIPopoverArrowDirectionAny], nil];
    NSString* docsPath = [NSTemporaryDirectory()stringByStandardizingPath];   // use file system temporary directory
    NSError* err = nil;
    NSFileManager* fileMgr = [[NSFileManager alloc] init];
    
    // generate unique file name
    NSString* filePath;
    int i = 1;
    do {
        filePath = [NSString stringWithFormat:@"%@/audio_%03d.wav", docsPath, i++];
    } while ([fileMgr fileExistsAtPath:filePath]);
    
    NSURL* fileURL = [NSURL fileURLWithPath:filePath isDirectory:NO];
    
    // create AVAudioPlayer
    if (!avRecorder) {
       avRecorder = [[AVAudioRecorder alloc] initWithURL:fileURL settings:nil error:&err];
    }
    if (!avSession) {
      avSession = [AVAudioSession sharedInstance];
    }
}

@synthesize hasPendingOperation, pickerController, locationManager;

- (NSURL*) urlTransformer:(NSURL*)url
{
    NSURL* urlToTransform = url;
    
    // for backwards compatibility - we check if this property is there
    SEL sel = NSSelectorFromString(@"urlTransformer");
    if ([self.commandDelegate respondsToSelector:sel]) {
        // grab the block from the commandDelegate
        NSURL* (^urlTransformer)(NSURL*) = ((id(*)(id, SEL))objc_msgSend)(self.commandDelegate, sel);
        // if block is not null, we call it
        if (urlTransformer) {
            urlToTransform = urlTransformer(url);
        }
    }
    
    return urlToTransform;
}

- (BOOL)usesGeolocation
{
    id useGeo = [self.commandDelegate.settings objectForKey:[@"CameraUsesGeolocation" lowercaseString]];
    return [(NSNumber*)useGeo boolValue];
}

- (BOOL)popoverSupported
{
    return (NSClassFromString(@"UIPopoverController") != nil) &&
    (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad);
}
/*  takePicture arguments:
 * INDEX   ARGUMENT
 *  0       quality
 *  1       destination type
 *  2       source type
 *  3       targetWidth
 *  4       targetHeight
 *  5       encodingType
 *  6       mediaType
 *  7       allowsEdit
 *  8       correctOrientation
 *  9       saveToPhotoAlbum
 *  10      popoverOptions
 *  11      cameraDirection
 */
- (void)takePicture:(OPGInvokedUrlCommand*)command sourceType:(NSString*)mediatype
{
    self.hasPendingOperation = YES;
    
    __weak OPGMediaPickerAndPreviewPlugin* weakSelf = self;
    
    [self.commandDelegate runInBackground:^{
        
        // Validate the app has permission to access the photoLibrary
        //[AVCaptureDevice respondsToSelector:@selector(authorizationStatusForMediaType:)]
        ALAuthorizationStatus authStatus = [ALAssetsLibrary authorizationStatus];
        if (authStatus == ALAuthorizationStatusDenied ||
            authStatus == ALAuthorizationStatusRestricted) {
            CallbackId=command.callbackId;
            // If iOS 8+, offer a link to the Settings app
            NSString* settingsButton = (&UIApplicationOpenSettingsURLString != NULL)
            ? NSLocalizedString(@"Settings", nil)
            : nil;
            
            // Denied; show an alert
            dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:[[NSBundle mainBundle]objectForInfoDictionaryKey:@"CFBundleDisplayName"]
                                                             message:NSLocalizedString(@"Access to the Gallery has been prohibited; please enable it in the Settings app to continue.", nil)
                                                            delegate:self cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:settingsButton, nil];
                alert.tag=1;
                [alert  show];
                return ;
            });
        }

        OPGPictureOptionsNew* pictureOptions = [OPGPictureOptionsNew createFromTakePictureArguments:command];
        pictureOptions.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
        pictureOptions.popoverSupported = [weakSelf popoverSupported];
        pictureOptions.usesGeolocation = [weakSelf usesGeolocation];
        pictureOptions.cropToSize = NO;
        
        BOOL hasCamera = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary];
        if (!hasCamera) {
            NSLog(@"Camera.getPicture: source type %lu not available.", (unsigned long)UIImagePickerControllerSourceTypePhotoLibrary);
            OPGPluginResult* result = [OPGPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"No camera available"];
            [weakSelf.commandDelegate sendPluginResult:result callbackId:command.callbackId];
            return;
        }
        
        OPGCameraPickerNew* cameraPicker =[OPGCameraPickerNew createFromPictureOptions:pictureOptions];
        weakSelf.pickerController = cameraPicker;
        
        cameraPicker.delegate = weakSelf;
        cameraPicker.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
        cameraPicker.mediaTypes=[mediatype isEqualToString:@"video"]?[NSArray arrayWithObjects:(NSString*)kUTTypeMovie, nil]:[NSArray arrayWithObjects:(NSString*)kUTTypeImage, nil];
        cameraPicker.callbackId = command.callbackId;
        // we need to capture this state for memory warnings that dealloc this object
        cameraPicker.webView = weakSelf.webView;
        
        // Perform UI operations on the main thread
        dispatch_async(dispatch_get_main_queue(), ^{
            // If a popover is already open, close it; we only want one at a time.
            if (([[weakSelf pickerController] pickerPopoverController] != nil) && [[[weakSelf pickerController] pickerPopoverController] isPopoverVisible]) {
                [[[weakSelf pickerController] pickerPopoverController] dismissPopoverAnimated:YES];
                [[[weakSelf pickerController] pickerPopoverController] setDelegate:nil];
                [[weakSelf pickerController] setPickerPopoverController:nil];
            }
            
            if ([weakSelf popoverSupported] && (pictureOptions.sourceType != UIImagePickerControllerSourceTypeCamera)) {
                if (cameraPicker.pickerPopoverController == nil) {
                    cameraPicker.pickerPopoverController = [[NSClassFromString(@"UIPopoverController") alloc] initWithContentViewController:cameraPicker];
                }
                [weakSelf displayPopover:[command.arguments objectAtIndex:0]];
                weakSelf.hasPendingOperation = NO;
            } else {
                [weakSelf.viewController presentViewController:cameraPicker animated:YES completion:^{
                    weakSelf.hasPendingOperation = NO;
                }];
            }
        });
    }];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    NSString *Errormsg;
    switch (alertView.tag) {
        case 1:
            if (([[self pickerController] pickerPopoverController] != nil) && [[[self pickerController] pickerPopoverController] isPopoverVisible]) {
                [[[self pickerController] pickerPopoverController] dismissPopoverAnimated:YES];
                [[[self pickerController] pickerPopoverController] setDelegate:nil];
                [[self pickerController] setPickerPopoverController:nil];
            }
            Errormsg=@"Error Occured in Access photo";
            break;
        case 2:
            Errormsg=@"Error Occured in Recording Audio";
            break;
        case 3:
           Errormsg=@"Error Occured in Capture photo";
            break;
        case 4:
            Errormsg=@"Error Occured in Capture video";
          break;
        default:
            break;
    }
    if (buttonIndex == 1) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
    }
    if (buttonIndex == 0) {
        NSDictionary *ldict=[[NSDictionary alloc]initWithObjectsAndKeys:Errormsg ,@"Error", nil];
        [self errorCallBack:[ldict JSONRepresentation] withcallbackId:CallbackId];
    }
}

- (void)pickImageFromGallery:(OPGInvokedUrlCommand*)command
{
    
    mediaMode=MEDIA_MODE_GALLERY;
    [self takePicture:command sourceType:@"image"];
}
- (void)pickVideoFromGallery:(OPGInvokedUrlCommand*)command
{
    mediaMode=MEDIA_MODE_GALLERY;
     [self takePicture:command sourceType:@"video"];
}
- (void)displayPopover:(NSDictionary*)options
{
    NSInteger x = 0;
    NSInteger y = 32;
    NSInteger width = 320;
    NSInteger height = 480;
    UIPopoverArrowDirection arrowDirection = UIPopoverArrowDirectionAny;
    
    if (options) {
        x = [[options valueForKey:@"left"]intValue];
        y = [[options valueForKey:@"top"]intValue];
        CGRect screenRect = [[UIScreen mainScreen] bounds];
        CGFloat screenWidth = screenRect.size.width;
        // CGFloat screenHeight = screenRect.size.height;
        if(x>=screenWidth/2){
            arrowDirection=UIPopoverArrowDirectionRight;
        }
        if(x<=screenWidth/2){
            arrowDirection=UIPopoverArrowDirectionLeft;
        }
    }
    
    [[[self pickerController] pickerPopoverController] setDelegate:self];
    [[[self pickerController] pickerPopoverController] presentPopoverFromRect:CGRectMake(x, y-480/2, width, height)
                                                                       inView:[self.webView superview]
                                                     permittedArrowDirections:arrowDirection
                                                                     animated:YES];
}
- (NSInteger)integerValueForKey:(NSDictionary*)dict key:(NSString*)key defaultValue:(NSInteger)defaultValue
{
    NSInteger value = defaultValue;
    
    NSNumber* val = [dict valueForKey:key];  // value is an NSNumber
    
    if (val != nil) {
        value = [val integerValue];
    }
    return value;
}

- (void)repositionPopover:(OPGInvokedUrlCommand*)command
{
    NSDictionary* options = [command argumentAtIndex:0 withDefault:nil];
    
    [self displayPopover:options];
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if([navigationController isKindOfClass:[UIImagePickerController class]]){
        UIImagePickerController* cameraPicker = (UIImagePickerController*)navigationController;
        
        if(![cameraPicker.mediaTypes containsObject:(NSString*)kUTTypeImage]){
            [viewController.navigationItem setTitle:NSLocalizedString(@"Videos", nil)];
        }
    }
}

- (void)cleanup:(OPGInvokedUrlCommand*)command
{
    // empty the tmp directory
    NSFileManager* fileMgr = [[NSFileManager alloc] init];
    NSError* err = nil;
    BOOL hasErrors = NO;
    
    // clear contents of NSTemporaryDirectory
    NSString* tempDirectoryPath = NSTemporaryDirectory();
    NSDirectoryEnumerator* directoryEnumerator = [fileMgr enumeratorAtPath:tempDirectoryPath];
    NSString* fileName = nil;
    BOOL result;
    
    while ((fileName = [directoryEnumerator nextObject])) {
        // only delete the files we created
        if (![fileName hasPrefix:CDV_PHOTO_PREFIX]) {
            continue;
        }
        NSString* filePath = [tempDirectoryPath stringByAppendingPathComponent:fileName];
        result = [fileMgr removeItemAtPath:filePath error:&err];
        if (!result && err) {
            NSLog(@"Failed to delete: %@ (error: %@)", filePath, err);
            hasErrors = YES;
        }
    }
    
    OPGPluginResult* lpluginResult;
    if (hasErrors) {
        lpluginResult = [OPGPluginResult resultWithStatus:CDVCommandStatus_IO_EXCEPTION messageAsString:@"One or more files failed to be deleted."];
    } else {
        lpluginResult = [OPGPluginResult resultWithStatus:CDVCommandStatus_OK];
    }
    [self.commandDelegate sendPluginResult:lpluginResult callbackId:command.callbackId];
}

- (void)popoverControllerDidDismissPopover:(id)popoverController
{
    UIPopoverController* pc = (UIPopoverController*)popoverController;
    
    [pc dismissPopoverAnimated:YES];
    pc.delegate = nil;
    if (self.pickerController && self.pickerController.callbackId && self.pickerController.pickerPopoverController) {
        self.pickerController.pickerPopoverController = nil;
        NSString* callbackId = self.pickerController.callbackId;
        OPGPluginResult* result = [OPGPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"no image selected"];   // error callback expects string ATM
        [self.commandDelegate sendPluginResult:result callbackId:callbackId];
    }
    self.hasPendingOperation = NO;
}

- (NSData*)processImage:(UIImage*)image info:(NSDictionary*)info options:(OPGPictureOptionsNew*)options
{
    NSData* data = nil;

    switch (options.encodingType) {
        case EncodingTypePNG:
            data = UIImagePNGRepresentation(image);
            break;
        case EncodingTypeJPEG:
        {
            if ((options.allowsEditing == NO) && (options.targetSize.width <= 0) && (options.targetSize.height <= 0) && (options.correctOrientation == NO)){
                // use image unedited as requested , don't resize
                //data = UIImageJPEGRepresentation(image, 1.0);
                NSData *imgDataBeforeCompression = UIImageJPEGRepresentation(image, 1.0);
                data = [self compressImageBasedOnSize:imgDataBeforeCompression forImage:image];
                //NSLog(@"Image compressed %lu bytes to %lu bytes", (unsigned long)imgDataBeforeCompression.length, (unsigned long)data.length);
            }
            else {
                if (options.usesGeolocation) {
                    NSDictionary* controllerMetadata = [info objectForKey:@"UIImagePickerControllerMediaMetadata"];
                    if (controllerMetadata) {
                        self.data = data;
                        self.metadata = [[NSMutableDictionary alloc] init];
                        
                        NSMutableDictionary* EXIFDictionary = [[controllerMetadata objectForKey:(NSString*)kCGImagePropertyExifDictionary]mutableCopy];
                        if (EXIFDictionary)	{
                            [self.metadata setObject:EXIFDictionary forKey:(NSString*)kCGImagePropertyExifDictionary];
                        }
                        
                        if (IsAtLeastiOSVersion(@"8.0")) {
                            [[self locationManager] performSelector:NSSelectorFromString(@"requestWhenInUseAuthorization") withObject:nil afterDelay:0];
                        }
                        [[self locationManager] startUpdatingLocation];
                    }
                } else {
                    NSData *imgDataBeforeCompression = UIImageJPEGRepresentation(image, 1.0);
                    //data = UIImageJPEGRepresentation(image, [options.quality floatValue] / 100.0f);
                    data = [self compressImageBasedOnSize:imgDataBeforeCompression forImage:image];
                }
            }
        }
            break;
        default:
            break;
    };
    return data;
}

- (NSString*)tempFilePath:(NSString*)extension
{
    NSString* docsPath = [NSTemporaryDirectory()stringByStandardizingPath];
    NSFileManager* fileMgr = [[NSFileManager alloc] init]; // recommended by Apple (vs [NSFileManager defaultManager]) to be threadsafe
    NSString* filePath;
    
    // generate unique file name
    int i = 1;
    do {
        filePath = [NSString stringWithFormat:@"%@/%@%03d.%@", docsPath, CDV_PHOTO_PREFIX, i++, extension];
    } while ([fileMgr fileExistsAtPath:filePath]);
    
    return filePath;
}

- (UIImage*)retrieveImage:(NSDictionary*)info options:(OPGPictureOptionsNew*)options
{
    // get the image
    UIImage* image = nil;
    if (options.allowsEditing && [info objectForKey:UIImagePickerControllerEditedImage]) {
        image = [info objectForKey:UIImagePickerControllerEditedImage];
    } else {
        image = [info objectForKey:UIImagePickerControllerOriginalImage];
    }
    
    if (options.correctOrientation) {
        image = [image imageCorrectedForCaptureOrientation];
    }
    
    if (!(image.imageOrientation == UIImageOrientationUp)){
        UIGraphicsBeginImageContextWithOptions(image.size, NO, image.scale);
        [image drawInRect:(CGRect){0, 0, image.size}];
        UIImage *normalizedImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        image = normalizedImage;
    }
    
    UIImage* scaledImage = nil;
    
    if ((options.targetSize.width > 0) && (options.targetSize.height > 0)) {
        // if cropToSize, resize image and crop to target size, otherwise resize to fit target without cropping
        if (options.cropToSize) {
            scaledImage = [image imageByScalingAndCroppingForSize:options.targetSize];
        } else {
            scaledImage = [image imageByScalingNotCroppingForSize:options.targetSize];
        }
    }
    
   
    
    return (scaledImage == nil ? image : scaledImage);
}


- (NSString*)resultForImage:(OPGPictureOptionsNew*)options info:(NSDictionary*)info
{
    @autoreleasepool {
        NSString* result = nil;
        BOOL saveToPhotoAlbum = options.saveToPhotoAlbum;
        UIImage* image = nil;
        
        switch (options.destinationType) {
            case DestinationTypeNativeUri:
            {
                NSURL* url = (NSURL*)[info objectForKey:UIImagePickerControllerReferenceURL];
                NSString* nativeUri = [[self urlTransformer:url] absoluteString];
                result = nativeUri;//[OPGPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:nativeUri];
                saveToPhotoAlbum = NO;
            }
                break;
            case DestinationTypeFileUri:
            {
                image = [self retrieveImage:info options:options];
                NSData* data = [self processImage:image info:info options:options];
                if (data) {
                    
                    NSString* extension = options.encodingType == EncodingTypePNG? @"png" : @"jpg";
                    NSString* filePath = [self tempFilePath:extension];
                    NSError* err = nil;
                    
                    // save file
                    if (![data writeToFile:filePath options:NSAtomicWrite error:&err]) {
                        result = [err localizedDescription]; //[OPGPluginResult resultWithStatus:CDVCommandStatus_IO_EXCEPTION messageAsString:[err localizedDescription]];
                    } else {
                        result = [[self urlTransformer:[NSURL fileURLWithPath:filePath]] absoluteString]; //[OPGPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:[[self urlTransformer:[NSURL fileURLWithPath:filePath]] absoluteString]];
                    }
                }
            }
                break;
            case DestinationTypeDataUrl:
            {
                image = [self retrieveImage:info options:options];
                NSData* data = [self processImage:image info:info options:options];
                
                if (data)  {
                    result = toBase64(data) ;//[OPGPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:toBase64(data)];
                }
            }
                break;
            default:
                break;
        };
        
        if (saveToPhotoAlbum && image) {
            ALAssetsLibrary* library = [ALAssetsLibrary new];
            [library writeImageToSavedPhotosAlbum:image.CGImage orientation:(ALAssetOrientation)(image.imageOrientation) completionBlock:nil];
        }
        
        return result;
  
    }
}

- (NSString*)resultForVideo:(NSDictionary*)info
{
    NSString* moviePath = [[info objectForKey:UIImagePickerControllerMediaURL] absoluteString];
    return moviePath;//[OPGPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:moviePath];
}

-(void) startActivityIndicator {
    spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge]; [self.viewController.view addSubview:spinner];
    spinner.center = self.viewController.webView.center;
    spinner.hidesWhenStopped = YES;
    spinner.hidden = NO;
    spinner.color = [UIColor colorWithRed:255/255.0f green:150/255.0f blue:0/255.0f alpha:0.5];
    [spinner startAnimating];
}

-(void) stopActivityIndicator {
    [spinner stopAnimating];
}

- (void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary*)info
{
    switch (mediaMode) {
        case MEDIA_MODE_CAPTURE:
        {
            OPGImagePickerNew* cameraPicker = (OPGImagePickerNew*)picker;
            NSString* callbackId = cameraPicker.callbackId;
            
            [[picker presentingViewController] dismissViewControllerAnimated:YES completion:nil];
            
            NSString* result = nil;
            
            UIImage* image = nil;
            
           
            
            
            NSString* mediaType = [info objectForKey:UIImagePickerControllerMediaType];
            if (!mediaType || [mediaType isEqualToString:(NSString*)kUTTypeImage]) {
                // mediaType is nil then only option is UIImagePickerControllerOriginalImage
                if ([UIImagePickerController respondsToSelector:@selector(allowsEditing)] &&
                    (cameraPicker.allowsEditing && [info objectForKey:UIImagePickerControllerEditedImage])) {
                    image = [info objectForKey:UIImagePickerControllerEditedImage];
                } else {
                    image = [info objectForKey:UIImagePickerControllerOriginalImage];
                }
            }
            if (image != nil) {
                // mediaType was image
                result = [self processImage:image type:cameraPicker.mimeType forCallbackId:callbackId];
            } else if ([mediaType isEqualToString:(NSString*)kUTTypeMovie]) {
                // process video
                NSString* moviePath = [[info objectForKey:UIImagePickerControllerMediaURL] path];
                if (moviePath) {
                    result = [self processVideo:moviePath forCallbackId:callbackId];
                }
            }
            if (!result) {
               // result = [OPGPluginResult resultWithStatus:CDVCommandStatus_ERROR messageToErrorObject:CAPTURE_INTERNAL_ERR];
                NSDictionary *ldict=[[NSDictionary alloc]initWithObjectsAndKeys:result ,@"Error", nil];
                [self errorCallBack:[ldict JSONRepresentation] withcallbackId:callbackId];
                if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
                    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
                    
                }
                return;
            }
            //[self.commandDelegate sendPluginResult:result callbackId:callbackId];
            NSDictionary *ldict=[[NSDictionary alloc]initWithObjectsAndKeys:result ,@"path", nil];
            [self successCallBack:[ldict JSONRepresentation] withcallbackId:callbackId];
            pickerController = nil;
            break;
        }
        case MEDIA_MODE_GALLERY:
        {
            __weak OPGCameraPickerNew* cameraPicker = (OPGCameraPickerNew*)picker;
            __weak OPGMediaPickerAndPreviewPlugin* weakSelf = self;
            [self startActivityIndicator];
            dispatch_block_t invoke = ^(void) {
                __block NSString* result = nil;
                
                NSString* mediaType = [info objectForKey:UIImagePickerControllerMediaType];
                if ([mediaType isEqualToString:(NSString*)kUTTypeImage]) {
                    result = [self resultForImage:cameraPicker.pictureOptions info:info];
                    [self stopActivityIndicator];
                }
                else {
                    result = [self resultForVideo:info];
                }
                
                if (result) {
                    NSDictionary *ldict=[[NSDictionary alloc]initWithObjectsAndKeys:result ,@"path", nil];
                    [self successCallBack:[ldict JSONRepresentation] withcallbackId:cameraPicker.callbackId];
                   // [weakSelf.commandDelegate sendPluginResult:result callbackId:cameraPicker.callbackId];
                    weakSelf.hasPendingOperation = NO;
                    weakSelf.pickerController = nil;
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                [self stopActivityIndicator];
            });

            };
            
            if (cameraPicker.pictureOptions.popoverSupported && (cameraPicker.pickerPopoverController != nil)) {
                [cameraPicker.pickerPopoverController dismissPopoverAnimated:YES];
                cameraPicker.pickerPopoverController.delegate = nil;
                cameraPicker.pickerPopoverController = nil;
                invoke();
            } else {
                [[cameraPicker presentingViewController] dismissViewControllerAnimated:YES completion:invoke];
            }
 
        }
            
        default:
            break;
    }
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        
    }
}

// older api calls newer didFinishPickingMediaWithInfo
- (void)imagePickerController:(UIImagePickerController*)picker didFinishPickingImage:(UIImage*)image editingInfo:(NSDictionary*)editingInfo
{
    NSDictionary* imageInfo;
    switch (mediaMode) {
        case MEDIA_MODE_GALLERY:
            imageInfo = [NSDictionary dictionaryWithObject:image forKey:UIImagePickerControllerOriginalImage];
            
            [self imagePickerController:picker didFinishPickingMediaWithInfo:imageInfo];
            break;
        case MEDIA_MODE_CAPTURE:
            [self imagePickerController:picker didFinishPickingMediaWithInfo:editingInfo];
        default:
            break;
    }
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController*)picker
{
    switch (mediaMode) {
        case MEDIA_MODE_GALLERY:
        {
            __weak OPGCameraPickerNew* cameraPicker = (OPGCameraPickerNew*)picker;
            __weak OPGMediaPickerAndPreviewPlugin* weakSelf = self;
            
            dispatch_block_t invoke = ^ (void) {
                OPGPluginResult* result;
                if ([ALAssetsLibrary authorizationStatus] == ALAuthorizationStatusAuthorized) {
                    result = [OPGPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"no image selected"];
                } else {
                    result = [OPGPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"has no access to assets"];
                }
                
                [weakSelf.commandDelegate sendPluginResult:result callbackId:cameraPicker.callbackId];
                
                weakSelf.hasPendingOperation = NO;
                weakSelf.pickerController = nil;
            };
            
            [[cameraPicker presentingViewController] dismissViewControllerAnimated:YES completion:invoke];
            break;
    }
    
            case MEDIA_MODE_CAPTURE:
        {
            OPGImagePickerNew* cameraPicker = (OPGImagePickerNew*)picker;
            NSString* callbackId = cameraPicker.callbackId;
            
            [[picker presentingViewController] dismissViewControllerAnimated:YES completion:nil];
            
            OPGPluginResult* result = [OPGPluginResult resultWithStatus:CDVCommandStatus_ERROR messageToErrorObject:CAPTURE_NO_MEDIA_FILES];
            [self.commandDelegate sendPluginResult:result callbackId:callbackId];
            pickerController = nil;        }

        default:
            break;
    }
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
    
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        
    }
}

- (UIImage*)imageByScalingAndCroppingForSize:(UIImage*)anImage toSize:(CGSize)targetSize
{
    @autoreleasepool {
        UIImage* sourceImage = anImage;
        UIImage* newImage = nil;
        CGSize imageSize = sourceImage.size;
        CGFloat width = imageSize.width;
        CGFloat height = imageSize.height;
        CGFloat targetWidth = targetSize.width;
        CGFloat targetHeight = targetSize.height;
        CGFloat scaleFactor = 0.0;
        CGFloat scaledWidth = targetWidth;
        CGFloat scaledHeight = targetHeight;
        CGPoint thumbnailPoint = CGPointMake(0.0, 0.0);
        
        if (CGSizeEqualToSize(imageSize, targetSize) == NO) {
            CGFloat widthFactor = targetWidth / width;
            CGFloat heightFactor = targetHeight / height;
            
            if (widthFactor > heightFactor) {
                scaleFactor = widthFactor; // scale to fit height
            } else {
                scaleFactor = heightFactor; // scale to fit width
            }
            scaledWidth = width * scaleFactor;
            scaledHeight = height * scaleFactor;
            
            // center the image
            if (widthFactor > heightFactor) {
                thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
            } else if (widthFactor < heightFactor) {
                thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
            }
        }
        
        UIGraphicsBeginImageContext(targetSize); // this will crop
        
        CGRect thumbnailRect = CGRectZero;
        thumbnailRect.origin = thumbnailPoint;
        thumbnailRect.size.width = scaledWidth;
        thumbnailRect.size.height = scaledHeight;
        
        [sourceImage drawInRect:thumbnailRect];
        
        newImage = UIGraphicsGetImageFromCurrentImageContext();
        if (newImage == nil) {
            NSLog(@"could not scale image");
        }
        
        // pop the context to get back to the default
        UIGraphicsEndImageContext();
        return newImage;

    }
}

- (UIImage*)imageCorrectedForCaptureOrientation:(UIImage*)anImage
{
    @autoreleasepool {
        float rotation_radians = 0;
        bool perpendicular = false;
        
        switch ([anImage imageOrientation]) {
            case UIImageOrientationUp :
                rotation_radians = 0.0;
                break;
                
            case UIImageOrientationDown:
                rotation_radians = M_PI; // don't be scared of radians, if you're reading this, you're good at math
                break;
                
            case UIImageOrientationRight:
                rotation_radians = M_PI_2;
                perpendicular = true;
                break;
                
            case UIImageOrientationLeft:
                rotation_radians = -M_PI_2;
                perpendicular = true;
                break;
                
            default:
                break;
        }
        
        UIGraphicsBeginImageContext(CGSizeMake(anImage.size.width, anImage.size.height));
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        // Rotate around the center point
        CGContextTranslateCTM(context, anImage.size.width / 2, anImage.size.height / 2);
        CGContextRotateCTM(context, rotation_radians);
        
        CGContextScaleCTM(context, 1.0, -1.0);
        float width = perpendicular ? anImage.size.height : anImage.size.width;
        float height = perpendicular ? anImage.size.width : anImage.size.height;
        CGContextDrawImage(context, CGRectMake(-width / 2, -height / 2, width, height), [anImage CGImage]);
        
        // Move the origin back since the rotation might've change it (if its 90 degrees)
        if (perpendicular) {
            CGContextTranslateCTM(context, -anImage.size.height / 2, -anImage.size.width / 2);
        }
        
        UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return newImage;
 
    }
}

- (UIImage*)imageByScalingNotCroppingForSize:(UIImage*)anImage toSize:(CGSize)frameSize
{
    @autoreleasepool {
        UIImage* sourceImage = anImage;
        UIImage* newImage = nil;
        CGSize imageSize = sourceImage.size;
        CGFloat width = imageSize.width;
        CGFloat height = imageSize.height;
        CGFloat targetWidth = frameSize.width;
        CGFloat targetHeight = frameSize.height;
        CGFloat scaleFactor = 0.0;
        CGSize scaledSize = frameSize;
        
        if (CGSizeEqualToSize(imageSize, frameSize) == NO) {
            CGFloat widthFactor = targetWidth / width;
            CGFloat heightFactor = targetHeight / height;
            
            // opposite comparison to imageByScalingAndCroppingForSize in order to contain the image within the given bounds
            if (widthFactor > heightFactor) {
                scaleFactor = heightFactor; // scale to fit height
            } else {
                scaleFactor = widthFactor; // scale to fit width
            }
            scaledSize = CGSizeMake(MIN(width * scaleFactor, targetWidth), MIN(height * scaleFactor, targetHeight));
        }
        
        UIGraphicsBeginImageContext(scaledSize); // this will resize
        
        [sourceImage drawInRect:CGRectMake(0, 0, scaledSize.width, scaledSize.height)];
        
        newImage = UIGraphicsGetImageFromCurrentImageContext();
        if (newImage == nil) {
            NSLog(@"could not scale image");
        }
        
        // pop the context to get back to the default
        UIGraphicsEndImageContext();
        return newImage;
 
    }
}

- (void)postImage:(UIImage*)anImage withFilename:(NSString*)filename toUrl:(NSURL*)url
{
    self.hasPendingOperation = YES;
    
    NSString* boundary = @"----BOUNDARY_IS_I";
    
    NSMutableURLRequest* req = [NSMutableURLRequest requestWithURL:url];
    [req setHTTPMethod:@"POST"];
    
    NSString* contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    [req setValue:contentType forHTTPHeaderField:@"Content-type"];
    
    NSData* imageData = UIImagePNGRepresentation(anImage);
    
    // adding the body
    NSMutableData* postBody = [NSMutableData data];
    
    // first parameter an image
    [postBody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"upload\"; filename=\"%@\"\r\n", filename] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[@"Content-Type: image/png\r\n\r\n" dataUsingEncoding : NSUTF8StringEncoding]];
    [postBody appendData:imageData];
    [req setHTTPBody:postBody];
    
    NSURLResponse* response;
    NSError* error;
    [NSURLConnection sendSynchronousRequest:req returningResponse:&response error:&error];
    self.hasPendingOperation = NO;
}


- (CLLocationManager *)locationManager {
    
	if (locationManager != nil) {
		return locationManager;
	}
    
	locationManager = [[CLLocationManager alloc] init];
	[locationManager setDesiredAccuracy:kCLLocationAccuracyNearestTenMeters];
	[locationManager setDelegate:self];
    
	return locationManager;
}

- (void)locationManager:(CLLocationManager*)manager didUpdateToLocation:(CLLocation*)newLocation fromLocation:(CLLocation*)oldLocation
{
    if (locationManager == nil) {
        return;
    }
    
    [self.locationManager stopUpdatingLocation];
    self.locationManager = nil;
    
    NSMutableDictionary *GPSDictionary = [[NSMutableDictionary dictionary] init];
    
    CLLocationDegrees latitude  = newLocation.coordinate.latitude;
    CLLocationDegrees longitude = newLocation.coordinate.longitude;
    
    // latitude
    if (latitude < 0.0) {
        latitude = latitude * -1.0f;
        [GPSDictionary setObject:@"S" forKey:(NSString*)kCGImagePropertyGPSLatitudeRef];
    } else {
        [GPSDictionary setObject:@"N" forKey:(NSString*)kCGImagePropertyGPSLatitudeRef];
    }
    [GPSDictionary setObject:[NSNumber numberWithFloat:latitude] forKey:(NSString*)kCGImagePropertyGPSLatitude];
    
    // longitude
    if (longitude < 0.0) {
        longitude = longitude * -1.0f;
        [GPSDictionary setObject:@"W" forKey:(NSString*)kCGImagePropertyGPSLongitudeRef];
    }
    else {
        [GPSDictionary setObject:@"E" forKey:(NSString*)kCGImagePropertyGPSLongitudeRef];
    }
    [GPSDictionary setObject:[NSNumber numberWithFloat:longitude] forKey:(NSString*)kCGImagePropertyGPSLongitude];
    
    // altitude
    CGFloat altitude = newLocation.altitude;
    if (!isnan(altitude)){
        if (altitude < 0) {
            altitude = -altitude;
            [GPSDictionary setObject:@"1" forKey:(NSString *)kCGImagePropertyGPSAltitudeRef];
        } else {
            [GPSDictionary setObject:@"0" forKey:(NSString *)kCGImagePropertyGPSAltitudeRef];
        }
        [GPSDictionary setObject:[NSNumber numberWithFloat:altitude] forKey:(NSString *)kCGImagePropertyGPSAltitude];
    }
    
    // Time and date
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm:ss.SSSSSS"];
    [formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    [GPSDictionary setObject:[formatter stringFromDate:newLocation.timestamp] forKey:(NSString *)kCGImagePropertyGPSTimeStamp];
    [formatter setDateFormat:@"yyyy:MM:dd"];
    [GPSDictionary setObject:[formatter stringFromDate:newLocation.timestamp] forKey:(NSString *)kCGImagePropertyGPSDateStamp];
    
    [self.metadata setObject:GPSDictionary forKey:(NSString *)kCGImagePropertyGPSDictionary];
    [self imagePickerControllerReturnImageResult];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    if (locationManager == nil) {
        return;
    }
    
    [self.locationManager stopUpdatingLocation];
    self.locationManager = nil;
    
    [self imagePickerControllerReturnImageResult];
}

- (void)imagePickerControllerReturnImageResult
{
    OPGPictureOptionsNew* options = self.pickerController.pictureOptions;
    OPGPluginResult* result = nil;
    
    if (self.metadata) {
        CGImageSourceRef sourceImage = CGImageSourceCreateWithData((__bridge CFDataRef)self.data, NULL);
        CFStringRef sourceType = CGImageSourceGetType(sourceImage);
        
        CGImageDestinationRef destinationImage = CGImageDestinationCreateWithData((__bridge CFMutableDataRef)self.data, sourceType, 1, NULL);
        CGImageDestinationAddImageFromSource(destinationImage, sourceImage, 0, (__bridge CFDictionaryRef)self.metadata);
        CGImageDestinationFinalize(destinationImage);
        
        CFRelease(sourceImage);
        CFRelease(destinationImage);
    }
    
    switch (options.destinationType) {
        case DestinationTypeFileUri:
        {
            NSError* err = nil;
            NSString* extension = self.pickerController.pictureOptions.encodingType == EncodingTypePNG ? @"png":@"jpg";
            NSString* filePath = [self tempFilePath:extension];
            
            // save file
            if (![self.data writeToFile:filePath options:NSAtomicWrite error:&err]) {
                result = [OPGPluginResult resultWithStatus:CDVCommandStatus_IO_EXCEPTION messageAsString:[err localizedDescription]];
            }
            else {
                result = [OPGPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:[[self urlTransformer:[NSURL fileURLWithPath:filePath]] absoluteString]];
            }
        }
            break;
        case DestinationTypeDataUrl:
        {
            result = [OPGPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:toBase64(self.data)];
        }
            break;
        case DestinationTypeNativeUri:
        default:
            break;
    };
    
    if (result) {
        [self.commandDelegate sendPluginResult:result callbackId:self.pickerController.callbackId];
    }
    
    self.hasPendingOperation = NO;
    self.pickerController = nil;
    self.data = nil;
    self.metadata = nil;
    
    if (options.saveToPhotoAlbum) {
        ALAssetsLibrary *library = [ALAssetsLibrary new];
        [library writeImageDataToSavedPhotosAlbum:self.data metadata:self.metadata completionBlock:nil];
    }
}
- (id)initWithWebView:(UIWebView*)theWebView
{
    self = (OPGMediaPickerAndPreviewPlugin*)[super initWithWebView:theWebView];
    if (self) {
        self.inUse = NO;
    }
    return self;
}

- (void)startRecordingAudio:(OPGInvokedUrlCommand*)command
{
    mediaMode=MEDIA_MODE_CAPTURE;
    
    if ([[UIApplication sharedApplication]respondsToSelector:@selector(recordPermission)]) {
        AVAudioSessionRecordPermission authStatus = [[AVAudioSession sharedInstance]recordPermission];
        if (authStatus == AVAudioSessionRecordPermissionDenied ||
            authStatus == AVAudioSessionRecordPermissionUndetermined) {
            CallbackId=command.callbackId;
            // If iOS 8+, offer a link to the Settings app
            NSString* settingsButton = (&UIApplicationOpenSettingsURLString != NULL)
            ? NSLocalizedString(@"Settings", nil)
            : nil;
            
            // Denied; show an alert
            
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:[[NSBundle mainBundle]objectForInfoDictionaryKey:@"CFBundleDisplayName"]
                                                         message:NSLocalizedString(@"Access to the micorphone has been prohibited; please enable it in the Settings app to continue.", nil)
                                                        delegate:self cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:settingsButton, nil];
            alert.tag=2;
            [alert  show];
            return;
            
        }
        
    }

//    NSDictionary* options;
//    if ([options isKindOfClass:[NSNull class]]) {
//        options = [NSDictionary dictionary];
//    }
//   
    
   // NSNumber* duration = [options objectForKey:@"duration"];
    UIAccessibilityPostNotification(UIAccessibilityScreenChangedNotification, nil);
    NSError* error1 = nil;

    // the default value of duration is 0 so use nil (no duration) if default value
    if (avSession == nil) {
        // create audio session
        avSession = [AVAudioSession sharedInstance];
        if (error1) {
            // return error if can't create recording audio session
            NSLog(@"error creating audio session: %@", [[error1 userInfo] description]);
            self.errorCode = CAPTURE_INTERNAL_ERR;
            
        }
    }
    
    // create file to record to in temporary dir
    
    NSString* docsPath = [NSTemporaryDirectory()stringByStandardizingPath];   // use file system temporary directory
    NSError* err = nil;
    NSFileManager* fileMgr = [[NSFileManager alloc] init];
    
    // generate unique file name
    NSString* filePath;
    int i = 1;
    do {
        filePath = [NSString stringWithFormat:@"%@/audio_%03d.wav", docsPath, i++];
    } while ([fileMgr fileExistsAtPath:filePath]);
    
    NSURL* fileURL = [NSURL fileURLWithPath:filePath isDirectory:NO];
    
    // create AVAudioPlayer
    avRecorder = [[AVAudioRecorder alloc] initWithURL:fileURL settings:nil error:&err];
    if (err) {
        NSLog(@"Failed to initialize AVAudioRecorder: %@\n", [err localizedDescription]);
        avRecorder = nil;
        // return error
        self.errorCode = CAPTURE_INTERNAL_ERR;
        
    } else {
        avRecorder.delegate = self;
        [avRecorder prepareToRecord];
            }

//    if (duration) {
//        duration = [duration doubleValue] == 0 ? nil : duration;
//    }

    if (NSClassFromString(@"AVAudioRecorder") == nil) {
        pluginResult = [OPGPluginResult resultWithStatus:CDVCommandStatus_ERROR messageToErrorObject:CAPTURE_NOT_SUPPORTED];
    } else if (self.inUse == YES) {
        pluginResult = [OPGPluginResult resultWithStatus:CDVCommandStatus_ERROR messageToErrorObject:CAPTURE_APPLICATION_BUSY];
    } else {
        __block NSError* error = nil;
        
        void (^startRecording)(void) = ^{
            [avSession setCategory:AVAudioSessionCategoryPlayAndRecord error:&error];
            [avSession setActive:YES error:&error];
            if (error) {
                // can't continue without active audio session
                self.errorCode = CAPTURE_INTERNAL_ERR;
                
            } else {
                [avRecorder record];
                
            }
            UIAccessibilityPostNotification(UIAccessibilityLayoutChangedNotification, nil);
        };
        
        SEL rrpSel = NSSelectorFromString(@"requestRecordPermission:");
        if ([avSession respondsToSelector:rrpSel])
        {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [avSession performSelector:rrpSel withObject:^(BOOL granted){
                if (granted) {
                    startRecording();
                } else {
                    NSLog(@"Error creating audio session, microphone permission denied.");
                    self.errorCode = CAPTURE_INTERNAL_ERR;
                    
                }
            }];
#pragma clang diagnostic pop
        } else {
            startRecording();
        }

    }
    [self successCallBack:@"recording started" withcallbackId:command.callbackId];
    
}
- (void)stopRecordingAudio:(OPGInvokedUrlCommand*)command
{
    CallbackId=command.callbackId;
    if (avRecorder.recording) {
        [avRecorder stop];
         NSError *error=nil;
       [[AVAudioSession sharedInstance]setActive:NO withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation error:&error];
        
    }
}
- (void)startPlayingRecordedAudio:(OPGInvokedUrlCommand*)command{
    NSString *mediaFilePath=[[[command.arguments objectAtIndex:0]valueForKey:@"path"]description];
    CallbackId=command.callbackId;
    if ([[NSFileManager defaultManager]fileExistsAtPath:[mediaFilePath stringByReplacingOccurrencesOfString:@"file://" withString:@""]]) {
    
    NSURL *audioFileURL=[NSURL fileURLWithPath:mediaFilePath];
    NSError *error=nil;
    avPlayer= [[AVAudioPlayer alloc] initWithContentsOfURL:audioFileURL error:&error];
    avPlayer.delegate=self;
    if (error) {
        NSLog(@"error %@ %@ ",[error description],[error userInfo]);
    }
    [avPlayer play];
    }
    else{
       [self errorCallBack:@"error occured while trying to play audio" withcallbackId:command.callbackId];
    }
}
- (void)stopPlayingRecordedAudio:(OPGInvokedUrlCommand*)command{
    CallbackId=command.callbackId;
    [avPlayer stop];
    [self successCallBack:@"stoped" withcallbackId:command.callbackId];
    
}
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag;
{
    if (flag) {
        [self successCallBack:@"stoped" withcallbackId:CallbackId];
       
    }
    
}
- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error;
{
    if (error) {
        [self errorCallBack:[error description] withcallbackId:CallbackId];
        
    }
}

- (void)stopRecordingCleanup
{
    if (avRecorder.recording) {
        [avRecorder stop];
    }
    if (avSession) {
        NSError *error=nil;
        // deactivate session so sounds can come through
        [avSession setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
        [[AVAudioSession sharedInstance]setActive:NO withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation error:&error];
    }
}
- (void)audioRecorderDidFinishRecording:(AVAudioRecorder*)recorder successfully:(BOOL)flag
{
    // may be called when timed audio finishes - need to stop time and reset buttons
    [self stopRecordingCleanup];
    // generate success result
    if (flag) {
        NSString* filePath = [avRecorder.url path];
        // NSLog(@"filePath: %@", filePath);
        NSDictionary* fileDict = [self getMediaDictionaryFromPath:filePath ofType:@"audio/wav"];
    
        NSDictionary *ldict=[[NSDictionary alloc]initWithObjectsAndKeys:[fileDict valueForKey:@"fullPath"],@"path", nil];
        [self successCallBack:[ldict JSONRepresentation] withcallbackId:CallbackId];
        
    } else {
        [self errorCallBack:@"error in Audio Path" withcallbackId:CallbackId];
        
    }
}

- (void)audioRecorderEncodeErrorDidOccur:(AVAudioRecorder*)recorder error:(NSError*)error
{
    [self stopRecordingCleanup];
    [self errorCallBack:@"error in Audio Recording" withcallbackId:CallbackId];
   

}
- (void) playVideoSelectedPath:(OPGInvokedUrlCommand*)command
{
    NSString *mediaFilePath=[[[command.arguments objectAtIndex:0]valueForKey:@"path"]description];
    CallbackId=command.callbackId;
    NSURL *vedioURL;
    AVPlayerItem *playerItem;
    AVPlayer *playVideo;
    
    if ([[NSFileManager defaultManager]fileExistsAtPath:[mediaFilePath stringByReplacingOccurrencesOfString:@"file://" withString:@""]]) {
        if ([mediaFilePath hasPrefix:@"file://"]) {
            vedioURL =[NSURL fileURLWithPath:mediaFilePath];
            playerItem = [AVPlayerItem playerItemWithURL:vedioURL];
            playVideo = [[AVPlayer alloc] initWithPlayerItem:playerItem];
            _playerViewController = [[AVPlayerViewController alloc] init];
            _playerViewController.player = playVideo;
        }
        else{
            vedioURL =[NSURL fileURLWithPath:mediaFilePath];
            playerItem = [AVPlayerItem playerItemWithURL:vedioURL];
            playVideo = [[AVPlayer alloc] initWithPlayerItem:playerItem];
            _playerViewController = [[AVPlayerViewController alloc] init];
            _playerViewController.player = playVideo;
        }
        [self.viewController presentViewController:_playerViewController animated:NO completion:nil];
        [playVideo play];
        
    }
    else if (mediaFilePath != nil){
        vedioURL =[NSURL fileURLWithPath:mediaFilePath];
        playerItem = [AVPlayerItem playerItemWithURL:vedioURL];
        playVideo = [[AVPlayer alloc] initWithPlayerItem:playerItem];
        _playerViewController = [[AVPlayerViewController alloc] init];
        _playerViewController.player = playVideo;
        [self.viewController presentViewController:_playerViewController animated:NO completion:nil];
        [playVideo play];
    }
    else{
        [self errorCallBack:@"error occured while trying to play video" withcallbackId:command.callbackId];
    }
 
}
- (void) showImageFromPath:(OPGInvokedUrlCommand*)command{
    
    NSString *mediaFilePath=[[[command.arguments objectAtIndex:0]valueForKey:@"path"]description];
    if ([[NSFileManager defaultManager]fileExistsAtPath:[mediaFilePath stringByReplacingOccurrencesOfString:@"file://" withString:@""]]) {
    NSDictionary *dictionary=[command.arguments objectAtIndex:0];
  //  AppDelegate *delegate=[[UIApplication sharedApplication]delegate];
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
        if([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeLeft||[UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeRight)
        {
            self.imageBgView=[[UIView alloc]initWithFrame:CGRectMake(0, 0,screenHeight,screenWidth)];
            self.imageView=[[UIImageView alloc]initWithFrame:CGRectMake(10, 20,screenHeight-20,screenWidth-90)];
            self.closeButton=[[UIButton alloc]initWithFrame:CGRectMake(10,screenWidth-66, screenHeight-20,50)];
        }
       else if([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait||[UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortraitUpsideDown)
        {
            self.imageBgView=[[UIView alloc]initWithFrame:CGRectMake(0, 0,screenWidth,screenHeight)];
            self.imageView=[[UIImageView alloc]initWithFrame:CGRectMake(10, 20,screenWidth-20,screenHeight-90)];
            self.closeButton=[[UIButton alloc]initWithFrame:CGRectMake(10,screenHeight-66, screenWidth-20,50)];
        }
      self.imageBgView.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
    
    if ([[[[command.arguments objectAtIndex:0]valueForKey:@"path"]description] hasPrefix:@"file://"]) {
       self.imageView.image=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[dictionary valueForKey:@"path"]]]];
    }
    else{
        self.imageView.image=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL fileURLWithPath:[dictionary valueForKey:@"path"]]]];
    }
        self.closeButton.backgroundColor=[UIColor whiteColor];
        [self.closeButton setTitle:@"Close" forState:UIControlStateNormal];
        [self.closeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal] ;
        [self.closeButton addTarget:self action:@selector(closePreview) forControlEvents:UIControlEventTouchUpInside];
        [self.viewController.view addSubview:self.imageBgView];
        [self.viewController.view addSubview:self.imageView];
        [self.viewController.view addSubview:self.closeButton];
    }
    else{
        [self errorCallBack:@"eroro occured" withcallbackId:command.callbackId];
    }
 
}
-(void)closePreview{
        [self.imageView removeFromSuperview];
        [self.closeButton removeFromSuperview];
        [self.imageBgView removeFromSuperview];
 
}


- (void) pickImageFromCamera:(OPGInvokedUrlCommand*)command
{
    mediaMode=MEDIA_MODE_CAPTURE;
    
    if ([AVCaptureDevice respondsToSelector:@selector(authorizationStatusForMediaType:)]) {
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if (authStatus == AVAuthorizationStatusDenied ||
            authStatus == AVAuthorizationStatusRestricted) {
            CallbackId=command.callbackId;
            // If iOS 8+, offer a link to the Settings app
            NSString* settingsButton = (&UIApplicationOpenSettingsURLString != NULL)
            ? NSLocalizedString(@"Settings", nil)
            : nil;
            
            // Denied; show an alert
            
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:[[NSBundle mainBundle]objectForInfoDictionaryKey:@"CFBundleDisplayName"]
                                                         message:NSLocalizedString(@"Access to the camera has been prohibited; please enable it in the Settings app to continue.", nil)
                                                        delegate:self cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:settingsButton, nil];
            alert.tag=3;
            [alert  show];
            return;
            
        }
    }

    NSString* callbackId = command.callbackId;
 
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        NSLog(@"Capture.imageCapture: camera not available.");
        OPGPluginResult* result = [OPGPluginResult resultWithStatus:CDVCommandStatus_ERROR messageToErrorObject:CAPTURE_NOT_SUPPORTED];
        [self.commandDelegate sendPluginResult:result callbackId:callbackId];
    } else {
        if (imagePickerController == nil) {
            imagePickerController = [[OPGImagePickerNew alloc] init];
        }
        
        imagePickerController.delegate = self;
        imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePickerController.allowsEditing = NO;
        imagePickerController.modalPresentationStyle = UIModalPresentationCurrentContext;
        
        if ([imagePickerController respondsToSelector:@selector(mediaTypes)]) {
            // iOS 3.0
            imagePickerController.mediaTypes = [NSArray arrayWithObjects:(NSString*)kUTTypeImage, nil];
        }
        
        /*if ([pickerController respondsToSelector:@selector(cameraCaptureMode)]){
         // iOS 4.0
         pickerController.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
         pickerController.cameraDevice = UIImagePickerControllerCameraDeviceRear;
         pickerController.cameraFlashMode = UIImagePickerControllerCameraFlashModeAuto;
         }*/
        // CDVImagePicker specific property
        imagePickerController.callbackId = callbackId;
        
        [self.viewController presentViewController:imagePickerController animated:YES completion:nil];
    }
}

-(UIImage*)getResizedImage:(UIImage*)image scaledToSize:(CGSize)newSize {
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();    
    UIGraphicsEndImageContext();
    return newImage;
}

-(NSData*) compressImageBasedOnSize: (NSData*)imageData forImage:(UIImage*)image {
    // Check if the image size is larger than 900 KB
    if ((imageData.length/1024) >= 900) {

        while ((imageData.length/1024) >= 900) {
            //NSLog(@"While start - The imagedata size is currently: %f KB",roundf((imageData.length/1024)));
            // While the imageData is too large scale down the image
            // Get the current image size
            CGSize currentSize = CGSizeMake(image.size.width, image.size.height);

            // Resize the image with 80% of original size
            image = [self getResizedImage:image scaledToSize:CGSizeMake(roundf(((currentSize.width/100)*80)), roundf(((currentSize.height/100)*80)))];

            // Pass the NSData out again
            imageData = UIImageJPEGRepresentation(image, 0.8);
           //NSLog(@"After compression - The imagedata size is currently: %f KB",roundf((imageData.length/1024)));
        }
        return imageData;
    }
    return imageData;
}

- (NSString*)processImage:(UIImage*)image type:(NSString*)mimeType forCallbackId:(NSString*)callbackId
{
    // save the image to photo album
    if (!(image.imageOrientation == UIImageOrientationUp)){
        UIGraphicsBeginImageContextWithOptions(image.size, NO, image.scale);
        [image drawInRect:(CGRect){0, 0, image.size}];
        UIImage *normalizedImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        image = normalizedImage;
    }
    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    
    NSData* data = nil;
    NSDictionary* fileDict;
    if (mimeType && [mimeType isEqualToString:@"image/png"]) {
        data = UIImagePNGRepresentation(image);
    } else {
        NSData *imgDataBeforeCompression = UIImageJPEGRepresentation(image, 1.0);
        //NSLog(@"processImage mimeType %@", mimeType);
        data = [self compressImageBasedOnSize:imgDataBeforeCompression forImage:image];
        //NSLog(@"Image compressed %lu bytes to %lu bytes", (unsigned long)imgDataBeforeCompression.length, (unsigned long)data.length);
    }
    
    // write to temp directory and return URI
    NSString* docsPath = [NSTemporaryDirectory()stringByStandardizingPath];   // use file system temporary directory
    NSError* err = nil;
    NSFileManager* fileMgr = [[NSFileManager alloc] init];
    
    // generate unique file name
    NSString* filePath;
    int i = 1;
    do {
        filePath = [NSString stringWithFormat:@"%@/photo_%03d.jpg", docsPath, i++];
    } while ([fileMgr fileExistsAtPath:filePath]);
    
    if (![data writeToFile:filePath options:NSAtomicWrite error:&err]) {
       
        if (err) {
            NSLog(@"Error saving image: %@", [err localizedDescription]);
        }
    } else {
       
        
        fileDict = [self getMediaDictionaryFromPath:filePath ofType:mimeType];
        

        }
    
    return [fileDict valueForKey:@"fullPath"];;
}
- (void) pickVideoFromCamera:(OPGInvokedUrlCommand*)command
{
    mediaMode=MEDIA_MODE_CAPTURE;
    if ([AVCaptureDevice respondsToSelector:@selector(authorizationStatusForMediaType:)]) {
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if (authStatus == AVAuthorizationStatusDenied ||
            authStatus == AVAuthorizationStatusRestricted) {
            CallbackId=command.callbackId;
            // If iOS 8+, offer a link to the Settings app
            NSString* settingsButton = (&UIApplicationOpenSettingsURLString != NULL)
            ? NSLocalizedString(@"Settings", nil)
            : nil;
            
            // Denied; show an alert
            
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:[[NSBundle mainBundle]objectForInfoDictionaryKey:@"CFBundleDisplayName"]
                                                         message:NSLocalizedString(@"Access to the camera has been prohibited; please enable it in the Settings app to continue.", nil)
                                                        delegate:self cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:settingsButton, nil];
            alert.tag=4;
            [alert  show];
            return;
            
        }
    }

    NSString* callbackId = command.callbackId;
    NSString* mediaType = nil;
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        imagePickerController = [[OPGImagePickerNew alloc] init];
        
        NSArray* types = nil;
        if ([UIImagePickerController respondsToSelector:@selector(availableMediaTypesForSourceType:)]) {
            types = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
            
            if ([types containsObject:(NSString*)kUTTypeMovie]) {
                mediaType = (NSString*)kUTTypeMovie;
            } else if ([types containsObject:(NSString*)kUTTypeVideo]) {
                mediaType = (NSString*)kUTTypeVideo;
            }
        }
    }
    if (!mediaType) {
        // don't have video camera return error
        NSLog(@"Capture.captureVideo: video mode not available.");
        OPGPluginResult* result = [OPGPluginResult resultWithStatus:CDVCommandStatus_ERROR messageToErrorObject:CAPTURE_NOT_SUPPORTED];
        [self.commandDelegate sendPluginResult:result callbackId:callbackId];
        imagePickerController = nil;
    } else {
        imagePickerController.delegate = self;
        imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePickerController.allowsEditing = YES;
        
        // iOS 3.0
        imagePickerController.mediaTypes = [NSArray arrayWithObjects:mediaType, nil];
        imagePickerController.videoMaximumDuration=1800;
        // iOS 4.0
        if ([imagePickerController respondsToSelector:@selector(cameraCaptureMode)]) {
            imagePickerController.cameraCaptureMode = UIImagePickerControllerCameraCaptureModeVideo;
             imagePickerController.videoQuality = UIImagePickerControllerQualityTypeLow;
             imagePickerController.cameraDevice = UIImagePickerControllerCameraDeviceRear;
             imagePickerController.cameraFlashMode = UIImagePickerControllerCameraFlashModeAuto;
        }
        // CDVImagePicker specific property
        imagePickerController.callbackId = callbackId;
        
        [self.viewController presentViewController:imagePickerController animated:YES completion:nil];
    }
}

- (NSString*)processVideo:(NSString*)moviePath forCallbackId:(NSString*)callbackId
{
    NSDictionary* fileDict = [self getMediaDictionaryFromPath:moviePath ofType:nil];
  
    return [fileDict valueForKey:@"fullPath"];
}

- (void)getMediaModes:(OPGInvokedUrlCommand*)command
{
    // NSString* callbackId = [command argumentAtIndex:0];
    // NSMutableDictionary* imageModes = nil;
    NSArray* imageArray = nil;
    NSArray* movieArray = nil;
    NSArray* audioArray = nil;
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        // there is a camera, find the modes
        // can get image/jpeg or image/png from camera
        
        /* can't find a way to get the default height and width and other info
         * for images/movies taken with UIImagePickerController
         */
        NSDictionary* jpg = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithInt:0], kW3CMediaFormatHeight,
                             [NSNumber numberWithInt:0], kW3CMediaFormatWidth,
                             @"image/jpeg", kW3CMediaModeType,
                             nil];
        NSDictionary* png = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithInt:0], kW3CMediaFormatHeight,
                             [NSNumber numberWithInt:0], kW3CMediaFormatWidth,
                             @"image/png", kW3CMediaModeType,
                             nil];
        imageArray = [NSArray arrayWithObjects:jpg, png, nil];
        
        if ([UIImagePickerController respondsToSelector:@selector(availableMediaTypesForSourceType:)]) {
            NSArray* types = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
            
            if ([types containsObject:(NSString*)kUTTypeMovie]) {
                NSDictionary* mov = [NSDictionary dictionaryWithObjectsAndKeys:
                                     [NSNumber numberWithInt:0], kW3CMediaFormatHeight,
                                     [NSNumber numberWithInt:0], kW3CMediaFormatWidth,
                                     @"video/quicktime", kW3CMediaModeType,
                                     nil];
                movieArray = [NSArray arrayWithObject:mov];
            }
        }
    }
    NSDictionary* modes = [NSDictionary dictionaryWithObjectsAndKeys:
                           imageArray ? (NSObject*)                          imageArray:[NSNull null], @"image",
                           movieArray ? (NSObject*)                          movieArray:[NSNull null], @"video",
                           audioArray ? (NSObject*)                          audioArray:[NSNull null], @"audio",
                           nil];
    
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:modes options:0 error:nil];
    NSString* jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    NSString* jsString = [NSString stringWithFormat:@"navigator.device.capture.setSupportedModes(%@);", jsonStr];
    [self.commandDelegate evalJs:jsString];
}

- (void)getFormatData:(OPGInvokedUrlCommand*)command
{
    NSString* callbackId = command.callbackId;
    // existence of fullPath checked on JS side
    NSString* fullPath = [command.arguments objectAtIndex:0];
    // mimeType could be null
    NSString* mimeType = nil;
    
    if ([command.arguments count] > 1) {
        mimeType = [command.arguments objectAtIndex:1];
    }
    BOOL bError = NO;
    OPGCaptureErrorNew errorCode = CAPTURE_INTERNAL_ERR;
    OPGPluginResult* result = nil;
    
    if (!mimeType || [mimeType isKindOfClass:[NSNull class]]) {
        // try to determine mime type if not provided
        id command = [self.commandDelegate getCommandInstance:@"File"];
        bError = !([command isKindOfClass:[OPGFile class]]);
        if (!bError) {
            OPGFile* cdvFile = (OPGFile*)command;
            mimeType = [cdvFile getMimeTypeFromPath:fullPath];
            if (!mimeType) {
                // can't do much without mimeType, return error
                bError = YES;
                errorCode = CAPTURE_INVALID_ARGUMENT;
            }
        }
    }
    if (!bError) {
        // create and initialize return dictionary
        NSMutableDictionary* formatData = [NSMutableDictionary dictionaryWithCapacity:5];
        [formatData setObject:[NSNull null] forKey:kW3CMediaFormatCodecs];
        [formatData setObject:[NSNumber numberWithInt:0] forKey:kW3CMediaFormatBitrate];
        [formatData setObject:[NSNumber numberWithInt:0] forKey:kW3CMediaFormatHeight];
        [formatData setObject:[NSNumber numberWithInt:0] forKey:kW3CMediaFormatWidth];
        [formatData setObject:[NSNumber numberWithInt:0] forKey:kW3CMediaFormatDuration];
        
        if ([mimeType rangeOfString:@"image/"].location != NSNotFound) {
            UIImage* image = [UIImage imageWithContentsOfFile:fullPath];
            if (image) {
                CGSize imgSize = [image size];
                [formatData setObject:[NSNumber numberWithInteger:imgSize.width] forKey:kW3CMediaFormatWidth];
                [formatData setObject:[NSNumber numberWithInteger:imgSize.height] forKey:kW3CMediaFormatHeight];
            }
        } else if (([mimeType rangeOfString:@"video/"].location != NSNotFound) && (NSClassFromString(@"AVURLAsset") != nil)) {
            NSURL* movieURL = [NSURL fileURLWithPath:fullPath];
            AVURLAsset* movieAsset = [[AVURLAsset alloc] initWithURL:movieURL options:nil];
            CMTime duration = [movieAsset duration];
            [formatData setObject:[NSNumber numberWithFloat:CMTimeGetSeconds(duration)]  forKey:kW3CMediaFormatDuration];
            
            NSArray* allVideoTracks = [movieAsset tracksWithMediaType:AVMediaTypeVideo];
            if ([allVideoTracks count] > 0) {
                AVAssetTrack* track = [[movieAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
                CGSize size = [track naturalSize];
                
                [formatData setObject:[NSNumber numberWithFloat:size.height] forKey:kW3CMediaFormatHeight];
                [formatData setObject:[NSNumber numberWithFloat:size.width] forKey:kW3CMediaFormatWidth];
                // not sure how to get codecs or bitrate???
                // AVMetadataItem
                // AudioFile
            } else {
                NSLog(@"No video tracks found for %@", fullPath);
            }
        } else if ([mimeType rangeOfString:@"audio/"].location != NSNotFound) {
            if (NSClassFromString(@"AVAudioPlayer") != nil) {
                NSURL* fileURL = [NSURL fileURLWithPath:fullPath];
                NSError* err = nil;
                
                AVAudioPlayer* avPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL error:&err];
                if (!err) {
                    // get the data
                    [formatData setObject:[NSNumber numberWithDouble:[avPlayer duration]] forKey:kW3CMediaFormatDuration];
                    if ([avPlayer respondsToSelector:@selector(settings)]) {
                        NSDictionary* info = [avPlayer settings];
                        NSNumber* bitRate = [info objectForKey:AVEncoderBitRateKey];
                        if (bitRate) {
                            [formatData setObject:bitRate forKey:kW3CMediaFormatBitrate];
                        }
                    }
                } // else leave data init'ed to 0
            }
        }
        result = [OPGPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:formatData];
        // NSLog(@"getFormatData: %@", [formatData description]);
    }
    if (bError) {
        result = [OPGPluginResult resultWithStatus:CDVCommandStatus_ERROR messageToErrorObject:(int)errorCode];
    }
    if (result) {
        [self.commandDelegate sendPluginResult:result callbackId:callbackId];
    }
}

- (NSDictionary*)getMediaDictionaryFromPath:(NSString*)fullPath ofType:(NSString*)type
{
    NSFileManager* fileMgr = [[NSFileManager alloc] init];
    NSMutableDictionary* fileDict = [NSMutableDictionary dictionaryWithCapacity:5];
    
    OPGFile *fs = [self.commandDelegate getCommandInstance:@"File"];
    
    // Get canonical version of localPath
    NSURL *fileURL = [NSURL URLWithString:[NSString stringWithFormat:@"file://%@", fullPath]];
    NSURL *resolvedFileURL = [fileURL URLByResolvingSymlinksInPath];
    NSString *path = [resolvedFileURL path];
    
    OPGFilesystemURL *url = [fs fileSystemURLforLocalPath:path];
    
    [fileDict setObject:[fullPath lastPathComponent] forKey:@"name"];
    [fileDict setObject:fullPath forKey:@"fullPath"];
    if (url) {
        [fileDict setObject:[url absoluteURL] forKey:@"localURL"];
    }
    // determine type
    if (!type) {
        id command = [self.commandDelegate getCommandInstance:@"File"];
        if ([command isKindOfClass:[OPGFile class]]) {
            OPGFile* cdvFile = (OPGFile*)command;
            NSString* mimeType = [cdvFile getMimeTypeFromPath:fullPath];
            [fileDict setObject:(mimeType != nil ? (NSObject*)mimeType : [NSNull null]) forKey:@"type"];
        }
    }
    NSDictionary* fileAttrs = [fileMgr attributesOfItemAtPath:fullPath error:nil];
    [fileDict setObject:[NSNumber numberWithUnsignedLongLong:[fileAttrs fileSize]] forKey:@"size"];
    NSDate* modDate = [fileAttrs fileModificationDate];
    NSNumber* msDate = [NSNumber numberWithDouble:[modDate timeIntervalSince1970] * 1000];
    [fileDict setObject:msDate forKey:@"lastModifiedDate"];
    
    return fileDict;
}

- (UIImage *)normalResImage:(UIImage*)image
{
    // Convert ALAsset to UIImage
  //  UIImage *image = [self highResImageForAsset:asset];
    
    // Determine output size
    CGFloat maxSize = 1024.0f;
    CGFloat width = image.size.width;
    CGFloat height = image.size.height;
    CGFloat newWidth = width;
    CGFloat newHeight = height;
    
    // If any side exceeds the maximun size, reduce the greater side to 1200px and proportionately the other one
    if (width > maxSize || height > maxSize) {
        if (width > height) {
            newWidth = maxSize;
            newHeight = (height*maxSize)/width;
        } else {
            newHeight = maxSize;
            newWidth = (width*maxSize)/height;
        }
    }
    
    // Resize the image
    CGSize newSize = CGSizeMake(newWidth, newHeight);
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    // Set maximun compression in order to decrease file size and enable faster uploads & downloads
    NSData *imageData = UIImageJPEGRepresentation(newImage, 0.0f);
    UIImage *processedImage = [UIImage imageWithData:imageData];
    
    return processedImage;
}

@end

@implementation OPGCameraPickerNew

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (UIViewController*)childViewControllerForStatusBarHidden
{
    return nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    SEL sel = NSSelectorFromString(@"setNeedsStatusBarAppearanceUpdate");
    if ([self respondsToSelector:sel]) {
        [self performSelector:sel withObject:nil afterDelay:0];
    }
    
    [super viewWillAppear:animated];
}

+ (instancetype) createFromPictureOptions:(OPGPictureOptionsNew*)pictureOptions;
{
    OPGCameraPickerNew* cameraPicker = [[OPGCameraPickerNew alloc] init];
    cameraPicker.pictureOptions = pictureOptions;
    cameraPicker.sourceType = pictureOptions.sourceType;
    cameraPicker.allowsEditing = pictureOptions.allowsEditing;
    
    if (cameraPicker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        // We only allow taking pictures (no video) in this API.
        cameraPicker.mediaTypes = @[(NSString*)kUTTypeImage];
        // We can only set the camera device if we're actually using the camera.
        cameraPicker.cameraDevice = pictureOptions.cameraDirection;
    } else if (pictureOptions.mediaType == MediaTypeAll) {
        cameraPicker.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:cameraPicker.sourceType];
    } else {
        NSArray* mediaArray = @[(NSString*)(pictureOptions.mediaType == MediaTypeVideo ? kUTTypeMovie : kUTTypeImage)];
        cameraPicker.mediaTypes = mediaArray;
    }
    
    return cameraPicker;
}
@end


