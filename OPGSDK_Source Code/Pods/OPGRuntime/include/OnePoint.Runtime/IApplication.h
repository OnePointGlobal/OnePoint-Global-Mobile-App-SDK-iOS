//
//  IApplication.h
//  OnePoint.Player
//
//  Created by Varahala Babu on 21/03/14.
//  Copyright (c) 2014 Onepoint Global. All rights reserved.
//


#import <Foundation/Foundation.h>
@protocol IContext;
@class Interview;
@protocol IApplication <NSObject>

-(Interview*)getInterview;
-(Interview*)getContext;

@end
