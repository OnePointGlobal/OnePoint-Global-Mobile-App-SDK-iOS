//
//  OPGPanellistPanel.m
//  OnePointSDK
//
//  Created by OnePoint Global on 17/10/16.
//  Copyright © 2016 OnePointGlobal. All rights reserved.
//

#import "OPGPanellistPanel.h"

@implementation OPGPanellistPanel
@synthesize panelsArray,surveyPanelArray,themesArray,panelPanelistArray,isSuccess,statusMessage;
-(NSString *)description{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
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
    if (panelPanelistArray !=nil) {
        [dict setObject:panelPanelistArray forKey:@"panelPanelistArray"];
    }
    else{
        [dict setObject:@"" forKey:@"panelPanelistArray"];
    }
    if (panelsArray !=nil) {
        [dict setObject:panelsArray forKey:@"panelsArray"];
    }
    else{
        [dict setObject:@"" forKey:@"panelsArray"];
    }
    if (themesArray !=nil) {
        [dict setObject:themesArray forKey:@"themesArray"];
    }
    else{
        [dict setObject:@"" forKey:@"themesArray"];
    }
    if (surveyPanelArray !=nil) {
        [dict setObject:surveyPanelArray forKey:@"surveyPanelArray"];
    }
    else{
        [dict setObject:@"" forKey:@"surveyPanelArray"];
    }

    return [dict description];
}

-(void)encodeWithCoder:(NSCoder *)encoder {
    //Encode properties, other class variables, etc
    [encoder encodeObject:self.panelsArray forKey:@"panelsArray"];
    [encoder encodeObject:self.surveyPanelArray forKey:@"surveyPanelArray"];
    [encoder encodeObject:self.themesArray forKey:@"themesArray"];
    [encoder encodeObject:self.panelPanelistArray forKey:@"panelPanelistArray"];
    [encoder encodeObject:self.statusMessage forKey:@"statusMessage"];
    [encoder encodeObject:self.isSuccess forKey:@"isSuccess"];
}

-(id)initWithCoder:(NSCoder *)decoder {
    if((self = [super init])) {
        //decode properties, other class vars
        self.panelsArray = [decoder decodeObjectForKey:@"panelsArray"];
        self.surveyPanelArray = [decoder decodeObjectForKey:@"surveyPanelArray"];
        self.themesArray = [decoder decodeObjectForKey:@"themesArray"];
        self.panelPanelistArray = [decoder decodeObjectForKey:@"panelPanelistArray"];
        self.statusMessage = [decoder decodeObjectForKey:@"statusMessage"];
        self.isSuccess = [decoder decodeObjectForKey:@"isSuccess"];
    }
    return self;
}
@end
