//
//  AuthenticationTests.m
//  OnePointSDK
//
//  Created by OnePoint Global on 23/08/16.
//  Copyright © 2016 OnePointGlobal. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "OPGSDK.h"
#import "TestConstants.h"
@interface AuthenticationTests : XCTestCase
@property (nonatomic) OPGSDK *sdk;
@end

@implementation AuthenticationTests

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

-(void)testAuthenticateSuccess
{
    NSError *error;
    [OPGSDK initializeWithUserName:UserNameSuccess withSDKKey:SharedKeySuccess];
    [OPGSDK setAppVersion:AppVersionSuccess];
    OPGAuthenticate *obj = [self.sdk authenticate:AuthUserNameSuccess password:AuthPasswordSuccess error:&error];
    XCTAssertTrue([obj.isSuccess intValue] == 1 && [error description] == nil);
}

-(void)testAuthneticationGoogleSuccess
{
//    NSError *error;
//    [OPGSDK initializeWithUserName:UserNameSuccess withSDKKey:SharedKeySuccess];
//    [OPGSDK setAppVersion:AppVersionSuccess];
//    OPGAuthenticate *obj = [self.sdk authenticateWithGoogle:googleTokenSuccess error:&error];
//    XCTAssertTrue([obj.isSuccess intValue] == 1);
}

-(void)testFacebookAuthenticationSuccess
{
    NSError *error;
    [OPGSDK initializeWithUserName:UserNameSuccess withSDKKey:SharedKeySuccess];
    [OPGSDK setAppVersion:AppVersionSuccess];
    OPGAuthenticate *obj = [self.sdk authenticateWithFacebook:facebookTokenSuccess error:&error];
    XCTAssertTrue([obj.isSuccess intValue] == 1);
}

-(void)testAuthneticationGoogleWrongToken
{
    NSError *error;
    [OPGSDK initializeWithUserName:@"m.ramesh" withSDKKey:@""];
    [OPGSDK setAppVersion:AppVersionSuccess];
    NSString *token = @"-";
    OPGAuthenticate *obj = [self.sdk authenticateWithGoogle:token error:&error];
    XCTAssertTrue([obj.isSuccess intValue] == 0);
}

-(void)testAuthneticationGoogleNoToken
{
    NSError *error;
    [OPGSDK initializeWithUserName:@"" withSDKKey:@""];
    [OPGSDK setAppVersion:AppVersionSuccess];
    OPGAuthenticate *obj = [self.sdk authenticateWithGoogle:@"" error:&error];
    XCTAssertTrue([obj.isSuccess intValue] == 0);
}

-(void)testFacebookAuthenticationWrongToken
{
    NSError *error;
    [OPGSDK initializeWithUserName:@"" withSDKKey:@""];
    [OPGSDK setAppVersion:AppVersionSuccess];
    NSString *token = @"";
    OPGAuthenticate *obj = [self.sdk authenticateWithFacebook:token error:&error];
    XCTAssertTrue([obj.isSuccess intValue] == 0);
}

-(void)testFacebookAuthenticationNoToken
{
    NSError *error;
    [OPGSDK initializeWithUserName:@"" withSDKKey:@""];
    [OPGSDK setAppVersion:AppVersionSuccess];
    OPGAuthenticate *obj = [self.sdk authenticateWithFacebook:@"" error:&error];
    XCTAssertTrue([obj.isSuccess intValue] == 0);
}

-(void)testAuthenticateFailedWithEmptySDKKey
{
    NSError *error;
    [OPGSDK initializeWithUserName:UserNameSuccess withSDKKey:Empty_String];
    [OPGSDK setAppVersion:AppVersionSuccess];
    OPGAuthenticate *obj = [self.sdk authenticate:AuthUserNameSuccess password:AuthPasswordFailed error:&error];
    XCTAssertTrue([obj.isSuccess intValue] == 0);
}

-(void)testAuthenticateFailedWithEmptySDKUsername
{
    NSError *error;
    [OPGSDK initializeWithUserName:Empty_String withSDKKey:SharedKeySuccess];
    [OPGSDK setAppVersion:AppVersionSuccess];
    OPGAuthenticate *obj = [self.sdk authenticate:AuthUserNameSuccess password:AuthPasswordFailed error:&error];
    XCTAssertTrue([obj.isSuccess intValue] == 0);
}

-(void)testAuthenticateFailedWithWrongPassword
{
    NSError *error;
    [OPGSDK initializeWithUserName:UserNameSuccess withSDKKey:SharedKeySuccess];
    [OPGSDK setAppVersion:AppVersionSuccess];
    OPGAuthenticate *obj = [self.sdk authenticate:AuthUserNameSuccess password:AuthPasswordFailed error:&error];
    XCTAssertTrue([obj.isSuccess intValue] == 0);
    XCTAssertEqualObjects(obj.statusMessage, @"username and/or password are invalid");
    XCTAssertEqualObjects(obj.httpStatusCode, [NSNumber numberWithInt:406]);

}

-(void)testAuthenticateFailedWithNoAppVersion
{
    NSError *error;
    [OPGSDK initializeWithUserName:UserNameSuccess withSDKKey:SharedKeySuccess];
    [OPGSDK setAppVersion:Empty_String];
    OPGAuthenticate *obj = [self.sdk authenticate:AuthUserNameSuccess password:AuthPasswordFailed error:&error];
    XCTAssertTrue([obj.isSuccess intValue] == 0 && [error description] != nil);
}

@end
