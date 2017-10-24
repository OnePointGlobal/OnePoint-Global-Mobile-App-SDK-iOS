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

@interface OnePointPanel : NSObject

/*!
 * @brief The property indicates geo-fencing.
 */
@property(nonatomic,strong)NSString *IsDeleted;

/*!
 * @brief Panel description.
 */
@property(nonatomic,strong)NSString *Description;
/*!
 * @brief Panel id.
 */
@property(nonatomic,strong)NSNumber *PanelID;
/*!
 * @brief Panel type.
 */
@property(nonatomic,strong)NSNumber *PanelType;
/*!
 * @brief User id.
 */
@property(nonatomic,strong)NSNumber *UserID;
/*!
 * @brief panel name.
 */
@property(nonatomic,strong)NSString *Name;
/*!
 * @brief Remark.
 */
@property(nonatomic,strong)NSString *Remark;
/*!
 * @brief The property indicates ThemeTemplateID.
 */
@property(nonatomic,strong)NSNumber *ThemeTemplateID;
/*!
 * @brief The property indicates ThemeTemplateIDSpecified.
 */
@property(nonatomic,strong)NSNumber *ThemeTemplateIDSpecified;
/*!
 * @brief Last updated date of the survey.
 */
@property(nonatomic,strong)NSString *LastUpdatedDate;
/*!
 * @brief Create updated date of the survey.
 */
@property(nonatomic,strong)NSString *CreatedUpdatedDate;
/*!
 * @brief Search Tag.
 */
@property(nonatomic,strong)NSString *SearchTag;

@end
