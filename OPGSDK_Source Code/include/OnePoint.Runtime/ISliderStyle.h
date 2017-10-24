//
//  ISliderStyle.h
//  TestRuntime
//
//  Created by Varahala Babu on 20/10/14.
//  Copyright (c) 2014 OnePoint. All rights reserved.
//

#import "SliderStyles.h"
@protocol ISliderStyle < NSObject>

-(SliderStyles) getType;
-(void) setType:(SliderStyles) value ;
-(NSString*) getLow;
-(void) setLow:(NSString*) value  ;
-(NSString*)getHigh;
-(void) setHigh:(NSString*) value ;
-(NSString*)getTypeAsString;
@end