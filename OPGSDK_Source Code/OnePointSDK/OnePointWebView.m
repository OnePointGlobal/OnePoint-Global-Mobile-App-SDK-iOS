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

#import "OnePointWebView.h"
#import <OnePointFrameworkV2/NSObject+SBJSON.h>
#import <OnePointFrameworkV2/Constants.h>
#import <OnePointFrameworkV2/NSString+AESCrypt.h>

@interface OnePointWebView()

@end

@implementation OnePointWebView

@synthesize delegateWebView;


#pragma mark - Private Methods
- (void)loadWebView:(NSString *)surveyReference{
    self.delegate = self;
    
    NSURLRequest* urlRequest = [NSURLRequest requestWithURL:[[NSURL alloc] initWithString:[self getSurveyLink:surveyReference]]];
    [super loadRequest:urlRequest];
}

-(NSString *)getSurveyLink:(NSString *)surveyID{
    // @"81504",@"surveyID",@"22194",@"panellistID",@"20475",@"panelID",@"ios",@"platform",@"B1",@"SEV",deviceID,@"deviceID"
    
    NSString *deviceID=[[[UIDevice currentDevice]identifierForVendor]UUIDString];
    NSDictionary *dictionary=[[NSDictionary alloc]initWithObjectsAndKeys:[NSString stringWithFormat:@"%@",surveyID],@"surveyID",@"ios",@"platform",@"B1",@"SEV",deviceID,@"deviceID" ,nil];
    
    NSString *encryptedJson=[[dictionary JSONRepresentation]AES256EncryptWithKey:KEY_DATA];
    if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"InterviewUrl"] isEqualToString:@""]) {
    }
    NSString *urlString=[NSString stringWithFormat:@"%@?data=%@",[[NSUserDefaults standardUserDefaults]valueForKey:@"InterviewUrl"],encryptedJson];
    return urlString;
}


#pragma mark - UIWebView Delegates
-(void)webViewDidFinishLoad:(UIWebView *)webView {
    NSString *url=[webView.request.URL absoluteString];
    if ([url rangeOfString:@"status=3"].location!=NSNotFound){
        if([self.delegateWebView respondsToSelector:@selector(surveyCompleted)]) {
            [self.delegateWebView surveyCompleted];
        }
        
    }
    else if([self.delegateWebView respondsToSelector:@selector(didOnePointWebViewFinishLoad)]) {
        [self.delegateWebView didOnePointWebViewFinishLoad];
    }
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
    if([self.delegateWebView respondsToSelector:@selector(didOnePointWebViewStartLoad)]) {
        [self.delegateWebView didOnePointWebViewStartLoad];
    }
    
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    if (([self.delegateWebView respondsToSelector:@selector(didOnePointWebViewFailLoadWithError:)])) {
        [self.delegateWebView didOnePointWebViewFailLoadWithError:error];
    }
    
}

@end
