//
//  OPGScript.m
//  OnePointSDK
//
//  Created by OnePoint Global on 01/08/16.
//  Copyright © 2016 OnePointGlobal. All rights reserved.
//

#import "OPGScript.h"

@implementation OPGScript
@synthesize surveyReference,scriptFilePath,isSuccess,statusMessage;

-(NSString *)description{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    
    if (surveyReference !=nil) {
        [dict setObject:surveyReference forKey:@"surveyReference"];
    }
    else{
        [dict setObject:@"" forKey:@"surveyReference"];
        
    }
    if (scriptFilePath !=nil) {
        [dict setObject:scriptFilePath forKey:@"scriptFilePath"];
    }
    else{
        [dict setObject:@"" forKey:@"scriptFilePath"];
        
    }
    if (statusMessage !=nil) {
        [dict setObject:statusMessage forKey:@"statusMessage"];
    }
    else{
        [dict setObject:@"" forKey:@"statusMessage"];
        
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
    [encoder encodeObject:self.surveyReference forKey:@"surveyReference"];
    [encoder encodeObject:self.scriptFilePath forKey:@"scriptFilePath"];
}

-(id)initWithCoder:(NSCoder *)decoder {
    if((self = [super init])) {
        //decode properties, other class vars
        self.statusMessage = [decoder decodeObjectForKey:@"statusMessage"];
        self.isSuccess = [decoder decodeObjectForKey:@"isSuccess"];
        self.surveyReference = [decoder decodeObjectForKey:@"surveyReference"];
        self.scriptFilePath = [decoder decodeObjectForKey:@"scriptFilePath"];
    }
    return self;
}
@end
