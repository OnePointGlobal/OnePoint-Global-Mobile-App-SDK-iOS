//
//  OPGPanelistProfile.m
//  OnePointSDK
//
//  Created by OnePoint Global on 02/08/16.
//  Copyright © 2016 OnePointGlobal. All rights reserved.
//

#import "OPGPanelistProfile.h"

@implementation OPGPanelistProfile
@synthesize title, firstName,lastName,email,mobileNumber,address1,address2,DOB,gender,postalCode;

-(NSString *)description{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:title forKey:@"title"];
    [dict setObject:firstName forKey:@"firstName"];
    [dict setObject:lastName forKey:@"lastName"];
    [dict setObject:email forKey:@"email"];
    [dict setObject:mobileNumber forKey:@"mobileNumber"];
    [dict setObject:address1 forKey:@"address1"];
    [dict setObject:address2 forKey:@"address2"];
    [dict setObject:DOB forKey:@"DOB"];
    [dict setObject:gender forKey:@"gender"];
    [dict setObject:postalCode forKey:@"postalCode"];
    
    return [dict description];
}

@end
