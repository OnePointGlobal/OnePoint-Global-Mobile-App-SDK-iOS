//
//  OPGParseResult.m
//  OnePointSDK
//
//  Created by OnePoint Global on 30/08/16.
//  Copyright © 2016 OnePointGlobal. All rights reserved.
//

#import "OPGParseResult.h"
#import "OPGReachability.h"
#import "NSObject+OPGSBJSON.h"
#import "NSString+OPGAESCrypt.h"
#import "PKMultipartInputStream.h"
#import "NSString+OPGMD5.h"
#import <UIKit/UIKit.h>
#import "OPGConstants.h"


@implementation OPGParseResult


-(void) populateErrorObject:(NSString*)errorMessage withError:(NSError **)errorDomain
{
    int errorCode = 4;
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    [userInfo setObject:errorMessage
                 forKey:NSLocalizedDescriptionKey];
    
    // Populate the error reference.
    *errorDomain = [[NSError alloc] initWithDomain:ErrorDomain
                                              code:errorCode
                                          userInfo:userInfo];
}

-(void)setInterviewUrl : (NSString*)interviewUrl
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:interviewUrl forKey:@"OPGInterviewUrl"];
}

-(void)setApiUrl : (NSString*)apiUrl
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:apiUrl forKey:@"OPGApiUrl"];
}

#pragma mark - Parse Methods
- (NSMutableArray*)parseSurveys:(NSArray*)responseList isLiteSDK:(BOOL)isLiteSDK error:(NSError **)error {
    NSMutableArray* _surveyList = [[NSMutableArray alloc] init];

    if(responseList == nil)
    {
        [self populateErrorObject:GenericError withError:error];  //Occurs when UniqueID or session ID is wrong
        return nil;
    }

    if ([responseList isKindOfClass:[NSDictionary class]])
    {
        [self populateErrorObject:[responseList valueForKey:@"ErrorMessage"] withError:error];  //Occurs when UniqueID or session ID is wrong
        return nil;
    }
    
    for (int i = 0; i < [responseList count]; i++) {
        OPGSurvey *survey = [OPGSurvey new];
        survey.surveyName = [[responseList objectAtIndex:i] valueForKey:@"Name"];
        
        if ([[[responseList objectAtIndex:i] valueForKey:@"SurveyReference"] isKindOfClass:[NSString class]]) {
            survey.surveyReference = [[responseList objectAtIndex:i] valueForKey:@"SurveyReference"];
        }
        else {
            survey.surveyReference = [[[responseList objectAtIndex:i] valueForKey:@"SurveyReference"] stringValue];
        }
        survey.surveyID = [[responseList objectAtIndex:i] valueForKey:@"SurveyID"];
        survey.surveyDescription = [[responseList objectAtIndex:i] valueForKey:@"Description"];


        NSString *startDateString = [[responseList objectAtIndex:i] valueForKey:@"StartDate"];                   //for scheduled surveys
        NSString *endDateString = [[responseList objectAtIndex:i] valueForKey:@"EndDate"];                       //for scheduled surveys
        //NSRange range = [startDateString rangeOfString:@"null" options:NSCaseInsensitiveSearch];
        survey.startDate = ([startDateString isKindOfClass:[NSNull class]]) ? @"" : startDateString;
        survey.endDate = ([endDateString isKindOfClass:[NSNull class]]) ? @"" : endDateString;
        survey.createdDate = [[responseList objectAtIndex:i] valueForKey:@"CreatedDate"];
        survey.lastUpdatedDate = [[responseList objectAtIndex:i] valueForKey:@"LastUpdatedDate"];
        survey.isGeoFencing = [[[responseList objectAtIndex:i] valueForKey:@"IsGeoFencing"] intValue] == 0 ? [NSNumber numberWithBool:NO] : [NSNumber numberWithBool:YES];
        survey.isOffline = [[[responseList objectAtIndex:i] valueForKey:@"IsOffline"] intValue] == 0 ? [NSNumber numberWithBool:NO] : [NSNumber numberWithBool:YES];
        survey.estimatedTime = [[responseList objectAtIndex:i] valueForKey:@"EstimatedTime"];
        survey.deadline = [[responseList objectAtIndex:i] valueForKey:@"DeadLine"];
        survey.status = @"New";                                 //hardcoded default status
        survey.isOfflineDownloaded = [NSNumber numberWithInt:0]; //hardcoded default value

        if (isLiteSDK) {
            // Add only online surveys for lite SDK
            if([survey.isOffline integerValue] == 0) {
                [_surveyList addObject:survey];
            }
        }
        else {
            // Add all surveys for full SDK
            [_surveyList addObject:survey];
        }
    }
    return _surveyList;
}

