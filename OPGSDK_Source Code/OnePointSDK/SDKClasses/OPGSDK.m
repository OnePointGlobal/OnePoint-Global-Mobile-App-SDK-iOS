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

#import "OPGSDK.h"
#import "NSObject+OPGSBJSON.h"
#import "NSString+OPGAESCrypt.h"
#import "PKMultipartInputStream.h"
#import "NSString+OPGMD5.h"
#import <UIKit/UIKit.h>
#import "OPGSurvey.h"
#import "OPGConstants.h"
#import "OPGNetworkRequest.h"
#import "OPGParseResult.h"
#import "OPGRequest.h"
#import "OPGReachability.h"
#include <math.h>

#define KEY_DATA @"HiYNZFOI1S1biFnoiFFWZcPwWBnhxqhkQ1Ipyh2yG7U="

#define DevInterviewUrl @"http://apidev.1pt.mobi/i/interview"
#define QCInterviewUrl @"http://apistaging.1pt.mobi/i/interview"
#define LiveInterviewUrl @"https://api.1pt.mobi/i/interview"

/*--------------- API URLs ------------------------------- */

#define DevApiURL @"http://apidev.1pt.mobi/V3.0/Api/"
#define QCApiURL @"http://apistaging.1pt.mobi/V3.1/Api/"
#define LiveApiURL @"https://api.1pt.mobi/V3.1/Api/"

/*---------------------------------------------- */

#define DevDownloadMediaURL @"http://apidev.1pt.mobi/i/Media?"
#define QCDownloadMediaURL @"http://apistaging.1pt.mobi/i/Media?"
#define LiveDownloadMediaURL @"https://api.1pt.mobi/i/Media?"


@interface OPGSDK()

typedef id (^error_handler_t)(NSError* error);

@end


@implementation OPGSDK

static BOOL isResourceFound;

#pragma mark - Init Method
+(void)initializeWithUserName:(NSString *)userName withSDKKey:(NSString *)key
{
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:LiveInterviewUrl forKey:@"OPGInterviewUrl"];
    [defaults setObject:LiveApiURL forKey:@"OPGApiUrl"];
    [defaults setObject:LiveDownloadMediaURL forKey:@"OPGDownloadMediaUrl"];

    isResourceFound = [self isResourceBundleAvailable];
    if (!isResourceFound) {
        NSLog(@"Bundle not imported.! Continue once you import the bundle");
        return;
    }
    [defaults setObject:userName forKey:@"OPGUsername"];
    [defaults setObject:key forKey:@"OPGSharedkey"];
    
    if ([userName isEqualToString:@""] || [key  isEqualToString:@""]) {
        NSLog(@"%@ initialization failed! Username/Shared key can not be empty",LiteSDKVersion);
    }
    else
    {
        NSLog(@"%@ initialised successfully!",LiteSDKVersion);
    }
    
}

#pragma mark - Utility Methods
-(NSString*)timeInString : (NSDate*)todaysDate
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    [dateFormatter setTimeZone:timeZone];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    [dateFormatter setLocale:usLocale];
    NSString *dateString = [dateFormatter stringFromDate:todaysDate];
    return dateString;
}

- (BOOL)validateEmail:(NSString*)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

-(void) populateErrorObject:(NSString*)errorMessage withError:(NSError **)errorDomain
{
    int errorCode = 4;
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    [userInfo setObject:errorMessage
                 forKey:NSLocalizedDescriptionKey];
    
    // Populate the error reference.
    *errorDomain = [[NSError alloc] initWithDomain:ErrorDomain
                                              code:errorCode
                                          userInfo:userInfo];
}

#pragma mark - SDK User Methods
-(BOOL)isOnline{
    OPGReachability *reachability = [OPGReachability reachabilityForInternetConnection];
    if (reachability.currentReachabilityStatus!=NotReachable) {
        return YES;
    }
    else{
        return FALSE;
    }
    
}

+(void)setUniqueId:(NSString*)uniqueID
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:uniqueID forKey:@"OPGUniqueID"];
}

+(void)setAppVersion:(NSString*)appVersion
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:appVersion forKey:@"OPGAppVersion"];
}

+(BOOL)isResourceBundleAvailable {
   // NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"OPGResourceBundle" ofType:@"bundle"];
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *bundlePath = [bundle pathForResource:@"OPGResourceBundle" ofType:@"bundle"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:bundlePath]) {
        return FALSE;
    }
    
    return TRUE;
}

-(BOOL)isSessionExpired:(id)response
{
    if ([response isKindOfClass:[NSDictionary class]])
    {
        NSString *errorMsg = [response valueForKey:@"ErrorMessage"];
        if(errorMsg != nil && errorMsg != (id)[NSNull null])
        {
             if ([errorMsg isEqualToString:@"UniqueID does not exist."])
             {
                    return true;
            }
            return false;
        }
        return false;
    }
    return false;
}

