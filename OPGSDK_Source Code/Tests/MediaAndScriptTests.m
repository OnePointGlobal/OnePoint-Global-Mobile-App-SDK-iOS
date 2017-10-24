//
//  MediaAndScriptTests.m
//  OnePointSDK
//
//  Created by OnePoint Global on 23/08/16.
//  Copyright © 2016 OnePointGlobal. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "OPGSDK.h"
#import "TestConstants.h"
#import "OPGSurvey.h"
@interface MediaAndScriptTests : XCTestCase
@property (nonatomic) OPGSDK *sdk;
@end

@implementation MediaAndScriptTests

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

//-(void)testGetScriptSuccess
//{
//    NSError *error;
//    [OPGSDK initializeWithUserName:@"" withSDKKey:@""];
//    OPGSDK *sdk = [OPGSDK new];
//    OPGAuthenticate *AuthObj = [sdk authenticate:@"" password:@"" error:&error];
//    //[OPGSDK setUniqueId:UniqueIdSuccess];
//    OPGSurvey *survey = [OPGSurvey new];
//    survey.surveyID = [NSNumber numberWithInt:102392];
//    survey.surveyName = @"";
//    survey.surveyReference = @"";
//
//    OPGScript *obj = [sdk getScript:survey error:&error];
//    XCTAssertTrue([obj.isSuccess intValue] == 1 && [error description] == nil);
//}
//
//-(void)testGetScriptFailedWithWrongUniqueID
//{
//    NSError *error;
//    [OPGSDK initializeWithUserName:UserNameSuccess withSDKKey:SharedKeySuccess];
//    [OPGSDK setUniqueId:WrongUniqueId];
//    OPGSDK* sdk = [OPGSDK new];
//    OPGScript *obj = [sdk getScript:CorrectSurveyID error:&error];
//    XCTAssertTrue([obj.isSuccess intValue] == 0 || [error description] != nil);
//}
//
//-(void)testGetScriptFailedWrongSurveyID
//{
//    NSError *error;
//    [OPGSDK initializeWithUserName:UserNameSuccess withSDKKey:SharedKeySuccess];
//    [OPGSDK setUniqueId:UniqueIdSuccess];
//    OPGSDK* sdk = [OPGSDK new];
//    OPGScript *obj = [sdk getScript:IncorrectSurveyID error:&error];
//    XCTAssertFalse([obj.isSuccess intValue] == 1 && [error description] == nil);
//}
//
//-(void)testGetScriptFailedEmptySDKKey
//{
//    NSError *error;
//    [OPGSDK initializeWithUserName:UserNameSuccess withSDKKey:Empty_String];
//    //[OPGSDK setUniqueId:UniqueIdSuccess];
//    OPGSDK* sdk = [OPGSDK new];
//    OPGAuthenticate *authObj = [sdk authenticate:AuthUserNameSuccess password:AuthPasswordSuccess error:&error];
//    OPGScript *obj = [sdk getScript:CorrectSurveyID error:&error];
//    XCTAssertFalse([obj.isSuccess intValue] == 1 && [error description] == nil);
//}
//
//-(void)testGetScriptFailedEmptySDKUsername
//{
//    NSError *error;
//    [OPGSDK initializeWithUserName:Empty_String withSDKKey:SharedKeySuccess];
//    //[OPGSDK setUniqueId:UniqueIdSuccess];
//    OPGSDK* sdk = [OPGSDK new];
//    OPGAuthenticate *authObj = [sdk authenticate:AuthUserNameSuccess password:AuthPasswordSuccess error:&error];
//    OPGScript *obj = [sdk getScript:CorrectSurveyID error:&error];
//    XCTAssertFalse([obj.isSuccess intValue] == 1 && [error description] == nil);
//}
//
//-(void)testGetScriptFailedWrongSDKUsername
//{
//    NSError *error;
//    [OPGSDK initializeWithUserName:UserNameFailed withSDKKey:SharedKeySuccess];
//    //[OPGSDK setUniqueId:UniqueIdSuccess];
//    OPGSDK* sdk = [OPGSDK new];
//    OPGAuthenticate *authObj = [sdk authenticate:AuthUserNameSuccess password:AuthPasswordSuccess error:&error];
//    OPGScript *obj = [sdk getScript:CorrectSurveyID error:&error];
//    XCTAssertFalse([obj.isSuccess intValue] == 1 && [error description] == nil);
//}

-(void)testDownloadMediaSuccess
{
    NSError *error;
    [OPGSDK initializeWithUserName:UserNameSuccess withSDKKey:SharedKeySuccess];
    OPGAuthenticate *AuthObj = [self.sdk authenticate:AuthUserNameSuccess password:AuthPasswordSuccess error:&error];
    OPGDownloadMedia *obj = [self.sdk downloadMediaFile:CorrectMediaID mediaType:CorrectMediaType error:&error];
    XCTAssertTrue([obj.isSuccess intValue] == 1 && error==nil);
}

-(void)testDownloadMediaFailedWrongSharedKey
{
    NSError *error;
    [OPGSDK initializeWithUserName:UserNameSuccess withSDKKey:SharedKeyFailed];
    [OPGSDK setUniqueId:UniqueIdSuccess];
    OPGDownloadMedia *obj = [self.sdk downloadMediaFile:IncorrectMediaID mediaType:IncorrectMediaType error:&error];
    XCTAssertTrue([obj.isSuccess intValue] == 0 || [error description] != nil);
}

-(void)testDownloadMediaFailedNoUniqueID
{
    NSError *error;
    [OPGSDK initializeWithUserName:UserNameSuccess withSDKKey:SharedKeySuccess];
    [OPGSDK setUniqueId:Empty_String];
    OPGDownloadMedia *obj = [self.sdk downloadMediaFile:Empty_String mediaType:CorrectMediaType error:&error];
    XCTAssertTrue([obj.isSuccess intValue] == 0 && [error description] != nil);
}
@end
