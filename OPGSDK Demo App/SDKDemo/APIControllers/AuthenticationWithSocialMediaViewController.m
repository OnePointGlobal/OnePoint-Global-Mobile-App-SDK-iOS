//
//  AuthenticationWithSocialMediaViewController.m
//  SDKDemoApp
//
//  Created by OnePoint Global on 01/12/16.
//  Copyright © 2016 opg. All rights reserved.
//

#import "AuthenticationWithSocialMediaViewController.h"
#import <OPGSDK/OPGSDK.h>

@interface AuthenticationWithSocialMediaViewController ()

@end

@implementation AuthenticationWithSocialMediaViewController
@synthesize googleToken,facebookToken;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    googleToken.delegate=self;
    facebookToken.delegate=self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBAction
-(IBAction)authenticateWithGoogle:(id)sender
{
    OPGSDK* sdk = [OPGSDK new];                   // Creating OPGSDK instance
    NSError *error;
    OPGAuthenticate *obj = [sdk authenticateWithGoogle:@"" error:&error];
    if ([obj.isSuccess intValue]==1 && error==nil)
    {
        [self showAlert:@"Authentication Successful"];

    }
    else
    {
        [self showAlert:obj.statusMessage];

    }
}

-(IBAction)authenticateWithFacebook:(id)sender
{
    OPGSDK* sdk = [OPGSDK new];                   // Creating OPGSDK instance
    NSError *error;
    OPGAuthenticate *obj = [sdk authenticateWithFacebook:@"" error:&error];
    if ([obj.isSuccess intValue]==1 && error==nil)
    {
        [self showAlert:@"Authentication Successful"];

    }
    else
    {
        [self showAlert:obj.statusMessage];

    }
}

-(void)showAlert : (NSString*)alertMessage
{
    UIAlertController * alert = [UIAlertController
                                     alertControllerWithTitle:@"OPGSDK"
                                     message:alertMessage
                                     preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* okButton = [UIAlertAction
                                   actionWithTitle:@"OK"
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction * action) {
                                       //Handle your yes please button action here
                                   }];
        
        [alert addAction:okButton];
        [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - TextField delegates
-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}

@end
