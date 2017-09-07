//
//  ViewController.m
//  SDKDemo
//
//  Created by OnePoint Global on 30/09/16.
//  Copyright © 2016 opg. All rights reserved.
//

#import "ViewController.h"
#import <OPGSDK/OPGSDK.h>
@interface ViewController ()



@end

@implementation ViewController

- (void)viewDidLoad {
    self.username.delegate=self;
    self.password.delegate=self;
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)login:(id)sender
{
    OPGSDK* sdk = [OPGSDK new];                   // Creating OPGSDK instance
    NSError *error;
    OPGAuthenticate *obj = [sdk authenticate:self.username.text password:self.password.text error:&error];
    if ([obj.isSuccess intValue]==0)
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
