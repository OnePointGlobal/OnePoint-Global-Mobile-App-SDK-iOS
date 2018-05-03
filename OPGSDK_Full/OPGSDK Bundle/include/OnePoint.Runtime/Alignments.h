//
//  Alignments.h
//  OnePoint.Runtime
//
//  Created by ChinthanMac on 3/3/15.
//  Copyright (c) 2015 OnePointGlobal. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    alDefault = 0,
    alLeft = 1,
    alCenter = 2,
    alRight = 3,
    alJustify = 4,
}
AlignmentsEnm;

@protocol Alignments
-(AlignmentsEnm)getEnum:(NSString *)value;
@end

@interface Alignments :NSObject<Alignments>{
    AlignmentsEnm enumValue;
}

@property(nonatomic,assign) AlignmentsEnm enumValue;


-(AlignmentsEnm)getEnum;
-(void)setEnum:(NSString *)value;
-(AlignmentsEnm)getEnum:(NSString *)value;
-(NSString*)description;
@end
