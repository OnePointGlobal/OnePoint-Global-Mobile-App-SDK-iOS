//
//  DataEncryption.h
//  OnePoint.Player
//
//  Created by Varahala Babu on 29/05/14.
//  Copyright (c) 2014 Onepoint Global. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSData+AESCrypt.h"
@interface DataEncryption : NSObject
+(NSString*)decrypt:(NSString*)data;
+(NSString*)encrypt:(NSString*)data;
+(NSString*)encrypt:(NSString*)data withNSString:(NSString*)iv;
@end
