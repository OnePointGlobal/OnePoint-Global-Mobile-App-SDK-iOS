//
//  GridStyleTypes.h
//  OnePoint.Runtime
//
//  Created by ChinthanMac on 3/3/15.
//  Copyright (c) 2015 OnePointGlobal. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    gsCell = 0,
    gsAltRow = 1,
    gsAltCol = 2,
    gsRowHeader = 3,
    gsColHeader = 4,
    gsAltRowHeader = 5,
    gsAltColHeader = 6,
} GridStyleTypesEnum;

@protocol GridStyleTypes
-(GridStyleTypesEnum)getEnum:(NSString *)value;
@end

@interface GridStyleTypes :NSObject<GridStyleTypes>{
    GridStyleTypesEnum enumValue;
}

@property(nonatomic,assign) GridStyleTypesEnum enumValue;


-(GridStyleTypesEnum)getEnum;
-(void)setEnum:(NSString *)value;
-(GridStyleTypesEnum)getEnum:(NSString *)value;
@end
