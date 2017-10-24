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
#import <UIKit/UIKit.h>

/*!
 @protocol OnePointWebViewDelegate
 
 @brief The OnePointWebViewDelegate protocol
 
 It's a protocol used as a demo here. In a real application, it would be quite useful.
 */

@protocol OnePointWebViewDelegate <NSObject>

@optional
/*!
 @brief This method indicates that the survey has been completed.
 
 @discussion This method indicates that the survey has been completed.
 
 @code
 [self.myWebView surveyCompleted];
 @endcode
 
 
 @return void.
 */
-(void)surveyCompleted;

/*!
 @brief Sent after a web view starts loading a frame.
 
 @discussion The web view that has begun loading a new frame.
 
 @return void.
 */
-(void)didOnePointWebViewStartLoad;

/*!
 @brief Sent after a web view finishes loading a frame.
 
 @discussion The web view has finished loading.
 
 @return void.
 */
-(void)didOnePointWebViewFinishLoad;


/*!
 @brief Sent if a web view failed to load a frame..
 
 @discussion The web view has an error while loading.
 
 @return void.
 */
-(void)didOnePointWebViewFailLoadWithError:(NSError*)error;


@end

@interface OnePointWebView : UIWebView<UIWebViewDelegate>
/*!
 * @brief Delegate to run the survey on WebView
 */
@property (weak, nonatomic) id<OnePointWebViewDelegate> delegateWebView;

/*!
 @brief This method loads the URL to run the survey.
 
 @discussion This method initiates the survey on a WebView.
 
 @param  surveyReference This parameter is used to construct the URL which will be later loaded on to the WebView.
 
 @code
 [self.myWebView loadWebView:surveyRef];
 @endcode
 
 
 @return void.
 */
- (void)loadWebView:(NSString *)surveyReference;

@end
