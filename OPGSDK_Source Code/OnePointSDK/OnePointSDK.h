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

@interface OnePointSDK : NSObject

/*!
 @brief It initializes the OnePoint SDK with Username and SDK Key.
 
 @discussion This method is to intialize the SDK .
 
 This has to be initialised in AppDelegate didFinishLaunchingWithOptions method, As it is a static method just call OnePointSDK and initialize
 
 @param  sdk_UserName The input value is the admin username.
 
 @param  sdk_KEY The input value is the admin sdk key.
 
 @code
 [OnePointSDK initializeWithUserName:@"YOUR_ADMIN_NAME" withSDKKey:@"YOUR_ADMIN_KEY"];
 @endcode
 
 @return void.
 */

+(void)initializeWithUserName:(NSString *)sdk_UserName withSDKKey:(NSString *)sdk_KEY;

/*!
 @brief This method returns an array of surveys.
 
 @discussion This method is to get the list of surveys .
 
 This has to be invoked with the SDK object.
 
 @param  error An NSError object encapsulates information about an error condition in an extendable, object-oriented manner..
 
 @code
 self.surveyList = [sdk getUserSurveyList];
 @endcode
 
 
 @return NSArray.
 */

-(NSArray *)getUserSurveyList:(NSError **)error;


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


@end
