//
//  NotificationTests.m
//  OnePointSDK
//
//  Created by OnePoint Global on 31/08/16.
//  Copyright © 2016 OnePointGlobal. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "TestConstants.h"
#import "OPGSDK.h"
@interface NotificationTests : XCTestCase
@property (nonatomic) OPGSDK *sdk;
@end

@implementation NotificationTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    self.sdk = [[OPGSDK alloc] init];
    [OPGSDK initializeWithUserName:UserNameSuccess withSDKKey:SharedKeySuccess];
    
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

-(void)testRegisterNotificationSuccess
{
    NSError *error;
    [OPGSDK initializeWithUserName:UserNameSuccess withSDKKey:SharedKeySuccess];
    [OPGSDK setAppVersion:AppVersionSuccess];
    OPGAuthenticate *AuthObj = [self.sdk authenticate:AuthUserNameSuccess password:AuthPasswordSuccess error:&error];
    BOOL status = [self.sdk registerNotifications:deviceTokenIDSuccess error:&error];
    XCTAssertTrue(status);
}

-(void)testRegisterNotificationFailedEmptySDKKey
{
    NSError *error;
    [OPGSDK initializeWithUserName:UserNameSuccess withSDKKey:Empty_String];
    [OPGSDK setAppVersion:AppVersionSuccess];
    [OPGSDK setUniqueId:UniqueIdSuccess];
    BOOL status = [self.sdk registerNotifications:deviceTokenIDSuccess error:&error];
    XCTAssertFalse(status);
}

-(void)testUnregisterNotificationFailedEmptySDKUsername
{
    NSError *error;
    [OPGSDK initializeWithUserName:Empty_String withSDKKey:SharedKeySuccess];
    [OPGSDK setAppVersion:AppVersionSuccess];
    [OPGSDK setUniqueId:UniqueIdSuccess];
    BOOL status = [self.sdk unregisterNotifications:deviceTokenIDSuccess error:&error];
    XCTAssertFalse(status);
}



@end
