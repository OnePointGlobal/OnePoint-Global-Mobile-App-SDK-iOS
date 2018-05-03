//
//  OPGPanel.h
//  OnePointSDK
//
//  Created by OnePoint Global on 04/08/16.
//  Copyright © 2016 OnePointGlobal. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OPGPanel : NSObject<NSCoding>
/*!
 * @brief panelID : panel ID
 */
@property(nonatomic,strong) NSNumber *panelID;
/*!
 * @brief themeTemplateID : theme template ID
 */
@property(nonatomic,strong) NSNumber *themeTemplateID;
/*!
 * @brief themeTemplateIDSpecified : bool value of true indicates specified and false indicates it is not specified.
 */
@property(nonatomic,strong) NSNumber *themeTemplateIDSpecified;
/*!
 * @brief panelName : panelName
 */
@property(nonatomic,strong) NSString *panelName;
/*!
 * @brief description : description
 */
@property(nonatomic,strong) NSString *panelDescription;
/*!
 * @brief panelType : 1 indicates Normal and 2 indicates CAPI
 */
@property(nonatomic,strong) NSNumber *panelType;
/*!
 * @brief searchTag : search tag
 */
@property(nonatomic,strong) NSString *searchTag;
/*!
 * @brief remark : remark
 */
@property(nonatomic,strong) NSString *remark;
/*!
 * @brief isDeleted : bool value of true indicates deleted and false indicates not deleted. */
@property(nonatomic,strong) NSNumber *isDeleted;
/*!
 * @brief createdDate : created date
 */
@property(nonatomic,strong) NSDate *createdDate;
/*!
 * @brief lastUpdatedDate : last updated date
 */
@property(nonatomic,strong) NSDate *lastUpdatedDate;
/*!
 * @brief userID : user ID
 */
@property(nonatomic,strong) NSNumber *userID;
/*!
 * @brief mediaUrl : URL for the panel media
 */
@property(nonatomic,strong) NSString *mediaUrl;
/*!
 * @brief mediaUrl : URL for the panel logo
 */
@property(nonatomic,strong) NSString *logoUrl;
/*!
 * @brief mediaID : media ID
 */
@property(nonatomic,strong) NSNumber *mediaID;
/*!
 * @brief logoID : logo ID
 */
@property(nonatomic,strong) NSNumber *logoID;
/*!
 * @brief mediaIDSpecified : bool value of true indicates specified and false indicates it is not specified.
 */
@property(nonatomic,strong) NSNumber *mediaIDSpecified;
@end