-(BOOL)refreshSession
{
    NSNumber *authType = [[NSUserDefaults standardUserDefaults] valueForKey:@"OPGAuthType"];
    NSError *error;
    NSLog(@"Refreshing session");
    if(authType!=nil)
    {
        if(authType.intValue == 0)
        {
            //Username Password authentication
            NSString *username = [[NSUserDefaults standardUserDefaults] valueForKey:@"OPGPanelUsername"];
            NSString *password = [[NSUserDefaults standardUserDefaults] valueForKey:@"OPGPanelPassword"];
            OPGAuthenticate *authResult = [self authenticate:[username AES256DecryptWithKey:KEY_DATA] password:[password AES256DecryptWithKey:KEY_DATA] error:&error];
            return authResult.isSuccess.boolValue;
        }
        else if(authType.intValue == 1)
        {
            //Google token authentication
            NSString *token = [[NSUserDefaults standardUserDefaults] valueForKey:@"OPGAuthToken"];
            OPGAuthenticate *authResult = [self authenticateWithGoogle:token error:&error];
            return authResult.isSuccess.boolValue;
        }
        else if(authType.intValue == 2)
        {
            //Facebook token authentication
            NSString *token = [[NSUserDefaults standardUserDefaults] valueForKey:@"OPGAuthToken"];
            OPGAuthenticate *authResult = [self authenticateWithFacebook:token error:&error];
            return authResult.isSuccess.boolValue;
        }
    }
    return false;
}


#pragma mark - getter/setter Methods
-(NSString*)getApiUrl
{
    return [[NSUserDefaults standardUserDefaults] valueForKey:@"OPGApiUrl"];
}

-(NSString*)getUniqueId
{
    return [[NSUserDefaults standardUserDefaults] valueForKey:@"OPGUniqueID"];
}

-(NSString*)getAppVersion
{
    return [[NSUserDefaults standardUserDefaults] valueForKey:@"OPGAppVersion"];
}

-(NSString*)getSDKUsername
{
    return [[NSUserDefaults standardUserDefaults] valueForKey:@"OPGUsername"];
}

-(NSString*)getSDKSharedKey
{
    return [[NSUserDefaults standardUserDefaults] valueForKey:@"OPGSharedkey"];
}

-(NSString*)getDownloadMediaUrl
{
    return [[NSUserDefaults standardUserDefaults] valueForKey:@"OPGDownloadMediaUrl"];
}

#pragma mark - api Methods
-(OPGAuthenticate*)authenticate:(NSString*)username password:(NSString*)password error:(NSError **)error
{
    if ([self getSDKUsername].length==0 || [self getSDKSharedKey].length==0)
    {
        OPGAuthenticate *authResult = [OPGAuthenticate new];
        [self populateErrorObject:UsernameSharedKeyMessage withError:error];
        authResult.statusMessage= UsernameSharedKeyMessage;
        authResult.isSuccess= [NSNumber numberWithBool:FALSE];
        return authResult;
    }
    if (username.length==0 || password.length==0 )
    {
        OPGAuthenticate *authResult = [OPGAuthenticate new];
        [self populateErrorObject:UsernamePasswordMessage withError:error];
        authResult.statusMessage= UsernamePasswordMessage;
        authResult.isSuccess= [NSNumber numberWithBool:FALSE];
        return authResult;
    }
    if ([self getAppVersion].length==0)
    {
        OPGAuthenticate *authResult = [OPGAuthenticate new];
        [self populateErrorObject:AppVersionMessage withError:error];
        authResult.statusMessage= AppVersionMessage;
        authResult.isSuccess= [NSNumber numberWithBool:FALSE];
        return authResult;
    }
    OPGRequest *entityManager = [OPGRequest new];
    OPGNetworkRequest *networkManager = [OPGNetworkRequest new];
    OPGParseResult *parseManager = [OPGParseResult new];
    NSMutableDictionary *authEntity = [entityManager getAuthEntity:username password:password AppVersion:[self getAppVersion]];
    NSMutableURLRequest *request = [networkManager createRequest:authEntity forApi:Authentication];
    NSDictionary *resultData = [networkManager performRequest:request withError:error];
    OPGAuthenticate *authResult = [parseManager parseAuthenticationResult:resultData];
    if (authResult.isSuccess.boolValue)
    {
        [[NSUserDefaults standardUserDefaults] setObject:[username AES256EncryptWithKey:KEY_DATA] forKey:@"OPGPanelUsername"];
        [[NSUserDefaults standardUserDefaults] setObject:[password AES256EncryptWithKey:KEY_DATA] forKey:@"OPGPanelPassword"];
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:0] forKey:@"OPGAuthType"];
    }
    return authResult;
}

