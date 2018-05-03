//
//  OPGRuntimePlugin.h
//  OnePointSDK
//
//  Created by OnePoint Global on 30/08/16.
//  Copyright © 2016 OnePointGlobal. All rights reserved.
//

#import "RootPlugin.h"


#import <OnePoint.Runtime/InterviewSession.h>
#import <OnePoint.Runtime/IosRuntimeInteractor.h>
#import <OnePoint.Runtime/WebPlayer.h>
#import <OnePoint.Runtime/Controller.h>
#import <OnePoint.Runtime/WebSession.h>

@interface OPGRuntimePlugin : RootPlugin<IosRuntimeInteractor>
{
    
    NSMutableDictionary *callInfo;
    NSString *actionName;
    BOOL callBack;
    BOOL terminatePage;
    NSString *callBackID;
    BOOL NoSurvey;

    
}
+(void)setWebPlayer:(WebPlayer *)webPlayer;
+(void)setInterviewSession:(InterviewSession *)inetrviewSession;
+(void)setController:(Controller *)controller;

@end
