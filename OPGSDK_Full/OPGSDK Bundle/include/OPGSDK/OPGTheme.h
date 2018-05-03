//
//  OPGTheme.h
//  OnePointSDK
//
//  Created by OnePoint Global on 04/08/16.
//  Copyright © 2016 OnePointGlobal. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OPGTheme : NSObject<NSCoding>
/*!
 * @brief themeID : themeID
 */
@property(nonatomic,strong) NSNumber *themeID;
/*!
 * @brief themeTemplateID : themeTemplateID
 */
@property(nonatomic,strong) NSNumber *themeTemplateID;
/*!
 * @brief themeElementTypeID : themeElementTypeID
 */
@property(nonatomic,strong) NSNumber *themeElementTypeID;

/*!
 * @brief name : name
 */
@property(nonatomic,strong) NSString *themeName;
/*!
 * @brief value : Hexadecimal color code
 */
@property(nonatomic,strong) NSString *value;
/*!
 * @brief mediaUrl : Media URL
 */
@property(nonatomic,strong) NSString *mediaUrl;
/*!
 * @brief isDeleted : bool value of true indicates deleted and false indicates not deleted.
 */
@property(nonatomic,strong) NSNumber *isDeleted;
/*!
 * @brief createdDate : created date
 */
@property(readwrite,strong) NSDate *createdDate;
/*!
 * @brief lastUpdatedDate : last updated date
 */
@property(readwrite,strong) NSDate *lastUpdatedDate;
@end
