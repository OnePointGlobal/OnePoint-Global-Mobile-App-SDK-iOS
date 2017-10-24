//
//  OPGPanelistProfile.m
//  OnePointSDK
//
//  Created by OnePoint Global on 02/08/16.
//  Copyright © 2016 OnePointGlobal. All rights reserved.
//

#import "OPGPanellistProfile.h"

@implementation OPGPanellistProfile
@synthesize title, firstName,lastName,email,mobileNumber,address1,address2,DOB,gender,postalCode, mediaID, countryName, std;

-(NSString *)description{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    if (title !=nil) {
        [dict setObject:title forKey:@"title"];
    }
    else{
        [dict setObject:@"" forKey:@"title"];
        
    }
    if (firstName !=nil) {
        [dict setObject:firstName forKey:@"firstName"];
    }
    else{
        [dict setObject:@"" forKey:@"firstName"];
        
    }
    if (lastName !=nil) {
        [dict setObject:lastName forKey:@"lastName"];
    }
    else{
        [dict setObject:@"" forKey:@"lastName"];
        
    }
    if (email !=nil) {
        [dict setObject:email forKey:@"email"];
    }
    else{
        [dict setObject:@"" forKey:@"email"];
        
    }
    if (mobileNumber !=nil) {
        [dict setObject:mobileNumber forKey:@"mobileNumber"];
    }
    else{
        [dict setObject:@"" forKey:@"mobileNumber"];
        
    }

    if (address1 !=nil) {
        [dict setObject:address1 forKey:@"address1"];
    }
    else{
        [dict setObject:@"" forKey:@"address1"];
        
    }
    if (address2 !=nil) {
        [dict setObject:address2 forKey:@"address2"];
    }
    else{
        [dict setObject:@"" forKey:@"address2"];
        
    }
    if (DOB !=nil) {
        [dict setObject:DOB forKey:@"DOB"];
    }
    else{
        [dict setObject:@"" forKey:@"DOB"];
        
    }
    if (gender !=nil) {
        [dict setObject:gender forKey:@"gender"];
    }
    else{
        [dict setObject:@"" forKey:@"gender"];
        
    }
    if (postalCode !=nil) {
        [dict setObject:postalCode forKey:@"postalCode"];
    }
    else{
        [dict setObject:@"" forKey:@"postalCode"];
        
    }
    if (mediaID !=nil) {
        [dict setObject:mediaID forKey:@"mediaID"];
    }
    else{
        [dict setObject:@"" forKey:@"mediaID"];
        
    }
    if (countryName !=nil) {
        [dict setObject:countryName forKey:@"countryName"];
    }
    else{
        [dict setObject:@"" forKey:@"countryName"];
        
    }
    if (std !=nil) {
        [dict setObject:std forKey:@"std"];
    }
    else{
        [dict setObject:@"" forKey:@"std"];
        
    }
    return [dict description];
}

-(void)encodeWithCoder:(NSCoder *)encoder {
    //Encode properties, other class variables, etc
    [encoder encodeObject:self.title forKey:@"title"];
    [encoder encodeObject:self.firstName forKey:@"firstName"];
    [encoder encodeObject:self.lastName forKey:@"lastName"];
    [encoder encodeObject:self.email forKey:@"email"];
    [encoder encodeObject:self.mobileNumber forKey:@"mobileNumber"];
    [encoder encodeObject:self.address1 forKey:@"address1"];
    [encoder encodeObject:self.address2 forKey:@"address2"];
    [encoder encodeObject:self.DOB forKey:@"DOB"];
    [encoder encodeObject:self.gender forKey:@"gender"];
    [encoder encodeObject:self.postalCode forKey:@"postalCode"];
    [encoder encodeObject:self.mediaID forKey:@"mediaID"];
    [encoder encodeObject:self.countryName forKey:@"countryName"];
    [encoder encodeObject:self.std forKey:@"std"];
}

-(id)initWithCoder:(NSCoder *)decoder {
    if((self = [super init])) {
        //decode properties, other class vars
        self.title = [decoder decodeObjectForKey:@"title"];
        self.firstName = [decoder decodeObjectForKey:@"firstName"];
        self.lastName = [decoder decodeObjectForKey:@"lastName"];
        self.email = [decoder decodeObjectForKey:@"email"];
        self.mobileNumber = [decoder decodeObjectForKey:@"mobileNumber"];
        self.address1 = [decoder decodeObjectForKey:@"address1"];
        self.address2 = [decoder decodeObjectForKey:@"address2"];
        self.DOB = [decoder decodeObjectForKey:@"DOB"];
        self.gender = [decoder decodeObjectForKey:@"gender"];
        self.postalCode = [decoder decodeObjectForKey:@"postalCode"];
        self.mediaID = [decoder decodeObjectForKey:@"mediaID"];
        self.countryName = [decoder decodeObjectForKey:@"countryName"];
        self.std = [decoder decodeObjectForKey:@"std"];
    }
    return self;
}
@end
