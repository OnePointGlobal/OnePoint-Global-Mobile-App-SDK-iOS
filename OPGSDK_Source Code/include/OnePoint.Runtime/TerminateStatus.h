//
//  TerminateStatus.h
//  OnePoint.Runtime
//
//  Created by ChinthanMac on 11/28/14.
//  Copyright (c) 2014 OnePointGlobal. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum{
    tsCompleted = 0,
    tsScriptStopped = 1,
    
} TerminateStatusEnm;

@protocol TerminateStatus
-(TerminateStatusEnm)getEnum:(NSString *)value;
@end

@interface TerminateStatus :NSObject<TerminateStatus>{
    TerminateStatusEnm enumValue;
}

@property(nonatomic,assign) TerminateStatusEnm enumValue;


-(TerminateStatusEnm)getEnum;
-(void)setEnum:(NSString *)value;
-(TerminateStatusEnm)getEnum:(NSString *)value;

@end

