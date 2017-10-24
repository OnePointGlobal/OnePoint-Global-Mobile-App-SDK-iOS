//
//  HttpContext.h
//  OnePoint.Player
//
//  Created by Varahala Babu on 04/04/14.
//  Copyright (c) 2014 Onepoint Global. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSMutableURLRequest+Form.h"
#import "NSHTTPURLResponse+Write.h"
#import "IRequest.h"
#import "IResponse.h"

@interface HttpContext : NSObject
{
    id<IRequest> __request_;
    id<IResponse> __response_;
}
-(id)initWithRequest:(id<IRequest>)request withResponse:(id<IResponse>)response;
-(void)setRequest:(id<IRequest>)request;
-(id<IRequest>)getRequest;
-(void)setResponse:(id<IResponse>)response;
-(id<IResponse>)getResponse;
@end