-(OPGAuthenticate*) authenticateWithGoogle:(NSString*)tokenID error:(NSError **)error
{
    if ([self getSDKUsername].length==0 || [self getSDKSharedKey].length==0)
    {
        OPGAuthenticate *authResult = [OPGAuthenticate new];
        [self populateErrorObject:UsernameSharedKeyMessage withError:error];
        authResult.statusMessage= UsernameSharedKeyMessage;
        authResult.isSuccess= [NSNumber numberWithBool:FALSE];
        return authResult;
    }
    if (tokenID.length==0)
    {
        OPGAuthenticate *authResult = [OPGAuthenticate new];
        [self populateErrorObject:GoogleTokenIDEmptyMessage withError:error];
        authResult.statusMessage= GoogleTokenIDEmptyMessage;
        authResult.isSuccess= [NSNumber numberWithBool:FALSE];
        return authResult;
    }
    if ([self getAppVersion].length==0)
    {
        OPGAuthenticate *authResult = [OPGAuthenticate new];
        [self populateErrorObject:AppVersionMessage withError:error];
        authResult.statusMessage= AppVersionMessage;
        authResult.isSuccess= [NSNumber numberWithBool:FALSE];
        return authResult;
    }
    OPGRequest *entityManager = [OPGRequest new];
    OPGNetworkRequest *networkManager = [OPGNetworkRequest new];
    OPGParseResult *parseManager = [OPGParseResult new];
    NSMutableDictionary *authEntity = [entityManager getGoogleAuthEntity:tokenID AppVersion:[self getAppVersion]];
    NSMutableURLRequest *request = [networkManager createRequest:authEntity forApi:GoogleAuthentication];
    NSDictionary *resultData = [networkManager performRequest:request withError:error];
    OPGAuthenticate *authResult = [parseManager parseAuthenticationResult:resultData];
    if (authResult.isSuccess.boolValue)
    {
        [[NSUserDefaults standardUserDefaults] setObject:tokenID forKey:@"OPGAuthToken"];
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:1] forKey:@"OPGAuthType"];
    }
    return authResult;

}

-(OPGAuthenticate*) authenticateWithFacebook:(NSString*)tokenID error:(NSError **)error
{
    if ([self getSDKUsername].length==0 || [self getSDKSharedKey].length==0)
    {
        OPGAuthenticate *authResult = [OPGAuthenticate new];
        [self populateErrorObject:UsernameSharedKeyMessage withError:error];
        authResult.statusMessage= UsernameSharedKeyMessage;
        authResult.isSuccess= [NSNumber numberWithBool:FALSE];
        return authResult;
    }
    if (tokenID.length==0)
    {
        OPGAuthenticate *authResult = [OPGAuthenticate new];
        [self populateErrorObject:FacebookTokenIDEmptyMessage withError:error];
        authResult.statusMessage= FacebookTokenIDEmptyMessage;
        authResult.isSuccess= [NSNumber numberWithBool:FALSE];
        return authResult;
    }
    if ([self getAppVersion].length==0)
    {
        OPGAuthenticate *authResult = [OPGAuthenticate new];
        [self populateErrorObject:AppVersionMessage withError:error];
        authResult.statusMessage= AppVersionMessage;
        authResult.isSuccess= [NSNumber numberWithBool:FALSE];
        return authResult;
    }
    OPGRequest *entityManager = [OPGRequest new];
    OPGNetworkRequest *networkManager = [OPGNetworkRequest new];
    OPGParseResult *parseManager = [OPGParseResult new];
    NSMutableDictionary *authEntity = [entityManager getFacebookAuthEntity:tokenID AppVersion:[self getAppVersion]];
    NSMutableURLRequest *request = [networkManager createRequest:authEntity forApi:FacebookAuthentication];
    NSDictionary *resultData = [networkManager performRequest:request withError:error];
    OPGAuthenticate *authResult = [parseManager parseAuthenticationResult:resultData];
    if (authResult.isSuccess.boolValue)
    {
        [[NSUserDefaults standardUserDefaults] setObject:tokenID forKey:@"OPGAuthToken"];
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:2] forKey:@"OPGAuthType"];
    }
    return authResult;

}

-(NSArray *)getUserSurveyListWithPanelID:(NSString*)panelId error:(NSError **)error
{
    if (!isResourceFound) {
        NSLog(@"Bundle not imported.! Continue once you import the bundle");
    }
    else if ([self getUniqueId].length==0)
    {
        [self populateErrorObject:UniqueIDMessage withError:error];
        return nil;
    }
    else if ([self getSDKUsername].length==0 || [self getSDKSharedKey].length==0)
    {
        [self populateErrorObject:UsernameSharedKeyMessage withError:error];
        return nil;
    }
    OPGRequest *entityManager = [OPGRequest new];
    OPGNetworkRequest *networkManager = [OPGNetworkRequest new];
    OPGParseResult *parseManager = [OPGParseResult new];
    NSMutableDictionary *surveyEntity = [entityManager getSurveyEntity:[self getUniqueId] panelId:panelId];
    NSMutableURLRequest *request = [networkManager createRequest:surveyEntity forApi:GetSurveys];
    id responseList = [networkManager performRequest:request withError:error];
    if([self isSessionExpired:responseList])            //check if Unique ID doesn't exist in response
    {
        if([self refreshSession])
        {
           //rebuild entity, request with fresh session ID
            surveyEntity = [entityManager getSurveyEntity:[self getUniqueId] panelId:panelId];
            request = [networkManager createRequest:surveyEntity forApi:GetSurveys];
            responseList = [networkManager performRequest:request withError:error];
        }
    }
    NSArray* surveyList = [parseManager parseSurveys:responseList isLiteSDK:YES error:error];
    return surveyList;
}

