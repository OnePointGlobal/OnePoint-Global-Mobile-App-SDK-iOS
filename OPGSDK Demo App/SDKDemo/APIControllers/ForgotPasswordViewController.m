//
//  ForgotPasswordViewController.m
//  SDKDemo
//
//  Created by OnePoint Global on 04/10/16.
//  Copyright © 2016 opg. All rights reserved.
//

#import "ForgotPasswordViewController.h"
#import <OPGSDK/OPGSDK.h>

@interface ForgotPasswordViewController ()

@end

@implementation ForgotPasswordViewController
@synthesize email;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.email.delegate=self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBAction
-(IBAction)forgotPassword:(id)sender
{
    OPGSDK* sdk = [OPGSDK new];                   // Creating OPGSDK instance
    NSError *error;
    OPGForgotPassword *obj = [sdk forgotPassword:self.email.text error:&error];
    
    if ([obj.isSuccess intValue]==1 && error==nil)
    {
        UIAlertController * alert = [UIAlertController
                                     alertControllerWithTitle:@"OPGSDK"
                                     message:@"Password Reset Mail Sent Successfully!"
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
    else
    {
        UIAlertController * alert = [UIAlertController
                                     alertControllerWithTitle:@"OPGSDK"
                                     message:obj.statusMessage
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
}

#pragma mark - TextField delegates
-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}
@end
