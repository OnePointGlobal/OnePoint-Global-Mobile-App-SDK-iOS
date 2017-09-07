//
//  CategoryStyleTypes.h
//  OnePoint.Runtime
//
//  Created by ChinthanMac on 3/3/15.
//  Copyright (c) 2015 OnePointGlobal. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum
{
    csSingle = 0,
    csMulti = 1,
    csExclusive = 2,
    csList = 3,
} CategoryStyleTypesEnum;


@protocol CategoryStyleTypes
-(CategoryStyleTypesEnum)getEnum:(NSString *)value;
@end

@interface CategoryStyleTypes :NSObject<CategoryStyleTypes>{
    CategoryStyleTypesEnum enumValue;
}

@property(nonatomic,assign) CategoryStyleTypesEnum enumValue;


-(CategoryStyleTypesEnum)getEnum;
-(void)setEnum:(NSString *)value;
-(CategoryStyleTypesEnum)getEnum:(NSString *)value;


@end
