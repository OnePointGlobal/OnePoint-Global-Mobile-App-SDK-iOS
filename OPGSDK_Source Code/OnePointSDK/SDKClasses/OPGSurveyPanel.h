//
//  OPGSurveyPanel.h
//  OnePointSDK
//
//  Created by OnePoint Global on 04/08/16.
//  Copyright © 2016 OnePointGlobal. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OPGSurveyPanel : NSObject<NSCoding>
/*!
 * @brief surveyPanelID : surveyPanelID
 */
@property(nonatomic,strong) NSNumber *surveyPanelID;
/*!
 * @brief surveyID : surveyID
 */
@property(nonatomic,strong) NSNumber *surveyID;
/*!
 * @brief panelID : panelID
 */
@property(nonatomic,strong) NSNumber *panelID;
/*!
 * @brief excluded : bool value of true indicates excluded and false indicates it is not.
 */
@property(nonatomic,strong) NSNumber *excluded;
/*!
 * @brief excludedSpecified : bool value of true indicates excluded specified and false indicates it is not.
 */
@property(nonatomic,strong) NSNumber *excludedSpecified;
/*!
 * @brief isDeleted : bool value of true indicates deleted and false indicates it is not deleted.
 */
@property(nonatomic,strong) NSNumber *isDeleted;
/*!
 * @brief createdDate : created date
 */
@property(nonatomic,strong) NSDate *createdDate;
/*!
 * @brief lastUpdatedDate : last updated date
 */
@property(nonatomic,strong) NSDate *lastUpdatedDate;
@end
