//
//  SurveyTests.m
//  OnePointSDK
//
//  Created by OnePoint Global on 23/08/16.
//  Copyright © 2016 OnePointGlobal. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "OPGSDK.h"
#import "TestConstants.h"

@interface SurveyTests : XCTestCase
@property (nonatomic) OPGSDK *sdk;
@end

@implementation SurveyTests

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

-(void)testGetSurveyListSucess{
    NSError *error;
     [OPGSDK initializeWithUserName:UserNameSuccess withSDKKey:SharedKeySuccess];
    OPGAuthenticate *obj = [self.sdk authenticate:AuthUserNameSuccess password:AuthPasswordSuccess error:&error];
    NSArray *surveyList = [self.sdk getUserSurveyList:&error];
    XCTAssertTrue([surveyList count] > 0 && [error description] == nil);
}

-(void)testGetSurveyListForPanelSucess{
    NSError *error;
    [OPGSDK initializeWithUserName:UserNameSuccess withSDKKey:SharedKeySuccess];
    OPGAuthenticate *obj = [self.sdk authenticate:AuthUserNameSuccess password:AuthPasswordSuccess error:&error];
    NSArray *surveyList = [self.sdk getUserSurveyListWithPanelID:CorrectPanelID error:&error];
    XCTAssertTrue([surveyList count] > 0 && [error description] == nil);
}

-(void)testGetSurveyListForEmptySDKKey{
    NSError *error;
    [OPGSDK initializeWithUserName:UserNameSuccess withSDKKey:Empty_String];
    OPGAuthenticate *obj = [self.sdk authenticate:AuthUserNameSuccess password:AuthPasswordSuccess error:&error];
    NSArray *surveyList = [self.sdk getUserSurveyListWithPanelID:IncorrectPanelID error:&error];
    XCTAssertTrue([surveyList count] == 0 && [error description] != nil);
}

-(void)testGetSurveyListForEmptySDKUsername{
    NSError *error;
    [OPGSDK initializeWithUserName:Empty_String withSDKKey:SharedKeySuccess];
    OPGAuthenticate *obj = [self.sdk authenticate:AuthUserNameSuccess password:AuthPasswordSuccess error:&error];
    NSArray *surveyList = [self.sdk getUserSurveyListWithPanelID:IncorrectPanelID error:&error];
    XCTAssertTrue([surveyList count] == 0 && [error description] != nil);
}

-(void)testGetSurveyListForWrongPanelFailed{
    NSError *error;
    [OPGSDK initializeWithUserName:UserNameSuccess withSDKKey:SharedKeySuccess];
    OPGAuthenticate *obj = [self.sdk authenticate:AuthUserNameSuccess password:AuthPasswordSuccess error:&error];
    NSArray *surveyList = [self.sdk getUserSurveyListWithPanelID:IncorrectPanelID error:&error];
    XCTAssertTrue([surveyList count] == 0 && [error description] != nil);
}

-(void)testGetSurveyListWrongSharedKeyFailed {
    NSError *error;
    [OPGSDK initializeWithUserName:UserNameSuccess withSDKKey:SharedKeyFailed];
    OPGAuthenticate *obj = [self.sdk authenticate:AuthUserNameSuccess password:AuthPasswordSuccess error:&error];
    NSArray *surveyList = [self.sdk getUserSurveyList:&error];
    XCTAssertFalse([error description] != nil && [surveyList count] > 0 );
}

-(void)testGetSurveyListFailedAuthentication {
    NSError *error;
    [OPGSDK initializeWithUserName:UserNameSuccess withSDKKey:SharedKeySuccess];
    OPGAuthenticate *obj = [self.sdk authenticate:AuthUserNameSuccess password:AuthPasswordFailed error:&error];
    NSArray *surveyList = [self.sdk getUserSurveyList:&error];
    XCTAssertTrue([error description] != nil && [surveyList count] == 0 );
}

@end
