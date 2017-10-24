//
//  OPGRuntimePlugin.m
//  OnePointSDK
//
//  Created by OnePoint Global on 30/08/16.
//  Copyright © 2016 OnePointGlobal. All rights reserved.
//

#import "OPGRuntimePlugin.h"


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@implementation OPGRuntimePlugin
static WebPlayer *player=nil;
static InterviewSession *session=nil;
static Controller *cont=nil;


+(void)setWebPlayer:(WebPlayer *)webPlayer{
    player = webPlayer;
}

+(void)setInterviewSession:(InterviewSession *)inetrviewSession{
    session = inetrviewSession;
}

+(void)setController:(Controller *)controller{
    cont = controller;
}

-(void)continueSurvey:(OPGInvokedUrlCommand*)command{
    
    @try {
        callBackID=command.callbackId;
        [[NSUserDefaults standardUserDefaults] setObject:@"true" forKey:@"OPGIsOfflineSurvey"];
        [self processRequest:[command.arguments objectAtIndex:0]];
    }
    @catch(NSException *exception) {
        [self errorCallBack:@" Error Occurred " withcallbackId:command.callbackId];
    }
    
}
-(void)processRequest:(NSString *)data {
  
    NSMutableDictionary *newDict = [[NSMutableDictionary alloc] init];
    [newDict setObject:[NSJSONSerialization JSONObjectWithData:[data dataUsingEncoding:NSUnicodeStringEncoding] options:0 error:nil] forKey:@"data"];
    [player setAppResponse:newDict];
    [player updateContext:[player getAppContext]];
    
    if ([session validate]) {
        if ([[session getHandler] getAction] == InterviewAction_Terminate) {
            
            [player updateUrl:FALSE];
            return;
        }
        else{
            
        }
    }
    [player updateUrl:TRUE];
    
  
}

@end