-(NSArray *)getSurveyList:(NSError **)error {
    if (!isResourceFound) {
        NSLog(@"Bundle not imported.! Continue once you import the bundle");
    }
    OPGRequest *entityManager = [OPGRequest new];
    OPGNetworkRequest *networkManager = [OPGNetworkRequest new];
    OPGParseResult *parseManager = [OPGParseResult new];
    NSMutableDictionary *surveyEntity = [entityManager getSurveyEntity:@"" panelId:@""];
    NSMutableURLRequest *request = [networkManager createRequest:surveyEntity forApi:GetSurveys];
    id responseList = [networkManager performRequest:request withError:error];
    if([self isSessionExpired:responseList])            //check if Unique ID doesn't exist in response
    {
        if([self refreshSession])
        {
            //rebuild entity, request with fresh session ID
            surveyEntity = [entityManager getSurveyEntity:@"" panelId:@""];
            request = [networkManager createRequest:surveyEntity forApi:GetSurveys];
            responseList = [networkManager performRequest:request withError:error];
        }
    }
    NSArray* surveyList = [parseManager parseSurveys:responseList isLiteSDK:YES error:error];
    return surveyList;
}

-(NSArray *)getUserSurveyList:(NSError **)error
{
    return [self getUserSurveyListWithPanelID:nil error:error];
}


-(NSString*) uploadMediaFile :(NSString*)mediaPath error:(NSError **)error
{
    if ([self getSDKUsername].length==0 || [self getSDKSharedKey].length==0)
    {
        [self populateErrorObject:UsernameSharedKeyMessage withError:error];
        return nil;
    }
    if(mediaPath.length==0)
    {
        [self populateErrorObject:MediaPathMessage withError:error];
        return nil;
    }
    OPGNetworkRequest *networkManager = [OPGNetworkRequest new];
    NSMutableURLRequest * request = [networkManager createRequestForMediaForApi:UploadMedia];
    
    NSRange range= [mediaPath rangeOfString: @"/" options: NSBackwardsSearch];
    NSString* fileName= [mediaPath substringFromIndex: range.location+1];
    //create stream of media
    PKMultipartInputStream *HttpBody = [[PKMultipartInputStream alloc] init];
    NSString *mediaFilePath =[mediaPath stringByReplacingOccurrencesOfString:@"file://" withString:@""];

    [HttpBody addPartWithName:@"file" filename:fileName path:mediaFilePath];
    [request setValue:[NSString stringWithFormat:@"multipart/form-data; boundary=%@", [HttpBody boundary]] forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[HttpBody length]] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBodyStream:HttpBody];
    NSArray *mediaIDArray = [networkManager performRequest:request withError:error];
    if([self isSessionExpired:mediaIDArray])            //check if Unique ID doesn't exist in response
    {
        if([self refreshSession])
        {
            //rebuild entity, request with fresh session ID
            request = [networkManager createRequestForMediaForApi:UploadMedia];
            [request setValue:[NSString stringWithFormat:@"multipart/form-data; boundary=%@", [HttpBody boundary]] forHTTPHeaderField:@"Content-Type"];
            [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[HttpBody length]] forHTTPHeaderField:@"Content-Length"];
            [request setHTTPBodyStream:HttpBody];
            mediaIDArray = [networkManager performRequest:request withError:error];
        }
    }

    if ([mediaIDArray isKindOfClass:[NSArray class]])       //we get NSDictionary on error and Array of one mediaID on success
    {
        if (mediaIDArray.count>0)
        {
            NSNumber *uploadedMediaId = [mediaIDArray objectAtIndex:0];
            return [uploadedMediaId stringValue];
        }
    }
    return nil;
}

-(OPGDownloadMedia*) downloadMediaFile :(NSString*)mediaId mediaType:(NSString*)mediaType error:(NSError **)error
{
    OPGDownloadMedia *mediaObj = [OPGDownloadMedia new];
    if ([self getSDKUsername].length==0 || [self getSDKSharedKey].length==0)
    {
        [self populateErrorObject:UsernameSharedKeyMessage withError:error];
        mediaObj.isSuccess=[NSNumber numberWithBool:FALSE];
        mediaObj.mediaFilePath=nil;
        mediaObj.statusMessage=UsernameSharedKeyMessage;
        return mediaObj;
    }
    if(mediaId.length==0)
    {
        [self populateErrorObject:MediaIDMessage withError:error];
        mediaObj.isSuccess=[NSNumber numberWithBool:FALSE];
        mediaObj.mediaFilePath=nil;
        mediaObj.statusMessage=MediaIDMessage;
        return mediaObj;
    }
    else if ([self getUniqueId].length==0)
    {
        [self populateErrorObject:UniqueIDMessage withError:error];
        mediaObj.isSuccess=[NSNumber numberWithBool:FALSE];
        mediaObj.mediaFilePath=nil;
        mediaObj.statusMessage=UniqueIDMessage;
        return mediaObj;
    }
    else if (mediaType.length==0)
    {
        [self populateErrorObject:MediaTypeMessage withError:error];
        mediaObj.isSuccess=[NSNumber numberWithBool:FALSE];
        mediaObj.mediaFilePath=nil;
        mediaObj.statusMessage=MediaTypeMessage;
        return mediaObj;
    }
    
    NSString *urlString = [NSString stringWithFormat:@"%@mediaid=%@&mediatype=%@",[self getDownloadMediaUrl],mediaId,mediaType];
    NSData* myData = [NSData dataWithContentsOfURL:[NSURL URLWithString: urlString]];

    if (myData.length>100 && myData!=nil)
    {
        NSString *tmpDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
        if (![[NSFileManager defaultManager] fileExistsAtPath:tmpDir])
        {
            [[NSFileManager defaultManager] createDirectoryAtPath:tmpDir withIntermediateDirectories:NO attributes:nil error:error];
        }
        tmpDir = [[tmpDir stringByDeletingLastPathComponent] stringByAppendingPathComponent:@"tmp"];
//        NSDate *date=[NSDate date];
//        NSDateFormatter *timeFormat = [[NSDateFormatter alloc] init];
//        [timeFormat setDateFormat:@"HH_mm_ss.SSS"];
//        NSString *stringDate=[timeFormat stringFromDate:date];
        NSString *stringDate = [self timeInString:[NSDate date]];

        NSString  *filePath = [NSString stringWithFormat:@"%@/%@%@.%@",tmpDir,@"AppMedia",stringDate, mediaType];
        [myData writeToFile:filePath atomically:YES];
        mediaObj.isSuccess = [NSNumber numberWithBool:TRUE];
        mediaObj.mediaFilePath = filePath;
        mediaObj.statusMessage=@"Download Success";
        return mediaObj;
    }
    else
    {
        mediaObj.isSuccess = [NSNumber numberWithBool:FALSE];
        mediaObj.mediaFilePath = nil;
        mediaObj.statusMessage=GenericError;
        return mediaObj;
    }
    
}

