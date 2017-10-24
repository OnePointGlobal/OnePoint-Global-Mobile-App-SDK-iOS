//
//  OPGPanelPanellist.m
//  OnePointSDK
//
//  Created by OnePoint Global on 04/08/16.
//  Copyright © 2016 OnePointGlobal. All rights reserved.
//

#import "OPGPanelPanellist.h"

@implementation OPGPanelPanellist
@synthesize panelID,panellistID,panelPanellistID,createdDate,lastUpdatedDate,isDeleted, included,includedSpecified;

-(NSString *)description{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    if (panelID !=nil) {
        [dict setObject:panelID forKey:@"panelID"];
    }
    else{
        [dict setObject:@"" forKey:@"panelID"];
    }
    if (panellistID !=nil) {
        [dict setObject:panellistID forKey:@"panellistID"];
    }
    else{
        [dict setObject:@"" forKey:@"panellistID"];
    }
    if (panelPanellistID !=nil) {
        [dict setObject:panelPanellistID forKey:@"panelPanellistID"];
    }
    else{
        [dict setObject:@"" forKey:@"panelPanellistID"];
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
    if (included !=nil) {
        [dict setObject:included forKey:@"included"];
    }
    else{
        [dict setObject:@"" forKey:@"included"];
    }
    if (includedSpecified !=nil) {
        [dict setObject:includedSpecified forKey:@"includedSpecified"];
    }
    else{
        [dict setObject:@"" forKey:@"includedSpecified"];
    }
    return [dict description];
}

-(void)encodeWithCoder:(NSCoder *)encoder {
    //Encode properties, other class variables, etc
    [encoder encodeObject:self.panelID forKey:@"panelID"];
    [encoder encodeObject:self.panellistID forKey:@"panellistID"];
    [encoder encodeObject:self.panelPanellistID forKey:@"panelPanellistID"];
    [encoder encodeObject:self.createdDate forKey:@"createdDate"];
    [encoder encodeObject:self.lastUpdatedDate forKey:@"lastUpdatedDate"];
    [encoder encodeObject:self.isDeleted forKey:@"isDeleted"];
    [encoder encodeObject:self.included forKey:@"included"];
    [encoder encodeObject:self.includedSpecified forKey:@"includedSpecified"];
}

-(id)initWithCoder:(NSCoder *)decoder {
    if((self = [super init])) {
        //decode properties, other class vars
        self.panelID = [decoder decodeObjectForKey:@"panelID"];
        self.panellistID = [decoder decodeObjectForKey:@"panellistID"];
        self.panelPanellistID = [decoder decodeObjectForKey:@"panelPanellistID"];
        self.createdDate = [decoder decodeObjectForKey:@"createdDate"];
        self.lastUpdatedDate = [decoder decodeObjectForKey:@"lastUpdatedDate"];
        self.isDeleted = [decoder decodeObjectForKey:@"isDeleted"];
        self.included = [decoder decodeObjectForKey:@"included"];
        self.includedSpecified = [decoder decodeObjectForKey:@"includedSpecified"];
    }
    return self;
}
@end
