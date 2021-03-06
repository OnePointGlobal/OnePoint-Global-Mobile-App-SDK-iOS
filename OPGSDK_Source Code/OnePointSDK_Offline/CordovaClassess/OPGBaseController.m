/*
 Licensed to the Apache Software Foundation (ASF) under one
 or more contributor license agreements.  See the NOTICE file
 distributed with this work for additional information
 regarding copyright ownership.  The ASF licenses this file
 to you under the Apache License, Version 2.0 (the
 "License"); you may not use this file except in compliance
 with the License.  You may obtain a copy of the License at

 http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing,
 software distributed under the License is distributed on an
 "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 KIND, either express or implied.  See the License for the
 specific language governing permissions and limitations
 under the License.
 */

#import <objc/message.h>
#import "OPG.h"
#import "OPGPanellistProfile.h"
#import "OPGCommandDelegateImpl.h"
#import "OPGConfigParser.h"
#import "OPGUserAgentUtil.h"
#import "OPGWebViewDelegate.h"
#import <AVFoundation/AVFoundation.h>
#import "OPGHandleOpenURL.h"
#import "NSObject+OPGSBJSON.h"
#import "OPGConstants.h"
#import "NSString+OPGAESCrypt.h"
#import "OPGRuntimePlugin.h"
#import "OPGSBJsonParser.h"



#define KEY_DATA @"HiYNZFOI1S1biFnoiFFWZcPwWBnhxqhkQ1Ipyh2yG7U="

#define degreesToRadian(x) (M_PI * (x) / 180.0)

@interface OPGBaseController () {
    NSInteger _userAgentLockToken;
    OPGWebViewDelegate* _webViewDelegate;
    WebPlayer *player;
    InterviewSession *session;
    Controller *cont;
}



@property (nonatomic, readwrite, strong) NSXMLParser* configParser;
@property (nonatomic, readwrite, strong) NSMutableDictionary* settings;
@property (nonatomic, readwrite, strong) OPGWhitelist* whitelist;
@property (nonatomic, readwrite, strong) NSMutableDictionary* pluginObjects;
@property (nonatomic, readwrite, strong) NSArray* startupPluginNames;
@property (nonatomic, readwrite, strong) NSDictionary* pluginsMap;
@property (nonatomic, readwrite, strong) NSArray* supportedOrientations;
@property (nonatomic, readwrite, copy) NSDictionary* queryDict;
@property (nonatomic, readwrite, copy) NSString* surveyReference;
@property (nonatomic, readwrite, copy) NSNumber* panelID;
@property (nonatomic, readwrite, copy) NSNumber* panellistID;




@property (nonatomic, readwrite, assign) BOOL loadFromString;

@property (readwrite, assign) BOOL initialized;

@property (atomic, strong) NSURL* openURL;


-(void)opgsurveyCompleted;

-(void)opgdidOnePointWebViewStartLoad;

-(void)opgdidOnePointWebViewFinishLoad;

-(void)opgdidOnePointWebViewLoadWithError:(NSError*)error;

@end

@implementation OPGBaseController
@synthesize closeButton, imageBgView, imageView;
@synthesize webView, supportedOrientations;
@synthesize pluginObjects, pluginsMap, whitelist, startupPluginNames;
@synthesize configParser, settings, loadFromString;
@synthesize wwwFolderName, startPage, initialized, openURL, baseUserAgent,surveyReference,queryDict;
@synthesize commandDelegate = _commandDelegate;
@synthesize commandQueue = _commandQueue;

-(void)copyResourceBundleFiles:(NSString *)bundlePath {
    
    NSString *cacheDirPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    NSString *sourcePath = [bundlePath stringByAppendingPathComponent:@"www"];
    NSArray* resContents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:sourcePath error:nil];
    for (NSString* obj in resContents){
        NSError* error;
        if (![obj isEqualToString:@"images"]&&![obj isEqualToString:@"img"]) {
            if ([[NSFileManager defaultManager] fileExistsAtPath:[cacheDirPath stringByAppendingPathComponent:obj]]) {
                // copy only if the resource files do not exist
                [[NSFileManager defaultManager] removeItemAtPath:[cacheDirPath stringByAppendingPathComponent:obj] error:&error];
            }
            [[NSFileManager defaultManager] copyItemAtPath:[sourcePath stringByAppendingPathComponent:obj] toPath:[cacheDirPath stringByAppendingPathComponent:obj]error:&error];
            
        }
    }
    sourcePath = [bundlePath stringByAppendingPathComponent:@"Interview"];
    resContents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:sourcePath error:nil];
    
    for (NSString* obj in resContents){
        NSError* error;
        if ([[NSFileManager defaultManager] fileExistsAtPath:[cacheDirPath stringByAppendingPathComponent:obj]]) {
            // copy only if the resource files do not exist
            [[NSFileManager defaultManager] removeItemAtPath:[cacheDirPath stringByAppendingPathComponent:obj] error:&error];
        }
        [[NSFileManager defaultManager] copyItemAtPath:[sourcePath stringByAppendingPathComponent:obj] toPath:[cacheDirPath stringByAppendingPathComponent:obj]error:&error];
    }
}

-(NSNumber *)getAssetsVersion:(NSString *)path {
    if (![path isEqualToString:@""] || path != nil) {
        NSData *data = [NSData dataWithContentsOfFile:path];
        NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        OPGSBJsonParser *parser = [[OPGSBJsonParser alloc] init];
        NSDictionary *json = (NSDictionary *)[parser objectWithString:str];
        int resources_version = [[json objectForKey:@"resources_version"] intValue];
        NSLog(@"resources_version %d",resources_version);
        return [NSNumber numberWithInt:resources_version];
        
    }
    return [NSNumber numberWithInt:0];
}

-(NSNumber *)checkFileExists {
    @try {
        NSBundle *bundle = [NSBundle bundleForClass:[self class]];
        NSString *bundlePath = [bundle pathForResource:@"OPGResourceBundle" ofType:@"bundle"];
        NSString *resourceFilePath = [bundlePath stringByAppendingPathComponent:@"resources_version.json"];
        
        if (![[NSFileManager defaultManager] fileExistsAtPath: resourceFilePath]) {
            return [NSNumber numberWithBool:NO];
        }
        else {
            NSString *cacheDirPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
            NSError* error;
            NSString *cacheResourceFilePath = [cacheDirPath stringByAppendingPathComponent:@"resources_version.json"];
            if ([[NSFileManager defaultManager] fileExistsAtPath: cacheResourceFilePath]) {
                NSNumber *cacheResFileVersion = [self getAssetsVersion:cacheResourceFilePath];
                NSNumber *resFileVersion = [self getAssetsVersion:resourceFilePath];
                if ([cacheResFileVersion intValue] == [resFileVersion intValue]) {
                    return [NSNumber numberWithBool:NO];
                }
                else{
                    [[NSFileManager defaultManager] removeItemAtPath:cacheResourceFilePath error:&error];
                    [[NSFileManager defaultManager] copyItemAtPath:resourceFilePath toPath:cacheResourceFilePath error:&error];
                    [self copyResourceBundleFiles:bundlePath];
                    return [NSNumber numberWithBool:YES];
                }
            }
            else {
                [[NSFileManager defaultManager] copyItemAtPath:resourceFilePath toPath:cacheResourceFilePath error:&error];
                [self copyResourceBundleFiles:bundlePath];
                return [NSNumber numberWithBool:NO];
            }
        }
    }
    @catch (NSException *exception) {
        NSLog(@"exception - %@",exception);
    }
}

