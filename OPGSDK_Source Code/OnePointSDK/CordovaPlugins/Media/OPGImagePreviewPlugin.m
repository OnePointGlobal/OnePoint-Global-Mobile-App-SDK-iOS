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
#import "OPGImagePreviewPlugin.h"

@implementation OPGImagePreviewPlugin
- (void) showImageFromPath:(OPGInvokedUrlCommand*)command{
    
    NSString *mediaFilePath=[[[command.arguments objectAtIndex:0]valueForKey:@"path"]description];
    if ([[NSFileManager defaultManager]fileExistsAtPath:[mediaFilePath stringByReplacingOccurrencesOfString:@"file://" withString:@""]]) {
    NSDictionary *dictionary=[command.arguments objectAtIndex:0];
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    if (self.imageBgView==nil) {
        self.imageBgView=[[UIView alloc]init];
    }
    if (self.imageView==nil) {
        self.imageView=[[UIImageView alloc]init];
    }
    if (self.closeButton==nil) {
        self.closeButton=[[UIButton alloc]init];
    }
        if([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeLeft||[UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeRight)
        {
            if(self.viewController.navigationController)
            {
                self.imageBgView.frame=CGRectMake(0, 0,screenWidth,screenHeight);
                self.imageView.frame=CGRectMake(10, 20,screenWidth-20,screenHeight-90);
                self.closeButton.frame=CGRectMake(10,screenHeight-105, screenWidth-20,40);
            }
            else
            {
                self.imageBgView.frame=CGRectMake(0, 0,screenWidth,screenHeight);
                self.imageView.frame=CGRectMake(10, 20,screenWidth-20,screenHeight-40);
                self.closeButton.frame=CGRectMake(10,screenHeight-105, screenWidth-20,40);
            }

        }
        else if([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait||[UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortraitUpsideDown)
        {
            if(self.viewController.navigationController)
            {
                self.imageBgView.frame=CGRectMake(0, 0,screenWidth,screenHeight);
                self.imageView.frame=CGRectMake(10, 15,screenWidth-20,screenHeight-125);
                self.closeButton.frame=CGRectMake(10,screenHeight-110, screenWidth-20,45);
            }
            else
            {
                self.imageBgView.frame=CGRectMake(0, 0,screenWidth,screenHeight);
                self.imageView.frame=CGRectMake(10, 15,screenWidth-20,screenHeight-85);
                self.closeButton.frame=CGRectMake(10,screenHeight-110, screenWidth-20,45);
            }
        }
    self.imageBgView.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
    
    if ([[[[command.arguments objectAtIndex:0]valueForKey:@"path"]description] hasPrefix:@"file://"]) {
        self.imageView.image=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[dictionary valueForKey:@"path"]]]];
    }
    else{
        self.imageView.image=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL fileURLWithPath:[dictionary valueForKey:@"path"]]]];
    }
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.imageView.clipsToBounds = YES;
    self.closeButton.backgroundColor=[UIColor whiteColor];
    [self.closeButton setTitle:@"Close" forState:UIControlStateNormal];
    [self.closeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal] ;
    [self.closeButton addTarget:self action:@selector(closePreview) forControlEvents:UIControlEventTouchUpInside];
    self.viewController.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.viewController.imageView.clipsToBounds = YES;
    self.viewController.imageView = self.imageView;
    self.viewController.closeButton = self.closeButton;

    self.viewController.imageBgView = self.imageBgView;


    [self.viewController.view addSubview:self.imageBgView];
    [self.viewController.view addSubview:self.imageView];
    [self.viewController.view addSubview:self.closeButton];


    }
    else{
        [self errorCallBack:@"eroro occured" withcallbackId:command.callbackId];
    }
}
-(void)closePreview{
    [self.imageView removeFromSuperview];
    [self.closeButton removeFromSuperview];
    [self.imageBgView removeFromSuperview];
}


@end
