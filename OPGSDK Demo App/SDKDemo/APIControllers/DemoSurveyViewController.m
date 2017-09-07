//
//  DemoSurveyViewController.m
//  SDKDemoApp
//
//  Created by OnePoint Global on 06/10/16.
//  Copyright © 2016 opg. All rights reserved.
//

#import "DemoSurveyViewController.h"
#import <OPGSDK/OPGSDK.h>
#import "TakeSurveyViewController.h"
#import "SurveyListViewController.h"

@interface DemoSurveyViewController ()
@property(strong, nonatomic) NSArray* surveyList;
@property(strong, nonatomic) NSArray* panelList;
@end

@implementation DemoSurveyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.activityIndicator setHidden:TRUE];
    self.txtSharedKey.delegate = self;
    self.txtUsername.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - IBAction
-(IBAction)btnGOTapped:(id)sender{
    
    if ((self.txtUsername.text == nil || [self.txtUsername.text isEqualToString:@""]) || (self.txtSharedKey.text == nil || [self.txtSharedKey.text isEqualToString:@""])) {
        // pick the default admin name and key from Appdelegate
    }
    else{
        // Initialising OPGSDK with admin name and key from Text fileds
        //[OPGSDK initializeWithUserName:self.txtUsername.text withSDKKey:self.txtSharedKey.text];
        
    }
    OPGSDK* sdk = [OPGSDK new];
    NSError *error;
    OPGAuthenticate *obj=[sdk authenticate:self.txtUsername.text password:self.txtSharedKey.text error:&error];
    self.surveyList = [sdk getUserSurveyList:&error];       // Getting list of Surveys assigned to user
    if (error == nil) {
        [self performSegueWithIdentifier:@"embedSurveyList" sender:sender];
    }
    else{
        NSLog(@"Error - %@",[error description]);
        UIAlertController * alert=   [UIAlertController
                                      alertControllerWithTitle:@"MySurveys Demo"
                                      message:[[error userInfo] valueForKey:NSLocalizedDescriptionKey]          /* @"Error Occured. Contact Support!" */
                                      preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* noButton = [UIAlertAction
                                   actionWithTitle:@"Got it!"
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction * action)
                                   {
                                       //Handle error
                                       
                                   }];
        [alert addAction:noButton];
        
        [self presentViewController:alert animated:YES completion:nil];
        
    }
}


#pragma mark - Segues Operations
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"embedSurveyList"]) {
        // Get the SurveyList view
        SurveyListViewController *viewController = [segue destinationViewController];
        viewController.surveyListArray = self.surveyList;
    }
    
}


#pragma mark - TextField delegates
-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

@end
