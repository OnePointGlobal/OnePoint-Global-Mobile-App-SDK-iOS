//
//  VerticalAlignments.h
//  OnePoint.Runtime
//
//  Created by ChinthanMac on 3/3/15.
//  Copyright (c) 2015 OnePointGlobal. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    vaDefault = 0,
    vaBaseline = 1,
    vaMiddle = 2,
    vaSub = 3,
    vaSuper = 4,
    vaTextTop = 5,
    vaTextBottom = 6,
    vaTop = 7,
    vaBottom = 8,
} VerticalAlignmentsEnm;


@protocol VerticalAlignments
-(VerticalAlignmentsEnm)getEnum:(NSString *)value;
@end

@interface VerticalAlignments :NSObject<VerticalAlignments>{
    VerticalAlignmentsEnm enumValue;
}

@property(nonatomic,assign) VerticalAlignmentsEnm enumValue;


-(VerticalAlignmentsEnm)getEnum;
-(void)setEnum:(NSString *)value;
-(VerticalAlignmentsEnm)getEnum:(NSString *)value;
@end

