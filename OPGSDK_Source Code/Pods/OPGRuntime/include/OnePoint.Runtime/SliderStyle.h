//
//  SliderStyles.h
//  TestRuntime
//
//  Created by Varahala Babu on 20/10/14.
//  Copyright (c) 2014 OnePoint. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ISliderStyle.h"
#import "SliderStyles.h"
@interface SliderStyle : NSObject<ISliderStyle>
{
    SliderStyles _type;
    NSString *_low;
    NSString *_high;
}
-(id)initWithJson:(id)json;
-(NSString*)getTypeAsString;
@end
