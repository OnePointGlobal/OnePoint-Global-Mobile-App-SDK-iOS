//
//  OPGGeoFence.h
//  OnePointSDK
//
//  Created by Chinthan on 12/06/17.
//  Copyright © 2017 OnePointGlobal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OPGGeofenceSurvey.h"

/*!
 This delegate lets the implementing class to monitor for a user's entry and exit events based on his locations.
 */
@protocol OPGGeoFenceSurveyDelegate <NSObject>
/*!
 This delegate method is invoked when the user enters the geofenced region.
 */
-(void)didEnterSurveyRegion:(OPGGeofenceSurvey*)regionEntered;

/*!
 This delegate method is invoked when the user exits the geofenced region.
 */
-(void)didExitSurveyRegion:(OPGGeofenceSurvey*)regionExited;
@end



@interface OPGGeoFence : NSObject
/*!
 This method returns a singleton object of OPGGeoFence class.
 */
+(OPGGeoFence *)sharedInstance;

/*!
 This method initialises the location manager and request user for location authorization permission.
 */
-(void)initialiseGeofencing;

/*!
 This method tells the user if monitoring is enabled based on the location authorization permission.
 */
-(BOOL)isMonitoringAllowed;

/*!
 This method performs monitoring for OPGGeofenceSurvey locations passed in arguments. A max of 20 locations can be monitored by iOS.
 */
-(void)startMonitorForGeoFencing:(NSArray<OPGGeofenceSurvey *> *)locations
                           error:(NSError **)error;

/*!
 This method stops monitoring for geofenced locations.
 */
-(void)stopMonitorForGeoFencing;
/*!
 This delegate property of type OPGGeoFenceSurveyDelegate.
 */
@property(assign, nonatomic) id<OPGGeoFenceSurveyDelegate> fencingDelegate;
@end
