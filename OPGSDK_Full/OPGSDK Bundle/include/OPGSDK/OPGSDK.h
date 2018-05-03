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
#import <Foundation/Foundation.h>
#import "OPGAuthenticate.h"
#import "OPGScript.h"
#import "OPGForgotPassword.h"
#import "OPGChangePassword.h"
#import "OPGDownloadMedia.h"
#import "OPGPanellistProfile.h"
#import "OPGPanelPanellist.h"
#import "OPGPanel.h"
#import "OPGTheme.h"
#import "OPGSurveyPanel.h"
#import "OPGPanellistPanel.h"
#import "OPGUploadResult.h"
#import "OPGSurvey.h"


@interface OPGSDK : NSObject

/*!
 @brief It sets the Unique ID.
 @discussion This method is a setter for Unique ID.
 @code
 [sdk setUniqueId:@"UNIQUE_ID"];
 @endcode
 @return void.
 */
+(void)setUniqueId:(NSString*)uniqueID;

/*!
 @brief It sets the app version.
 @discussion This method is a setter for the app version.
 @code
 [sdk setAppVersion:@"APP_VERSION"];
 @endcode
 @return void.
 */
+(void)setAppVersion:(NSString*)appVersion;

/*!
 @brief It initializes the OnePoint SDK with Username and SDK Key.
 @discussion This method is to intialize the SDK .
 This has to be initialised in AppDelegate didFinishLaunchingWithOptions method, As it is a static method just call OPGSDK and initialize
 @param  sdk_UserName The input value is the admin username.
 @param  sdk_KEY The input value is the admin sdk key.
 @code
 [OPGSDK initializeWithUserName:@"YOUR_ADMIN_NAME" withSDKKey:@"YOUR_ADMIN_KEY"];
 @endcode
 @return void.
 */
+(void)initializeWithUserName:(NSString *)sdk_UserName
                   withSDKKey:(NSString *)sdk_KEY;

 /*!
 @brief It returns the number of tiems an offline survey is taken.
 @discussion This method returns the number of tiems an offline survey is taken.
 @code
 [sdk getOfflineSurveyCount:surveyID];
 @endcode
 @return NSNumber.
 */
-(NSNumber *)getOfflineSurveyCount:(NSNumber *)surveyID;

/*!
 @brief This method returns an array of media file names for a particular survey.
 @discussion This method is to get the list of media files.
 This has to be invoked with the SDK object.
 @param  error An NSError object encapsulates information about an error condition in an extendable, object-oriented manner..
 @code
 self.mediaList = [sdk getMediaFilesForOfflineSurvey:surveyID];
 @endcode
 @return NSArray.
 */
-(NSArray *)getMediaFilesForOfflineSurvey:(NSNumber *)surveyID;

/*!
 @brief This method returns an array of offline survey result file names for a particular survey.
 @discussion This method is to get the list of offline result files.
 This has to be invoked with the SDK object.
 @param  error An NSError object encapsulates information about an error condition in an extendable, object-oriented manner..
 @code
 self.mediaList = [sdk getResultFilesForOfflineSurvey:surveyID];
 @endcode
 @return NSArray.
 */
-(NSArray *)getResultFilesForOfflineSurvey:(NSNumber  *)surveyID;

/*!
 @brief This method returns the path string of the offline result files.
 @discussion This method is to get the path of offline result files.
 This has to be invoked with the SDK object.
 @param  error An NSError object encapsulates information about an error condition in an extendable, object-oriented manner..
 @code
 self.resultPath= [sdk getResultsFilePath];
 @endcode
 @return NSString.
 */
-(NSString *)getResultsFilePath;

/*!
 @brief This method returns the path string of the offline media files.
 @discussion This method is to get the path of offline media files.
 This has to be invoked with the SDK object.
 @param  error An NSError object encapsulates information about an error condition in an extendable, object-oriented manner..
 @code
 self.mediaPath = [sdk getMediaFilePath];
 @endcode
 @return NSString.
 */
-(NSString *)getMediaFilePath;

/*!
 @brief This method returns an OPGAuthenticate object.
 @discussion This method is used to authenticate the user.
 This has to be invoked with the SDK object.
 @param  username panel username
 @param  password panel password
 @param  error An NSError object encapsulates information about an error condition in an extendable, object-oriented manner..
 @code
 self.authObj = [sdk authenticate:@"USERNAME" password:@"PASSWORD" error:&error];
 @endcode
 @return OPGAuthenticate.
 */
-(OPGAuthenticate *)authenticate:(NSString *)username
                        password:(NSString *)password
                           error:(NSError **)error;

