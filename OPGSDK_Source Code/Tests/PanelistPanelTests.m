//
//  PanelistPanelTests.m
//  OnePointSDK
//
//  Created by OnePoint Global on 23/08/16.
//  Copyright © 2016 OnePointGlobal. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "OPGSDK.h"
#import "TestConstants.h"

@interface PanelistPanelTests : XCTestCase
@property (nonatomic) OPGSDK *sdk;
@end

@implementation PanelistPanelTests

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

-(void)testPanelistPanelApiSuccess
{
    NSError *error;
    [OPGSDK initializeWithUserName:UserNameSuccess withSDKKey:SharedKeySuccess];
    OPGAuthenticate *obj = [self.sdk authenticate:AuthUserNameSuccess password:AuthPasswordSuccess error:&error];
    OPGPanellistPanel *objPan = [self.sdk getPanellistPanel:&error];
    
    XCTAssertTrue([objPan.themesArray count] > 0 && [error description] == nil);
    XCTAssertTrue([objPan.panelsArray count] > 0 && [error description] == nil);
    XCTAssertTrue([objPan.panelPanelistArray count] > 0 && [error description] == nil);
    XCTAssertTrue([objPan.surveyPanelArray count] > 0 && [error description] == nil);
}

-(void)testPanelistPanelApiFailedWrongSDKUsername
{
    NSError *error;
    [OPGSDK initializeWithUserName:UserNameFailed withSDKKey:SharedKeySuccess];
    OPGAuthenticate *obj = [self.sdk authenticate:AuthUserNameSuccess password:AuthPasswordSuccess error:&error];
    OPGPanellistPanel *objPan = [self.sdk getPanellistPanel:&error];
    XCTAssertTrue([objPan.themesArray count] == 0 && [error description] != nil);
}

-(void)testPanelistPanelApiFailedWrongSharedKey
{
    NSError *error;
    [OPGSDK initializeWithUserName:UserNameSuccess withSDKKey:SharedKeyFailed];
    OPGAuthenticate *obj = [self.sdk authenticate:AuthUserNameSuccess password:AuthPasswordSuccess error:&error];
    OPGPanellistPanel *objPan = [self.sdk getPanellistPanel:&error];
    XCTAssertTrue([objPan.themesArray count] == 0 && [error description] != nil);
}

@end
