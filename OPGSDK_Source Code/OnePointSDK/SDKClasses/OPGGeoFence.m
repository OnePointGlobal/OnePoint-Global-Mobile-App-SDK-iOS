//
//  OPGGeoFence.m
//  OnePointSDK
//
//  Created by Chinthan on 12/06/17.
//  Copyright © 2017 OnePointGlobal. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "OPGGeoFence.h"
#import "OPGNetworkRequest.h"
#import "OPGAuthenticate.h"
#import "OPGSDK.h"
#import "OPGConstants.h"

static OPGGeoFence *_sharedMySingleton = nil;

@interface OPGGeoFence()<CLLocationManagerDelegate>
@property (nonatomic,strong) NSMutableArray* locationsArray;
@property (nonatomic, strong) CLLocationManager* locationManager;
@property (nonatomic, strong) CLRegion* currentRegion;
@property (nonatomic, assign) BOOL didPassTimeIntervalInTheRegion;
@end

@implementation OPGGeoFence
@synthesize fencingDelegate, locatonTimestamp;

+(OPGGeoFence *)sharedInstance {
    @synchronized([OPGGeoFence class])
    {
        if (!_sharedMySingleton)
            _sharedMySingleton=[[self alloc] init];
        return _sharedMySingleton;
    }
    return nil;
}

+(id)alloc {
    @synchronized([OPGGeoFence class]) {
        NSAssert(_sharedMySingleton == nil,
                 @"Attempted to allocate a second instance of a singleton.");
        _sharedMySingleton = [super alloc];
        return _sharedMySingleton;
    }
    return nil;
}

#pragma mark - Private Methods
-(void) populateErrorObject:(NSString*)errorMessage withError:(NSError **)errorDomain
{
    int errorCode = 4;
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    [userInfo setObject:errorMessage
                 forKey:NSLocalizedDescriptionKey];
    
    // Populate the error reference.
    *errorDomain = [[NSError alloc] initWithDomain:kCLErrorDomain
                                              code:errorCode
                                          userInfo:userInfo];
}

- (OPGGeofenceSurvey*)runThroughAddress:(NSString*)geoID {
    NSArray *geoIdArray = [geoID componentsSeparatedByString:@"--"];
    NSString *surveyref = [geoIdArray objectAtIndex:0];
    NSString *address = [geoIdArray objectAtIndex:1];

    if(self.locationsArray == nil) {
        NSLog(@"self.locationsArray is nil");
        NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
        NSMutableArray *decodedArray = [NSKeyedUnarchiver unarchiveObjectWithData:[defaults valueForKey:@"OPGSuveyLocations"]];
        self.locationsArray = decodedArray;
        NSLog(@"Locations Array: %@", self.locationsArray);
    }
    if (self.locationsArray.count > 0) {
        for (OPGGeofenceSurvey* geo in self.locationsArray) {
            if ([address isEqualToString:geo.address] && [surveyref isEqualToString:geo.surveyReference]) {
                return  geo;
            }
        }
    }
    else {
        OPGGeofenceSurvey* geo = [OPGGeofenceSurvey new];
        return  geo;
    }
    return nil;
}

-(BOOL) checkForAuthorizationPermission: (NSError **)error {
    BOOL shouldMonitorLocations = NO;
    if ([CLLocationManager locationServicesEnabled]) {
        switch ([CLLocationManager authorizationStatus]) {
            case kCLAuthorizationStatusAuthorizedAlways:
                shouldMonitorLocations= YES;
                break;
            case kCLAuthorizationStatusAuthorizedWhenInUse:
                shouldMonitorLocations= YES;
                break;
            case kCLAuthorizationStatusDenied:
            {
                if (error !=nil)
                [self populateErrorObject:LocationAuthorizationDenied withError:error];

                shouldMonitorLocations= NO;
                break;
            }
            case kCLAuthorizationStatusNotDetermined:
            {
                if (error !=nil)
                [self populateErrorObject:LocationAuthorizationNotDetermined withError:error];

                shouldMonitorLocations= NO;
                break;
            }
            case kCLAuthorizationStatusRestricted:
            {
                if (error !=nil)
                [self populateErrorObject:LocationAuthorizationRestricted withError:error];

                shouldMonitorLocations= NO;
                break;
            }
            default:
                break;
        }
    }
    else{
        if (error !=nil)
        [self populateErrorObject:LocationSettingsDisabled withError:error];

        shouldMonitorLocations= NO;
    }
    return shouldMonitorLocations;
}

