//
//  Attribute.h
//  TestRuntime
//
//  Created by chinthan on 10/12/13.
//  Copyright (c) 2013 OnePoint. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Attribute : NSObject{
@public
    short int __Index_;
    NSString *__Name_;

}

- (id)initWithNSString:(NSString *)name;
- (id)initWithShort:(short int)index;
- (short int)getIndex;
- (void)setIndexWithShort:(short int)value;
- (NSString *)getName;
- (void)setNameWithNSString:(NSString *)value;

@end
