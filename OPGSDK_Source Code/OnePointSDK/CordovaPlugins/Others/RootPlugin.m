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

#import "RootPlugin.h"
@implementation RootPlugin

-(BOOL)isOnline{
    OPGReachability *reachability = [OPGReachability reachabilityForInternetConnection];
    if (reachability.currentReachabilityStatus!=NotReachable) {
        return YES;
    }
    else{
        return FALSE;
    }

}
-(void)successCallBack:(NSString*)jsCallbackValue withcallbackId:(NSString*)callbackID{
    OPGPluginResult* pluginResult = [OPGPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:jsCallbackValue];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:callbackID];
   
}
-(void)errorCallBack:(NSString*)jsCallbackValue withcallbackId:(NSString*)callbackID{
  
   OPGPluginResult* pluginResult=[OPGPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:jsCallbackValue];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:callbackID];
   
}

@end
