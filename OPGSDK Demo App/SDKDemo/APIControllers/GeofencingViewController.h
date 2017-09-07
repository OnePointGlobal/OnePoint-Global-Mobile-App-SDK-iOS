//
//  GeofencingViewController.h
//  SDKDemoApp
//
//  Created by Manjunath on 19/06/17.
//  Copyright © 2017 opg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <OPGSDK/OPGGeoFence.h>
#import <OPGSDK/OPGGeofenceSurvey.h>

@interface GeofencingViewController : UIViewController
@property(weak, nonatomic) IBOutlet UISwitch *switchControl;
@end