-(OPGDownloadMedia*)downloadMediaFile:(NSString*)mediaId mediaType:(NSString*)mediaType fileName:(NSString*)fileName error:(NSError **)error
{
    OPGDownloadMedia *mediaObj = [OPGDownloadMedia new];
    if ([self getSDKUsername].length==0 || [self getSDKSharedKey].length==0)
    {
        [self populateErrorObject:UsernameSharedKeyMessage withError:error];
        mediaObj.isSuccess=[NSNumber numberWithBool:FALSE];
        mediaObj.mediaFilePath=nil;
        mediaObj.statusMessage=UsernameSharedKeyMessage;
        return mediaObj;
    }
    if(mediaId.length==0)
    {
        [self populateErrorObject:MediaIDMessage withError:error];
        mediaObj.isSuccess=[NSNumber numberWithBool:FALSE];
        mediaObj.mediaFilePath=nil;
        mediaObj.statusMessage=MediaIDMessage;
        return mediaObj;
    }
    else if ([self getUniqueId].length==0)
    {
        [self populateErrorObject:UniqueIDMessage withError:error];
        mediaObj.isSuccess=[NSNumber numberWithBool:FALSE];
        mediaObj.mediaFilePath=nil;
        mediaObj.statusMessage=UniqueIDMessage;
        return mediaObj;
    }
    else if (mediaType.length==0)
    {
        [self populateErrorObject:MediaTypeMessage withError:error];
        mediaObj.isSuccess=[NSNumber numberWithBool:FALSE];
        mediaObj.mediaFilePath=nil;
        mediaObj.statusMessage=MediaTypeMessage;
        return mediaObj;
    }
    
    NSString *urlString = [NSString stringWithFormat:@"%@mediaid=%@&mediatype=%@",[self getDownloadMediaUrl],mediaId,mediaType];
    NSData* myData = [NSData dataWithContentsOfURL:[NSURL URLWithString: urlString]];

    if (myData.length>100 && myData!=nil)
    {
        NSString *tmpDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
        if (![[NSFileManager defaultManager] fileExistsAtPath:tmpDir])
        {
            [[NSFileManager defaultManager] createDirectoryAtPath:tmpDir withIntermediateDirectories:NO attributes:nil error:error];
        }
        tmpDir = [[tmpDir stringByDeletingLastPathComponent] stringByAppendingPathComponent:@"tmp"];

//        NSDate *date=[NSDate date];
//        NSDateFormatter *timeFormat = [[NSDateFormatter alloc] init];
//        [timeFormat setDateFormat:@"HH_mm_ss.SSS"];
//        NSString *stringDate=[timeFormat stringFromDate:date];
        
        NSString  *filePath = [NSString stringWithFormat:@"%@/%@.%@",tmpDir,fileName, mediaType];
        [myData writeToFile:filePath atomically:YES];
        mediaObj.isSuccess = [NSNumber numberWithBool:TRUE];
        mediaObj.mediaFilePath = filePath;
        mediaObj.statusMessage=@"Download Success";
        return mediaObj;
    }
    else
    {
        mediaObj.isSuccess = [NSNumber numberWithBool:FALSE];
        mediaObj.mediaFilePath = nil;
        mediaObj.statusMessage=GenericError;
        return mediaObj;
    }
}