- (NSString *)loadSurveyLink:(NSString *)surveyRef withDictionary:(NSDictionary *)values{
    
    NSString *deviceID=[[[UIDevice currentDevice]identifierForVendor]UUIDString];
    NSDictionary *dictionary;
    if(self.panelID == nil || self.panellistID == nil)
    {
        dictionary=[[NSDictionary alloc]initWithObjectsAndKeys:[NSString stringWithFormat:@"%@", self.surveyReference],@"surveyReference",@"ios",@"platform",@"B1",@"SEV",deviceID,@"deviceID" ,nil];
    }
    else
    {
        //for resuming online survey
        dictionary=[[NSDictionary alloc]initWithObjectsAndKeys:[NSString stringWithFormat:@"%@", self.surveyReference],@"surveyReference",self.panellistID,@"panellistID",self.panelID,@"panelID",@"ios",@"platform",@"B1",@"SEV",deviceID,@"deviceID" ,nil];
    }
    
    NSString *encryptedJson=[[dictionary JSONRepresentation]AES256EncryptWithKey:KEY_DATA];
    NSString *urlString=[NSString stringWithFormat:@"%@?data=%@",[[NSUserDefaults standardUserDefaults]valueForKey:@"OPGInterviewUrl"],encryptedJson];
    //for Query Parameters
    if ([values count] > 0 || values != nil)
    {
        NSString *dictURLString = [self getURLStringFromDict:values];
        return [NSString stringWithFormat:@"%@&%@",urlString,dictURLString];
    }
    return urlString;
}


- (void)loadSurvey:(NSString *)surveyRef{
    self.surveyReference = surveyRef;
    [self loadWebviewWithSurvey];
}

- (void)loadSurvey:(NSString *)surveyRef panelID:(NSNumber*)panelID panellistID:(NSNumber*)panellistID
{
    self.surveyReference = surveyRef;
    self.panelID = panelID;
    self.panellistID = panellistID;
    [self loadWebviewWithSurvey];
}

-(void)loadSurvey:(NSString *)surveyRef withDictionary:(NSDictionary *)values
{
    self.surveyReference = surveyRef;
    if ([values count] > 0 || values != nil)
    {
         self.queryDict = values;
    }
    [self loadWebviewWithSurvey];
}

-(void)loadSurvey:(NSString *)surveyRef panelID:(NSNumber*)panelID panellistID:(NSNumber*)panellistID withDictionary:(NSDictionary *)values
{
    self.surveyReference = surveyRef;
    self.panelID = panelID;
    self.panellistID = panellistID;
    if ([values count] > 0 || values != nil)
    {
         self.queryDict = values;
    }
    [self loadWebviewWithSurvey];
}


//Offline Survey
-(void)loadOfflineSurvey:(NSString*)scriptPath surveyName:(NSString*)surveyName surveyID:(NSNumber*)surveyID panelID:(NSNumber*)panelID panellistID:(NSNumber*)panellistID
{
    [self initWebView];
    dispatch_queue_t myQueue = dispatch_queue_create("My Queue",NULL);
    dispatch_async(myQueue, ^{
        NSNumber *num = [self checkFileExists];
        NSLog(@"checkFileExists %@",num);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self start:scriptPath surveyName:surveyName surveyID:surveyID panelID:panelID panellistID:panellistID panellistProfile:nil];
        });
     });
}

-(void)loadOfflineSurvey:(NSString *)scriptPath surveyName:(NSString *)surveyName surveyID:(NSNumber *)surveyID panelID:(NSNumber *)panelID panellistID:(NSNumber *)panellistID panellistProfile:(OPGPanellistProfile*)panellistProfile {
    // Overloaded loadOfflineSurvey for passing Additional Sample Record
    [self initWebView];
    dispatch_queue_t myQueue = dispatch_queue_create("My Queue",NULL);
    dispatch_async(myQueue, ^{
        NSNumber *num = [self checkFileExists];
        NSLog(@"checkFileExists %@",num);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self start:scriptPath surveyName:surveyName surveyID:surveyID panelID:panelID panellistID:panellistID panellistProfile:panellistProfile];
        });
     });
}

-(void)successCallBack:(NSString*)jsCallbackValue withcallbackId:(NSString*)callbackID{
    OPGPluginResult* pluginResult = [OPGPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:jsCallbackValue];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:callbackID];
   
}
-(void)errorCallBack:(NSString*)jsCallbackValue withcallbackId:(NSString*)callbackID{
  
   OPGPluginResult* pluginResult=[OPGPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:jsCallbackValue];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:callbackID];
   
}


-(NSString *) getURLStringFromDict : (NSDictionary*)values
{
        NSMutableArray *pairs = NSMutableArray.array;
        for (NSString *key in values.keyEnumerator) {
            id value = values[key];
            if ([value isKindOfClass:[NSDictionary class]])
                for (NSString *subKey in value)
                    [pairs addObject:[NSString stringWithFormat:@"%@[%@]=%@", key, subKey, [self escapeValueForURLParameter:[value objectForKey:subKey]]]];
            
            else if ([value isKindOfClass:[NSArray class]])
                for (NSString *subValue in value)
                    [pairs addObject:[NSString stringWithFormat:@"%@[]=%@", key, [self escapeValueForURLParameter:subValue]]];
            
            else
                [pairs addObject:[NSString stringWithFormat:@"%@=%@", key, [self escapeValueForURLParameter:value]]];
            
        }
        return [pairs componentsJoinedByString:@"&"];
}

- (NSString *)escapeValueForURLParameter:(NSString *)valueToEscape {
    return (__bridge_transfer NSString *) CFURLCreateStringByAddingPercentEscapes(NULL, (__bridge CFStringRef) valueToEscape,
                                                                                  NULL, (CFStringRef) @"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8);
}

- (void)__init
{
    if ((self != nil) && !self.initialized) {
        _commandQueue = [[OPGCommandQueue alloc] initWithViewController:self];
        _commandDelegate = [[OPGCommandDelegateImpl alloc] initWithViewController:self];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onAppWillTerminate:)
                                                     name:UIApplicationWillTerminateNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onAppWillResignActive:)
                                                     name:UIApplicationWillResignActiveNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onAppDidBecomeActive:)
                                                     name:UIApplicationDidBecomeActiveNotification object:nil];

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onAppWillEnterForeground:)
                                                     name:UIApplicationWillEnterForegroundNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onAppDidEnterBackground:)
                                                     name:UIApplicationDidEnterBackgroundNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onPageDidLoad:)
                                                     name:CDVPageDidLoadNotification object:nil];

        // read from UISupportedInterfaceOrientations (or UISupportedInterfaceOrientations~iPad, if its iPad) from -Info.plist
        self.supportedOrientations = [self parseInterfaceOrientations:
            [[[NSBundle mainBundle] infoDictionary] objectForKey:@"UISupportedInterfaceOrientations"]];

      //  [self printVersion];
      //  [self printMultitaskingInfo];
        [self printPlatformVersionWarning];
        self.initialized = YES;

        // load config.xml settings
        [self loadSettings];
    }
}

- (id)initWithNibName:(NSString*)nibNameOrNil bundle:(NSBundle*)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    [self __init];
    return self;
}

- (id)initWithCoder:(NSCoder*)aDecoder
{
    self = [super initWithCoder:aDecoder];
    [self __init];
    return self;
}

