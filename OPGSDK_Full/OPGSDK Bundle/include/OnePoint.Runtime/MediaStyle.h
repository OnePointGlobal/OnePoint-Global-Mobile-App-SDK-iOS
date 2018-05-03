//
//  MediaStyle.h
//  TestRuntime
//
//  Created by Varahala Babu on 09/10/14.
//  Copyright (c) 2014 OnePoint. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IMediaStyle.h"
#import "MediaTypes.h"

@interface MediaStyle : NSObject<IMediaStyle>{
    NSNumber *__AccessGallery;
    NSNumber *__AccessNew;
    NSNumber *__AllowPlayback;
    NSNumber *__AllowUpload;
    MediaTypes __Type;
}
-(id)initWithJson:(id)json;
-(NSNumber *)getAccessGallery;
-(void)setAccessGallery:(NSNumber *)value;
-(NSNumber *)getAccessNew;
-(void)setAccessNew:(NSNumber *)value;
-(NSNumber *)getAllowPlayback;
-(void)setAllowPlayback:(NSNumber *)value;
-(NSNumber *)getAllowUpload;
-(void)setAllowUpload:(NSNumber *)value;
-(MediaTypes)getType;
-(void)setType:(MediaTypes)value;


@end
