//
//  OPGSurveyPanel.m
//  OnePointSDK
//
//  Created by OnePoint Global on 04/08/16.
//  Copyright © 2016 OnePointGlobal. All rights reserved.
//

#import "OPGSurveyPanel.h"

@implementation OPGSurveyPanel
@synthesize surveyID,panelID,surveyPanelID,isDeleted,createdDate,lastUpdatedDate,excluded,excludedSpecified;

-(NSString *)description{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    if (surveyID !=nil) {
        [dict setObject:surveyID forKey:@"surveyID"];
    }
    else{
        [dict setObject:@"" forKey:@"surveyID"];
    }
    if (panelID !=nil) {
        [dict setObject:panelID forKey:@"panelID"];
    }
    else{
        [dict setObject:@"" forKey:@"panelID"];
    }
    if (surveyPanelID !=nil) {
        [dict setObject:surveyPanelID forKey:@"surveyPanelID"];
    }
    else{
        [dict setObject:@"" forKey:@"surveyPanelID"];
    }
    if (excluded !=nil) {
        [dict setObject:excluded forKey:@"excluded"];
    }
    else{
        [dict setObject:@"" forKey:@"excluded"];
    }
    if (excludedSpecified !=nil) {
        [dict setObject:excludedSpecified forKey:@"excludedSpecified"];
    }
    else{
        [dict setObject:@"" forKey:@"excludedSpecified"];
    }
    if (isDeleted !=nil) {
        [dict setObject:isDeleted forKey:@"isDeleted"];
    }
    else{
        [dict setObject:@"" forKey:@"isDeleted"];
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
    return [dict description];
}

-(void)encodeWithCoder:(NSCoder *)encoder {
    //Encode properties, other class variables, etc
    [encoder encodeObject:self.surveyID forKey:@"surveyID"];
    [encoder encodeObject:self.panelID forKey:@"panelID"];
    [encoder encodeObject:self.surveyPanelID forKey:@"surveyPanelID"];
    [encoder encodeObject:self.isDeleted forKey:@"isDeleted"];
    [encoder encodeObject:self.createdDate forKey:@"createdDate"];
    [encoder encodeObject:self.lastUpdatedDate forKey:@"lastUpdatedDate"];
    [encoder encodeObject:self.excluded forKey:@"excluded"];
    [encoder encodeObject:self.excludedSpecified forKey:@"excludedSpecified"];
}

-(id)initWithCoder:(NSCoder *)decoder {
    if((self = [super init])) {
        //decode properties, other class vars
        self.surveyID = [decoder decodeObjectForKey:@"surveyID"];
        self.panelID = [decoder decodeObjectForKey:@"panelID"];
        self.surveyPanelID = [decoder decodeObjectForKey:@"surveyPanelID"];
        self.isDeleted = [decoder decodeObjectForKey:@"isDeleted"];
        self.createdDate = [decoder decodeObjectForKey:@"createdDate"];
        self.lastUpdatedDate = [decoder decodeObjectForKey:@"lastUpdatedDate"];
        self.excluded = [decoder decodeObjectForKey:@"excluded"];
        self.excludedSpecified = [decoder decodeObjectForKey:@"excludedSpecified"];
    }
    return self;
}
@end