-(NSMutableArray *)parseMSGeoFencing:(NSArray *)responseList error:(NSError **)error {
    NSMutableArray* surveyList = [[NSMutableArray alloc] init];
    if ([responseList isKindOfClass:[NSArray class]])
    {
        if (responseList.count > 0) {
            for (NSDictionary* dict in responseList) {
                OPGGeofenceSurvey* geoFencing = [OPGGeofenceSurvey new];
                geoFencing.surveyName = [dict valueForKey:@"SurveyName"];
                geoFencing.surveyReference = [dict valueForKey:@"SurveyReference"];
                geoFencing.surveyID = [dict valueForKey:@"SurveyID"];
                geoFencing.address = [dict valueForKey:@"Address"];
                geoFencing.addressID = [dict valueForKey:@"AddressID"];
                geoFencing.latitude = [dict valueForKey:@"Latitude"];
                geoFencing.longitude = [dict valueForKey:@"Longitude"];
                geoFencing.geocode = [dict valueForKey:@"Geocode"];
                geoFencing.isDeleted = @1;//[dict valueForKey:@"IsDeleted"];
                geoFencing.distance = [dict valueForKey:@"Distance"];
                geoFencing.createdDate = [dict valueForKey:@"CreatedDate"];
                geoFencing.lastUpdatedDate = [dict valueForKey:@"LastUpdatedDate"];
                geoFencing.range = [dict valueForKey:@"Range"];

                geoFencing.isEnter = [[dict valueForKey:@"EnterEvent"] intValue] == 0 ? [NSNumber numberWithBool:NO] : [NSNumber numberWithBool:YES];
                geoFencing.isExit = [[dict valueForKey:@"ExitEvent"] intValue] == 0 ? [NSNumber numberWithBool:NO] : [NSNumber numberWithBool:YES];
                geoFencing.timeInterval = [dict valueForKey:@"EventTime"];
                [surveyList addObject:geoFencing];
            }
        }
    }
    else if ([responseList isKindOfClass:[NSDictionary class]]) {
        [self populateErrorObject:[responseList valueForKey:@"ErrorMessage"] withError:error];  //Occurs when UniqueID or session ID is wrong or there is no geofenced survey
    }
    else if (responseList == nil)
    {
        //NSLog(@"Something wrong. Check your internet connection");
        [self populateErrorObject:GenericError withError:error];
    }
    return surveyList;
}

- (OPGAuthenticate*) parseAuthenticationResult : (NSDictionary*) values
{
    OPGAuthenticate *opgAuthObject = [OPGAuthenticate new];
    if(values != nil)
    {
        if ([values objectForKey:@"ErrorMessage"]!= nil)
        {
            opgAuthObject.statusMessage= [values objectForKey:@"ErrorMessage"];
            opgAuthObject.isSuccess= [NSNumber numberWithBool:FALSE];
            opgAuthObject.httpStatusCode = [values objectForKey:@"HttpStatusCode"];
        }
        else
        {
            NSString *uniqueId = [values valueForKey:@"UniqueID"];
            if (uniqueId ==nil || [uniqueId isEqualToString:@""])
            {
                // DO nothing
            }
            else
            {
                NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
                [defaults setObject:uniqueId forKey:@"OPGUniqueID"];                // Set Unique ID to access other api.
            }
            opgAuthObject.statusMessage = @"Success";    //yet to be made vailable in api
            opgAuthObject.isSuccess= [NSNumber numberWithBool:TRUE];
            opgAuthObject.httpStatusCode = [NSNumber numberWithInt:200];        //hardcode status because we don't get httpStatusCode from api in success scenario
            if (![[values objectForKey:@"InterviewUrl" ] isEqualToString:@""])
            {
                [self setInterviewUrl:[values objectForKey:@"InterviewUrl"]];
            }
            if (![[values objectForKey:@"Url" ] isEqualToString:@""])
            {
                [self setApiUrl:[values objectForKey:@"Url"]];
            }
        }
    }
    else
    {
        opgAuthObject.statusMessage= GenericError;
        //HTTP 500 is Internal Server Error
        opgAuthObject.httpStatusCode = [NSNumber numberWithInt:500];        //hardcode http code because we don't get httpStatusCode when api result is nil
        opgAuthObject.isSuccess= [NSNumber numberWithBool:FALSE];
    }
    return opgAuthObject;
}

