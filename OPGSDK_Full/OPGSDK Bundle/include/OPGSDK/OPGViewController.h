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

#import "OPGBaseController.h"

@protocol OPGSurveyDelegate <NSObject>

@optional
/*!
 @brief This method indicates that the survey has been completed.
 @discussion This method indicates that the survey has been completed.
 @return void.
 */
-(void)didSurveyCompleted;

/*!
 @brief Sent after a web view starts loading a frame.
 @discussion The web view that has begun loading a new frame.
 @return void.
 */
-(void)didSurveyStartLoad;

/*!
 @brief Sent after a web view finishes loading a frame.
 @discussion The web view has finished loading.
 @return void.
 */
-(void)didSurveyFinishLoad;

/*!
 @brief Sent after a web view loads with an error.
 @discussion The web view has loaded with an error.
 @return void.
 */
-(void)didSurveyLoadWithError:(NSError*)error;
@end


@interface OPGViewController : OPGBaseController

@property(assign, nonatomic) id<OPGSurveyDelegate> surveyDelegate;

@end
