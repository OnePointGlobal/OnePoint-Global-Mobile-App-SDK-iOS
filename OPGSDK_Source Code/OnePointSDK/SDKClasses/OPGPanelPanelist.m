//
//  OPGPanelPanelist.m
//  OnePointSDK
//
//  Created by OnePoint Global on 04/08/16.
//  Copyright © 2016 OnePointGlobal. All rights reserved.
//

#import "OPGPanelPanelist.h"

@implementation OPGPanelPanelist
@synthesize panelID,panellistID,panelPanellistID,createdDate,lastUpdatedDate,isDeleted;

-(NSString *)description{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:panelID forKey:@"panelID"];
    [dict setObject:panellistID forKey:@"panellistID"];
    [dict setObject:panelPanellistID forKey:@"panelPanellistID"];
    [dict setObject:createdDate forKey:@"createdDate"];
    [dict setObject:lastUpdatedDate forKey:@"lastUpdatedDate"];
    [dict setObject:isDeleted forKey:@"isDeleted"];
    
    return [dict description];
}

@end