-(OPGScript*) parseAndDownloadScript : (NSDictionary*) scriptData forSurvey : (OPGSurvey*)survey error:(NSError **)error
{
    OPGScript *opgScript = [OPGScript new];
    if (scriptData==nil || [[[scriptData valueForKey:@"ScriptContent"] valueForKey:@"ByteCode"] isEqualToString:@""])
    {
        [self populateErrorObject:GenericError withError:error];
        opgScript.surveyReference=survey.surveyReference;
        opgScript.scriptFilePath = nil;
        opgScript.isSuccess=[NSNumber numberWithBool:FALSE];
        opgScript.statusMessage = GenericError;
        return opgScript;
    }
    else if([scriptData valueForKey:@"ErrorMessage"]!=nil)
    {
        opgScript.surveyReference=survey.surveyReference;
        opgScript.scriptFilePath = nil;
        opgScript.isSuccess=[NSNumber numberWithBool:FALSE];
        opgScript.statusMessage = [scriptData valueForKey:@"ErrorMessage"];
        return opgScript;
    }
    NSDictionary *scriptContent = [scriptData valueForKey:@"ScriptContent"];
    NSString *byteCode = [scriptContent valueForKey:@"ByteCode"];
    NSString *docPath= [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask,YES) lastObject];
    //Saving as surveyID.opgs in cache folder
    NSString *path = [docPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.opgs",survey.surveyID.stringValue]];
    NSData *opgsData = [[NSData alloc] initWithBase64EncodedString:byteCode options:0];
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:path];
    if (!fileExists) {
        [opgsData writeToFile:path atomically:NSDataWritingAtomic];
        opgScript.surveyReference=survey.surveyReference;
        opgScript.scriptFilePath = path;
        opgScript.isSuccess=[NSNumber numberWithBool:TRUE];
        opgScript.statusMessage = [NSString stringWithFormat:@"Download script for survey ID %@ successful",survey.surveyID.stringValue];
        return opgScript;
    }
    else
    {
        BOOL success = [[NSFileManager defaultManager] removeItemAtPath:path error:error];
        if (success) {
            [opgsData writeToFile:path atomically:NSDataWritingAtomic];
            opgScript.surveyReference=survey.surveyReference;
            opgScript.scriptFilePath = path;
            opgScript.isSuccess=[NSNumber numberWithBool:TRUE];
            opgScript.statusMessage = [NSString stringWithFormat:@"Download script for survey ID %@ successful",survey.surveyID.stringValue];
            return opgScript;
        }
        else
        {
            opgScript.surveyReference=survey.surveyReference;
            opgScript.scriptFilePath = path;
            opgScript.isSuccess=[NSNumber numberWithBool:FALSE];
            opgScript.statusMessage = [NSString stringWithFormat:@"Script for survey ID %@ already exists. Update failed.",survey.surveyID.stringValue];
            return opgScript;
        }
        
    }
}

-(OPGForgotPassword*) parseForgotPassword : (NSDictionary*)responseData
{
    OPGForgotPassword *passObj = [[OPGForgotPassword alloc]init];
    if (responseData!=nil) {
        if ([[responseData valueForKey:@"ErrorMessage"] isEqual:@""])
        {
            passObj.isSuccess =[NSNumber numberWithBool:TRUE];
            passObj.statusMessage = [responseData valueForKey:@"Message"];
            passObj.httpStatusCode = [responseData valueForKey:@"HttpStatusCode"];
            return passObj;
        }
        else
        {
            passObj.isSuccess =[NSNumber numberWithBool:FALSE];
            passObj.statusMessage = [responseData valueForKey:@"Message"];
            passObj.httpStatusCode = [responseData valueForKey:@"HttpStatusCode"];
            return passObj;
        }
    }
    else
    {
        passObj.isSuccess =[NSNumber numberWithBool:FALSE];
        passObj.statusMessage = GenericError;
        passObj.httpStatusCode = [NSNumber numberWithInt:500];        //hardcode http code because we don't get httpStatusCode when api result is nil
        return passObj;
    }
    
}