/*!
 @brief This method returns an OPGAuthenticate object.
 @discussion This method is used to authenticate the user with his Google sign in credentials.
 This has to be invoked with the SDK object.
 @param  tokenID The token issued by Google on signing in successfully that identifies a user.
 @param  error An NSError object encapsulates information about an error condition in an extendable, object-oriented manner..
 @code
 self.authObj = [sdk authenticateWithGoogle:@"TOKEN_ID" error:&error];
 @endcode
 @return OPGAuthenticate.
 */
-(OPGAuthenticate *)authenticateWithGoogle:(NSString *)tokenID
                                     error:(NSError **)error;

/*!
 @brief This method returns an OPGAuthenticate object.
 @discussion This method is used to authenticate the user with his Facebook sign in credentials.
 This has to be invoked with the SDK object.
 @param  tokenID The token issued by Facebook on signing in successfully that identifies a user.
 @param  error An NSError object encapsulates information about an error condition in an extendable, object-oriented manner..
 @code
 self.authObj = [sdk authenticateWithFacebook:@"TOKEN_ID" error:&error];
 @endcode
 @return OPGAuthenticate.
 */
-(OPGAuthenticate *)authenticateWithFacebook:(NSString *)tokenID
                                       error:(NSError **)error;

/*!
 @brief This method returns an array of surveys.
 @discussion This method is to get the list of surveys for a particular panel ID.
 This has to be invoked with the SDK object.
 @param  panelId Panel ID
 @param  error An NSError object encapsulates information about an error condition in an extendable, object-oriented manner..
 @code
 self.surveyList = [sdk getUserSurveyList:@"PANEL_ID" error:&error];
 @endcode
 @return NSArray.
 */
-(NSArray *)getUserSurveyListWithPanelID:(NSString *)panelId
                                   error:(NSError **)error;

/*!
 @brief This method returns an array of surveys.
 @discussion This method is to get the list of surveys.
 This has to be invoked with the SDK object.
 @param  error An NSError object encapsulates information about an error condition in an extendable, object-oriented manner..
 @code
 self.surveyList = [sdk getUserSurveyList:&error];
 @endcode
 @return NSArray.
 */
-(NSArray *)getUserSurveyList:(NSError **)error;

/*!
 @brief This method returns an array of surveys.
 @discussion This method is to get the list of surveys.
 This has to be invoked with the SDK object.
 @param  error An NSError object encapsulates information about an error condition in an extendable, object-oriented manner..
 @code
 self.surveyList = [sdk getSurveyList:&error];
 @endcode
 @return NSArray.
 */
-(NSArray *)getSurveyList:(NSError **)error;


/*!
 @brief This method downloads the survey script file.
 @discussion This method is to download the survey script file..
 This has to be invoked with the SDK object.
 @param  survey OPGSurvey object
 @param  error An NSError object encapsulates information about an error condition in an extendable, object-oriented manner..
 @code
 self.scriptResult = [sdk getScript:@"SURVEY_OBJ" error:&error];
 @endcode
 @return OPGScript.
 */
-(OPGScript *)getScript:(OPGSurvey *)survey
                  error:(NSError **)error;

/*!
 @brief This method will provide the request objectcan be used to download the survey script file.
 @discussion This method is to download the survey script file..
 This has to be invoked with the SDK object.
 @param  survey OPGSurvey object
 @param  error An NSError object encapsulates information about an error condition in an extendable, object-oriented manner..
 @code
 self.scriptResult = [sdk getScriptRequest:@"SURVEY_OBJ" error:&error];
 @endcode
 @return NSMutableURLRequest.
 */

-(NSMutableURLRequest *)getScriptRequest:(OPGSurvey *)survey
                                   error:(NSError **)error;


/*!
 @brief This method uploads the media file.
 @discussion This method is to upload the media file and it returns the media ID of the uploaded file.
 This has to be invoked with the SDK object.
 @param  mediaPath Path of the media file
 @param  error An NSError object encapsulates information about an error condition in an extendable, object-oriented manner..
 @code
 self.mediaId = [sdk uploadMediaFile:@"MEDIA_PATH" error:&error];
 @endcode
 @return NSString.
 */
-(NSString *)uploadMediaFile:(NSString *)mediaPath
                       error:(NSError **)error;

/*!
 @brief This method downloads the media file.
 @discussion This method is to download the media file and it returns the status.
 This has to be invoked with the SDK object.
 @param  mediaId ID of the media file
 @param  mediaType Type of the media file
 @param  error An NSError object encapsulates information about an error condition in an extendable, object-oriented manner..
 @code
 self.downloadMediaResult = [sdk downloadMediaFile:@"MEDIA_ID" mediaType:@"MEDIA_TYPE" error:&error];
 @endcode
 @return OPGDownloadMedia.
 */