-(void) performMonitoring: (NSArray*)locations {
    NSArray *locationsToMonitor;
    if(![CLLocationManager isMonitoringAvailableForClass:[CLRegion class]]) {
        NSLog(@"Geofence monitoring not supported by the device");
    }
    if(locations.count > 20) {
        locationsToMonitor = [locations subarrayWithRange:NSMakeRange(0, 20)];
    }
    else {
        locationsToMonitor = locations;
    }
    //NSLog(@"Number of Locations is %lu, below 20 is preferred for monitoring", (unsigned long)self.locationsArray.count);
    for (int i = 0 ; i < locationsToMonitor.count ; i++) {
        OPGGeofenceSurvey* geo = [locationsToMonitor objectAtIndex:i];
        CLLocationCoordinate2D region ;
        region.latitude = geo.latitude.doubleValue;
        region.longitude = geo.longitude.doubleValue;
        //NSLog(@"latitude %f longitude %f Address %@", geo.latitude.doubleValue, geo.longitude.doubleValue,geo.address);
        NSString *identifier = [NSString stringWithFormat:@"%@--%@",geo.surveyReference,geo.address];
        CLCircularRegion* regionToMonitor = [[CLCircularRegion alloc] initWithCenter:region radius:geo.range.doubleValue identifier:identifier];
        regionToMonitor.notifyOnEntry = TRUE;
        regionToMonitor.notifyOnExit = TRUE;
        [self.locationManager startMonitoringForRegion:regionToMonitor];
    }

    [NSTimer scheduledTimerWithTimeInterval:5.0f target:self selector:@selector(startRequestState) userInfo:nil repeats:NO];
    //NSLog(@"Monitored Regions %@",self.locationManager.monitoredRegions);
}

-(void)startRequestState {
    [self initialiseGeofencing];
    for (CLRegion *region in self.locationManager.monitoredRegions) {
        [self.locationManager requestStateForRegion:region];
    }
}

#pragma mark - Class Methods
-(void)initialiseGeofencing {
    if (self.locationManager == nil) {
        self.locationManager = [[CLLocationManager alloc] init];
        //NSLog(@"self.locationsArray is nil");
    }
    self.locationManager.delegate = self; // Tells the location manager to send updates to this object
    NSString *version = [[UIDevice currentDevice] systemVersion];
    if ([version floatValue] >= 8.0f) //for iOS8
    {
        if ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
            [self.locationManager requestAlwaysAuthorization];
        }
        if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
            [self.locationManager requestWhenInUseAuthorization];
        }
    }
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.distanceFilter = 10;
    if ([version floatValue] >= 9.0f) //for iOS8
    {
        self.locationManager.allowsBackgroundLocationUpdates = YES;
    }
    [[self locationManager] startUpdatingLocation];
}

-(BOOL)isMonitoringAllowed {
    return [self checkForAuthorizationPermission:nil];
}

-(void)startMonitorForGeoFencing:(NSArray<OPGGeofenceSurvey *> *)locations error:(NSError **)error{
    [self initialiseGeofencing];
    self.locationsArray = [NSMutableArray arrayWithArray:locations];
    BOOL shouldMonitor = [self checkForAuthorizationPermission:error];
    if (shouldMonitor) {
        if(locations.count > 0) {
            NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
            NSData *encodedData= [NSKeyedArchiver archivedDataWithRootObject:self.locationsArray];
            [defaults setObject:encodedData forKey:@"OPGSuveyLocations"];
            [defaults synchronize];
            [self performMonitoring:locations];
        }
        else {
            [self populateErrorObject:NoRegionsToMonitor withError:error];
        }
    }
}

-(void)stopMonitorForGeoFencing {
    [self initialiseGeofencing];
    for (CLRegion* region in [self.locationManager monitoredRegions]) {
        [self.locationManager stopMonitoringForRegion:region];
    }
    //[[self locationManager] stopUpdatingLocation];
    //self.fencingDelegate = nil;
    if (self.locationManager == nil) {
        NSLog(@"not stopped monitoring");
    } else {
        NSLog(@"stopped monitoring");
    }
}

