//
//  OPGCountry.m
//  OnePointSDK
//
//  Created by OnePoint Global on 02/11/16.
//  Copyright © 2016 OnePointGlobal. All rights reserved.
//

#import "OPGCountry.h"

@implementation OPGCountry
@synthesize countryID, countryCode, creditRate, name, isDeleted,std, gmt;

-(NSString *)description{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    if (countryID !=nil) {
        [dict setObject:countryID forKey:@"countryID"];
    }
    else{
        [dict setObject:@"" forKey:@"countryID"];
    }
    if (name !=nil) {
        [dict setObject:name forKey:@"name"];
    }
    else{
        [dict setObject:@"" forKey:@"name"];
    }
    if (countryCode !=nil) {
        [dict setObject:countryCode forKey:@"countryCode"];
    }
    else{
        [dict setObject:@"" forKey:@"countryCode"];
    }
    if (std !=nil) {
        [dict setObject:std forKey:@"std"];
    }
    else{
        [dict setObject:@"" forKey:@"std"];
    }
    if (gmt !=nil) {
        [dict setObject:gmt forKey:@"gmt"];
    }
    else{
        [dict setObject:@"" forKey:@"gmt"];
    }
    if (creditRate !=nil) {
        [dict setObject:creditRate forKey:@"creditRate"];
    }
    else{
        [dict setObject:@"" forKey:@"creditRate"];
    }
    if (isDeleted !=nil) {
        [dict setObject:isDeleted forKey:@"isDeleted"];
    }
    else{
        [dict setObject:@"" forKey:@"isDeleted"];
    }
    return [dict description];
}

-(void)encodeWithCoder:(NSCoder *)encoder {
    //Encode properties, other class variables, etc
    [encoder encodeObject:self.countryID forKey:@"countryID"];
    [encoder encodeObject:self.countryCode forKey:@"countryCode"];
    [encoder encodeObject:self.creditRate forKey:@"creditRate"];
    [encoder encodeObject:self.name forKey:@"name"];
    [encoder encodeObject:self.isDeleted forKey:@"isDeleted"];
    [encoder encodeObject:self.std forKey:@"std"];
    [encoder encodeObject:self.gmt forKey:@"gmt"];
}

-(id)initWithCoder:(NSCoder *)decoder {
    if((self = [super init])) {
        //decode properties, other class vars
        self.countryID = [decoder decodeObjectForKey:@"countryID"];
        self.countryCode = [decoder decodeObjectForKey:@"countryCode"];
        self.creditRate = [decoder decodeObjectForKey:@"creditRate"];
        self.name = [decoder decodeObjectForKey:@"name"];
        self.isDeleted = [decoder decodeObjectForKey:@"isDeleted"];
        self.std = [decoder decodeObjectForKey:@"std"];
        self.gmt = [decoder decodeObjectForKey:@"gmt"];

    }
    return self;
}

@end