- (id)init
{
    self = [super init];
    [self __init];
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)printVersion
{
    NSLog(@"OPG Web native platform version %@ is starting.", CDV_VERSION);
}

- (void)printPlatformVersionWarning
{
    if (!IsAtLeastiOSVersion(@"6.0")) {
        NSLog(@"CRITICAL: For Cordova 3.5.0 and above, you will need to upgrade to at least iOS 6.0 or greater. Your current version of iOS is %@.",
            [[UIDevice currentDevice] systemVersion]
            );
    }
}

- (void)printMultitaskingInfo
{
    UIDevice* device = [UIDevice currentDevice];
    BOOL backgroundSupported = NO;

    if ([device respondsToSelector:@selector(isMultitaskingSupported)]) {
        backgroundSupported = device.multitaskingSupported;
    }

    NSNumber* exitsOnSuspend = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"UIApplicationExitsOnSuspend"];
    if (exitsOnSuspend == nil) { // if it's missing, it should be NO (i.e. multi-tasking on by default)
        exitsOnSuspend = [NSNumber numberWithBool:NO];
    }

   // NSLog(@"Multi-tasking -> Device: %@, App: %@", (backgroundSupported ? @"YES" : @"NO"), (![exitsOnSuspend intValue]) ? @"YES" : @"NO");
}

- (BOOL)URLisAllowed:(NSURL*)url
{
    if (self.whitelist == nil) {
        return YES;
    }

    return [self.whitelist URLIsAllowed:url];
}

- (void)loadSettings

{
    OPGConfigParser* delegate = [[OPGConfigParser alloc] init];

    // read from config.xml in the app bundle
    
    NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"OPGResourceBundle" ofType:@"bundle"];
    NSBundle *bundle = [NSBundle bundleWithPath:bundlePath];
    NSString *path = [bundle pathForResource:@"config" ofType:@"xml"];
    
    
  //  NSString* path = [[NSBundle mainBundle] pathForResource:@"config" ofType:@"xml"];

    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
        NSAssert(NO, @"ERROR: config.xml does not exist. Please run cordova-ios/bin/cordova_plist_to_config_xml path/to/project.");
        return;
    }

    NSURL* url = [NSURL fileURLWithPath:path];

    configParser = [[NSXMLParser alloc] initWithContentsOfURL:url];
    if (configParser == nil) {
        NSLog(@"Failed to initialize XML parser.");
        return;
    }
    [configParser setDelegate:((id < NSXMLParserDelegate >)delegate)];
    [configParser parse];

    // Get the plugin dictionary, whitelist and settings from the delegate.
    self.pluginsMap = delegate.pluginsDict;
    self.startupPluginNames = delegate.startupPluginNames;
    self.whitelist = [[OPGWhitelist alloc] initWithArray:delegate.whitelistHosts];
    self.settings = delegate.settings;

    // And the start folder/page.
    self.wwwFolderName = @"www";
    self.startPage = delegate.startPage;
    if (self.startPage == nil) {
        self.startPage = @"index.html";
    }

    // Initialize the plugin objects dict.
    self.pluginObjects = [[NSMutableDictionary alloc] initWithCapacity:20];
}


- (NSURL*)appUrl
{
    NSURL* appURL = nil;

    if ([self.startPage rangeOfString:@"://"].location != NSNotFound) {
        appURL = [NSURL URLWithString:self.startPage];
    } else if ([self.wwwFolderName rangeOfString:@"://"].location != NSNotFound) {
        appURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", self.wwwFolderName, self.startPage]];
    } else {
        // CB-3005 strip parameters from start page to check if page exists in resources
        NSURL* startURL = [NSURL URLWithString:self.startPage];
        NSString* startFilePath = [self.commandDelegate pathForResource:[startURL path]];

        if (startFilePath == nil) {
            self.loadFromString = YES;
            appURL = nil;
        } else {
            appURL = [NSURL fileURLWithPath:startFilePath];
            // CB-3005 Add on the query params or fragment.
            NSString* startPageNoParentDirs = self.startPage;
            NSRange r = [startPageNoParentDirs rangeOfCharacterFromSet:[NSCharacterSet characterSetWithCharactersInString:@"?#"] options:0];
            if (r.location != NSNotFound) {
                NSString* queryAndOrFragment = [self.startPage substringFromIndex:r.location];
                appURL = [NSURL URLWithString:queryAndOrFragment relativeToURL:appURL];
            }
        }
    }

    return appURL;
}

- (NSURL*)errorUrl
{
    NSURL* errorURL = nil;

    id setting = [self settingForKey:@"ErrorUrl"];

    if (setting) {
        NSString* errorUrlString = (NSString*)setting;
        if ([errorUrlString rangeOfString:@"://"].location != NSNotFound) {
            errorURL = [NSURL URLWithString:errorUrlString];
        } else {
            NSURL* url = [NSURL URLWithString:(NSString*)setting];
            NSString* errorFilePath = [self.commandDelegate pathForResource:[url path]];
            if (errorFilePath) {
                errorURL = [NSURL fileURLWithPath:errorFilePath];
            }
        }
    }

    return errorURL;
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];

   
    
    
}

