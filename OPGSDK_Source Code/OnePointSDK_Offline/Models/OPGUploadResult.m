//
//  OPGUploadResult.m
//  OnePointSDK
//
//  Created by OnePoint Global on 17/01/17.
//  Copyright © 2017 OnePointGlobal. All rights reserved.
//

#import "OPGUploadResult.h"

@implementation OPGUploadResult
@synthesize isSuccess, statusMessage;

-(NSString *)description{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    if (statusMessage !=nil) {
        [dict setObject:statusMessage forKey:@"Status"];
    }
    else{
        [dict setObject:@"" forKey:@"Status"];
    }
    if (isSuccess !=nil) {
        [dict setObject:isSuccess forKey:@"isSuccess"];
    }
    else{
        [dict setObject:@"" forKey:@"isSuccess"];
        
    }
    return [dict description];
}

-(void)encodeWithCoder:(NSCoder *)encoder {
    //Encode properties, other class variables, etc
    [encoder encodeObject:self.statusMessage forKey:@"statusMessage"];
    [encoder encodeObject:self.isSuccess forKey:@"isSuccess"];
}

-(id)initWithCoder:(NSCoder *)decoder {
    if((self = [super init])) {
        //decode properties, other class vars
        self.statusMessage = [decoder decodeObjectForKey:@"statusMessage"];
        self.isSuccess = [decoder decodeObjectForKey:@"isSuccess"];
    }
    return self;
}
@end
