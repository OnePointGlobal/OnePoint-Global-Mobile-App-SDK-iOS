//
//  NSMutableURLRequest+Form.h
//  OnePoint.Player
//
//  Created by Varahala Babu on 26/03/14.
//  Copyright (c) 2014 Onepoint Global. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IRequest.h"
@interface NSMutableURLRequest (Form)<IRequest>
@property(nonatomic,retain)NSMutableDictionary *__keyValues;
-(NSDictionary*)form;
-(id)form:(NSString*)key;
-(NSString*)QueryString;
@end