#pragma mark - Location Manager Delegate Methods
- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region {
    // Note the time of entry into location
    self.locatonTimestamp = [NSDate new];
    self.currentRegion = region;
}

- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region {
    self.locatonTimestamp = nil;
    self.currentRegion = nil;       // denotify when user comes out of region

    OPGGeofenceSurvey *geoSurvey = [self runThroughAddress:region.identifier];
    if (geoSurvey.timeInterval == 0) {
        [self.fencingDelegate didExitSurveyRegion:[self runThroughAddress:region.identifier]];
    }
    else if (geoSurvey.timeInterval > 0 && self.didPassTimeIntervalInTheRegion && [geoSurvey.isExit intValue] == 1) {
        // check if the user has stayed for enough time in the area
        self.didPassTimeIntervalInTheRegion = NO;
        [self.fencingDelegate didExitSurveyRegion:[self runThroughAddress:region.identifier]];
    }
    //[self.locationManager stopMonitoringForRegion:region];
}


-(void) locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    if (locations.count > 0) {
        NSDate *now = [NSDate new];
        NSTimeInterval interval = (self.locatonTimestamp != nil) ? [now timeIntervalSinceDate:self.locatonTimestamp] : 0;
        OPGGeofenceSurvey *surveyRegion = [self runThroughAddress:self.currentRegion.identifier];
        double scheduledSurveyTimeInterval = [surveyRegion.timeInterval doubleValue] * 60;    // minutes to seconds

        //it will pass this condition when the time limit is elapsed
        if (interval != 0 && interval >= scheduledSurveyTimeInterval)
        {
            self.didPassTimeIntervalInTheRegion = YES;
            //do your region checking here
            if (self.currentRegion != nil) {
                [self.locationManager requestStateForRegion:self.currentRegion];
            }
        }
    }
}

- (void)locationManager:(CLLocationManager *)manager didStartMonitoringForRegion:(CLRegion *)region {
    //NSLog(@"Monitoring started %@", region.identifier);
    @synchronized ([self class]) {
       // [self.locationManager performSelector:@selector(requestStateForRegion:) withObject:region afterDelay:5];
        region.notifyOnEntry = TRUE;
    }
}

// This method is called for all regions and we are handling the case here where the user is already inside the region,
// so no need of calling delegate method "didEnterSurveyRegion" from the location manager's delegate "didEnterRegion"
- (void)locationManager:(CLLocationManager *)manager didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region {
    @synchronized ([self class]) {
        OPGGeofenceSurvey *geoSurvey = [self runThroughAddress:region.identifier];
        if (state == CLRegionStateInside) {
            if (self.locatonTimestamp == nil) {
                // Note the time of entry into location
                self.locatonTimestamp = [NSDate new];
            }
            if (self.currentRegion == nil) {
                // Already inside
                self.currentRegion = region;
            }

            if ([geoSurvey.isEnter intValue] == 0 && [geoSurvey.isExit intValue] == 0) {
                // if geosurvey is from old adminsuite, consider "Enter" as default selection.
                geoSurvey.isEnter = [NSNumber numberWithInt:1];
            }

            if (geoSurvey.timeInterval==0) {
                // It is just an entry event so trigger delegate immediately
                [self.fencingDelegate didEnterSurveyRegion:geoSurvey];
            }
            else if (geoSurvey.timeInterval > 0 && self.didPassTimeIntervalInTheRegion && [geoSurvey.isEnter intValue] == 1) {
                // It is time based geofencing
                [self.fencingDelegate didEnterSurveyRegion:geoSurvey];
                // reset value so that the delegate didEnterSurveyRegion is not called repetitively
                self.didPassTimeIntervalInTheRegion = NO;
                self.locatonTimestamp = nil;
                self.currentRegion = nil;
            }
        }
    }
}

-(void)locationManager:(CLLocationManager *)manager monitoringDidFailForRegion:(CLRegion *)region withError:(NSError *)error {
    NSLog(@"monitoring failed due to %@", error.description);
}
@end
