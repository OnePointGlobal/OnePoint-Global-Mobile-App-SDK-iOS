//
//  OPGParseResult.h
//  OnePointSDK
//
//  Created by OnePoint Global on 30/08/16.
//  Copyright © 2016 OnePointGlobal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OPGSurvey.h"
#import "OPGAuthenticate.h"
#import "OPGScript.h"
#import "OPGForgotPassword.h"
#import "OPGChangePassword.h"
#import "OPGDownloadMedia.h"
#import "OPGPanellistProfile.h"
#import "OPGPanelPanellist.h"
#import "OPGPanel.h"
#import "OPGTheme.h"
#import "OPGSurveyPanel.h"
#import "OPGGeofenceSurvey.h"
#import "OPGPanellistPanel.h"
#import "OPGCountry.h"

@interface OPGParseResult : NSObject
/*!
 This method does parsing of json response obtained from getSurveys api.
 */
-(NSMutableArray *)parseSurveys:(NSArray *)responseList
                          error:(NSError **)error;
/*!
 This method does parsing of json response obtained from authenticate api.
 */
-(OPGAuthenticate *)parseAuthenticationResult:(NSDictionary *)values;

/*!
 This method does parsing of json response obtained from getScript api.
 */
-(OPGScript *)parseAndDownloadScript:(NSDictionary *)scriptData
                          forSurvey:(OPGSurvey *)survey
                              error:(NSError **)error;

/*!
 This method does parsing of json response obtained from forgotPassword api.
 */
-(OPGForgotPassword *)parseForgotPassword:(NSDictionary *)responseData;

/*!
 This method does parsing of json response obtained from changePassword api.
 */
-(OPGChangePassword *)parseChangePassword:(NSDictionary *)responseData;

/*!
 This method does parsing of json response obtained from panellistProfile api.
 */
-(OPGPanellistProfile *)parsePanelistProfile:(NSDictionary *)panelistProfile;

/*!
 This method does parsing of json response obtained from getCountries api.
 */
-(OPGCountry *)parseCountry:(NSDictionary *)countryJson;

/*!
 This method does parsing of json response obtained from panellistProfile api.
 */
-(BOOL)parseUpdatePanelistProfile:(NSDictionary *)panelistProfile;

/*!
 This method does parsing of json response obtained from panelistPanel api.
 */
-(NSMutableArray *)parsePanelPanelist:(NSArray *)panelistPanels;

/*!
 This method does parsing of json response obtained from panelistPanel api.
 */
-(NSMutableArray *)parsePanels:(NSArray *)panelArray;

/*!
 This method does parsing of json response obtained from panelistPanel api.
 */
-(NSMutableArray *)parseThemes:(NSArray *)themeArray;

/*!
 This method does parsing of json response obtained from panelistPanel api.
 */
-(NSMutableArray *)parseSurveyPanels:(NSArray *)surveyPanelArray;

/*!
 This method does parsing of json response obtained from panelistPanel api.
 */
-(OPGPanellistPanel *)parsePanellistPanel:(NSDictionary *)panellistPanel;

/*!
 This method does parsing of json response obtained from geofencing api.
 */
-(NSMutableArray *)parseMSGeoFencing:(NSArray *)responseList
                              error:(NSError **)error;

/*!
 This method does parsing of json response obtained from notfications api.
 */
-(BOOL)parseNotificationResponse:(NSDictionary*)responseResult;

/*!
 This method does parsing of json response obtained from getCountries api.
 */
-(NSMutableArray *)parseListOfCountries:(NSArray *)responseList
                                 error:(NSError **)error;
@end
