//
// Copyright (c) 2016 OnePoint Global Ltd. All rights reserved.
//
// This code is licensed under the OnePoint Global License.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//

#import "OnePointSDK.h"
#import <OnePointFrameworkV2/AuthenticationRequest.h>
#import <OnePointFrameworkV2/AuthenticationResponse.h>
#import <OnePointFrameworkV2/Reachability.h>
#import <OnePointFrameworkV2/NSObject+SBJSON.h>
#import <OnePointFrameworkV2/NSString+AESCrypt.h>
#import <OnePointFrameworkV2/CheckForUpdate.h>
#import <UIKit/UIKit.h>
#import "OnePointSurvey.h"
#import "OnePointPanel.h"
#import "Constants.h"

@interface OnePointSDK()

typedef id (^error_handler_t)(NSError* error);

@end


@implementation OnePointSDK

static NSString *sdk_Username = @"";
static NSString *sdk_KEY = @"";
static NSString *ErrorDomain = @"com.OnePointSDK.ErrorDomain";

+(void)initializeWithUserName:(NSString *)userName withSDKKey:(NSString *)key {
    sdk_Username = userName;
    sdk_KEY = key;
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:LiveInterviewUrl forKey:@"InterviewUrl"];
    NSLog(@"%@ initialised successfully!",SucessMessage);
    
}


-(BOOL)isOnline{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    if (reachability.currentReachabilityStatus!=NotReachable) {
        return YES;
    }
    else{
        return FALSE;
    }
    
}

-(NSArray *)getUserSurveyList:(NSError **)errorDomian {
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@UserSurvey",LiveApiURL]]];
    NSArray* surveyList;
    [request setHTTPMethod:GET];
    NSString *authStr = [NSString stringWithFormat:@"%@:%@", sdk_Username, sdk_KEY];
    NSData *authData = [authStr dataUsingEncoding:NSASCIIStringEncoding];
    NSString *authValue = [NSString stringWithFormat:@"Basic %@", [authData base64EncodedString]];
    [request setValue:authValue forHTTPHeaderField:@"Authorization"];
    NSArray* responseList = [self performRequest:request withError:errorDomian];
    surveyList = [self parseSurveys:responseList];
    return surveyList;
}

