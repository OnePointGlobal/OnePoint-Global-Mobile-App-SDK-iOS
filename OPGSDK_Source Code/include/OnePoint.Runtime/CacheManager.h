//
//  CacheManager.h
//  OnePoint.Player
//
//  Created by Varahala Babu on 24/03/14.
//  Copyright (c) 2014 Onepoint Global. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CacheManager : NSMutableDictionary
{
    NSMutableDictionary *__cacheData_;
    id __key_;
}
-(id)initWithKey:(id)key;
-(void)add:(id)key Value:(id)value;
-(id)find:(id)key;
-(void)flush;
-(void)remove:(id)key;
@end
