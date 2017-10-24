//
//  OPGNetworkRequest.m
//  OnePointSDK
//
//  Created by OnePoint Global on 30/08/16.
//  Copyright © 2016 OnePointGlobal. All rights reserved.
//

#import "OPGNetworkRequest.h"
#import "NSObject+OPGSBJSON.h"
#import "NSString+OPGAESCrypt.h"
#import "PKMultipartInputStream.h"
#import "NSString+OPGMD5.h"
#import "OPGConstants.h"

#define MySurveysSDKUsername @"Username"
#define MySurveysSDKSharedkey @"SharedKey"

@implementation OPGNetworkRequest

#pragma mark - getter Methods
-(NSString*)getApiUrl
{
    return [[NSUserDefaults standardUserDefaults] valueForKey:@"OPGApiUrl"];
}

-(NSString*)getSDKUsername
{
    return [[NSUserDefaults standardUserDefaults] valueForKey:@"OPGUsername"];
}

-(NSString*)getSDKSharedKey
{
    return [[NSUserDefaults standardUserDefaults] valueForKey:@"OPGSharedkey"];
}

-(NSString*)getUniqueId
{
    return [[NSUserDefaults standardUserDefaults] valueForKey:@"OPGUniqueID"];
}



#pragma mark - Networking Operations
-(NSMutableURLRequest *)createRequest:(NSMutableDictionary*)values forApi:(NSString*)apiName
{
    NSString *jsonString = [values JSONRepresentation];
    NSDictionary *data = [NSDictionary dictionaryWithObject:jsonString forKey:@"Data"];
    NSString *finalString = [data JSONRepresentation];
    NSData *postData = [finalString dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES ];
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",[self getApiUrl],apiName]] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:360];
    
    
    if (!([[self getSDKUsername] isEqualToString:MySurveysSDKUsername] && [[self getSDKSharedKey] isEqualToString:MySurveysSDKSharedkey]))
    {
        NSString *authStr = [NSString stringWithFormat:@"%@:%@", [self getSDKUsername], [self getSDKSharedKey]];
        NSData *authData = [authStr dataUsingEncoding:NSASCIIStringEncoding];
        NSString *authValue = [NSString stringWithFormat:@"Basic %@", [authData base64EncodedString]];
        [request setValue:authValue forHTTPHeaderField:@"Authorization"];
    }
    
    [request setHTTPMethod:POST];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    if ([apiName isEqualToString:@"Media/ProfileMedia"])
    {
        [request setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    }
    else
    {
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    }
    [request setHTTPBody:postData];
    return request;
}

-(NSMutableURLRequest *)createRequestForMediaForApi:(NSString*)apiName{
    NSMutableURLRequest *request;
    if ([self getUniqueId] == nil) {
        request=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",[self getApiUrl],apiName]] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:360];
    } else {
        request=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@?Data=%@",[self getApiUrl],apiName,[self getUniqueId]]] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:360];
    }
    
    
    if (!([[self getSDKUsername] isEqualToString:MySurveysSDKUsername] && [[self getSDKSharedKey] isEqualToString:MySurveysSDKSharedkey]))
    {
        NSString *authStr = [NSString stringWithFormat:@"%@:%@", [self getSDKUsername], [self getSDKSharedKey]];
        NSData *authData = [authStr dataUsingEncoding:NSASCIIStringEncoding];
        NSString *authValue = [NSString stringWithFormat:@"Basic %@", [authData base64EncodedString]];
        [request setValue:authValue forHTTPHeaderField:@"Authorization"];
    }
    
    [request setHTTPMethod:POST];
    return request;
}

-(id) performRequest:(NSMutableURLRequest *)request withError:(NSError **)errorDomain{
    
    NSData *urlData;NSHTTPURLResponse *response; NSError *error=nil;
    id responseList;
    @try {
        urlData =[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        if (!urlData) {
            int errorCode = 4;
            NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
            [userInfo setObject:GenericError
                         forKey:NSLocalizedDescriptionKey];
            
            // Populate the error reference.
            *errorDomain = [[NSError alloc] initWithDomain:ErrorDomain
                                                      code:errorCode
                                                  userInfo:userInfo];
            return nil;
        }
        
        responseList = [NSJSONSerialization JSONObjectWithData:urlData options:kNilOptions
                                                         error:&error];
        
        if ([response statusCode] >=200 && [response statusCode] <300)
        {
            return responseList;
        }
        else if([[responseList valueForKey:@"ErrorMessage"] isEqualToString:@"UniqueID does not exist."])
        {
            return responseList;
        }
        else{
            int errorCode = 4;
            NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
            [userInfo setObject:GenericError
                         forKey:NSLocalizedDescriptionKey];
            
            // Populate the error reference.
            *errorDomain = [[NSError alloc] initWithDomain:ErrorDomain
                                                      code:errorCode
                                                  userInfo:userInfo];
            return responseList;
            
        }
    }
    @catch (NSException *exception) {
        int errorCode = 4;
        NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
        [userInfo setObject:GenericError
                     forKey:NSLocalizedDescriptionKey];
        
        // Populate the error reference.
        *errorDomain = [[NSError alloc] initWithDomain:ErrorDomain
                                                  code:errorCode
                                              userInfo:userInfo];
        
        
    }
    @finally {
        
    }
    
    return nil;
}

-(BOOL) performUploadFile:(NSMutableURLRequest *)request  filePath:(NSString*)filePath  fileName:(NSString*)fileName withError:(NSError **)errorDomain
{
    NSData *urlData;NSHTTPURLResponse *response; NSError *error=nil;
    id responseList;
    @try {
        urlData =[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        if (!urlData) {
            int errorCode = 4;
            NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
            [userInfo setObject:GenericError
                         forKey:NSLocalizedDescriptionKey];
            
            // Populate the error reference.
            *errorDomain = [[NSError alloc] initWithDomain:ErrorDomain
                                                      code:errorCode
                                                  userInfo:userInfo];
            return false;
        }
        
        responseList = [NSJSONSerialization JSONObjectWithData:urlData options:kNilOptions
                                                         error:&error];
        
        if ([response statusCode] == 200 )
        {
            NSString *path = [filePath stringByAppendingPathComponent:fileName];
            [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
            return true;                //return true if file uploaded successfully
        }
        else{
            int errorCode = 4;
            NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
            [userInfo setObject:GenericError
                         forKey:NSLocalizedDescriptionKey];
            
            // Populate the error reference.
            *errorDomain = [[NSError alloc] initWithDomain:ErrorDomain
                                                      code:errorCode
                                                  userInfo:userInfo];
            return false;
            
        }
    }
    @catch (NSException *exception) {
        int errorCode = 4;
        NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
        [userInfo setObject:GenericError
                     forKey:NSLocalizedDescriptionKey];
        
        // Populate the error reference.
        *errorDomain = [[NSError alloc] initWithDomain:ErrorDomain
                                                  code:errorCode
                                              userInfo:userInfo];
        
        
    }
    @finally {
        
    }
    
    return false;

}



@end
