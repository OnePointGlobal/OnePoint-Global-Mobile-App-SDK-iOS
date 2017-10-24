//
//  OPGDownloadMedia.m
//  OnePointSDK
//
//  Created by OnePoint Global on 02/08/16.
//  Copyright © 2016 OnePointGlobal. All rights reserved.
//

#import "OPGDownloadMedia.h"

@implementation OPGDownloadMedia
@synthesize  mediaFilePath,isSuccess,statusMessage;
-(NSString *)description{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    if (mediaFilePath !=nil) {
        [dict setObject:mediaFilePath forKey:@"mediaFilePath"];
    }
    else{
        [dict setObject:@"" forKey:@"mediaFilePath"];
        
    }
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
    return [dict description];
}

-(void)encodeWithCoder:(NSCoder *)encoder {
    //Encode properties, other class variables, etc
    [encoder encodeObject:self.statusMessage forKey:@"statusMessage"];
    [encoder encodeObject:self.isSuccess forKey:@"isSuccess"];
    [encoder encodeObject:self.mediaFilePath forKey:@"mediaFilePath"];
}

-(id)initWithCoder:(NSCoder *)decoder {
    if((self = [super init])) {
        //decode properties, other class vars
        self.statusMessage = [decoder decodeObjectForKey:@"statusMessage"];
        self.isSuccess = [decoder decodeObjectForKey:@"isSuccess"];
        self.mediaFilePath = [decoder decodeObjectForKey:@"mediaFilePath"];
    }
    return self;
}
@end