-(OPGForgotPassword*) forgotPassword : (NSString*)mailId error:(NSError **)error
{
    OPGForgotPassword *forgotPassObj = [[OPGForgotPassword alloc]init];
    if ([self getSDKUsername].length==0 || [self getSDKSharedKey].length==0)
    {
        [self populateErrorObject:UsernameSharedKeyMessage withError:error];
        forgotPassObj.isSuccess=[NSNumber numberWithBool:FALSE];
        forgotPassObj.statusMessage = UsernameSharedKeyMessage;
        return forgotPassObj;
    }
    if ([self getAppVersion].length==0)
    {
        [self populateErrorObject:AppVersionMessage withError:error];
        forgotPassObj.isSuccess=[NSNumber numberWithBool:FALSE];
        forgotPassObj.statusMessage = AppVersionMessage;
        return forgotPassObj;
    }
    if ([self validateEmail:mailId])
    {
        OPGRequest *entityManager = [OPGRequest new];
        OPGNetworkRequest *networkManager = [OPGNetworkRequest new];
        OPGParseResult *parseManager = [OPGParseResult new];
        NSMutableDictionary *forgotPasswordEntity = [entityManager getForgotPasswordEntity:mailId AppVersion:[self getAppVersion]];
        NSMutableURLRequest *request = [networkManager createRequest:forgotPasswordEntity forApi:ForgotPassword];
        NSDictionary *responseData = [networkManager performRequest:request withError:error];
        
        forgotPassObj = [parseManager parseForgotPassword:responseData];
        return forgotPassObj;
    }
    else
    {
        forgotPassObj.isSuccess=[NSNumber numberWithBool:FALSE];
        forgotPassObj.statusMessage = InvalidEmail;
        return forgotPassObj;
    }
}

-(OPGChangePassword*) changePassword :(NSString*)currentPassword newPassword:(NSString*)newPassword error:(NSError **)error
{
    OPGChangePassword *changePassObj = [[OPGChangePassword alloc]init];
    if ([self getSDKUsername].length==0 || [self getSDKSharedKey].length==0)
    {
        [self populateErrorObject:UsernameSharedKeyMessage withError:error];
        changePassObj.statusMessage = UsernameSharedKeyMessage;
        changePassObj.isSuccess =[NSNumber numberWithBool:FALSE];
        return changePassObj;
    }
    if(currentPassword.length==0)
    {
        [self populateErrorObject:CurrentPasswordMessage withError:error];
        changePassObj.statusMessage = CurrentPasswordMessage;
        changePassObj.isSuccess =[NSNumber numberWithBool:FALSE];
        return changePassObj;
    }
    else if ([self getUniqueId].length==0)
    {
        [self populateErrorObject:UniqueIDMessage withError:error];
        changePassObj.statusMessage = UniqueIDMessage;
        changePassObj.isSuccess =[NSNumber numberWithBool:FALSE];
        return changePassObj;
    }
    else if (newPassword.length==0)
    {
        [self populateErrorObject:NewPasswordMessage withError:error];
        changePassObj.statusMessage = NewPasswordMessage;
        changePassObj.isSuccess =[NSNumber numberWithBool:FALSE];
        return changePassObj;
    }
    
    if ([currentPassword isEqualToString:newPassword])
    {
        changePassObj.statusMessage = SamePasswordsMessage;
        changePassObj.isSuccess =[NSNumber numberWithBool:FALSE];
        return changePassObj;
    }
    else
    {
        OPGRequest *entityManager = [OPGRequest new];
        OPGNetworkRequest *networkManager = [OPGNetworkRequest new];
        OPGParseResult *parseManager = [OPGParseResult new];
        NSMutableDictionary *changePasswordEntity = [entityManager getChangePasswordEntity:[self getUniqueId] currentPassword:currentPassword newPassword:newPassword];
        NSMutableURLRequest *request = [networkManager createRequest:changePasswordEntity forApi:ChangePassword];
        NSDictionary *responseData = [networkManager performRequest:request withError:error];
        if([self isSessionExpired:responseData])            //check if Unique ID doesn't exist in response
        {
            if([self refreshSession])
            {
                 //rebuild entity, request with fresh session ID
                changePasswordEntity = [entityManager getChangePasswordEntity:[self getUniqueId] currentPassword:currentPassword newPassword:newPassword];
                request = [networkManager createRequest:changePasswordEntity forApi:ChangePassword];
                responseData = [networkManager performRequest:request withError:error];
            }
        }
        changePassObj = [parseManager parseChangePassword:responseData];
        if (changePassObj.isSuccess) {
            //if password successfully changed, update the password in defaults for refreshing session
            [[NSUserDefaults standardUserDefaults] setObject:[newPassword AES256EncryptWithKey:KEY_DATA] forKey:@"OPGPanelPassword"];
        }
        return changePassObj;
    }
}

-(OPGPanellistProfile*)getPanellistProfile:(NSError **)error
{
    if ([self getSDKUsername].length==0 || [self getSDKSharedKey].length==0)
    {
        [self populateErrorObject:UsernameSharedKeyMessage withError:error];
        return nil;
    }
    if ([self getUniqueId].length==0)
    {
        [self populateErrorObject:UniqueIDMessage withError:error];
        return nil;
    }
    OPGRequest *entityManager = [OPGRequest new];
    OPGNetworkRequest *networkManager = [OPGNetworkRequest new];
    OPGParseResult *parseManager = [OPGParseResult new];
    NSMutableDictionary *PanProfileEntity = [entityManager getPanelistProfileEntity:[self getUniqueId]];
    NSMutableURLRequest *request = [networkManager createRequest:PanProfileEntity forApi:GetPanelistProfile];
    NSDictionary *profileData = [networkManager performRequest:request withError:error];
    if([self isSessionExpired:profileData])            //check if Unique ID doesn't exist in response
    {
        if([self refreshSession])
        {
            //rebuild entity, request with fresh session ID
            PanProfileEntity = [entityManager getPanelistProfileEntity:[self getUniqueId]];
            request = [networkManager createRequest:PanProfileEntity forApi:GetPanelistProfile];
            profileData = [networkManager performRequest:request withError:error];
        }
    }
    OPGPanellistProfile *panProfile = [parseManager parsePanelistProfile:profileData];
    return panProfile;
}