-(OPGDownloadMedia *)downloadMediaFile:(NSString *)mediaId
                             mediaType:(NSString *)mediaType
                                 error:(NSError **)error;

/*!
 @brief This method downloads the media file.
 @discussion This method is to download the media file and it returns the status.
 This has to be invoked with the SDK object.
 @param  mediaId ID of the media file
 @param  mediaType Type of the media file
 @param fileName Name of the media file downloaded
 @param  error An NSError object encapsulates information about an error condition in an extendable, object-oriented manner..
 @code
 self.downloadMediaResult = [sdk downloadMediaFile:@"MEDIA_ID" mediaType:@"MEDIA_TYPE" error:&error];
 @endcode
 @return OPGDownloadMedia.
 */
-(OPGDownloadMedia *)downloadMediaFile:(NSString *)mediaId
                             mediaType:(NSString *)mediaType
                              fileName:(NSString *)fileName
                                 error:(NSError **)error;

/*!
 @brief This method sends the password reset link to your registered email.
 @discussion This method is to send the password reset link to your registered email..
 This has to be invoked with the SDK object.
 @param  mailId registered email
 @param  error An NSError object encapsulates information about an error condition in an extendable, object-oriented manner..
 @code
 self.forgotPassword = [sdk forgotPassword:@"YOUR_EMAILID" error:&error];
 @endcode
 @return OPGForgotPassword.
 */
-(OPGForgotPassword *)forgotPassword:(NSString *)mailId
                               error:(NSError **)error;

/*!
 @brief This method resets the password.
 @discussion This method is used to reset the password.
 This has to be invoked with the SDK object.
 @param  currentPassword Existing password
 @param  newPassword new password
 @param  error An NSError object encapsulates information about an error condition in an extendable, object-oriented manner..
 @code
 self.changePassResult = [sdk changePassword:@"CURRENT_PASSWORD" newPassword:@"NEW_PASSWORD" error:&error];
 @endcode
 @return OPGChangePassword.
 */
-(OPGChangePassword *)changePassword:(NSString *)currentPassword
                         newPassword:(NSString *)newPassword
                               error:(NSError **)error;

/*!
 @brief This method returns the panellist profile.
 @discussion This method is used to get the panellist profile.
 This has to be invoked with the SDK object.
 @param  error An NSError object encapsulates information about an error condition in an extendable, object-oriented manner..
 @code
 self.panellistProfile = [sdk getPanellistProfile:&error];
 @endcode
 @return OPGPanellistProfile
 */
-(OPGPanellistProfile *)getPanellistProfile:(NSError **)error;

/*!
 @brief This method updates the panelist profile.
 @discussion This method updates the panellist profile
 This has to be invoked with the SDK object.
 @param  panellistProfile panellist profile that is to be updated
 @param  error An NSError object encapsulates information about an error condition in an extendable, object-oriented manner..
 @code
 self.updatePanellistProfile = [sdk updatePanellistProfile:panellistProfile error:&error];
 @endcode
 @return BOOL
 */
-(BOOL)updatePanellistProfile:(OPGPanellistProfile *)panellistProfile
                        error:(NSError **)error;

/*!
@brief This method returns an array of OPGCountry objects.
@discussion This method is used to get the list of countries to provide the user with all the countries when he intends to edit the profile.
This has to be invoked with the SDK object.
@param  error An NSError object encapsulates information about an error condition in an extendable, object-oriented manner..
@code
self.surveyList = [sdk getCountries:&error];
@endcode
@return NSArray.
*/
-(NSArray *)getCountries:(NSError **)error;

/*!
 @brief This method returns the OPGPanellistPanel object containing array of PanelPanellist, Panels, Themes and Survey Panels.
 @discussion This method is used to get the PanelPanellist, Panels, Themes and Survey Panels.
 This has to be invoked with the SDK object.
 @param  error An NSError object encapsulates information about an error condition in an extendable, object-oriented manner..
 @code
 self.surveyPanels = [sdk getPanellistPanel:&error];
 @endcode
 @return OPGPanellistPanel
 */
-(OPGPanellistPanel *)getPanellistPanel:(NSError **)error;