-(void)initWebView{
   // // Fix the iOS 5.1 SECURITY_ERR bug (CB-347), this must be before the webView is instantiated ////
    
    NSString* backupWebStorageType = @"cloud"; // default value
    
    id backupWebStorage = [self settingForKey:@"BackupWebStorage"];
    if ([backupWebStorage isKindOfClass:[NSString class]]) {
        backupWebStorageType = backupWebStorage;
    }
    [self setSetting:backupWebStorageType forKey:@"BackupWebStorage"];
    
    if (IsAtLeastiOSVersion(@"5.1")) {
        [OPGLocalStorage __fixupDatabaseLocationsWithBackupType:backupWebStorageType];
    }
    
    // // Instantiate the WebView ///////////////
    
    
    
    
    // /////////////////
    if (!self.webView) {
        [self createGapView];
    }
    
    // Configure WebView
    _webViewDelegate = [[OPGWebViewDelegate alloc] initWithDelegate:self];
    self.webView.delegate = _webViewDelegate;
    
    // register this viewcontroller with the NSURLProtocol, only after the User-Agent is set
    [OPGURLProtocol registerViewController:self];
    
    // /////////////////
    
    NSString* enableViewportScale = [self settingForKey:@"EnableViewportScale"];
    NSNumber* allowInlineMediaPlayback = [self settingForKey:@"AllowInlineMediaPlayback"];
    BOOL mediaPlaybackRequiresUserAction = YES;  // default value
    if ([self settingForKey:@"MediaPlaybackRequiresUserAction"]) {
        mediaPlaybackRequiresUserAction = [(NSNumber*)[self settingForKey:@"MediaPlaybackRequiresUserAction"] boolValue];
    }
    
    self.webView.scalesPageToFit = [enableViewportScale boolValue];
    
    /*
     * Fire up CDVLocalStorage to work-around WebKit storage limitations: on all iOS 5.1+ versions for local-only backups, but only needed on iOS 5.1 for cloud backup.
     */
    if (IsAtLeastiOSVersion(@"5.1") && (([backupWebStorageType isEqualToString:@"local"]) ||
                                        ([backupWebStorageType isEqualToString:@"cloud"] && !IsAtLeastiOSVersion(@"6.0")))) {
        [self registerPlugin:[[OPGLocalStorage alloc] initWithWebView:self.webView] withClassName:NSStringFromClass([OPGLocalStorage class])];
    }
    
    /*
     * This is for iOS 4.x, where you can allow inline <video> and <audio>, and also autoplay them
     */
    if ([allowInlineMediaPlayback boolValue] && [self.webView respondsToSelector:@selector(allowsInlineMediaPlayback)]) {
        self.webView.allowsInlineMediaPlayback = YES;
    }
    if ((mediaPlaybackRequiresUserAction == NO) && [self.webView respondsToSelector:@selector(mediaPlaybackRequiresUserAction)]) {
        self.webView.mediaPlaybackRequiresUserAction = NO;
    }
    
    // By default, overscroll bouncing is allowed.
    // UIWebViewBounce has been renamed to DisallowOverscroll, but both are checked.
    BOOL bounceAllowed = YES;
    NSNumber* disallowOverscroll = [self settingForKey:@"DisallowOverscroll"];
    if (disallowOverscroll == nil) {
        NSNumber* bouncePreference = [self settingForKey:@"UIWebViewBounce"];
        bounceAllowed = (bouncePreference == nil || [bouncePreference boolValue]);
    } else {
        bounceAllowed = ![disallowOverscroll boolValue];
    }
    
    // prevent webView from bouncing
    // based on the DisallowOverscroll/UIWebViewBounce key in config.xml
    if (!bounceAllowed) {
        if ([self.webView respondsToSelector:@selector(scrollView)]) {
            ((UIScrollView*)[self.webView scrollView]).bounces = NO;
        } else {
            for (id subview in self.webView.subviews) {
                if ([[subview class] isSubclassOfClass:[UIScrollView class]]) {
                    ((UIScrollView*)subview).bounces = NO;
                }
            }
        }
    }
    
    NSString* decelerationSetting = [self settingForKey:@"UIWebViewDecelerationSpeed"];
    if (![@"fast" isEqualToString:decelerationSetting]) {
        [self.webView.scrollView setDecelerationRate:UIScrollViewDecelerationRateNormal];
    }
    
    /*
     * iOS 6.0 UIWebView properties
     */
    if (IsAtLeastiOSVersion(@"6.0")) {
        BOOL keyboardDisplayRequiresUserAction = YES; // KeyboardDisplayRequiresUserAction - defaults to YES
        if ([self settingForKey:@"KeyboardDisplayRequiresUserAction"] != nil) {
            if ([self settingForKey:@"KeyboardDisplayRequiresUserAction"]) {
                keyboardDisplayRequiresUserAction = [(NSNumber*)[self settingForKey:@"KeyboardDisplayRequiresUserAction"] boolValue];
            }
        }
        
        // property check for compiling under iOS < 6
        if ([self.webView respondsToSelector:@selector(setKeyboardDisplayRequiresUserAction:)]) {
            [self.webView setValue:[NSNumber numberWithBool:keyboardDisplayRequiresUserAction] forKey:@"keyboardDisplayRequiresUserAction"];
        }
        
        BOOL suppressesIncrementalRendering = NO; // SuppressesIncrementalRendering - defaults to NO
        if ([self settingForKey:@"SuppressesIncrementalRendering"] != nil) {
            if ([self settingForKey:@"SuppressesIncrementalRendering"]) {
                suppressesIncrementalRendering = [(NSNumber*)[self settingForKey:@"SuppressesIncrementalRendering"] boolValue];
            }
        }
        
        // property check for compiling under iOS < 6
        if ([self.webView respondsToSelector:@selector(setSuppressesIncrementalRendering:)]) {
            [self.webView setValue:[NSNumber numberWithBool:suppressesIncrementalRendering] forKey:@"suppressesIncrementalRendering"];
        }
    }
    
    /*
     * iOS 7.0 UIWebView properties
     */
    if (IsAtLeastiOSVersion(@"7.0")) {
        SEL ios7sel = nil;
        id prefObj = nil;
        
        CGFloat gapBetweenPages = 0.0; // default
        prefObj = [self settingForKey:@"GapBetweenPages"];
        if (prefObj != nil) {
            gapBetweenPages = [prefObj floatValue];
        }
        
        // property check for compiling under iOS < 7
        ios7sel = NSSelectorFromString(@"setGapBetweenPages:");
        if ([self.webView respondsToSelector:ios7sel]) {
            [self.webView setValue:[NSNumber numberWithFloat:gapBetweenPages] forKey:@"gapBetweenPages"];
        }
        
        CGFloat pageLength = 0.0; // default
        prefObj = [self settingForKey:@"PageLength"];
        if (prefObj != nil) {
            pageLength = [[self settingForKey:@"PageLength"] floatValue];
        }
        
        // property check for compiling under iOS < 7
        ios7sel = NSSelectorFromString(@"setPageLength:");
        if ([self.webView respondsToSelector:ios7sel]) {
            [self.webView setValue:[NSNumber numberWithBool:pageLength] forKey:@"pageLength"];
        }
        
        NSInteger paginationBreakingMode = 0; // default - UIWebPaginationBreakingModePage
        prefObj = [self settingForKey:@"PaginationBreakingMode"];
        if (prefObj != nil) {
            NSArray* validValues = @[@"page", @"column"];
            NSString* prefValue = [validValues objectAtIndex:0];
            
            if ([prefObj isKindOfClass:[NSString class]]) {
                prefValue = prefObj;
            }
            
            paginationBreakingMode = [validValues indexOfObject:[prefValue lowercaseString]];
            if (paginationBreakingMode == NSNotFound) {
                paginationBreakingMode = 0;
            }
        }
        
        // property check for compiling under iOS < 7
        ios7sel = NSSelectorFromString(@"setPaginationBreakingMode:");
        if ([self.webView respondsToSelector:ios7sel]) {
            [self.webView setValue:[NSNumber numberWithInteger:paginationBreakingMode] forKey:@"paginationBreakingMode"];
        }
        
        NSInteger paginationMode = 0; // default - UIWebPaginationModeUnpaginated
        prefObj = [self settingForKey:@"PaginationMode"];
        if (prefObj != nil) {
            NSArray* validValues = @[@"unpaginated", @"lefttoright", @"toptobottom", @"bottomtotop", @"righttoleft"];
            NSString* prefValue = [validValues objectAtIndex:0];
            
            if ([prefObj isKindOfClass:[NSString class]]) {
                prefValue = prefObj;
            }
            
            paginationMode = [validValues indexOfObject:[prefValue lowercaseString]];
            if (paginationMode == NSNotFound) {
                paginationMode = 0;
            }
        }
        
        // property check for compiling under iOS < 7
        ios7sel = NSSelectorFromString(@"setPaginationMode:");
        if ([self.webView respondsToSelector:ios7sel]) {
            [self.webView setValue:[NSNumber numberWithInteger:paginationMode] forKey:@"paginationMode"];
        }
    }
    
    if ([self.startupPluginNames count] > 0) {
        [OPGTimer start:@"TotalPluginStartup"];
        
        for (NSString* pluginName in self.startupPluginNames) {
            [OPGTimer start:pluginName];
            [self getCommandInstance:pluginName];
            [OPGTimer stop:pluginName];
        }
        
        [OPGTimer stop:@"TotalPluginStartup"];
    }
}



