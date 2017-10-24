//
//  OPGForgotPassword.m
//  OnePointSDK
//
//  Created by OnePoint Global on 01/08/16.
//  Copyright © 2016 OnePointGlobal. All rights reserved.
//

#import "OPGForgotPassword.h"

@implementation OPGForgotPassword
@synthesize isSuccess,statusMessage,httpStatusCode;
-(NSString *)description{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    if (isSuccess !=nil) {
        [dict setObject:isSuccess forKey:@"isSuccess"];
    }
    else{
        [dict setObject:@"" forKey:@"isSuccess"];
        
    }
    if (statusMessage !=nil) {
        [dict setObject:statusMessage forKey:@"statusMessage"];
    }
    else{
        [dict setObject:@"" forKey:@"statusMessage"];
        
    }
    if (httpStatusCode !=nil) {
        [dict setObject:httpStatusCode forKey:@"httpStatusCode"];
    }
    else{
        [dict setObject:@"" forKey:@"httpStatusCode"];
        
    }
    
    return [dict description];
}

-(void)encodeWithCoder:(NSCoder *)encoder {
    //Encode properties, other class variables, etc
    [encoder encodeObject:self.statusMessage forKey:@"statusMessage"];
    [encoder encodeObject:self.isSuccess forKey:@"isSuccess"];
    [encoder encodeObject:self.httpStatusCode forKey:@"httpStatusCode"];
}

-(id)initWithCoder:(NSCoder *)decoder {
    if((self = [super init])) {
        //decode properties, other class vars
        self.statusMessage = [decoder decodeObjectForKey:@"statusMessage"];
        self.isSuccess = [decoder decodeObjectForKey:@"isSuccess"];
        self.httpStatusCode = [decoder decodeObjectForKey:@"httpStatusCode"];
    }
    return self;
}
@end
