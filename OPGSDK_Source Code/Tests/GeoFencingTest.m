//
//  GeoFencingTest.m
//  OnePointSDK
//
//  Created by OnePoint Global on 20/09/16.
//  Copyright © 2016 OnePointGlobal. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "OPGGeoFence.h"
#import "OPGGeofenceSurvey.h"
#import "OPGSDK.h"
#import "OPGSurvey.h"
#import "TestConstants.h"

@interface GeoFencingTest : XCTestCase<OPGGeoFenceSurveyDelegate>

@end

@implementation GeoFencingTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    [OPGSDK initializeWithUserName:GeoUserNameSuccess withSDKKey:GeoSharedKeySuccess];
    [OPGSDK setAppVersion:AppVersionSuccess];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
    //geo.fencingDelegate = nil;
}

-(void)testGeoFencingSuccess
{
    NSError* error;
    OPGSDK* sdk = [OPGSDK new];
    [OPGSDK initializeWithUserName:UserNameSuccess withSDKKey:SharedKeySuccess];
    OPGAuthenticate *obj = [sdk authenticate:AuthUserNameSuccess password:AuthPasswordSuccess error:&error];
    NSArray *geoArray = [sdk getGeofenceSurveys:12.904 longitude:77.62 error:&error];
//    OPGGeoFence *geo = [[OPGGeoFence alloc]init];
 //   geo.fencingDelegate = self;
//    [geo initialiseGeofencing];
//    [geo startMonitorForGeoFencing:geoArray error:&error];
    XCTAssertTrue([geoArray count] > 0 && [error description] == nil);
}

-(void)testGeoFencingFailedAuthentication
{
    NSError* error;
    OPGSDK* sdk = [OPGSDK new];
    [OPGSDK logout];
    [OPGSDK initializeWithUserName:UserNameSuccess withSDKKey:SharedKeySuccess];
    OPGAuthenticate *obj = [sdk authenticate:AuthUserNameFailed password:AuthPasswordSuccess error:&error];
    NSArray *geoArray = [sdk getGeofenceSurveys:12.904 longitude:77.62 error:&error];
    XCTAssertTrue([geoArray count] == 0 && [error description] != nil);
}

-(void)testGeoFencingFailedWrongUsername
{
    NSError* error;
    OPGSDK* sdk = [OPGSDK new];
   [OPGSDK initializeWithUserName:UserNameSuccess withSDKKey:SharedKeyFailed];
    OPGAuthenticate *obj = [sdk authenticate:AuthUserNameSuccess password:AuthPasswordSuccess error:&error];
    NSArray *geoArray = [sdk getGeofenceSurveys:12.904 longitude:77.62 error:&error];
    XCTAssertTrue([geoArray count] == 0 && [error description] != nil);
}

-(void)testGeoFencingFailedNoSessionID
{
    NSError* error;
    OPGSDK* sdk = [OPGSDK new];
    [OPGSDK initializeWithUserName:UserNameSuccess withSDKKey:SharedKeySuccess];
    [OPGSDK logout];
    NSArray *geoArray = [sdk getGeofenceSurveys:12.904 longitude:77.62 error:&error];
    XCTAssertTrue(geoArray  == nil && [error description] != nil);
}

-(void)didEnterSurveyRegion:(OPGGeofenceSurvey*)regionEntered
{
    NSLog(@"Entered");
}

-(void)didExitSurveyRegion:(OPGGeofenceSurvey*)regionExited
{
    NSLog(@"Exited");
}
@end
