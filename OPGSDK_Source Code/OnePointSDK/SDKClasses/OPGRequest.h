//
//  OPGRequest.h
//  OnePointSDK
//
//  Created by OnePoint Global on 30/08/16.
//  Copyright © 2016 OnePointGlobal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OPGPanellistProfile.h"

@interface OPGRequest:NSObject
/*!
 This method returns the dictionary of key value pairs that are used in creating a request object for authentication.
 */
-(NSMutableDictionary *) getAuthEntity:(NSString *)UserName
                              password:(NSString*) password
                            AppVersion:(NSString *) AppVersion;

/*!
 This method returns the dictionary of key value pairs that are used in creating a request object for Google authentication.
 */
-(NSMutableDictionary *) getGoogleAuthEntity:(NSString *)tokenID
                                  AppVersion:(NSString *) appVersion;

/*!
 This method returns the dictionary of key value pairs that are used in creating a request object for facebook authentication.
 */
-(NSMutableDictionary *) getFacebookAuthEntity:(NSString *)tokenID
                                    AppVersion:(NSString *)appVersion;

/*!
 This method returns the dictionary of key value pairs that are used in creating a request object for survey api.
 */
-(NSMutableDictionary *) getSurveyEntity:(NSString *)uniqueId
                                 panelId:(NSString *)panelId;

/*!
 This method returns the dictionary of key value pairs that are used in creating a request object for script api.
 */
-(NSMutableDictionary *) getScriptEntity:(NSString *)uniqueId
                               surveyRef:(NSString *)surveyRef;

/*!
 This method returns the dictionary of key value pairs that are used in creating a request object for forgot password api.
 */
-(NSMutableDictionary *) getForgotPasswordEntity:(NSString *)mailId
                                      AppVersion:(NSString *) AppVersion;

/*!
 This method returns the dictionary of key value pairs that are used in creating a request object for change password api.
 */
-(NSMutableDictionary *) getChangePasswordEntity:(NSString *)uniqueId
                                 currentPassword:(NSString *)currentPassword
                                     newPassword:(NSString *)newPassword;

/*!
 This method returns the dictionary of key value pairs that are used in creating a request object for panellistProfile api.
 */
-(NSMutableDictionary *) getPanelistProfileEntity:(NSString *)uniqueId;

/*!
 This method returns the dictionary of key value pairs that are used in creating a request object for panellistPanel api.
 */
-(NSMutableDictionary *) getPanelistPanelEntity:(NSString *)uniqueId;

/*!
 This method returns the dictionary of key value pairs that are used in creating a request object for panellistProfile api.
 */
-(NSMutableDictionary *) getUpdatePanelistProfileEntity:(NSString *)uniqueId
                                        panelistProfile:(OPGPanellistProfile *)panelistProfile;

/*!
 This method returns the dictionary of key value pairs that are used in creating a request object for notifications api.
 */
-(NSMutableDictionary *) getNotificationEntity:(NSString *)uniqueId
                                   deviceToken:(NSString*)deviceToken
                                    appVersion:(NSString *)appVersion;

/*!
 This method returns the dictionary of key value pairs that are used in creating a request object for geofencing api.
 */
-(NSMutableDictionary *) getGeoFencingEntity:(NSString *)uniqueID
                                withLatitude:(NSString *)Latitude
                               withLongitude:(NSString *)Longitude;

/*!
 This method returns the dictionary of key value pairs that are used in creating a request object for countries api.
 */
-(NSMutableDictionary *) getCountryEntity:(NSString *)uniqueId;
@end
