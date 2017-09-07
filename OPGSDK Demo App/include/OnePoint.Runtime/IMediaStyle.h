//
//  IMediaStyle.h
//  TestRuntime
//
//  Created by Varahala Babu on 08/10/14.
//  Copyright (c) 2014 OnePoint. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "MediaTypes.h"

@protocol IMediaStyle < NSObject>
-(NSNumber *) getAccessGallery;

-(void) setAccessGallery:(NSNumber *)value  ;

-(NSNumber *) getAccessNew;

-(void)setAccessNew:(NSNumber *) value  ;

-(NSNumber *) getAllowPlayback;

-(void) setAllowPlayback:(NSNumber *) value  ;

-(NSNumber *) getAllowUpload;

-(void) setAllowUpload:(NSNumber *) value  ;
-(MediaTypes)getType;
-(void) setType:(MediaTypes)value  ;
@end