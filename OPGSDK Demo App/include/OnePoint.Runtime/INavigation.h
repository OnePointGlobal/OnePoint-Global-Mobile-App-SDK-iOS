
//  Generated by the J2ObjC translator.  DO NOT EDIT!
//  source: /Users/ashchauhan/Desktop/SampleApp/OnePoint/Runtime/Common/IOM/INavigation.java
//
//  Created by ashchauhan on 6/20/14.
//

//#ifndef _INavigation_H_
//#define _INavigation_H_


//@protocol IStyle;






#import <Foundation/Foundation.h>

@protocol ISavePoints;
@protocol ILabel;
@protocol IStyle;
#import "NavigationTypes.h"

@protocol INavigation < NSObject>

- (id<IStyle>)getStyle;
- (id<ISavePoints>)getTargets;
- (void)setTargets:(id<ISavePoints>)value;
- (NavigationTypesEnum)getType;
- (id<ILabel>)getLabel;
- (void)setLabel:(id<ILabel>)value;

@end


