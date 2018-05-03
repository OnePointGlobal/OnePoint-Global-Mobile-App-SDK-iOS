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
//

#import "RootPlugin.h"
#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <CoreLocation/CLLocationManager.h>
#import "OPGPlugin.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <AVFoundation/AVFoundation.h>
#import "OPGFile.h"
#import <MediaPlayer/MediaPlayer.h>
enum OPGCaptureErrorNew {
    CAPTURE_INTERNAL_ERR = 0,
    CAPTURE_APPLICATION_BUSY = 1,
    CAPTURE_INVALID_ARGUMENT = 2,
    CAPTURE_NO_MEDIA_FILES = 3,
    CAPTURE_NOT_SUPPORTED = 20
};
typedef NSUInteger OPGCaptureErrorNew;

@interface OPGImagePickerNew : UIImagePickerController
{
    NSString* callbackid;
    NSInteger quality;
    NSString* mimeType;
}
@property (assign) NSInteger quality;
@property (copy)   NSString* callbackId;
@property (copy)   NSString* mimeType;

@end

enum OPGDestinationTypeNew {
    DestinationTypeDataUrl = 0,
    DestinationTypeFileUri,
    DestinationTypeNativeUri
};
typedef NSUInteger OPGDestinationTypeNew;

enum OPGEncodingTypeNew {
    EncodingTypeJPEG = 0,
    EncodingTypePNG
};
typedef NSUInteger OPGEncodingTypeNew;

enum OPGMediaTypeNew {
    MediaTypePicture = 0,
    MediaTypeVideo,
    MediaTypeAll
};
typedef NSUInteger OPGMediaTypeNew;

@interface OPGPictureOptionsNew : NSObject

@property (strong) NSNumber* quality;
@property (assign) OPGDestinationTypeNew destinationType;
@property (assign) UIImagePickerControllerSourceType sourceType;
@property (assign) CGSize targetSize;
@property (assign) OPGEncodingTypeNew encodingType;
@property (assign) OPGMediaTypeNew mediaType;
@property (assign) BOOL allowsEditing;
@property (assign) BOOL correctOrientation;
@property (assign) BOOL saveToPhotoAlbum;
@property (strong) NSDictionary* popoverOptions;
@property (assign) UIImagePickerControllerCameraDevice cameraDirection;

@property (assign) BOOL popoverSupported;
@property (assign) BOOL usesGeolocation;
@property (assign) BOOL cropToSize;

+ (instancetype) createFromTakePictureArguments:(OPGInvokedUrlCommand*)command;

@end


@interface OPGCameraPickerNew : UIImagePickerController

@property (strong) OPGPictureOptionsNew* pictureOptions;

@property (copy)   NSString* callbackId;
@property (copy)   NSString* postUrl;
@property (strong) UIPopoverController* pickerPopoverController;
@property (assign) BOOL cropToSize;
@property (strong) UIView* webView;

+ (instancetype) createFromPictureOptions:(OPGPictureOptionsNew*)options;

@end
// ======================================================================= //
@interface OPGMediaPickerAndPreviewPlugin : RootPlugin<UIImagePickerControllerDelegate,
UINavigationControllerDelegate,
UIPopoverControllerDelegate,
CLLocationManagerDelegate,AVAudioRecorderDelegate,AVAudioPlayerDelegate>{
    // AppDelegate *appDelegate;
    OPGImagePickerNew* imagePickerController;
    BOOL inUse;
    int mediaMode;
    OPGPluginResult* pluginResult;
    NSString *CallbackId;

}
@property (strong) OPGCameraPickerNew* pickerController;
@property (strong) NSMutableDictionary *metadata;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong) NSData* data;
@property (nonatomic) OPGCaptureErrorNew errorCode;
@property (nonatomic, strong)UIImageView *imageView;
@property (nonatomic, strong)UIButton *closeButton;
@property (nonatomic, strong)UIView *imageBgView;
@property BOOL inUse;

- (void)takePicture:(OPGInvokedUrlCommand*)command sourceType:(NSString*)mediatype;
- (void)cleanup:(OPGInvokedUrlCommand*)command;
- (void)repositionPopover:(OPGInvokedUrlCommand*)command;

- (void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary*)info;
- (void)imagePickerController:(UIImagePickerController*)picker didFinishPickingImage:(UIImage*)image editingInfo:(NSDictionary*)editingInfo;
- (void)imagePickerControllerDidCancel:(UIImagePickerController*)picker;
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated;

- (void)locationManager:(CLLocationManager*)manager didUpdateToLocation:(CLLocation*)newLocation fromLocation:(CLLocation*)oldLocation;
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error;
- (NSString*)processImage:(UIImage*)image type:(NSString*)mimeType forCallbackId:(NSString*)callbackId;
- (NSString*)processVideo:(NSString*)moviePath forCallbackId:(NSString*)callbackId;
- (void)getMediaModes:(OPGInvokedUrlCommand*)command;
- (void)getFormatData:(OPGInvokedUrlCommand*)command;
- (NSDictionary*)getMediaDictionaryFromPath:(NSString*)fullPath ofType:(NSString*)type;

@end