-(void)loadWebviewWithSurvey{
    
    [self initWebView];
    
    if (self.surveyReference != nil) {
        [self registerPlugin:[[OPGHandleOpenURL alloc] initWithWebView:self.webView] withClassName:NSStringFromClass([OPGHandleOpenURL class])];

        NSURL* appURL = [[NSURL alloc] initWithString:[self loadSurveyLink:self.surveyReference withDictionary:self.queryDict]];
        
        [OPGUserAgentUtil acquireLock:^(NSInteger lockToken) {
            _userAgentLockToken = lockToken;
            [OPGUserAgentUtil setUserAgent:self.userAgent lockToken:lockToken];
            if (appURL) {
                NSURLRequest* appReq = [NSURLRequest requestWithURL:appURL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:20.0];
                [self.webView loadRequest:appReq];
            } else {
                NSString* loadErr = [NSString stringWithFormat:@"ERROR: Start Page at '%@/%@' was not found.", self.wwwFolderName, self.startPage];
                //  NSLog(@"%@", loadErr);
                
                NSURL* errorUrl = [self errorUrl];
                if (errorUrl) {
                    errorUrl = [NSURL URLWithString:[NSString stringWithFormat:@"?error=%@", [loadErr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] relativeToURL:errorUrl];
                    //   NSLog(@"%@", [errorUrl absoluteString]);
                    [self.webView loadRequest:[NSURLRequest requestWithURL:errorUrl]];
                } else {
                    NSString* html = [NSString stringWithFormat:@"<html><body> %@ </body></html>", loadErr];
                    [self.webView loadHTMLString:html baseURL:nil];
                }
            }
        }];
    }
}


- (void)start:(NSString*)scriptPath surveyName:(NSString*)surveyName surveyID:(NSNumber*)surveyID panelID:(NSNumber*)panelID panellistID:(NSNumber*)panellistID panellistProfile:(OPGPanellistProfile*)panellistProfile
{
    
    //NSLog(@"startRuntimePlugin");
    __block BOOL isScriptAvailable=FALSE;
    __block BOOL isExceptionOccured=FALSE;
    dispatch_queue_t myQueue = dispatch_queue_create("My Queue",NULL);
    dispatch_async(myQueue, ^{
        @try {
            NSDictionary *values= [NSDictionary dictionaryWithObjectsAndKeys:
                                     [surveyID stringValue], @"surveyID",
                                     panelID, @"panelID",
                                     surveyName,@"surveyName",panellistID,@"panellistID",nil];

            [[NSUserDefaults standardUserDefaults] setObject:@"true" forKey:@"OPGIsOfflineSurvey"];

            if ([[NSFileManager defaultManager] fileExistsAtPath:scriptPath])
            {
                self->cont = [[Controller alloc]initWithSurveyId:[values valueForKey:@"surveyID"]];
                [OPGRuntimePlugin setController:self->cont];
                self->player = [[WebPlayer alloc]initWithInteractor:self];

                WebSession *lSession=[[WebSession alloc]init];
                [self->player setWebSession:lSession];
                [OPGRuntimePlugin setWebPlayer:self->player];

                if (panellistProfile == nil) {
                    // Normal offline survey
                    self->session = [lSession createSession:surveyName withIplayer:self->player withType:0 values:values];
                }
                else {
                    // Offline survey with Additional Params in Sample Record
                    NSDictionary *panellistProfileValues = [self convertProfileToDictionary:panellistProfile panelID:[panelID stringValue]];
                    NSLog(@"Values in Start Method is %@", panellistProfileValues);
                    self->session = [lSession createSession:surveyName withIplayer:self->player withType:0 values:values additionalValues:panellistProfileValues];
                }
                [OPGRuntimePlugin setInterviewSession:self->session];
                [self->session execute];
                isScriptAvailable=TRUE;

            }

        }
        @catch (NSException *exception) {
            NSLog(@"exception - %@",exception);

            isExceptionOccured =TRUE;
            isScriptAvailable=TRUE;
        }
    dispatch_async(dispatch_get_main_queue(), ^{
           if (!isScriptAvailable) {
              // [self errorCallBack:@"Script is not available for this survey" withcallbackId:command.callbackId];
           }
        else if (isExceptionOccured)
        {
           // [self errorCallBack:@" Error Occurred " withcallbackId:command.callbackId];
        }
           
      });
    
    });
}

-(NSDictionary*) convertProfileToDictionary: (OPGPanellistProfile*) profile panelID:(NSString*) panelID{
    // WORK IN PROGRESS
    NSMutableDictionary *profileDict = [NSMutableDictionary new];
    if (profile == nil) {
        // empty dictionary
        return profileDict;
    }

    [profileDict setValue:profile.title forKey:@"Title"];
    [profileDict setValue:profile.address1 forKey:@"Address1"];
    [profileDict setValue:profile.address2 forKey:@"Address2"];
    [profileDict setValue:profile.DOB forKey:@"DOB"];
    [profileDict setValue:profile.email forKey:@"Email"];
    [profileDict setValue:profile.mobileNumber forKey:@"MobileNumber"];
    [profileDict setValue:profile.firstName forKey:@"FirstName"];
    [profileDict setValue:profile.lastName forKey:@"LastName"];
    [profileDict setValue:[profile.gender stringValue] forKey:@"Gender"];
    [profileDict setValue:profile.postalCode forKey:@"PostalCode"];
    [profileDict setValue:profile.mediaID forKey:@"MediaID"];

    // ADD ADDITIONAL FIELDS TO THE DICTIONARY
    NSString *additionalFieldString = profile.additionalParams;
    NSDictionary *additionalFieldsDict = [self parseAdditionalFields:additionalFieldString panelID:panelID];
    [profileDict addEntriesFromDictionary:additionalFieldsDict];
    return profileDict;
}

-(NSDictionary*) parseAdditionalFields: (NSString*) additionalFieldStr panelID:(NSString*) panelID {
    NSMutableDictionary *additionalFieldsDict = [NSMutableDictionary new];
    NSArray *additionalFieldArray = [additionalFieldStr componentsSeparatedByString:@","];
    NSString* panelIDToRemove = [panelID stringByAppendingString:@"-"];
    for (NSString* field in additionalFieldArray) {
        if ([field containsString:panelIDToRemove]) {
            NSString* keyValuePair = [field stringByReplacingOccurrencesOfString:panelIDToRemove withString:@""];
            NSArray *keyValueArray = [keyValuePair componentsSeparatedByString:@":"];
            if([keyValueArray count]==2) {
                [additionalFieldsDict setObject:keyValueArray[1] forKey:keyValueArray[0]];
            }
        }
    }
    return additionalFieldsDict;
}


-(void) postURL:(NSString*)url{
    
     dispatch_async(dispatch_get_main_queue(), ^{
         
    if ([url rangeOfString:@"status=3"].location!=NSNotFound)
    {

        [[NSUserDefaults standardUserDefaults] setObject:@"false" forKey:@"OPGIsOfflineSurvey"];
        if([self respondsToSelector:@selector(opgsurveyCompleted)]) {
                [self opgsurveyCompleted];
            }



        // delete survey media content
        NSFileManager* fileMgr = [[NSFileManager alloc] init];
        NSError* err = nil;
        NSString* tempDirectoryPath = NSTemporaryDirectory();
        NSDirectoryEnumerator* directoryEnumerator = [fileMgr enumeratorAtPath:tempDirectoryPath];
        NSString* fileName = nil;
        BOOL result;
        while ((fileName = [directoryEnumerator nextObject])) {
            if ([fileName hasPrefix:@"AppMedia"]) {
                continue;
            }
            NSString* filePath = [tempDirectoryPath stringByAppendingPathComponent:fileName];
            result = [fileMgr removeItemAtPath:filePath error:&err];
            if (!result && err) {
                NSLog(@"Failed to delete: %@ (error: %@)", filePath, err);
                
            }
        }

        return;
    }
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    [self.webView loadRequest:request];

    });
}

-(void)loadWebviewOfflineSurvey:(NSString *)appUrl{
    
    [self initWebView];
    
        [self registerPlugin:[[OPGHandleOpenURL alloc] initWithWebView:self.webView] withClassName:NSStringFromClass([OPGHandleOpenURL class])];

        NSURL* appURL = [[NSURL alloc] initWithString:appUrl];
        
        [OPGUserAgentUtil acquireLock:^(NSInteger lockToken) {
            self->_userAgentLockToken = lockToken;
            [OPGUserAgentUtil setUserAgent:self.userAgent lockToken:lockToken];
            if (appURL) {
                NSURLRequest* appReq = [NSURLRequest requestWithURL:appURL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:20.0];
                [self.webView loadRequest:appReq];
            } else {
               //Errorcallback code
            }
        }];

}




- (id)settingForKey:(NSString*)key
{
    return [[self settings] objectForKey:[key lowercaseString]];
}

- (void)setSetting:(id)setting forKey:(NSString*)key
{
    [[self settings] setObject:setting forKey:[key lowercaseString]];
}

- (NSArray*)parseInterfaceOrientations:(NSArray*)orientations
{
    NSMutableArray* result = [[NSMutableArray alloc] init];

    if (orientations != nil) {
        NSEnumerator* enumerator = [orientations objectEnumerator];
        NSString* orientationString;

        while (orientationString = [enumerator nextObject]) {
            if ([orientationString isEqualToString:@"UIInterfaceOrientationPortrait"]) {
                [result addObject:[NSNumber numberWithInt:UIInterfaceOrientationPortrait]];
            } else if ([orientationString isEqualToString:@"UIInterfaceOrientationPortraitUpsideDown"]) {
                [result addObject:[NSNumber numberWithInt:UIInterfaceOrientationPortraitUpsideDown]];
            } else if ([orientationString isEqualToString:@"UIInterfaceOrientationLandscapeLeft"]) {
                [result addObject:[NSNumber numberWithInt:UIInterfaceOrientationLandscapeLeft]];
            } else if ([orientationString isEqualToString:@"UIInterfaceOrientationLandscapeRight"]) {
                [result addObject:[NSNumber numberWithInt:UIInterfaceOrientationLandscapeRight]];
            }
        }
    }

    // default
    if ([result count] == 0) {
        [result addObject:[NSNumber numberWithInt:UIInterfaceOrientationPortrait]];
    }

    return result;
}

- (NSInteger)mapIosOrientationToJsOrientation:(UIInterfaceOrientation)orientation
{
    switch (orientation) {
        case UIInterfaceOrientationPortraitUpsideDown:
            return 180;

        case UIInterfaceOrientationLandscapeLeft:
            return -90;

        case UIInterfaceOrientationLandscapeRight:
            return 90;

        case UIInterfaceOrientationPortrait:
            return 0;

        default:
            return 0;
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // First, ask the webview via JS if it supports the new orientation
    NSString* jsCall = [NSString stringWithFormat:
        @"window.shouldRotateToOrientation && window.shouldRotateToOrientation(%ld);"
        , (long)[self mapIosOrientationToJsOrientation:interfaceOrientation]];
    NSString* res = [webView stringByEvaluatingJavaScriptFromString:jsCall];

    if ([res length] > 0) {
        return [res boolValue];
    }

    // if js did not handle the new orientation (no return value), use values from the plist (via supportedOrientations)
    return [self supportsOrientation:interfaceOrientation];
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    NSUInteger ret = 0;

    if ([self shouldAutorotateToInterfaceOrientation:UIInterfaceOrientationPortrait]) {
        ret = ret | (1 << UIInterfaceOrientationPortrait);
    }
    if ([self shouldAutorotateToInterfaceOrientation:UIInterfaceOrientationPortraitUpsideDown]) {
        ret = ret | (1 << UIInterfaceOrientationPortraitUpsideDown);
    }
    if ([self shouldAutorotateToInterfaceOrientation:UIInterfaceOrientationLandscapeRight]) {
        ret = ret | (1 << UIInterfaceOrientationLandscapeRight);
    }
    if ([self shouldAutorotateToInterfaceOrientation:UIInterfaceOrientationLandscapeLeft]) {
        ret = ret | (1 << UIInterfaceOrientationLandscapeLeft);
    }

    return ret;
}

- (BOOL)supportsOrientation:(UIInterfaceOrientation)orientation
{
    return [self.supportedOrientations containsObject:[NSNumber numberWithInt:orientation]];
}

- (UIWebView*)newCordovaViewWithFrame:(CGRect)bounds
{
    return [[UIWebView alloc] initWithFrame:bounds];
}

- (NSString*)userAgent
{
    if (_userAgent == nil) {
        NSString* localBaseUserAgent;
        if (self.baseUserAgent != nil) {
            localBaseUserAgent = self.baseUserAgent;
        } else {
            localBaseUserAgent = [OPGUserAgentUtil originalUserAgent];
        }
        // Use our address as a unique number to append to the User-Agent.
        _userAgent = [NSString stringWithFormat:@"%@ (%lld)", localBaseUserAgent, (long long)self];
    }
    return _userAgent;
}

- (void)createGapView
{
    CGRect webViewBounds = self.view.bounds;

    webViewBounds.origin = self.view.bounds.origin;

    self.webView = [self newCordovaViewWithFrame:webViewBounds];
    self.webView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);

    [self.view addSubview:self.webView];
    [self.view sendSubviewToBack:self.webView];
}

- (void)didReceiveMemoryWarning
{
    // iterate through all the plugin objects, and call hasPendingOperation
    // if at least one has a pending operation, we don't call [super didReceiveMemoryWarning]

    NSEnumerator* enumerator = [self.pluginObjects objectEnumerator];
    OPGPlugin* plugin;

    BOOL doPurge = YES;

    while ((plugin = [enumerator nextObject])) {
        if (plugin.hasPendingOperation) {
        //    NSLog(@"Plugin '%@' has a pending operation, memory purge is delayed for didReceiveMemoryWarning.", NSStringFromClass([plugin class]));
            doPurge = NO;
        }
    }

    if (doPurge) {
        // Releases the view if it doesn't have a superview.
        [super didReceiveMemoryWarning];
    }

    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload
{
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;

    self.webView.delegate = nil;
    self.webView = nil;
    [OPGUserAgentUtil releaseLock:&_userAgentLockToken];

    [super viewDidUnload];
}

#pragma mark UIWebViewDelegate

/**
 When web application loads Add stuff to the DOM, mainly the user-defined settings from the Settings.plist file, and
 the device's data such as device ID, platform version, etc.
 */

- (void)webViewDidStartLoad:(UIWebView*)theWebView
{
   // NSLog(@"Resetting plugins due to page load.");
    if([self respondsToSelector:@selector(opgdidOnePointWebViewStartLoad)]){
        [self opgdidOnePointWebViewStartLoad];
    }
    
    [_commandQueue resetRequestId];
    [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:CDVPluginResetNotification object:self.webView]];
}

/**
 Called when the webview finishes loading.  This stops the activity view.
 */
- (void)webViewDidFinishLoad:(UIWebView*)theWebView
{
    NSString *url=[webView.request.URL absoluteString];
        if ([url rangeOfString:@"status=3"].location!=NSNotFound){
            if([self respondsToSelector:@selector(opgsurveyCompleted)]) {
                [self opgsurveyCompleted];
            }
        }
        else if([self respondsToSelector:@selector(opgdidOnePointWebViewFinishLoad)]) {
            [self opgdidOnePointWebViewFinishLoad];
        }
    
    
    // It's safe to release the lock even if this is just a sub-frame that's finished loading.
    [OPGUserAgentUtil releaseLock:&_userAgentLockToken];

    /*
     * Hide the Top Activity THROBBER in the Battery Bar
     */
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];

    [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:CDVPageDidLoadNotification object:self.webView]];
}

