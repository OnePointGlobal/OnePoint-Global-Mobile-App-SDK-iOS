//
//  OPGRequest.m
//  OnePointSDK
//
//  Created by OnePoint Global on 30/08/16.
//  Copyright © 2016 OnePointGlobal. All rights reserved.
//

#import "OPGRequest.h"
#import "NSString+OPGMD5.h"

#define iOS  @"iOS"
#define iOSPlatform  @"1"

@implementation OPGRequest
#pragma mark - Util Methods
-(NSString*)timeInString : (NSDate*)todaysDate
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    [dateFormatter setTimeZone:timeZone];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    [dateFormatter setLocale:usLocale];
    NSString *dateString = [dateFormatter stringFromDate:todaysDate];
    
    return dateString;
}

-(NSString*) getLocale {
    NSString *localeStr = [[NSLocale preferredLanguages] firstObject];
    if (localeStr.length > 2) {
        NSString *locale = [localeStr substringToIndex:2];
        return locale;
    }

    NSLog(@"The language is %@", localeStr);
    return localeStr;
}

#pragma mark - Entity Methods
- (NSMutableDictionary*) getAuthEntity : (NSString*)userName password:(NSString*) password AppVersion:(NSString*) appVersion
{
    NSMutableDictionary *loginValues = [[NSMutableDictionary alloc] init];
    
    [loginValues setObject:userName forKey:@"UserName"];
    [loginValues setObject:password forKey:@"Password"];
    [loginValues setObject:appVersion forKey:@"AppVersion"];
    [loginValues setObject:[self timeInString:[NSDate date]] forKey:@"SigninTimeUtc"];
    NSString *encryptedPassword = [[ loginValues valueForKey:@"Password"] MD5];
    [loginValues setObject:encryptedPassword forKey:@"Password"];
    return loginValues;
}

- (NSMutableDictionary*) getGoogleAuthEntity : (NSString*)tokenID AppVersion:(NSString*) appVersion
{
    NSMutableDictionary *loginValues = [[NSMutableDictionary alloc] init];
    [loginValues setObject:appVersion forKey:@"AppVersion"];
    [loginValues setObject:tokenID forKey:@"GoogleToken"];
    return loginValues;
}

- (NSMutableDictionary*) getFacebookAuthEntity : (NSString*)tokenID AppVersion:(NSString*) appVersion
{
    NSMutableDictionary *loginValues = [[NSMutableDictionary alloc] init];
    [loginValues setObject:appVersion forKey:@"AppVersion"];
    [loginValues setObject:tokenID forKey:@"FacebookToken"];
    return loginValues;
}

- (NSMutableDictionary*) getSurveyEntity : (NSString*)uniqueId panelId:(NSString*)panelId
{
    NSMutableDictionary *surveyValues = [[NSMutableDictionary alloc] init];
   // [surveyValues setObject:uniqueId forKey:@"SessionID"];
    if(panelId)
    {
        [surveyValues setObject:panelId forKey:@"PanelID"];
    }
    return surveyValues;
}

- (NSMutableDictionary*) getScriptEntity : (NSString*)uniqueId surveyRef:(NSString*)surveyRef
{
    NSMutableDictionary *scriptValues = [[NSMutableDictionary alloc] init];
    //[scriptValues setObject:uniqueId forKey:@"SessionID"];
    [scriptValues setObject:surveyRef forKey:@"SurveyRef"];
    return scriptValues;
}

- (NSMutableDictionary*) getForgotPasswordEntity : (NSString*)mailId AppVersion:(NSString*) AppVersion
{
    NSString *locale = [self getLocale];
    NSMutableDictionary *forgotPasswordValues = [[NSMutableDictionary alloc] init];
    [forgotPasswordValues setObject:mailId forKey:@"emailID"];
    [forgotPasswordValues setObject:locale forKey:@"Language"];
    [forgotPasswordValues setObject:AppVersion forKey:@"AppVersion"];
    return forgotPasswordValues;
}

