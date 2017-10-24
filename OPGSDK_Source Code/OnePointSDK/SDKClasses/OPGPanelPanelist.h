//
//  OPGPanelPanelist.h
//  OnePointSDK
//
//  Created by OnePoint Global on 04/08/16.
//  Copyright © 2016 OnePointGlobal. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OPGPanelPanelist : NSObject
/*!
 * @brief panelPanellistID : panelPanellistID
 */
@property(nonatomic,strong) NSString *panelPanellistID;
/*!
 * @brief panelID : panelID
 */
@property(nonatomic,strong) NSString *panelID;
/*!
 * @brief panellistID : panellistID
 */
@property(nonatomic,strong) NSString *panellistID;
/*!
 * @brief createdDate : created date
 */
@property(nonatomic,strong) NSDate *createdDate;
/*!
 * @brief lastUpdatedDate : last updated date
 */
@property(nonatomic,strong) NSDate *lastUpdatedDate;
/*!
 * @brief isDeleted : bool value of 1 indicates success and 0 indicates failure.
 */
@property(nonatomic,retain) NSNumber *isDeleted;
@end