- (void)webView:(UIWebView*)theWebView didFailLoadWithError:(NSError*)error
{
    [OPGUserAgentUtil releaseLock:&_userAgentLockToken];

    NSString* message = [NSString stringWithFormat:@"Failed to load webpage with error: %@", [error localizedDescription]];
    NSLog(@"%@", message);
    if ([self respondsToSelector:@selector(opgdidOnePointWebViewLoadWithError:)]) {
        [self opgdidOnePointWebViewLoadWithError:error];
    }
    NSURL* errorUrl = [self errorUrl];
    if (errorUrl) {
        errorUrl = [NSURL URLWithString:[NSString stringWithFormat:@"?error=%@", [message stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] relativeToURL:errorUrl];
       // NSLog(@"%@", [errorUrl absoluteString]);
        [theWebView loadRequest:[NSURLRequest requestWithURL:errorUrl]];
    }
}

- (BOOL)webView:(UIWebView*)theWebView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSURL* url = [request URL];

    /*
     * Execute any commands queued with cordova.exec() on the JS side.
     * The part of the URL after gap:// is irrelevant.
     */
    if ([[url scheme] isEqualToString:@"gap"]) {
        [_commandQueue fetchCommandsFromJs];
        // The delegate is called asynchronously in this case, so we don't have to use
        // flushCommandQueueWithDelayedJs (setTimeout(0)) as we do with hash changes.
        [_commandQueue executePending];
        return NO;
    }

    if ([[url fragment] hasPrefix:@"%01"] || [[url fragment] hasPrefix:@"%02"]) {
        // Delegate is called *immediately* for hash changes. This means that any
        // calls to stringByEvaluatingJavascriptFromString will occur in the middle
        // of an existing (paused) call stack. This doesn't cause errors, but may
        // be unexpected to callers (exec callbacks will be called before exec() even
        // returns). To avoid this, we do not do any synchronous JS evals by using
        // flushCommandQueueWithDelayedJs.
        NSString* inlineCommands = [[url fragment] substringFromIndex:3];
        if ([inlineCommands length] == 0) {
            // Reach in right away since the WebCore / Main thread are already synchronized.
            [_commandQueue fetchCommandsFromJs];
        } else {
            inlineCommands = [inlineCommands stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [_commandQueue enqueueCommandBatch:inlineCommands];
        }
        // Switch these for minor performance improvements, and to really live on the wild side.
        // Callbacks will occur in the middle of the location.hash = ... statement!
        [(OPGCommandDelegateImpl*)_commandDelegate flushCommandQueueWithDelayedJs];
        // [_commandQueue executePending];

        // Although we return NO, the hash change does end up taking effect.
        return NO;
    }

    /*
     * Give plugins the chance to handle the url
     */
    for (NSString* pluginName in pluginObjects) {
        OPGPlugin* plugin = [pluginObjects objectForKey:pluginName];
        SEL selector = NSSelectorFromString(@"shouldOverrideLoadWithRequest:navigationType:");
        if ([plugin respondsToSelector:selector]) {
            if (((BOOL (*)(id, SEL, id, int))objc_msgSend)(plugin, selector, request, navigationType) == YES) {
                return NO;
            }
        }
    }

    /*
     * If a URL is being loaded that's a file/http/https URL, just load it internally
     */
    if ([url isFileURL]) {
        return YES;
    }

    /*
     *    If we loaded the HTML from a string, we let the app handle it
     */
    else if (self.loadFromString == YES) {
        self.loadFromString = NO;
        return YES;
    }

    /*
     * all tel: scheme urls we let the UIWebview handle it using the default behavior
     */
    else if ([[url scheme] isEqualToString:@"tel"]) {
        return YES;
    }

    /*
     * all about: scheme urls are not handled
     */
    else if ([[url scheme] isEqualToString:@"about"]) {
        return NO;
    }

    /*
     * all data: scheme urls are handled
     */
    else if ([[url scheme] isEqualToString:@"data"]) {
        return YES;
    }

    /*
     * Handle all other types of urls (tel:, sms:), and requests to load a url in the main webview.
     */
    else {
        if ([self.whitelist schemeIsAllowed:[url scheme]]) {
            return [self.whitelist URLIsAllowed:url];
        } else {
            if ([[UIApplication sharedApplication] canOpenURL:url]) {
                [[UIApplication sharedApplication] openURL:url];
            } else { // handle any custom schemes to plugins
                [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:CDVPluginHandleOpenURLNotification object:url]];
            }
        }

        return NO;
    }

    return YES;
}