-(NSMutableDictionary*) getChangePasswordEntity : (NSString*)uniqueId currentPassword:(NSString*)currentPassword newPassword:(NSString*)newPassword
{
    NSString *locale = [self getLocale];
    NSMutableDictionary *changePasswordValues = [[NSMutableDictionary alloc] init];
   // [changePasswordValues setObject:uniqueId forKey:@"SessionID"];
    [changePasswordValues setObject:[currentPassword MD5] forKey:@"CurrentPassword"];
    [changePasswordValues setObject:[newPassword MD5]  forKey:@"NewPassword"];
    [changePasswordValues setObject:locale forKey:@"Language"];
    return changePasswordValues;
}

-(NSMutableDictionary*) getPanelistProfileEntity : (NSString*)uniqueId
{
    NSMutableDictionary *profileValues = [[NSMutableDictionary alloc] init];
    [profileValues setObject:uniqueId forKey:@"SessionID"];
    return profileValues;
}

-(NSMutableDictionary*) getPanelistPanelEntity : (NSString*)uniqueId
{
    NSMutableDictionary *panelValues = [[NSMutableDictionary alloc] init];
    [panelValues setObject:uniqueId forKey:@"SessionID"];
    return panelValues;
}

-(NSMutableDictionary*) getUpdatePanelistProfileEntity : (NSString*)uniqueId panelistProfile : (OPGPanellistProfile*) panelistProfile
{
    NSMutableDictionary *updateProfileValues = [[NSMutableDictionary alloc] init];
    
   // [updateProfileValues setObject:uniqueId forKey:@"SessionID"];
    [updateProfileValues setObject:panelistProfile.title forKey:@"Title"];
    [updateProfileValues setObject:panelistProfile.address1 forKey:@"Address1"];
    [updateProfileValues setObject:panelistProfile.address2 forKey:@"Address2"];
    [updateProfileValues setObject:panelistProfile.DOB forKey:@"DOB"];
    [updateProfileValues setObject:panelistProfile.email forKey:@"Email"];
    [updateProfileValues setObject:panelistProfile.mobileNumber forKey:@"MobileNumber"];
    [updateProfileValues setObject:panelistProfile.firstName forKey:@"FirstName"];
    [updateProfileValues setObject:panelistProfile.lastName forKey:@"LastName"];
    [updateProfileValues setObject:[panelistProfile.gender stringValue] forKey:@"Gender"];
    [updateProfileValues setObject:panelistProfile.postalCode forKey:@"PostalCode"];
    [updateProfileValues setObject:panelistProfile.mediaID forKey:@"MediaID"];
    [updateProfileValues setObject:panelistProfile.std forKey:@"CountryCode"];
    return updateProfileValues;
}

-(NSMutableDictionary*) getNotificationEntity : (NSString*)uniqueId deviceToken:(NSString*)deviceToken appVersion:(NSString*)appVersion
{
    NSMutableDictionary *notificationValues = [[NSMutableDictionary alloc] init];
   // [notificationValues setObject:uniqueId forKey:@"SessionID"];
    [notificationValues setObject:deviceToken forKey:@"DeviceTokenID"];
    [notificationValues setObject:iOSPlatform forKey:@"Platform"];
    [notificationValues setObject:appVersion forKey:@"Version"];
    [notificationValues setObject:iOS forKey:@"DeviceID"];
    
    return notificationValues;
}

-(NSMutableDictionary*) getGeoFencingEntity:(NSString*)uniqueID withLatitude:(NSString*)Latitude withLongitude:(NSString*)Longitude
{
    NSMutableDictionary *geoFencingValues = [[NSMutableDictionary alloc]init];
   // [geoFencingValues setValue:uniqueID forKey:@"sessionID"];
    [geoFencingValues setValue:Latitude forKey:@"latitude"];
    [geoFencingValues setValue:Longitude forKey:@"longitude"];
    return geoFencingValues;
}
    
-(NSMutableDictionary*) getCountryEntity : (NSString*)uniqueId
{
        NSMutableDictionary *countryValues = [[NSMutableDictionary alloc] init];
        [countryValues setObject:uniqueId forKey:@"SessionID"];
        return countryValues;
}
@end
