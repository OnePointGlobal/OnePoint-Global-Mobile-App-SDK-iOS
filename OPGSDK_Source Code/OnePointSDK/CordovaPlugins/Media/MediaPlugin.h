//
//  MediaPlugin.h
//  ExampleApp
//
//  Created by Varahala Babu on 17/02/14.
//
//

#import "OPG.h"
#import "RootPlugin.h"


@interface MediaPlugin : RootPlugin<NSURLConnectionDelegate,NSURLConnectionDataDelegate>
{
    OPGInvokedUrlCommand *callbackCommand;
    NSDictionary* dict;
    NSMutableData* responceData;
}
- (void)mediaUpload_network:(OPGInvokedUrlCommand*)command;
@end