#pragma mark GapHelpers

- (void)javascriptAlert:(NSString*)text
{
    NSString* jsString = [NSString stringWithFormat:@"alert('%@');", text];

    [self.commandDelegate evalJs:jsString];
}

+ (NSString*)applicationDocumentsDirectory
{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* basePath = (([paths count] > 0) ? ([paths objectAtIndex : 0]) : nil);

    return basePath;
}

#pragma mark CordovaCommands

- (void)registerPlugin:(OPGPlugin*)plugin withClassName:(NSString*)className
{
    if ([plugin respondsToSelector:@selector(setViewController:)]) {
        [plugin setViewController:self];
    }

    if ([plugin respondsToSelector:@selector(setCommandDelegate:)]) {
        [plugin setCommandDelegate:_commandDelegate];
    }

    [self.pluginObjects setObject:plugin forKey:className];
    [plugin pluginInitialize];
}

- (void)registerPlugin:(OPGPlugin*)plugin withPluginName:(NSString*)pluginName
{
    if ([plugin respondsToSelector:@selector(setViewController:)]) {
        [plugin setViewController:self];
    }

    if ([plugin respondsToSelector:@selector(setCommandDelegate:)]) {
        [plugin setCommandDelegate:_commandDelegate];
    }

    NSString* className = NSStringFromClass([plugin class]);
    [self.pluginObjects setObject:plugin forKey:className];
    [self.pluginsMap setValue:className forKey:[pluginName lowercaseString]];
    [plugin pluginInitialize];
}

/**
 Returns an instance of a CordovaCommand object, based on its name.  If one exists already, it is returned.
 */
- (id)getCommandInstance:(NSString*)pluginName
{
    // first, we try to find the pluginName in the pluginsMap
    // (acts as a whitelist as well) if it does not exist, we return nil
    // NOTE: plugin names are matched as lowercase to avoid problems - however, a
    // possible issue is there can be duplicates possible if you had:
    // "org.apache.cordova.Foo" and "org.apache.cordova.foo" - only the lower-cased entry will match
    NSString* className = [self.pluginsMap objectForKey:[pluginName lowercaseString]];

    if (className == nil) {
        return nil;
    }

    id obj = [self.pluginObjects objectForKey:className];
    if (!obj) {
        obj = [[NSClassFromString(className)alloc] initWithWebView:webView];

        if (obj != nil) {
            [self registerPlugin:obj withClassName:className];
        } else {
         //   NSLog(@"OPGPlugin class %@ (pluginName: %@) does not exist.", className, pluginName);
            
            
            
            
        }
    }
    return obj;
}

