//
//  PasswordTest.m
//  OnePointSDK
//
//  Created by OnePoint Global on 23/08/16.
//  Copyright © 2016 OnePointGlobal. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "TestConstants.h"
#import "OPGSDK.h"

@interface PasswordTests : XCTestCase
@property (nonatomic) OPGSDK *sdk;
@end

@implementation PasswordTests

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

-(void)testforgotPasswordSuccess
{
    NSError *error;
    [OPGSDK initializeWithUserName:UserNameSuccess withSDKKey:SharedKeySuccess];
    [OPGSDK setAppVersion:AppVersionSuccess];
    OPGForgotPassword *obj = [self.sdk forgotPassword:MailIDSuccess error:&error];
    XCTAssertTrue([obj.isSuccess intValue] == 1 && error==nil);
}

-(void)testforgotPasswordFailedWrongMailID
{
    NSError *error;
    [OPGSDK initializeWithUserName:UserNameSuccess withSDKKey:SharedKeySuccess];
    [OPGSDK setAppVersion:AppVersionSuccess];
    OPGForgotPassword *obj = [self.sdk forgotPassword:MailIDFailed error:&error];
    XCTAssertTrue([obj.isSuccess intValue] == 0 && [error description] == nil);
}

-(void)testforgotPasswordFailedEmptyMailID
{
    NSError *error;
    [OPGSDK initializeWithUserName:UserNameSuccess withSDKKey:SharedKeySuccess];
    [OPGSDK setAppVersion:AppVersionSuccess];
    OPGForgotPassword *obj = [self.sdk forgotPassword:Empty_String error:&error];
    XCTAssertTrue([obj.isSuccess intValue] == 0 && [error description] == nil);
}

-(void)testforgotPasswordFailedNilMailID
{
    NSError *error;
    [OPGSDK initializeWithUserName:UserNameSuccess withSDKKey:SharedKeySuccess];
    [OPGSDK setAppVersion:AppVersionSuccess];
    OPGForgotPassword *obj = [self.sdk forgotPassword:nil error:&error];
    XCTAssertTrue([obj.isSuccess intValue] == 0 && [error description] == nil);
}

-(void)testforgotPasswordFailedNoAppVersion
{
    NSError *error;
    [OPGSDK initializeWithUserName:UserNameSuccess withSDKKey:SharedKeySuccess];
    [OPGSDK setAppVersion:Empty_String];
    OPGForgotPassword *obj = [self.sdk forgotPassword:MailIDFailed error:&error];
    XCTAssertTrue([obj.isSuccess intValue] == 0 && [error description] != nil);
}

-(void)testforgotPasswordFailedEmptySDKKey
{
    NSError *error;
    [OPGSDK initializeWithUserName:UserNameSuccess withSDKKey:Empty_String];
    [OPGSDK setAppVersion:AppVersionSuccess];
    OPGForgotPassword *obj = [self.sdk forgotPassword:MailIDFailed error:&error];
    XCTAssertTrue([obj.isSuccess intValue] == 0 && [error description] != nil);
}

-(void)testforgotPasswordFailedEmptySDKUsername
{
    NSError *error;
    [OPGSDK initializeWithUserName:Empty_String withSDKKey:SharedKeySuccess];
    [OPGSDK setAppVersion:AppVersionSuccess];
    OPGForgotPassword *obj = [self.sdk forgotPassword:MailIDFailed error:&error];
    XCTAssertTrue([obj.isSuccess intValue] == 0 && [error description] != nil);
}

-(void)testchangePasswordFailedWrongInput
{
    NSError *error;
    [OPGSDK initializeWithUserName:UserNameSuccess withSDKKey:SharedKeySuccess];
    [OPGSDK setUniqueId:UniqueIdSuccess];
    OPGChangePassword *obj = [self.sdk changePassword:CurrPasswordFailed newPassword:NewPassword error:&error];
    XCTAssertFalse([obj.isSuccess intValue] == 1 && [error description] == nil);
}

-(void)testchangePasswordFailedEmptyUniqueID
{
    NSError *error;
    [OPGSDK initializeWithUserName:UserNameSuccess withSDKKey:SharedKeySuccess];
    [OPGSDK setUniqueId:Empty_String];
    OPGChangePassword *obj = [self.sdk changePassword:CurrPasswordFailed newPassword:NewPassword error:&error];
    XCTAssertFalse([obj.isSuccess intValue] == 1 || [error description] == nil);
}

-(void)testchangePasswordFailedEmptySDKUsername
{
    NSError *error;
    [OPGSDK initializeWithUserName:Empty_String withSDKKey:SharedKeySuccess];
    [OPGSDK setUniqueId:UniqueIdSuccess];
    OPGChangePassword *obj = [self.sdk changePassword:CurrPasswordFailed newPassword:NewPassword error:&error];
    XCTAssertFalse([obj.isSuccess intValue] == 1 || [error description] == nil);
}

-(void)testchangePasswordFailedEmptySDKKey
{
    NSError *error;
    [OPGSDK initializeWithUserName:UserNameSuccess withSDKKey:Empty_String];
    [OPGSDK setUniqueId:UniqueIdSuccess];
    OPGChangePassword *obj = [self.sdk changePassword:CurrPasswordFailed newPassword:NewPassword error:&error];
    XCTAssertFalse([obj.isSuccess intValue] == 1 || [error description] == nil);
}

@end
