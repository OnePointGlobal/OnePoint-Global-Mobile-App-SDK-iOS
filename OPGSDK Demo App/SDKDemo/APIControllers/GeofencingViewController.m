//
//  GeofencingViewController.m
//  SDKDemoApp
//
//  Created by Manjunath on 19/06/17.
//  Copyright © 2017 opg. All rights reserved.
//

#import "GeofencingViewController.h"
#import <OPGSDK/OPGSDK.h>
@interface GeofencingViewController ()<OPGGeoFenceSurveyDelegate> {
    OPGGeoFence* geo;
    NSMutableArray* arrayLocations;
    CLLocationCoordinate2D *myLocation;

}
@end

@implementation GeofencingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    geo = OPGGeoFence.sharedInstance;
    geo.fencingDelegate = self;
    [geo initialiseGeofencing];

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) getGeoSurveysFromServer {
   CLLocationManager *locationManager = [[CLLocationManager alloc] init];
   myLocation = (__bridge CLLocationCoordinate2D *)([locationManager location]);

    dispatch_async(dispatch_queue_create("MyQueue", NULL), ^{
       OPGSDK* sdk = [OPGSDK new];                   // Creating OPGSDK instance
        NSError *error;
        @try {
            arrayLocations = [sdk getGeofenceSurveys:myLocation->latitude longitude:myLocation->longitude error:&error];
            dispatch_async(dispatch_get_main_queue(), ^{
                NSError *error1;
                if(arrayLocations.count > 0) {
                    [geo startMonitorForGeoFencing:arrayLocations error:&error1];
                    if (error1 != nil) {
                        NSLog(@"Err: %@", error1.debugDescription);
                    }
                }
                else {
                    NSLog(@"No regions to monitor");
                }
            });
        } @catch (NSException *e) {
            NSLog(@"json exception %@",[e description]);
        }
    });
}


- (IBAction)switchTapped:(id)sender {
    UISwitch* customSwitch = (UISwitch*)sender;
    if (customSwitch.isOn) {
        [self getGeoSurveysFromServer];
        
    } else if (!customSwitch.isOn ) {
        [geo stopMonitorForGeoFencing];
        
    }
}

- (void)showAlert{
    if ([arrayLocations count] == 0) {
        return;
    }
    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:@"OPGSDK"
                                 message:[NSString stringWithFormat:@"Congratulations! You're at location %@ and a survey available for u at this location",[[arrayLocations firstObject] address]]
                                 preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* okButton = [UIAlertAction
                               actionWithTitle:@"OK"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * action) {
                                   [arrayLocations removeObjectAtIndex:0];
                                   [self performSelector:@selector(showAlert) withObject:nil afterDelay:0.0];
                                   
                               }];
    UIAlertAction* takeSurveyButton = [UIAlertAction
                                       actionWithTitle:@"TakeSurvey"
                                       style:UIAlertActionStyleDefault
                                       handler:^(UIAlertAction * action) {
                                       }];
    
    [alert addAction:okButton];
    [alert addAction:takeSurveyButton];
    [self presentViewController:alert animated:YES completion:nil];
    
}

-(void) didEnterSurveyRegion:(OPGGeofenceSurvey *)regionEntered
{
    NSLog(@"Entered address is %@",regionEntered.address);
    [self showAlert];
}

-(void) didExitSurveyRegion:(OPGGeofenceSurvey *)regionExited
{

}

@end
