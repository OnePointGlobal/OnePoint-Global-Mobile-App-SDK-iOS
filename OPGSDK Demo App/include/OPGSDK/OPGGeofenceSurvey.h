//
//  OPGGeofenceSurvey.h
//  OnePointSDK
//
//  Created by Manjunath on 14/06/17.
//  Copyright © 2017 OnePointGlobal. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OPGGeofenceSurvey : NSObject<NSCoding>
/*! @brief surveyName : Name of the survey. */
@property(nonatomic, strong) NSString* surveyName;
/*! @brief surveyReference : Survey Reference. */
@property(nonatomic, strong) NSString* surveyReference;
/*! @brief address : Address of the survey location. */
@property(nonatomic, strong) NSString* address;
/*! @brief surveyID : Survey ID. */
@property(nonatomic, strong) NSNumber* surveyID;
/*! @brief addressID : Address ID. */
@property(nonatomic, strong) NSNumber* addressID;
/*! @brief latitude : latitude. */
@property(nonatomic, strong) NSNumber* latitude;
/*! @brief longitude : longitude. */
@property(nonatomic, strong) NSNumber* longitude;
/*! @brief geocode : geocode. */
@property(nonatomic, strong) NSString* geocode;
/*! @brief createdDate : Created Date. */
@property(nonatomic, strong) NSString* createdDate;
/*! @brief lastUpdatedDate : Last updated date. */
@property(nonatomic, strong) NSString* lastUpdatedDate;
/*! @brief isDeleted : bool value of true indicates deleted and false indicates not deleted.. */
@property(nonatomic, strong) NSNumber* isDeleted;
/*! @brief distance : Distance to the survey location from the given location. */
@property(nonatomic, strong) NSNumber* distance;
/*! @brief range : Range is the radius for the geofenced zone. */
@property(nonatomic, strong) NSNumber* range;
@end
