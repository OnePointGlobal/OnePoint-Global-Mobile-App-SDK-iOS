//
//  OPGGeofenceSurvey.m
//  OnePointSDK
//
//  Created by Manjunath on 14/06/17.
//  Copyright © 2017 OnePointGlobal. All rights reserved.
//

#import "OPGGeofenceSurvey.h"

@implementation OPGGeofenceSurvey
@synthesize surveyName,surveyID,surveyReference,createdDate,latitude,longitude,lastUpdatedDate,geocode,range,address,addressID,isDeleted,distance;

-(NSString *)description{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    if (surveyID !=nil) {
        [dict setObject:surveyID forKey:@"surveyID"];
    }
    else{
        [dict setObject:@"" forKey:@"surveyID"];
    }
    if (surveyName !=nil) {
        [dict setObject:surveyName forKey:@"surveyName"];
    }
    else{
        [dict setObject:@"" forKey:@"surveyName"];
    }
    if (surveyReference !=nil) {
        [dict setObject:surveyReference forKey:@"surveyReference"];
    }
    else{
        [dict setObject:@"" forKey:@"surveyReference"];
    }
    if (createdDate !=nil) {
        [dict setObject:createdDate forKey:@"createdDate"];
    }
    else{
        [dict setObject:@"" forKey:@"createdDate"];
    }
    if (latitude !=nil) {
        [dict setObject:latitude forKey:@"latitude"];
    }
    else{
        [dict setObject:@"" forKey:@"latitude"];
    }
    if (longitude !=nil) {
        [dict setObject:longitude forKey:@"longitude"];
    }
    else{
        [dict setObject:@"" forKey:@"longitude"];
    }
    if (lastUpdatedDate !=nil) {
        [dict setObject:lastUpdatedDate forKey:@"lastUpdatedDate"];
    }
    else{
        [dict setObject:@"" forKey:@"lastUpdatedDate"];
    }
    if (geocode !=nil) {
        [dict setObject:geocode forKey:@"geocode"];
    }
    else{
        [dict setObject:@"" forKey:@"geocode"];
    }
    if (range !=nil) {
        [dict setObject:range forKey:@"range"];
    }
    else{
        [dict setObject:@"" forKey:@"range"];
    }
    if (address !=nil) {
        [dict setObject:address forKey:@"address"];
    }
    else{
        [dict setObject:@"" forKey:@"address"];
    }
    if (addressID !=nil) {
        [dict setObject:addressID forKey:@"addressID"];
    }
    else{
        [dict setObject:@"" forKey:@"addressID"];
    }
    if (isDeleted !=nil) {
        [dict setObject:isDeleted forKey:@"isDeleted"];
    }
    else{
        [dict setObject:@"" forKey:@"isDeleted"];
    }
    if (distance !=nil) {
        [dict setObject:distance forKey:@"distance"];
    }
    else{
        [dict setObject:@"" forKey:@"distance"];
    }
    
    return [dict description];
}


- (void)encodeWithCoder:(NSCoder *)encoder {
    //Encode properties, other class variables, etc
    [encoder encodeObject:self.surveyID forKey:@"surveyID"];
    [encoder encodeObject:self.surveyReference forKey:@"surveyReference"];
    [encoder encodeObject:self.surveyName forKey:@"surveyName"];
    [encoder encodeObject:self.createdDate forKey:@"createdDate"];
    [encoder encodeObject:self.latitude forKey:@"latitude"];
    [encoder encodeObject:self.longitude forKey:@"longitude"];
    [encoder encodeObject:self.lastUpdatedDate forKey:@"lastUpdatedDate"];
    [encoder encodeObject:self.geocode forKey:@"geocode"];
    [encoder encodeObject:self.range forKey:@"range"];
    [encoder encodeObject:self.address forKey:@"address"];
    [encoder encodeObject:self.addressID forKey:@"addressID"];
    [encoder encodeObject:self.isDeleted forKey:@"isDeleted"];
    [encoder encodeObject:self.distance forKey:@"distance"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    if((self = [super init])) {
        //decode properties, other class vars
        self.surveyID = [decoder decodeObjectForKey:@"surveyID"];
        self.surveyReference = [decoder decodeObjectForKey:@"surveyReference"];
        self.surveyName = [decoder decodeObjectForKey:@"surveyName"];
        self.createdDate = [decoder decodeObjectForKey:@"createdDate"];
        self.latitude = [decoder decodeObjectForKey:@"latitude"];
        self.longitude = [decoder decodeObjectForKey:@"longitude"];
        self.lastUpdatedDate = [decoder decodeObjectForKey:@"lastUpdatedDate"];
        self.geocode = [decoder decodeObjectForKey:@"geocode"];
        self.range = [decoder decodeObjectForKey:@"range"];
        self.address = [decoder decodeObjectForKey:@"address"];
        self.addressID = [decoder decodeObjectForKey:@"addressID"];
        self.isDeleted = [decoder decodeObjectForKey:@"isDeleted"];
         self.distance = [decoder decodeObjectForKey:@"distance"];
    }
    return self;
}
@end