-(BOOL)updatePanellistProfile:(OPGPanellistProfile*)panellistProfile error:(NSError **)error
{
    if ([self getSDKUsername].length==0 || [self getSDKSharedKey].length==0)
    {
        [self populateErrorObject:UsernameSharedKeyMessage withError:error];
        return FALSE;
    }
    if([panellistProfile.firstName isKindOfClass:[NSString class]] && !([panellistProfile.firstName length]<=0))
    {
        OPGRequest *entityManager = [OPGRequest new];
        OPGNetworkRequest *networkManager = [OPGNetworkRequest new];
        OPGParseResult *parseManager = [OPGParseResult new];
        NSMutableDictionary *updateProfileEntity = [entityManager getUpdatePanelistProfileEntity:[self getUniqueId] panelistProfile:panellistProfile];
        NSMutableURLRequest *request = [networkManager createRequest:updateProfileEntity forApi:UpdatePanelistProfile];
        NSDictionary *updateStatus = [networkManager performRequest:request withError:error];
        if([self isSessionExpired:updateStatus])            //check if Unique ID doesn't exist in response
        {
            if([self refreshSession])
            {
                //rebuild entity, request with fresh session ID
                updateProfileEntity = [entityManager getUpdatePanelistProfileEntity:[self getUniqueId] panelistProfile:panellistProfile];
                request = [networkManager createRequest:updateProfileEntity forApi:UpdatePanelistProfile];
                updateStatus = [networkManager performRequest:request withError:error];            }
        }
        return [parseManager parseUpdatePanelistProfile:updateStatus];
    }
    return FALSE;
}


-(OPGPanellistPanel*) getPanellistPanel:(NSError **)error
{
    OPGPanellistPanel *panellistPanelObj = [OPGPanellistPanel new];
    if ([self getSDKUsername].length==0 || [self getSDKSharedKey].length==0)
    {
        [self populateErrorObject:UsernameSharedKeyMessage withError:error];
        panellistPanelObj.isSuccess=[NSNumber numberWithBool:FALSE];
        panellistPanelObj.statusMessage=UsernameSharedKeyMessage;
        panellistPanelObj.panelPanelistArray=nil;
        panellistPanelObj.panelsArray=nil;
        panellistPanelObj.themesArray=nil;
        panellistPanelObj.surveyPanelArray=nil;
        return panellistPanelObj;
    }
    if ([self getUniqueId].length==0)
    {
        [self populateErrorObject:UniqueIDMessage withError:error];
        panellistPanelObj.isSuccess=[NSNumber numberWithBool:FALSE];
        panellistPanelObj.statusMessage=UniqueIDMessage;
        panellistPanelObj.panelPanelistArray=nil;
        panellistPanelObj.panelsArray=nil;
        panellistPanelObj.themesArray=nil;
        panellistPanelObj.surveyPanelArray=nil;
        return panellistPanelObj;
    }
    NSDictionary *panellistPanelResult = [self callPanelistPanelApi:error];      //Call the api
    OPGParseResult *parseManager = [OPGParseResult new];
    panellistPanelObj = [parseManager parsePanellistPanel:panellistPanelResult];
    return panellistPanelObj;
}

-(NSMutableDictionary*)getThemesForPanel:(NSString*)panelID themeTemplateID:(NSString*)themeTemplateID themesArray:(NSArray*)themesArray
{
    NSMutableDictionary *themeDictionary= [[NSMutableDictionary alloc] init];
    for (OPGTheme *theme in themesArray)
    {
        if ([themeTemplateID isEqualToString:[theme.themeTemplateID stringValue]])
        {
            themeDictionary[theme.themeName] = theme.value;
        }
    }
    return themeDictionary;
}

-(BOOL) registerNotifications :(NSString*)deviceTokenID error:(NSError **)error
{
    if ([self getSDKUsername].length==0 || [self getSDKSharedKey].length==0)
    {
        [self populateErrorObject:UsernameSharedKeyMessage withError:error];
        return FALSE;
    }
    return [self manageNotifications:deviceTokenID api:registerNotification error:error];
    
}

-(BOOL) unregisterNotifications :(NSString*)deviceTokenID  error:(NSError **)error
{
    if ([self getSDKUsername].length==0 || [self getSDKSharedKey].length==0)
    {
        [self populateErrorObject:UsernameSharedKeyMessage withError:error];
        return FALSE;
    }
    return [self manageNotifications:deviceTokenID  api:unregisterNotification error:error];
}

