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
#define ErrorDomain @"com.OnePointSDK.ErrorDomain"

/*--------------- SDK Versions ------------------------------- */
#define LiteSDKVersion @"OnePointSDKv1.5"
#define FullSDKVersion @"OnePointSDKv1.0"

/*--------------- SDK Error Descriptions ------------------------------- */
#define NoSurveyMessage @"No Surveys available for Information provided"
#define AuthenticationFailedMessage @"Authentication Failed"
#define UsernamePasswordMessage @"Username/Password cannot be empty"
#define UsernameSharedKeyMessage @"Username/Shared Key cannot be empty"
#define GoogleTokenIDEmptyMessage @"Google token cannot be empty"
#define FacebookTokenIDEmptyMessage @"Facebook token cannot be empty"
#define AppVersionMessage @"App Version cannot be empty"
#define PanelIDMessage @"Panel ID cannot be empty"
#define MediaIDMessage @"Media ID cannot be empty"
#define MediaTypeMessage @"Media Type cannot be empty"
#define SurveyIDMessage @"Survey Reference or Survey ID cannot be empty"
#define PanelistIDMessage @"Panelist ID cannot be empty"
#define MediaPathMessage @"Media path cannot be empty"
#define UniqueIDMessage @"Please set Unique ID or Authenticate before making an API call"
#define CurrentPasswordMessage @"Current password cannot be empty"
#define NewPasswordMessage @"New password cannot be empty"
#define GenericError @"Something wrong in input ID or server"
#define InvalidEmail @"Invalid Email. Try again"
#define SamePasswordsMessage @"Old and new passwords must be different"
#define LocationNilMessage @"Lattitude/Longitude values cannot be nil or empty"
#define NoRegionsToMonitor @"Geofence survey list cannot be nil or empty"
#define LocationSettingsDisabled @"The location services seems to be disabled from the settings. "
#define LocationAuthorizationDenied @"Location authorization status has been denied"
#define LocationAuthorizationNotDetermined @"Location authorization status is not determioned"
#define LocationAuthorizationRestricted @"Location authorization status has been restricted"

/*--------------- HTTP Request Type ------------------------------- */
#define GET @"GET" 
#define POST @"POST"
#define DELETE @"DELETE"

/*--------------- API Names ------------------------------- */
#define Authentication @"Authentication"
#define GoogleAuthentication @"SocialLogin/GoogleLogin"
#define FacebookAuthentication @"SocialLogin/FacebookLogin"
#define GetSurveys @"Survey/Surveys"
#define PanelPanelist @"PanellistPanel/Panels"
#define GetScript @"Script"
#define UploadMedia @"media/post"
#define DownloadMedia @"Media/ProfileMedia"
#define ForgotPassword @"ForgotPassword"
#define ChangePassword @"ChangePassword/Changepassword"
#define GetPanelistProfile @"PanellistProfile/Profiles"
#define UpdatePanelistProfile @"UpdatePanelList/Update"
#define UploadResults @"Result/Post"
#define registerNotification @"PushNotification/Post"
#define unregisterNotification @"PushNotification/Delete"
#define GeoFencing @"Geofencing"
#define GetCountries @"UpdatePanelList/Country"

