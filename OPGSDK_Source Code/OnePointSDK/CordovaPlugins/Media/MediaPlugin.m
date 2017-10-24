//
//  MediaPlugin.m
//  ExampleApp
//
//  Created by Varahala Babu on 17/02/14.
//
//

#import "MediaPlugin.h"
#import "OPGConstants.h"
#import "PKMultipartInputStream.h"
#import "OPGSBJSON.h"
#import "NSString+OPGAESCrypt.h"
#import "NSObject+OPGSBJSON.h"

@implementation MediaPlugin

static NSString *ErrorDomain = @"com.OnePointSDK.ErrorDomain";

- (void)mediaUpload_network:(OPGInvokedUrlCommand*)command
{
    dict =[command argumentAtIndex:0];
    __block NSError *error;
    dispatch_queue_t myQueue = dispatch_queue_create("My Queue", NULL);
    dispatch_async(myQueue, ^{
        [self getUserSurveyList:&error];

    });
    
//    AppDelegate *delegate=[[UIApplication sharedApplication]delegate];
    callbackCommand=command;
//    if(delegate.offline){
//        [self mediaUpload_database:command];
//        return;
//    }
//    
//    if ([self isOnline]) {
//    uploadRequest=[[UploadMediaRequest alloc]init];
//    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(successCallbackFromNotification:)
                                                 name:@"NSURLConnectionDidFinish"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(errorCallbackFromNotification:)
                                                 name:@"NSURLConnectionDidFailWithError"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(percentCallbackFromNotification:)
                                                 name:@"NSURLConnectionDidSendBodyData"
                                               object:nil];
//    NSDictionary *values=[command argumentAtIndex:0];
//            [uploadRequest asynchronousMediaUpload:values];
//        return;
//    }
//    else{
//       NSDictionary *dictionary=[[NSDictionary alloc]initWithObjectsAndKeys:@"No Internet Connection",@"message",[NSNumber numberWithInt:101],@"code", nil];
//        [self errorCallBack:[dictionary JSONRepresentation] withcallbackId:command.callbackId];
//    }
   
}
- (void)mediaUploadOnline:(OPGInvokedUrlCommand*)command
{
//    uploadRequest=[[UploadMediaRequest alloc]init];
//    callbackCommand=command;
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(successCallbackFromNotification:)
//                                                 name:@"NSURLConnectionDidFinish"
//                                               object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(errorCallbackFromNotification:)
//                                                 name:@"NSURLConnectionDidFailWithError"
//                                               object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(percentCallbackFromNotification:)
//                                                 name:@"NSURLConnectionDidSendBodyData"
//                                               object:nil];
//    NSDictionary *values=[command argumentAtIndex:0];
//    if ([self isOnline]) {
//        [uploadRequest asynchronousMediaUpload:values];
//        return;
//    }
//    else{
//        NSDictionary *dictionary=[[NSDictionary alloc]initWithObjectsAndKeys:@"No Internet Connection",@"message",[NSNumber numberWithInt:101],@"code", nil];
//        [self errorCallBack:[dictionary JSONRepresentation] withcallbackId:command.callbackId];
//    }

}


-(void)successCallbackFromNotification:(NSNotification *)notification{
    
    NSString* object = [notification object];
    [self successCallBack:object withcallbackId:callbackCommand.callbackId];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
//    NetworkResult *result=[notification object];
//    UploadMediaResponse *response=[[UploadMediaResponse alloc]init];
//    [response setContentBody:[result getContentBody]];
//    [response tryParseResult];
//    if ([response getError]==nil) {
//        [self successCallBack:[response getContentBody] withcallbackId:callbackCommand.callbackId];
//        [[NSFileManager defaultManager]removeItemAtPath:[[[callbackCommand argumentAtIndex:0]valueForKey:@"mediaPath"]stringByReplacingOccurrencesOfString:@"file://" withString:@""] error:nil];
//        [[NSNotificationCenter defaultCenter] removeObserver:self];
//        return;
//    }
//    else if ([[response getError]isEqualToString:@"Invalid Session"]){
//        
//        NSString *stutus=[uploadRequest refreshSession];
//        if ([stutus isEqualToString:@"success"]) {
//            [[NSNotificationCenter defaultCenter] removeObserver:self];
//            [self mediaUpload_network:callbackCommand];
//        }
//        else{
//            [self errorCallBack:stutus withcallbackId:callbackCommand.callbackId];
//           // [[NSFileManager defaultManager]removeItemAtPath:[[[callbackCommand argumentAtIndex:0]valueForKey:@"mediaPath"]stringByReplacingOccurrencesOfString:@"file://" withString:@""] error:nil];
//            [[NSNotificationCenter defaultCenter] removeObserver:self];
//            return;
//        }
//      }
//  else {
//        [self errorCallBack:[response getContentBody] withcallbackId:callbackCommand.callbackId];
//       // [[NSFileManager defaultManager]removeItemAtPath:[[[callbackCommand argumentAtIndex:0]valueForKey:@"mediaPath"]stringByReplacingOccurrencesOfString:@"file://" withString:@""] error:nil];
//        [[NSNotificationCenter defaultCenter] removeObserver:self];
//    }
    
    
}
-(void)errorCallbackFromNotification:(NSNotification *)notification{
    
    NSString *error=[notification object];
    [self errorCallBack:error withcallbackId:callbackCommand.callbackId];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}
