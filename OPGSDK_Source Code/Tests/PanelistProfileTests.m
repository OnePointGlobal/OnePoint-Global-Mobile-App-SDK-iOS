//
//  Tests.m
//  Tests
//
//  Created by OnePoint Global on 12/04/16.
//  Copyright © 2016 OnePointGlobal. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <XCTest/XCTestAssertions.h>
#import "TestConstants.h"
#import "OPGSDK.h"



@interface PanelistProfileTests : XCTestCase

@property (nonatomic) OPGSDK *sdk;

@end

@implementation PanelistProfileTests

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

-(void)testUpdatePanelistProfileSuccess
{
    OPGPanellistProfile *profileObj = [OPGPanellistProfile new];
    profileObj.title= @"1";
    profileObj.firstName = @"IDENTITY";
    profileObj.lastName = @"GuruSwamy";
    profileObj.email = @"IDENTITY123@opg.com";
    profileObj.mobileNumber = @"0123456789";
    profileObj.address1 = @"Maruthi nagar BTM";
    profileObj.address2 = @"Madiwala";
    profileObj.DOB= @"1985-07-25T00:00:00";
    profileObj.gender= [NSNumber numberWithInt:1];
    profileObj.postalCode = @"456789";
    profileObj.std = @"213";                        //std is obtained from getCountries() api
    profileObj.mediaID = @"0";
    
    NSError *error;
    [OPGSDK initializeWithUserName:UserNameSuccess withSDKKey:SharedKeySuccess];
    OPGAuthenticate *obj = [self.sdk authenticate:AuthUserNameSuccess password:AuthPasswordSuccess error:&error];
    BOOL status = [self.sdk updatePanellistProfile:profileObj error:&error];
    XCTAssertTrue(status);
}

-(void)testGetPanelistProfileSuccess
{
    NSError *error;
    [OPGSDK initializeWithUserName:UserNameSuccess withSDKKey:SharedKeySuccess];
    OPGAuthenticate *AuthObj = [self.sdk authenticate:AuthUserNameSuccess password:AuthPasswordSuccess error:&error];
    OPGPanellistProfile *obj = [self.sdk getPanellistProfile:&error];
    XCTAssertTrue(obj !=nil && [error description] == nil);
}

-(void)testGetPanelistProfileFailed
{
    NSError *error;
    [OPGSDK initializeWithUserName:UserNameSuccess withSDKKey:SharedKeyFailed];
    [OPGSDK setUniqueId:UniqueIdSuccess];
    OPGPanellistProfile *obj = [self.sdk getPanellistProfile:&error];
    XCTAssertFalse(obj !=nil && [error description] == nil);
}

-(void)testGetPanelistProfileFailedEmptySDKKey
{
    NSError *error;
    [OPGSDK initializeWithUserName:UserNameSuccess withSDKKey:Empty_String];
    [OPGSDK setUniqueId:UniqueIdSuccess];
    OPGPanellistProfile *obj = [self.sdk getPanellistProfile:&error];
    XCTAssertTrue(obj ==nil && [error description] != nil);
}

-(void)testGetPanelistProfileFailedEmptySDKUsername
{
    NSError *error;
    [OPGSDK initializeWithUserName:Empty_String withSDKKey:SharedKeyFailed];
    [OPGSDK setUniqueId:UniqueIdSuccess];
    OPGPanellistProfile *obj = [self.sdk getPanellistProfile:&error];
    XCTAssertTrue(obj ==nil && [error description] != nil);
}

-(void)testGetPanelistProfileFailedEmptyUniqueID
{
    NSError *error;
    [OPGSDK initializeWithUserName:UserNameSuccess withSDKKey:SharedKeySuccess];
    [OPGSDK setUniqueId:Empty_String];
    OPGPanellistProfile *obj = [self.sdk getPanellistProfile:&error];
    XCTAssertTrue(obj ==nil && [error description] != nil);
}


@end