-(OPGChangePassword*) parseChangePassword : (NSDictionary*)responseData
{
    OPGChangePassword *passObj = [[OPGChangePassword alloc]init];
    if (responseData!=nil) {
        if ([[responseData valueForKey:@"ErrorMessage"] isEqual:@""])
        {
            passObj.isSuccess =[NSNumber numberWithBool:TRUE];
            passObj.statusMessage = [responseData valueForKey:@"Message"];
            passObj.httpStatusCode = [responseData valueForKey:@"HttpStatusCode"];
            return passObj;
        }
        else
        {
            passObj.isSuccess =[NSNumber numberWithBool:FALSE];
            passObj.statusMessage = [responseData valueForKey:@"Message"];
            passObj.httpStatusCode = [responseData valueForKey:@"HttpStatusCode"];
            return passObj;
        }
    }
    else
    {
        passObj.isSuccess =[NSNumber numberWithBool:FALSE];
        passObj.statusMessage = GenericError;
        passObj.httpStatusCode = [NSNumber numberWithInt:500];        //hardcode http code because we don't get httpStatusCode when api result is nil
        return passObj;
    }
    
}

-(OPGPanellistProfile*)parsePanelistProfile : (NSDictionary*)panelistProfile
{
    OPGPanellistProfile *profileObj = [OPGPanellistProfile new];
    if (([panelistProfile objectForKey:@"ErrorMessage"]!= nil) || panelistProfile == nil)
    {
        return nil;
    }

    OPGCountry *country = [OPGCountry new];
    profileObj.title = [panelistProfile valueForKey:@"Title"];
    profileObj.address1 = [panelistProfile valueForKey:@"Address1"];
    profileObj.address2 = [panelistProfile valueForKey:@"Address2"];
    profileObj.DOB = [panelistProfile valueForKey:@"DOB"];
    profileObj.email = [panelistProfile valueForKey:@"Email"];
    profileObj.mobileNumber = [panelistProfile valueForKey:@"MobileNumber"];
    profileObj.firstName = [panelistProfile valueForKey:@"FirstName"];
    profileObj.lastName = [panelistProfile valueForKey:@"LastName"];
    profileObj.gender = [[panelistProfile valueForKey:@"Gender"] intValue] == 0 ? [NSNumber numberWithBool:FALSE] : [NSNumber numberWithBool:TRUE];
    profileObj.postalCode = [panelistProfile valueForKey:@"PostalCode"];
    profileObj.mediaID = [panelistProfile valueForKey:@"MediaID"];
    profileObj.additionalParams = [panelistProfile valueForKey:@"Remark"];    // We get in Remarks from the API but showing as additional fields
    
    country = [self parseCountry:[panelistProfile valueForKey:@"Country"]];
    profileObj.countryName = country.name;
    profileObj.std = country.std;
    return profileObj;
}

-(OPGCountry*) parseCountry : (NSDictionary*) countryJson
{
    if ([countryJson isEqual:[NSNull null]])
    {
        OPGCountry *country = [OPGCountry new];
        country.countryID = @0;
        country.name = @"";
        country.countryCode = @"";
        country.std = @"";
        country.gmt = @"";
        country.creditRate = @0;
        country.isDeleted = @0;
        return country;
        
    }
    else
    {
        OPGCountry *country = [OPGCountry new];
        country.countryID = [countryJson valueForKey:@"CountryID"];
        country.name = [countryJson valueForKey:@"Name"];
        country.countryCode = [countryJson valueForKey:@"CountryCode"];
        country.std = [countryJson valueForKey:@"Std"];
        country.gmt = [countryJson valueForKey:@"Gmt"];
        country.creditRate = [countryJson valueForKey:@"CreditRate"];
        country.isDeleted = [countryJson valueForKey:@"IsDeleted"];
        return country;
    }
    
}
    
-(NSMutableArray*)parseListOfCountries:(NSArray*)responseList error:(NSError **)error
{
    NSMutableArray* countryList = [[NSMutableArray alloc] init];
    
    if ([responseList isKindOfClass:[NSDictionary class]])
    {
        [self populateErrorObject:[responseList valueForKey:@"ErrorMessage"] withError:error];                      //Occurs when UniqueID or session ID is wrong
        return nil;
    }
    
    for (int i = 0; i < [responseList count]; i++)
    {
        OPGCountry *country = [OPGCountry new];
        country = [self parseCountry:[responseList objectAtIndex:i]];
        [countryList addObject:country];
    }
    return countryList;
}

-(BOOL) parseUpdatePanelistProfile : (NSDictionary*)panelistProfile
{
    if ([[panelistProfile valueForKey:@"Message"] isEqualToString:@"Success"] || [[panelistProfile valueForKey:@"ErrorMessage"] isEqualToString:@""])
    {
        return TRUE;
    }
    return FALSE;
}