-(void)percentCallbackFromNotification:(NSNotification *)notification{
    NSNumber *percentage=[notification object];
    if(percentage){
    NSDictionary *dictionary=[[NSDictionary alloc]initWithObjectsAndKeys:percentage,@"Percent",@"",@"MediaId", nil];
    OPGPluginResult* pluginResult = [OPGPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:[dictionary JSONRepresentation]];
    [pluginResult setKeepCallbackAsBool:TRUE];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:callbackCommand.callbackId];
}
}


-(NSString *)getUserSurveyList:(NSError **)errorDomian {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *mediaFilePath =[[[dict valueForKey:@"mediaPath"]description]stringByReplacingOccurrencesOfString:@"file://" withString:@""];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@UserMedia",[defaults valueForKey:@"ApiUrl"]]]];
    [request setHTTPMethod:POST];
    NSString *authStr = [NSString stringWithFormat:@"%@:%@", [defaults valueForKey:@"username"], [defaults valueForKey:@"sharedkey"]];
    NSData *authData = [authStr dataUsingEncoding:NSASCIIStringEncoding];
    NSString *authValue = [NSString stringWithFormat:@"Basic %@", [authData base64EncodedString]];
    [request setValue:authValue forHTTPHeaderField:@"Authorization"];
    
    NSRange range= [[dict valueForKey:@"mediaPath"] rangeOfString: @"/" options: NSBackwardsSearch];
    NSString* fileName= [[dict valueForKey:@"mediaPath"] substringFromIndex: range.location+1];
    //create stream of media
    PKMultipartInputStream *HttpBody = [[PKMultipartInputStream alloc] init];
    [HttpBody addPartWithName:@"file" filename:fileName path:mediaFilePath];
    
    [self createRequestForUploadAsynchronous:HttpBody FileName:fileName withRequest:request];
    
    return @"";
}


-(void) createRequestForUploadAsynchronous:(PKMultipartInputStream*)mediaData FileName:(NSString*)fileName withRequest:(NSMutableURLRequest*)request{
    
    @autoreleasepool {
        [request setValue:[NSString stringWithFormat:@"multipart/form-data; boundary=%@", [mediaData boundary]] forHTTPHeaderField:@"Content-Type"];
        [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[mediaData length]] forHTTPHeaderField:@"Content-Length"];
        [request setHTTPBodyStream:mediaData];
        
        NSURLConnection *connection = [[NSURLConnection alloc]initWithRequest:request delegate:self];
        if (connection) {
            
            responceData = [NSMutableData data];
            
        }
        else{
            NSLog(@"connection error");
        }
        
    }
}


- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [responceData appendData:data];
}

- (void) connectionDidFinishLoading:(NSURLConnection *)connection {
    
    
    NSError* error;
    NSArray* responseList = [NSJSONSerialization JSONObjectWithData:responceData options:kNilOptions
                                                     error:&error];
   // id decryptedResponse = [self fetchDataRetrieved:responceData];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NSURLConnectionDidFinish" object:responseList];
    
}

- (void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NSURLConnectionDidFailWithError" object:[error description]];
}
- (void)connection:(NSURLConnection *)connection didSendBodyData:(NSInteger)bytesWritten totalBytesWritten:(NSInteger)totalBytesWritten totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite{
    float value= (float)totalBytesWritten / totalBytesExpectedToWrite;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NSURLConnectionDidSendBodyData" object:[NSNumber numberWithFloat:value*100]];
}


-(id)fetchDataRetrieved:(NSData*)Data{
    @try {
//        NSError *error=nil;
//        OPGSBJSON *json = [[OPGSBJSON alloc] init];
//        NSDictionary *codes = [[NSDictionary alloc]init];
//        codes = [json objectWithString:Data error:&error];
//        NSString *dataToDecrypt=[codes valueForKey:@"Data"];
//        NSString* decryptedData = [dataToDecrypt AES256DecryptWithKey:KEY_DATA];
        
        //Convert NSData to NSString
//        NSString * converted =[[NSString alloc] initWithData:Data encoding:NSUTF8StringEncoding];
//        NSData *data = [converted dataUsingEncoding:NSUTF8StringEncoding];
        id json = [NSJSONSerialization JSONObjectWithData:Data options:0 error:nil];
        NSLog(@"Data =%@",json);
        
        
        
        return json;
    }
    @catch (NSException *exception) {
        NSLog(@"Decryption Error");
    }
    @finally {
        
    }
    
}


//-(NSString*)fetchDataRetrieved:(NSString*)Data{
//    @try {
//        NSError *error=nil;
//        OPGSBJSON *json = [[OPGSBJSON alloc] init];
//        NSDictionary *codes = [[NSDictionary alloc]init];
//        codes = [json objectWithString:Data error:&error];
//        NSString *dataToDecrypt=[codes valueForKey:@"Data"];
//        NSString* decryptedData = [dataToDecrypt AES256DecryptWithKey:KEY_DATA];
//        
//        
//        NSData * data =[str dataUsingEncoding:NSUTF8StringEncoding]; //Data
//        
//        //Convert NSData to NSString
//        NSString * converted =[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//        NSLog(@"Data =%@",converted);
//        
//        
//        
//        return decryptedData;
//    }
//    @catch (NSException *exception) {
//        NSLog(@"Decryption Error");
//    }
//    @finally {
//        
//    }
//    
//}


@end