#pragma mark -

- (NSString*)appURLScheme
{
    NSString* URLScheme = nil;

    NSArray* URLTypes = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleURLTypes"];

    if (URLTypes != nil) {
        NSDictionary* dict = [URLTypes objectAtIndex:0];
        if (dict != nil) {
            NSArray* URLSchemes = [dict objectForKey:@"CFBundleURLSchemes"];
            if (URLSchemes != nil) {
                URLScheme = [URLSchemes objectAtIndex:0];
            }
        }
    }

    return URLScheme;
}

/**
 Returns the contents of the named plist bundle, loaded as a dictionary object
 */
+ (NSDictionary*)getBundlePlist:(NSString*)plistName
{
    NSString* errorDesc = nil;
    NSPropertyListFormat format;
    NSString* plistPath = [[NSBundle mainBundle] pathForResource:plistName ofType:@"plist"];
    NSData* plistXML = [[NSFileManager defaultManager] contentsAtPath:plistPath];
    NSDictionary* temp = (NSDictionary*)[NSPropertyListSerialization
        propertyListFromData:plistXML
            mutabilityOption:NSPropertyListMutableContainersAndLeaves
                      format:&format errorDescription:&errorDesc];

    return temp;
}

#pragma mark Orientation Change
- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{   
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context)
    {

    } completion:^(id<UIViewControllerTransitionCoordinatorContext> context)
    {
        [self adjustPreview];
    }];

    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
}


-(void)adjustPreview
{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;

    if(self.imageView)
    {
        if([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeLeft||[UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeRight)
        {
            if(self.navigationController)
            {
                self.imageBgView.frame=CGRectMake(0, 0,screenWidth,screenHeight);
                self.imageView.frame=CGRectMake(10, 20,screenWidth-20,screenHeight-90);
                self.closeButton.frame=CGRectMake(10,screenHeight-105, screenWidth-20,45);
            }
            else
            {
                self.imageBgView.frame=CGRectMake(0, 0,screenWidth,screenHeight);
                self.imageView.frame=CGRectMake(10, 20,screenWidth-20,screenHeight-40);
                self.closeButton.frame=CGRectMake(10,screenHeight-105, screenWidth-20,45);
            }

        }
        else if([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait||[UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortraitUpsideDown)
        {
            if(self.navigationController)
            {
                self.imageBgView.frame=CGRectMake(0, 0,screenWidth,screenHeight);
                self.imageView.frame=CGRectMake(10, 20,screenWidth-20,screenHeight-90);
                self.closeButton.frame=CGRectMake(10,screenHeight-110, screenWidth-20,45);
            }
            else
            {
                self.imageBgView.frame=CGRectMake(0, 0,screenWidth,screenHeight);
                self.imageView.frame=CGRectMake(10, 20,screenWidth-20,screenHeight-40);
                self.closeButton.frame=CGRectMake(10,screenHeight-110, screenWidth-20,45);
            }
        }
    }
    self.imageBgView.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
}



#pragma mark UIApplicationDelegate impl

/*
 This method lets your application know that it is about to be terminated and purged from memory entirely
 */
- (void)onAppWillTerminate:(NSNotification*)notification
{
    // empty the tmp directory
    NSFileManager* fileMgr = [[NSFileManager alloc] init];
    NSError* __autoreleasing err = nil;

    // clear contents of NSTemporaryDirectory
    NSString* tempDirectoryPath = NSTemporaryDirectory();
    NSDirectoryEnumerator* directoryEnumerator = [fileMgr enumeratorAtPath:tempDirectoryPath];
    NSString* fileName = nil;
    BOOL result;

    while ((fileName = [directoryEnumerator nextObject])) {
        NSString* filePath = [tempDirectoryPath stringByAppendingPathComponent:fileName];
        result = [fileMgr removeItemAtPath:filePath error:&err];
        if (!result && err) {
            NSLog(@"Failed to delete: %@ (error: %@)", filePath, err);
        }
    }
}

/*
 This method is called to let your application know that it is about to move from the active to inactive state.
 You should use this method to pause ongoing tasks, disable timer, ...
 */
- (void)onAppWillResignActive:(NSNotification*)notification
{
    // NSLog(@"%@",@"applicationWillResignActive");
    [self.commandDelegate evalJs:@"cordova.fireDocumentEvent('resign');" scheduledOnRunLoop:NO];
}

/*
 In iOS 4.0 and later, this method is called as part of the transition from the background to the inactive state.
 You can use this method to undo many of the changes you made to your application upon entering the background.
 invariably followed by applicationDidBecomeActive
 */
- (void)onAppWillEnterForeground:(NSNotification*)notification
{
    // NSLog(@"%@",@"applicationWillEnterForeground");
    [self.commandDelegate evalJs:@"cordova.fireDocumentEvent('resume');"];
}

// This method is called to let your application know that it moved from the inactive to active state.
- (void)onAppDidBecomeActive:(NSNotification*)notification
{
    // NSLog(@"%@",@"applicationDidBecomeActive");
    [self.commandDelegate evalJs:@"cordova.fireDocumentEvent('active');"];
}

/*
 In iOS 4.0 and later, this method is called instead of the applicationWillTerminate: method
 when the user quits an application that supports background execution.
 */
- (void)onAppDidEnterBackground:(NSNotification*)notification
{
    // NSLog(@"%@",@"applicationDidEnterBackground");
    [self.commandDelegate evalJs:@"cordova.fireDocumentEvent('pause', null, true);" scheduledOnRunLoop:NO];
}

// ///////////////////////

- (void)onPageDidLoad:(NSNotification*)notification
{
    if (self.openURL) {
        [self processOpenUrl:self.openURL pageLoaded:YES];
        self.openURL = nil;
    }
}

- (void)processOpenUrl:(NSURL*)url pageLoaded:(BOOL)pageLoaded
{
    if (!pageLoaded) {
        // query the webview for readystate
        NSString* readyState = [webView stringByEvaluatingJavaScriptFromString:@"document.readyState"];
        pageLoaded = [readyState isEqualToString:@"loaded"] || [readyState isEqualToString:@"complete"];
    }

    if (pageLoaded) {
        // calls into javascript global function 'handleOpenURL'
        NSString* jsString = [NSString stringWithFormat:@"if (typeof handleOpenURL === 'function') { handleOpenURL(\"%@\");}", url];
        [self.webView stringByEvaluatingJavaScriptFromString:jsString];
    } else {
        // save for when page has loaded
        self.openURL = url;
    }
}

- (void)processOpenUrl:(NSURL*)url
{
    [self processOpenUrl:url pageLoaded:NO];
}

// ///////////////////////

- (void)dealloc
{
    [OPGURLProtocol unregisterViewController:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self];

    self.webView.delegate = nil;
    self.webView = nil;
    [OPGUserAgentUtil releaseLock:&_userAgentLockToken];
    [_commandQueue dispose];
    [[self.pluginObjects allValues] makeObjectsPerformSelector:@selector(dispose)];
}

@end
