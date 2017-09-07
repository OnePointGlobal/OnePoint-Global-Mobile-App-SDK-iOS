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

@interface OPGSurvey : NSObject<NSCoding>
/*!
 * @brief isGeoFencing : bool value true indicates GeoFenced and false indicates it is not.
 */
@property(nonatomic,strong) NSNumber *isGeoFencing;
/*!
 * @brief surveyName : Name of the Survey.
 */
@property(nonatomic,strong) NSString *surveyName;
/*!
 * @brief surveyDescription : Description of the Survey.
 */
@property(nonatomic,strong) NSString *surveyDescription;
/*!
 * @brief isOffline : The property indicates bool value true as offline and false as Online
 */
@property(nonatomic,strong) NSNumber *isOffline;
/*!
 * @brief startDate : Scheduled start date of the survey.
 */
@property(nonatomic,strong) NSString *startDate;
/*!
 * @brief endDate : Scheduled end date of the survey.
 */
@property(nonatomic,strong) NSString *endDate;
/*!
 * @brief createdDate : Created date of the survey.
 */
@property(nonatomic,strong) NSString *createdDate;
/*!
 * @brief lastUpdatedDate : Last updated date of the survey.
 */
@property(nonatomic,strong) NSString *lastUpdatedDate;
/*!
 * @brief surveyReference : This survey reference is passed to OPGViewController to load Survey.
 */
@property(nonatomic,strong) NSString *surveyReference;
/*!
 * @brief surveyID : surveyID .
 */
@property(nonatomic,strong) NSNumber *surveyID;
/*!
 * @brief estimatedTime : EstimatedTime for the survey.
 */
@property(nonatomic,strong) NSNumber *estimatedTime;
/*!
 * @brief deadline : Deadline time for the survey.
 */
@property(nonatomic,strong) NSString *deadline;
/*!
 * @brief status : status of the survey which would be new, pending or completed.
 */
@property(nonatomic,strong) NSString *status;
/*!
 * @brief isOfflineDownloaded : The property indicates int value 1 as downloaded and 0 as not downloaded.
 */
@property(nonatomic,strong) NSNumber *isOfflineDownloaded;
@end
