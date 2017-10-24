//
//  OPGRuntimePlugin.h
//  OnePointSDK
//
//  Created by OnePoint Global on 30/08/16.
//  Copyright © 2016 OnePointGlobal. All rights reserved.
//

#import "RootPlugin.h"


#import "InterviewSession.h"
#import "IosRuntimeInteractor.h"
#import "WebPlayer.h"
#import "Controller.h"
#import "WebSession.h"

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
