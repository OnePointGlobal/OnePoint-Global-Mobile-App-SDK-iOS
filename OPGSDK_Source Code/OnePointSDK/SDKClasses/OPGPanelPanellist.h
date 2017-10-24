//
//  OPGPanelPanellist.h
//  OnePointSDK
//
//  Created by OnePoint Global on 04/08/16.
//  Copyright © 2016 OnePointGlobal. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OPGPanelPanellist : NSObject<NSCoding>
/*!
 * @brief panelPanellistID : panelPanellistID
 */
@property(nonatomic,strong) NSNumber *panelPanellistID;
/*!
 * @brief panelID : panelID
 */
@property(nonatomic,strong) NSNumber *panelID;
/*!
 * @brief panellistID : panellistID
 */
@property(nonatomic,strong) NSNumber *panellistID;
/*!
 * @brief included : bool value of true indicates included and false indicates it is not.
 */
@property(nonatomic,strong) NSNumber *included;
/*!
 * @brief includedSpecified : bool value of true indicates included specified and false indicates it is not.
 */
@property(nonatomic,strong) NSNumber *includedSpecified;
/*!
 * @brief createdDate : created date
 */
@property(nonatomic,strong) NSDate *createdDate;
/*!
 * @brief lastUpdatedDate : last updated date
 */
@property(nonatomic,strong) NSDate *lastUpdatedDate;
/*!
 * @brief isDeleted : bool value of true indicates deleted and false indicates it is not.
 */
@property(nonatomic,strong) NSNumber *isDeleted;
@end