-(NSMutableArray*) parsePanelPanelist : (NSArray*) panelistPanels
{
    NSMutableArray *panelPanelistArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < [panelistPanels count]; i++)
    {
        OPGPanelPanellist *panelPanelist = [OPGPanelPanellist new];
        panelPanelist.panelPanellistID = [[panelistPanels objectAtIndex:i] valueForKey:@"PanelPanellistID"];
        panelPanelist.panelID = [[panelistPanels objectAtIndex:i] valueForKey:@"PanelID"];
        panelPanelist.panellistID = [[panelistPanels objectAtIndex:i] valueForKey:@"PanellistID"];
        panelPanelist.createdDate = [[panelistPanels objectAtIndex:i] valueForKey:@"CreatedDate"];
        panelPanelist.lastUpdatedDate = [[panelistPanels objectAtIndex:i] valueForKey:@"LastUpdatedDate"];
        panelPanelist.isDeleted = [[panelistPanels objectAtIndex:i] valueForKey:@"IsDeleted"];
        panelPanelist.included = [[panelistPanels objectAtIndex:i] valueForKey:@"Included"];
        panelPanelist.includedSpecified = [[panelistPanels objectAtIndex:i] valueForKey:@"IncludedSpecified"];
        [panelPanelistArray addObject:panelPanelist];
    }
    return panelPanelistArray;
}


-(NSMutableArray*)parsePanels:(NSArray*)panelArray
{
    NSMutableArray* panels = [[NSMutableArray alloc] init];
    for (int i = 0; i < [panelArray count]; i++)
    {
        OPGPanel *panel = [OPGPanel new];
        panel.panelID = [[panelArray objectAtIndex:i] valueForKey:@"PanelID"];
        panel.themeTemplateID = [[panelArray objectAtIndex:i] valueForKey:@"ThemeTemplateID"];
        panel.themeTemplateIDSpecified = [[panelArray objectAtIndex:i] valueForKey:@"ThemeTemplateIDSpecified"];
        panel.panelName = [[panelArray objectAtIndex:i] valueForKey:@"Name"];
        panel.panelDescription = [[panelArray objectAtIndex:i] valueForKey:@"Description"];
        panel.panelType = [[panelArray objectAtIndex:i] valueForKey:@"PanelType"];
        panel.searchTag = [[panelArray objectAtIndex:i] valueForKey:@"SearchTag"];
        panel.remark = [[panelArray objectAtIndex:i] valueForKey:@"Remark"];
        panel.isDeleted = [[panelArray objectAtIndex:i] valueForKey:@"IsDeleted"];
        panel.createdDate = [[panelArray objectAtIndex:i] valueForKey:@"CreatedDate"];
        panel.lastUpdatedDate = [[panelArray objectAtIndex:i] valueForKey:@"LastUpdatedDate"];
        panel.userID = [[panelArray objectAtIndex:i] valueForKey:@"UserID"];
        panel.mediaUrl = [[panelArray objectAtIndex:i] valueForKey:@"MediaUrl"];
        panel.logoUrl = [[panelArray objectAtIndex:i] valueForKey:@"LogoUrl"];
        panel.mediaIDSpecified = [[panelArray objectAtIndex:i] valueForKey:@"MediaIDSpecified"];
        if ([panel.mediaIDSpecified intValue] == 1)
        {
            panel.mediaID = [NSNumber numberWithLongLong:[[[panelArray objectAtIndex:i] valueForKey:@"MediaID"] longLongValue]];
            panel.logoID =  [NSNumber numberWithLongLong:[[[panelArray objectAtIndex:i] valueForKey:@"LogoID"] longLongValue]];
        }
        else
        {
            panel.mediaID = [NSNumber numberWithInt:0];
            panel.logoID =  [NSNumber numberWithInt:0];
        }

        [panels addObject:panel];
    }
    return panels;
}

-(NSMutableArray*) parseThemes : (NSArray*)themeArray
{
    NSMutableArray* themes = [[NSMutableArray alloc] init];
    for (int i = 0; i < [themeArray count]; i++)
    {
        OPGTheme *theme = [OPGTheme new];
        theme.themeID = [[themeArray objectAtIndex:i] valueForKey:@"ThemeID"];
        theme.themeTemplateID = [[themeArray objectAtIndex:i] valueForKey:@"ThemeTemplateID"];
        theme.themeElementTypeID = [[themeArray objectAtIndex:i] valueForKey:@"ThemeElementTypeID"];
        theme.themeName = [[themeArray objectAtIndex:i] valueForKey:@"Name"];
        theme.value = [[themeArray objectAtIndex:i] valueForKey:@"Value"];
        theme.mediaUrl = [[themeArray objectAtIndex:i] valueForKey:@"MediaUrl"];
        theme.isDeleted = [[themeArray objectAtIndex:i] valueForKey:@"IsDeleted"];
        theme.createdDate = [[themeArray objectAtIndex:i] valueForKey:@"CreatedDate"];
        theme.lastUpdatedDate = [[themeArray objectAtIndex:i] valueForKey:@"LastUpdatedDate"];
        [themes addObject:theme];
    }
    return themes;
}