-(id) performRequest:(NSMutableURLRequest *)request withError:(NSError **)errorDomain{
    
    NSData *urlData;NSHTTPURLResponse *response; NSError *error=nil;
    NSArray* responseList;    
    @try {
        urlData =[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        if (!urlData) {
            int errorCode = 4;
            NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
            [userInfo setObject:NoSurveyMessage
                         forKey:NSLocalizedDescriptionKey];
            
            // Populate the error reference.
            *errorDomain = [[NSError alloc] initWithDomain:ErrorDomain
                                                      code:errorCode
                                                  userInfo:userInfo];
        }
        
        if ([response statusCode] >=200 && [response statusCode] <300)
        {
            
            responseList = [NSJSONSerialization JSONObjectWithData:urlData options:kNilOptions
                                                             error:&error];
            
            
        }
        else{
            int errorCode = 4;
            NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
            [userInfo setObject:NoSurveyMessage
                         forKey:NSLocalizedDescriptionKey];
            
            // Populate the error reference.
            *errorDomain = [[NSError alloc] initWithDomain:ErrorDomain
                                                      code:errorCode
                                                  userInfo:userInfo];
            
        }
    }
    @catch (NSException *exception) {
        int errorCode = 4;
        NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
        [userInfo setObject:NoSurveyMessage
                     forKey:NSLocalizedDescriptionKey];
        
        // Populate the error reference.
        *errorDomain = [[NSError alloc] initWithDomain:ErrorDomain
                                                  code:errorCode
                                              userInfo:userInfo];
        
        
    }
    @finally {
        
    }
    
    return responseList;
}

- (NSMutableArray*)parseSurveys:(NSArray*)responseList {
    NSMutableArray* _surveyList = [[NSMutableArray alloc] init];
    for (int i = 0; i < [responseList count]; i++) {
        OnePointSurvey *survey = [OnePointSurvey new];
        survey.Name = [[responseList objectAtIndex:i] valueForKey:@"Name"];
        
        if ([[[responseList objectAtIndex:i] valueForKey:@"SurveyID"] isKindOfClass:[NSString class]]) {
            survey.SurveyReference = [[responseList objectAtIndex:i] valueForKey:@"SurveyID"];
        }
        else {
            survey.SurveyReference = [[[responseList objectAtIndex:i] valueForKey:@"SurveyID"] stringValue];
        }
        
        survey.Description = [[responseList objectAtIndex:i] valueForKey:@"Description"];
        survey.LastUpdatedDate = [[responseList objectAtIndex:i] valueForKey:@"LastUpdatedDate"];
        survey.ScriptID = [[responseList objectAtIndex:i] valueForKey:@"ScriptID"];
        survey.IsGeoFencing = [[responseList objectAtIndex:i] valueForKey:@"IsGeoFencing"] == 0 ? [NSNumber numberWithBool:NO] : [NSNumber numberWithBool:YES];
        
        survey.IsOffline = [[responseList objectAtIndex:i] valueForKey:@"IsOffline"] == 0 ? [NSNumber numberWithBool:NO] : [NSNumber numberWithBool:YES];
        if ([[[responseList objectAtIndex:i] valueForKey:@"IsOffline"] intValue] == 0) {
            [_surveyList addObject:survey];
            
        }
        
    }
    return _surveyList;
}


/*
- (NSMutableArray*)parsePanels:(NSArray*)responseList {
    NSMutableArray* panelList = [[NSMutableArray alloc] init];
    for (int i = 0; i < [responseList count]; i++) {
        OnePointPanel *panel = [OnePointPanel new];
        panel.Name = [[responseList objectAtIndex:i] valueForKey:@"Name"];
        panel.PanelID = [[responseList objectAtIndex:i] valueForKey:@"PanelID"];
        panel.PanelType = [[responseList objectAtIndex:i] valueForKey:@"PanelType"];
        panel.Description = [[responseList objectAtIndex:i] valueForKey:@"Description"];
        panel.CreatedUpdatedDate = [[responseList objectAtIndex:i] valueForKey:@"CreatedDate"];
        panel.LastUpdatedDate = [[responseList objectAtIndex:i] valueForKey:@"LastUpdatedDate"];
        panel.ThemeTemplateIDSpecified = [[responseList objectAtIndex:i] valueForKey:@"ThemeTemplateIDSpecified"];
        panel.ThemeTemplateID = [[responseList objectAtIndex:i] valueForKey:@"ThemeTemplateID"];
        panel.SearchTag = [[responseList objectAtIndex:i] valueForKey:@"SearchTag"];
        panel.Remark = [[responseList objectAtIndex:i] valueForKey:@"Remark"];
        
        [panelList addObject:panel];
        
    }
    
    return panelList;

}

-(NSArray *)getUserPanelList:(NSError **)errorDomian {
    //NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"https://apidev.1pt.mobi/V3.0/Api/UserPanels"]];
     NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@UserProject",LiveApiURL]]];
    NSMutableArray* panelList = [[NSMutableArray alloc] init];
    [request setHTTPMethod:GET];
    NSString *authStr = [NSString stringWithFormat:@"%@:%@", sdk_Username, sdk_KEY];
    NSData *authData = [authStr dataUsingEncoding:NSASCIIStringEncoding];
    NSString *authValue = [NSString stringWithFormat:@"Basic %@", [authData base64EncodedString]];
    [request setValue:authValue forHTTPHeaderField:@"Authorization"];
    NSArray* responseList = [self performRequest:request withError:errorDomian];
    panelList = [self parsePanels:responseList];
    return panelList;
}

*/

@end
