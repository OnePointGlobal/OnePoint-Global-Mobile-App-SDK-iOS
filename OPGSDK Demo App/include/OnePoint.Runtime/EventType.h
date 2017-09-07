//
//  EventType.h
//  TestRuntime
//
//  Created by ChinthanMac on 9/24/14.
//  Copyright (c) 2014 OnePoint. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    EventType_OnInterviewStart = 0,
    EventType_OnInterviewEnd = 1,
    EventType_OnBeforeQuestionAsk = 2,
    EventType_OnAfterQuestionAsk = 3,
    EventType_OnBeforeQuestionValidation = 4,
} EnumEventType;


@interface EventType : NSObject
+(NSString*)EventTypeToString:(EnumEventType)formatType;

@end
