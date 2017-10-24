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

#import "OPGMediaPlugin.h"
#import "OPGPluginResult.h"
#import "OPGConstants.h"
#import "PKMultipartInputStream.h"
#import "OPGSBJSON.h"


#import "NSString+OPGAESCrypt.h"
#import "NSObject+OPGSBJSON.h"
#import "OPGSDK.h"

@implementation OPGMediaPlugin


- (void)mediaUpload_network:(OPGInvokedUrlCommand*)command
{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"OPGIsOfflineSurvey"] !=nil && [[[NSUserDefaults standardUserDefaults] objectForKey:@"OPGIsOfflineSurvey"] isEqualToString:@"true"]) {
        [self mediaUpload_database:command];
        return;
    }

    dict =[command argumentAtIndex:0];
    __block NSError *error;
    NSString *mediaFilePath =[[[dict valueForKey:@"mediaPath"]description]stringByReplacingOccurrencesOfString:@"file://" withString:@""];
    __block OPGSDK* sdk = [OPGSDK new];
    __block NSString* mediaID;
    dispatch_queue_t myQueue = dispatch_queue_create("My Queue",NULL);
    dispatch_async(myQueue, ^{
        mediaID = [sdk uploadMediaFile:mediaFilePath error:&error];
        dispatch_async(dispatch_get_main_queue(), ^{
            NSDictionary *sucessDictionary=[[NSDictionary alloc]initWithObjectsAndKeys:mediaID,@"MediaID", nil];
            if (error == nil && mediaID != nil) {
                NSDictionary *dictionary=[[NSDictionary alloc]initWithObjectsAndKeys:@"100",@"Percent",@"",@"MediaId", nil];
                OPGPluginResult* pluginResult = [OPGPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:[dictionary JSONRepresentation]];
                [pluginResult setKeepCallbackAsBool:TRUE];
                [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
                [self successCallBack:[sucessDictionary JSONRepresentation] withcallbackId:command.callbackId];
            } else {
                [self errorCallBack:@"Upload Media error" withcallbackId:command.callbackId];
            }
        });
    });
    
}

- (void)mediaUpload_database:(OPGInvokedUrlCommand*)command
{
    __block NSString *status;
    callbackCommand=command;
    __block NSString *fileName;
    dispatch_queue_t myQueue = dispatch_queue_create("My Queue",NULL);
    dispatch_async(myQueue, ^{
        NSDictionary *values=[command argumentAtIndex:0];
        NSData *mediaData=nil;
        if ([[[values valueForKey:@"mediaPath"]description] hasPrefix:@"file://"]) {
            mediaData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[[values valueForKey:@"mediaPath"]description]]];
        }
        else{
            mediaData = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:[[values valueForKey:@"mediaPath"]description]]];
        }
        NSFileManager *fileManager=[NSFileManager defaultManager];
        
        NSString *cacheDirPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
        NSString *filePath=[cacheDirPath stringByAppendingPathComponent:@"OPG_Surveys_Media"];
        NSError *error=nil;
        if(![fileManager fileExistsAtPath:filePath]){
            [fileManager createDirectoryAtPath:filePath withIntermediateDirectories:NO attributes:nil error:&error];
        }
        
        NSDateFormatter *DateFormatter=[[NSDateFormatter alloc] init];
        [DateFormatter setDateFormat:@"yyyy-MM-dd_hh_mm_ss"];
        [DateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
        NSRange fileRange=[[[values valueForKey:@"mediaPath"]description] rangeOfString: @"." options: NSBackwardsSearch];
        NSString *fileExtension=[[[values valueForKey:@"mediaPath"]description] substringFromIndex: fileRange.location+1];
        fileName=[NSString stringWithFormat:@"%@-%@-%@.%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"RunningSurvey"],[[NSUUID UUID] UUIDString],[DateFormatter stringFromDate:[NSDate date]],fileExtension];
        if ([mediaData writeToFile:[filePath stringByAppendingPathComponent:fileName] atomically:YES]) {
            [[NSFileManager defaultManager]removeItemAtPath:[[[values valueForKey:@"mediaPath"]description]stringByReplacingOccurrencesOfString:@"file://" withString:@""] error:nil];
            status=@"success";
        }
        else{
            status=@"false";
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([status isEqualToString:@"success"]) {
                NSMutableDictionary *dict=[[NSMutableDictionary alloc]init];
                [dict setObject:fileName forKey:@"MediaID"];
                [self successCallBack:[dict JSONRepresentation] withcallbackId:callbackCommand.callbackId];
            }
            else{
                NSMutableDictionary *dict=[[NSMutableDictionary alloc]init];
                [dict setObject:@"error in db" forKey:@"error"];
                [self errorCallBack:[dict JSONRepresentation] withcallbackId:callbackCommand.callbackId];
            }
        });
    });
}

@end
