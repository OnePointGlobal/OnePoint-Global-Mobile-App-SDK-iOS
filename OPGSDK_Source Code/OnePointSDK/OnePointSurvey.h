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

@interface OnePointSurvey : NSObject
/*!
 * @brief The property indicates geo-fencing.
 */
@property(nonatomic,strong)NSNumber *IsGeoFencing;
/*!
 * @brief Survey name.
 */
@property(nonatomic,strong)NSString *Name;
/*!
 * @brief Survey description.
 */
@property(nonatomic,strong)NSString *Description;
/*!
 * @brief Script id.
 */
@property(nonatomic,strong)NSString *ScriptID;
/*!
 * @brief The property indicates whether the survey is online or offline.
 */
@property(nonatomic,strong)NSNumber *IsOffline;
/*!
 * @brief Last updated date of the survey.
 */
@property(nonatomic,strong)NSString *LastUpdatedDate;
/*!
 * @brief Survey reference id.
 */
@property(nonatomic,strong)NSString *SurveyReference;

@end
