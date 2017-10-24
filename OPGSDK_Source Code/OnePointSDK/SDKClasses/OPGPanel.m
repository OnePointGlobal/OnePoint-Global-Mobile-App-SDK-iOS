//
//  OPGPanel.m
//  OnePointSDK
//
//  Created by OnePoint Global on 04/08/16.
//  Copyright © 2016 OnePointGlobal. All rights reserved.
//

#import "OPGPanel.h"

@implementation OPGPanel
@synthesize panelID,themeTemplateID,themeTemplateIDSpecified,panelName,panelDescription,panelType,searchTag,remark,isDeleted,createdDate,lastUpdatedDate,userID, mediaUrl, logoUrl, mediaID, logoID, mediaIDSpecified;

-(NSString *)description
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    if (panelID !=nil) {
        [dict setObject:panelID forKey:@"panelID"];
    }
    else{
        [dict setObject:@"" forKey:@"panelID"];
    }
    if (themeTemplateID !=nil) {
        [dict setObject:themeTemplateID forKey:@"themeTemplateID"];
    }
    else{
        [dict setObject:@"" forKey:@"themeTemplateID"];
    }
    if (themeTemplateIDSpecified !=nil) {
        [dict setObject:themeTemplateIDSpecified forKey:@"themeTemplateIDSpecified"];
    }
    else{
        [dict setObject:@"" forKey:@"themeTemplateIDSpecified"];
    }
    if (panelName !=nil) {
        [dict setObject:panelName forKey:@"panelName"];
    }
    else{
        [dict setObject:@"" forKey:@"panelName"];
    }
    if (panelDescription !=nil) {
        [dict setObject:panelDescription forKey:@"panelDescription"];
    }
    else{
        [dict setObject:@"" forKey:@"panelDescription"];
    }
    if (panelType !=nil) {
        [dict setObject:panelType forKey:@"panelType"];
    }
    else{
        [dict setObject:@"" forKey:@"panelType"];
    }
    if (searchTag !=nil) {
        [dict setObject:searchTag forKey:@"searchTag"];
    }
    else{
        [dict setObject:@"" forKey:@"searchTag"];
    }
    if (remark !=nil) {
        [dict setObject:remark forKey:@"remark"];
    }
    else{
        [dict setObject:@"" forKey:@"remark"];
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
    if (userID !=nil) {
        [dict setObject:userID forKey:@"userID"];
    }
    else{
        [dict setObject:@"" forKey:@"userID"];
    }
    if (mediaUrl !=nil) {
        [dict setObject:mediaUrl forKey:@"mediaUrl"];
    }
    else{
        [dict setObject:@"" forKey:@"mediaUrl"];
    }
    if (logoUrl !=nil) {
        [dict setObject:logoUrl forKey:@"logoUrl"];
    }
    else{
        [dict setObject:@"" forKey:@"logoUrl"];
    }

    if (mediaID !=nil) {
        [dict setObject:mediaID forKey:@"mediaID"];
    }
    else{
        [dict setObject:@"" forKey:@"mediaID"];
    }
    if (logoID !=nil) {
        [dict setObject:logoID forKey:@"logoID"];
    }
    else{
        [dict setObject:@"" forKey:@"logoID"];
    }

    if (mediaIDSpecified !=nil) {
        [dict setObject:mediaIDSpecified forKey:@"mediaIDSpecified"];
    }
    else
    {
        [dict setObject:@"" forKey:@"mediaIDSpecified"];
    }
   
    return [dict description];
}

-(void)encodeWithCoder:(NSCoder *)encoder {
    //Encode properties, other class variables, etc
    [encoder encodeObject:self.panelID forKey:@"panelID"];
    [encoder encodeObject:self.themeTemplateID forKey:@"themeTemplateID"];
    [encoder encodeObject:self.themeTemplateIDSpecified forKey:@"themeTemplateIDSpecified"];
    [encoder encodeObject:self.panelName forKey:@"panelName"];
    [encoder encodeObject:self.panelDescription forKey:@"panelDescription"];
    [encoder encodeObject:self.panelType forKey:@"panelType"];
    [encoder encodeObject:self.searchTag forKey:@"searchTag"];
    [encoder encodeObject:self.remark forKey:@"remark"];
    [encoder encodeObject:self.isDeleted forKey:@"isDeleted"];
    [encoder encodeObject:self.createdDate forKey:@"createdDate"];
    [encoder encodeObject:self.lastUpdatedDate forKey:@"lastUpdatedDate"];
    [encoder encodeObject:self.userID forKey:@"userID"];
    [encoder encodeObject:self.mediaUrl forKey:@"mediaUrl"];
    [encoder encodeObject:self.logoUrl forKey:@"logoUrl"];
    [encoder encodeObject:self.mediaID forKey:@"mediaID"];
    [encoder encodeObject:self.logoID forKey:@"logoID"];
    [encoder encodeObject:self.mediaIDSpecified forKey:@"mediaIDSpecified"];
}

-(id)initWithCoder:(NSCoder *)decoder {
    if((self = [super init])) {
        //decode properties, other class vars
        self.panelID = [decoder decodeObjectForKey:@"panelID"];
        self.themeTemplateID = [decoder decodeObjectForKey:@"themeTemplateID"];
        self.themeTemplateIDSpecified = [decoder decodeObjectForKey:@"themeTemplateIDSpecified"];
        self.panelName = [decoder decodeObjectForKey:@"panelName"];
        self.panelDescription = [decoder decodeObjectForKey:@"panelDescription"];
        self.panelType = [decoder decodeObjectForKey:@"panelType"];
        self.searchTag = [decoder decodeObjectForKey:@"searchTag"];
        self.remark = [decoder decodeObjectForKey:@"remark"];
        self.isDeleted = [decoder decodeObjectForKey:@"isDeleted"];
        self.createdDate = [decoder decodeObjectForKey:@"createdDate"];
        self.lastUpdatedDate = [decoder decodeObjectForKey:@"lastUpdatedDate"];
        self.userID = [decoder decodeObjectForKey:@"userID"];
        self.mediaUrl = [decoder decodeObjectForKey:@"mediaUrl"];
        self.logoUrl = [decoder decodeObjectForKey:@"logoUrl"];
        self.mediaID = [decoder decodeObjectForKey:@"mediaID"];
        self.logoID = [decoder decodeObjectForKey:@"logoID"];
        self.mediaIDSpecified = [decoder decodeObjectForKey:@"mediaIDSpecified"];
    }
    return self;
}

@end