/*!
 @brief This method returns a dictionary containing theme properties and values like media ID and hexadecimal color codes.
 @discussion This method is used to get the theme properties for a particular panel.
 This has to be invoked with the SDK object.
 @param panelID Panel ID for which the theme is needed.
 @param themeTemplateID Theme template ID for the panel
 @param themesArray Array of themes obtained from PanellistPanel api
 @code
 self.themeDict = [sdk getThemesForPanel:"Panel_ID" themeTemplateID:"themeTemplateID" themesArray:"themes_array"];
 @endcode
 @return NSMutableDictionary
 */
-(NSMutableDictionary *)getThemesForPanel:(NSString *)panelID
                          themeTemplateID:(NSString *)themeTemplateID
                              themesArray:(NSArray *)themesArray;

/*!
 @brief This method uploads the offline survey results.
 @discussion This method is used to upload the offline survey.
 This has to be invoked with the SDK object.
 @param  surveyReference survey Reference
 @param  panelistId Panelist ID
 @param  error An NSError object encapsulates information about an error condition in an extendable, object-oriented manner..
 @code
 OPGUploadResult *result = [sdk uploadResults:@"SURVEY_ID" panelistId:@"PANELIST_ID" error:&error]; 
 @endcode
 @return OPGUploadResult.
 */
-(OPGUploadResult *)uploadResults:(NSString *)surveyReference
                       panelistId:(NSString *)panelistId
                            error:(NSError **)error;

/*!
 @brief This method uploads an offline survey result file.
 @discussion This method is used to upload the offline survey result file, either a media file or a result complete file.
 This has to be invoked with the SDK object.
 @param  surveyReference survey Reference
 @param  panelistId Panelist ID
 @param  fileName Name of the file to be uploaded
 @param  filePath Path to the folder containing the file
 @param  error An NSError object encapsulates information about an error condition in an extendable, object-oriented manner..
 @code
 [sdk uploadOfflineResultFile:@"SURVEY_ID" panelistId:@"PANELIST_ID" fileName:@"fileName" filePath:@"filePath" error:&error];
 @endcode
 @return OPGUploadResult.
 */
-(OPGUploadResult *)uploadOfflineResultFile:(NSString *)surveyReference
                                 panelistId:(NSString *)panelistId
                                   fileName:(NSString *)fileName
                                   filePath:(NSString *)filePath
                                      error:(NSError **)error;

/*!
 @brief This method registers your app for the push notification service.
 @discussion This method registers your app for the push notification service
 This has to be invoked with the SDK object.
 @param  deviceTokenID device token ID
 @param  error An NSError object encapsulates information about an error condition in an extendable, object-oriented manner..
 @code
 BOOL status = [sdk registerNotifications:@"device_token" error:&error];
 @endcode
 @return BOOL
 */
-(BOOL)registerNotifications:(NSString *)deviceTokenID
                       error:(NSError **)error;

/*!
 @brief This method unregisters your app for the push notification service.
 @discussion This method unregisters your app for the push notification service and the user will not recieve anymore notifications.
 This has to be invoked with the SDK object.
 @param  deviceTokenID device token ID
 @param  error An NSError object encapsulates information about an error condition in an extendable, object-oriented manner..
 @code
 BOOL status = [sdk unregisterNotifications:@"device_token" error:&error];
 @endcode
 @return BOOL
 */
-(BOOL)unregisterNotifications:(NSString *)deviceTokenID
                         error:(NSError **)error;


/*!
 @brief This method returns an array of OPGGeofenceSurvey objects based on your current location.
 @discussion This method returns an array of OPGGeofenceSurvey objects based on your current location.
 This has to be invoked with the SDK object.
 @param  lattitude lattitude of your location
 @param  longitude longitude of your location
 @param  error An NSError object encapsulates information about an error condition in an extendable, object-oriented manner..
 @code
 NSArray *geoArray = [sdk getGeofenceSurveys:@"lattitude" longitude:@"longitude" error:&error];
 @endcode
 @return NSArray
 */
-(NSArray*) getGeofenceSurveys: (float) lattitude
                    longitude:(float) longitude
                         error:(NSError **)error;

/*!
 @brief It checks for internet connectivity.
 @discussion This synchronous method check for internet connectivity.
 This method can be written in an Utility class.
 @code
 - (IBAction)MemberSubmitAction:(id)sender
 {
 if([Utils isOnline] == YES)
 {
 NSlog(@"Network Connection available");
 }
 }
 @endcode
 @return Boolean.
 */
-(BOOL)isOnline;

/*!
 @brief It logs out of the application.
 @discussion This method terminates the session.
 This method can be written in an Utility class.
 @code
 [sdk logout];
 @endcode
 @return void.
 */
+(void)logout;
@end
