//
//  OPGCountry.h
//  OnePointSDK
//
//  Created by OnePoint Global on 02/11/16.
//  Copyright © 2016 OnePointGlobal. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OPGCountry : NSObject<NSCoding>
/*! @brief countryID : Country ID. */
@property (nonatomic,strong) NSNumber *countryID;
/*! @brief name : Name of the country. */
@property (nonatomic,strong) NSString *name;
/*! @brief countryCode : Country Code. */
@property (nonatomic,strong) NSString *countryCode;
/*! @brief std : STD Code. */
@property (nonatomic,strong) NSString *std;
/*! @brief gmt : Greenwich Mean Time. */
@property (nonatomic,strong) NSString *gmt;
/*! @brief creditRate : Credit Rate. */
@property (nonatomic,strong) NSNumber *creditRate;
/*! @brief isDeleted : bool value of true indicates deleted and false indicates not deleted. */
@property(nonatomic,strong) NSNumber *isDeleted;
@end