-(BOOL) manageNotifications :(NSString*)deviceTokenID api:(NSString*)apiName error:(NSError **)error
{
    
    if ([self getAppVersion].length==0)
    {
        [self populateErrorObject:AppVersionMessage withError:error];
        return FALSE;
    }
    if ([self getUniqueId].length==0)
    {
        [self populateErrorObject:UniqueIDMessage withError:error];
        return FALSE;
    }
    OPGRequest *entityManager = [OPGRequest new];
    OPGNetworkRequest *networkManager = [OPGNetworkRequest new];
    OPGParseResult *parseManager = [OPGParseResult new];
    NSMutableDictionary *notificationEntity  = [entityManager getNotificationEntity:[self getUniqueId] deviceToken:deviceTokenID appVersion:[self getAppVersion]];
    NSMutableURLRequest *request = [networkManager createRequest:notificationEntity forApi:apiName];
    NSDictionary *result = [networkManager performRequest:request withError:error];
    if([self isSessionExpired:result])            //check if Unique ID doesn't exist in response
    {
        if([self refreshSession])
        {
            //rebuild entity, request with fresh session ID
            notificationEntity  = [entityManager getNotificationEntity:[self getUniqueId] deviceToken:deviceTokenID appVersion:[self getAppVersion]];
            request = [networkManager createRequest:notificationEntity forApi:apiName];
            result = [networkManager performRequest:request withError:error];
        }
    }
    BOOL isSuccess = [parseManager parseNotificationResponse:result];
    return isSuccess;
    
}


-(NSDictionary*) callPanelistPanelApi :(NSError **)error
{
    OPGRequest *entityManager = [OPGRequest new];
    OPGNetworkRequest *networkManager = [OPGNetworkRequest new];
    NSMutableDictionary *panelistPanelEntity = [entityManager getPanelistPanelEntity:[self getUniqueId]];
    NSMutableURLRequest *request = [networkManager createRequest:panelistPanelEntity forApi:PanelPanelist];
    NSDictionary *panelistPanelData = [networkManager performRequest:request withError:error];
    if([self isSessionExpired:panelistPanelData])            //check if Unique ID doesn't exist in response
    {
        if([self refreshSession])
        {
            //rebuild entity, request with fresh session ID
            panelistPanelEntity = [entityManager getPanelistPanelEntity:[self getUniqueId]];
            request = [networkManager createRequest:panelistPanelEntity forApi:PanelPanelist];
            panelistPanelData = [networkManager performRequest:request withError:error];
        }
    }

    return panelistPanelData;
}

-(NSArray *)getCountries:(NSError **)error
{
    if ([self getUniqueId].length==0)
    {
        [self populateErrorObject:UniqueIDMessage withError:error];
        return nil;
    }
    else if ([self getSDKUsername].length==0 || [self getSDKSharedKey].length==0)
    {
        [self populateErrorObject:UsernameSharedKeyMessage withError:error];
        return nil;
    }
    OPGRequest *entityManager = [OPGRequest new];
    OPGNetworkRequest *networkManager = [OPGNetworkRequest new];
    OPGParseResult *parseManager = [OPGParseResult new];
    NSMutableDictionary *surveyEntity = [entityManager getCountryEntity:[self getUniqueId]];
    NSMutableURLRequest *request = [networkManager createRequest:surveyEntity forApi:GetCountries];
    id responseList = [networkManager performRequest:request withError:error];
    if([self isSessionExpired:responseList])            //check if Unique ID doesn't exist in response
    {
        if([self refreshSession])
        {
            surveyEntity = [entityManager getCountryEntity:[self getUniqueId]];
            request = [networkManager createRequest:surveyEntity forApi:GetCountries];
            responseList = [networkManager performRequest:request withError:error];
        }
    }
    NSArray* surveyList = [parseManager parseListOfCountries:responseList error:error];
    return surveyList;
}

-(NSArray*)getGeofenceSurveys: (float)lattitude longitude:(float)longitude error:(NSError **)error
{
    if ([self getUniqueId].length==0)
    {
        [self populateErrorObject:UniqueIDMessage withError:error];
        return nil;
    }
    else if ([self getSDKUsername].length==0 || [self getSDKSharedKey].length==0)
    {
        [self populateErrorObject:UsernameSharedKeyMessage withError:error];
        return nil;
    }
    else if (isnan(lattitude) || isnan(longitude))
    {
       [self populateErrorObject:LocationNilMessage withError:error];
        return nil;
    }
    OPGRequest *entityManager = [OPGRequest new];
    OPGNetworkRequest *networkManager = [OPGNetworkRequest new];
    OPGParseResult *parseManager = [OPGParseResult new];
    NSMutableDictionary *geoEntity = [entityManager getGeoFencingEntity:[self getUniqueId] withLatitude: [NSString stringWithFormat:@"%f",lattitude] withLongitude: [NSString stringWithFormat:@"%f",longitude]];
    NSMutableURLRequest* request = [networkManager createRequest:geoEntity forApi:GeoFencing];
    id responseList = [networkManager performRequest:request withError:error];
    if([self isSessionExpired:responseList])            //check if "Unique ID doesn't exist" comes in response
    {
        if([self refreshSession])
        {
            //update new session id in entity object
            [geoEntity setValue:[[NSUserDefaults standardUserDefaults] valueForKey:@"OPGUniqueID"] forKey:@"sessionID"];
            request = [networkManager createRequest:geoEntity forApi:GeoFencing];
            responseList = [networkManager performRequest:request withError:error];
        }
    }
    NSArray *geoArray = [parseManager parseMSGeoFencing:responseList error:error];
    return geoArray;
}

+(void)logout
{
    [OPGSDK setUniqueId:@""];
}
@end
