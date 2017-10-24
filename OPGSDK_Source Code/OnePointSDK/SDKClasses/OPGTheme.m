//
//  OPGTheme.m
//  OnePointSDK
//
//  Created by OnePoint Global on 04/08/16.
//  Copyright © 2016 OnePointGlobal. All rights reserved.
//

#import "OPGTheme.h"

@implementation OPGTheme
@synthesize themeTemplateID,themeID,themeElementTypeID,themeName,value,isDeleted,createdDate,lastUpdatedDate, mediaUrl;

-(NSString *)description{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    if (themeTemplateID !=nil) {
        [dict setObject:themeTemplateID forKey:@"themeTemplateID"];
    }
    else{
        [dict setObject:@"" forKey:@"themeTemplateID"];
    }
    if (themeID !=nil) {
        [dict setObject:themeID forKey:@"themeID"];
    }
    else{
        [dict setObject:@"" forKey:@"themeID"];
    }
    if (themeElementTypeID !=nil) {
        [dict setObject:themeElementTypeID forKey:@"themeElementTypeID"];
    }
    else{
        [dict setObject:@"" forKey:@"themeElementTypeID"];
    }
    if (themeName !=nil) {
        [dict setObject:themeName forKey:@"themeName"];
    }
    else{
        [dict setObject:@"" forKey:@"themeName"];
    }
    if (value !=nil) {
        [dict setObject:value forKey:@"value"];
    }
    else{
        [dict setObject:@"" forKey:@"value"];
    }
    if (mediaUrl !=nil) {
        [dict setObject:mediaUrl forKey:@"mediaUrl"];
    }
    else{
        [dict setObject:@"" forKey:@"mediaUrl"];
    }
    if (createdDate !=nil) {
        [dict setObject:createdDate forKey:@"createdDate"];
    }
    else{
        [dict setObject:@"" forKey:@"createdDate"];
    }
    if (lastUpdatedDate !=nil) {
        [dict setObject:lastUpdatedDate forKey:@"lastUpdatedDate"];
    }
    else{
        [dict setObject:@"" forKey:@"lastUpdatedDate"];
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
    [encoder encodeObject:self.themeTemplateID forKey:@"themeTemplateID"];
    [encoder encodeObject:self.themeID forKey:@"themeID"];
    [encoder encodeObject:self.themeElementTypeID forKey:@"themeElementTypeID"];
    [encoder encodeObject:self.themeName forKey:@"themeName"];
    [encoder encodeObject:self.value forKey:@"value"];
    [encoder encodeObject:self.isDeleted forKey:@"isDeleted"];
    [encoder encodeObject:self.createdDate forKey:@"createdDate"];
    [encoder encodeObject:self.lastUpdatedDate forKey:@"lastUpdatedDate"];
    [encoder encodeObject:self.mediaUrl forKey:@"mediaUrl"];
}

-(id)initWithCoder:(NSCoder *)decoder {
    if((self = [super init])) {
        //decode properties, other class vars
        self.themeTemplateID = [decoder decodeObjectForKey:@"themeTemplateID"];
        self.themeID = [decoder decodeObjectForKey:@"themeID"];
        self.themeElementTypeID = [decoder decodeObjectForKey:@"themeElementTypeID"];
        self.themeName = [decoder decodeObjectForKey:@"themeName"];
        self.value = [decoder decodeObjectForKey:@"value"];
        self.isDeleted = [decoder decodeObjectForKey:@"isDeleted"];
        self.createdDate = [decoder decodeObjectForKey:@"createdDate"];
        self.lastUpdatedDate = [decoder decodeObjectForKey:@"lastUpdatedDate"];
        self.mediaUrl = [decoder decodeObjectForKey:@"mediaUrl"];
    }
    return self;
}
@end