-(NSMutableArray*) parseSurveyPanels : (NSArray*) surveyPanelArray
{
    NSMutableArray *surveyPanels = [[NSMutableArray alloc]init];
    for (int i=0; i< [surveyPanelArray count]; i++)
    {
        OPGSurveyPanel *surveyPanel = [OPGSurveyPanel new];
        surveyPanel.surveyPanelID = [[surveyPanelArray objectAtIndex:i] valueForKey:@"SurveyPanelID"];
        surveyPanel.surveyID = [[surveyPanelArray objectAtIndex:i] valueForKey:@"SurveyID"];
        surveyPanel.panelID = [[surveyPanelArray objectAtIndex:i] valueForKey:@"PanelID"];
        surveyPanel.excluded = [[surveyPanelArray objectAtIndex:i] valueForKey:@"Excluded"];
        surveyPanel.excludedSpecified = [[surveyPanelArray objectAtIndex:i] valueForKey:@"ExcludedSpecified"];
        surveyPanel.isDeleted = [[surveyPanelArray objectAtIndex:i] valueForKey:@"IsDeleted"];
        surveyPanel.createdDate = [[surveyPanelArray objectAtIndex:i] valueForKey:@"CreatedDate"];
        surveyPanel.lastUpdatedDate = [[surveyPanelArray objectAtIndex:i] valueForKey:@"LastUpdatedDate"];
        [surveyPanels addObject:surveyPanel];
    }
    return surveyPanels;
}

-(OPGPanellistPanel*) parsePanellistPanel : (NSDictionary*) panellistPanelResult
{
    OPGPanellistPanel *panellistPanelObj = [OPGPanellistPanel new];
    if (([panellistPanelResult objectForKey:@"ErrorMessage"]!= nil) || panellistPanelResult == nil)
    {
        panellistPanelObj.isSuccess=[NSNumber numberWithBool:FALSE];
        panellistPanelObj.statusMessage=[panellistPanelResult objectForKey:@"ErrorMessage"];
        panellistPanelObj.panelPanelistArray=nil;
        panellistPanelObj.panelsArray=nil;
        panellistPanelObj.themesArray=nil;
        panellistPanelObj.surveyPanelArray=nil;
        return panellistPanelObj;
    }
    
    NSArray *panelPanelistArrayList = [self parsePanelPanelist:[panellistPanelResult valueForKey:@"PanelPanellist"]];      //obtain PanelPanellist
    NSArray *panelsArrayList = [self parsePanels:[panellistPanelResult valueForKey:@"Panels"]];                             // Obtain Panels
    NSArray *themesArrayList;
    NSMutableArray *finalArray=[[NSMutableArray alloc]init];;

    NSInteger count = [[panellistPanelResult valueForKey:@"Themes"] count];

    if (count > 0)
    {
        for(int i=0; i < count ; i++)
        {
            themesArrayList = [self parseThemes:[[panellistPanelResult valueForKey:@"Themes"] objectAtIndex:i]];                  //Obtain Themes
            [finalArray addObjectsFromArray:themesArrayList];
        }
    }
    NSArray *surveyPanelArrayList = [self parseSurveyPanels:[panellistPanelResult valueForKey:@"SurveyPanel"]];            // Obtain Survey Panels
    
    
    panellistPanelObj.isSuccess=[NSNumber numberWithBool:TRUE];
    panellistPanelObj.statusMessage=@"Successful";
    panellistPanelObj.panelPanelistArray=panelPanelistArrayList;
    panellistPanelObj.panelsArray=panelsArrayList;
    panellistPanelObj.themesArray=finalArray;
    panellistPanelObj.surveyPanelArray=surveyPanelArrayList;
    return panellistPanelObj;

}

-(BOOL) parseNotificationResponse : (NSDictionary*) responseResult
{
    if ([[[responseResult valueForKey:@"Status"] stringValue] isEqualToString:@"1"])
    {
        return TRUE;
    }
    else
    {
        return FALSE;
    }
}


@end
