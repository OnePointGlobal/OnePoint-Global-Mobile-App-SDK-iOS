//
//  GetSurveysViewController.m
//  SDKDemo
//
//  Created by OnePoint Global on 04/10/16.
//  Copyright © 2016 opg. All rights reserved.
//

#import "GetSurveysViewController.h"
#import <OPGSDK/OPGSDK.h>
#import "SurveyTableViewController.h"

@interface GetSurveysViewController ()

@property(strong, nonatomic) NSArray* surveyList;
@property(strong, nonatomic) IBOutlet UITextField* panelField;

@end

@implementation GetSurveysViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.panelField.delegate=self;
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBAction
-(IBAction)getSurveyObjC:(id)sender
{
    OPGSDK* sdk = [OPGSDK new];
    NSError *error;
    
    if ([[self.panelField.text description] isEqualToString:@""]) {
        self.surveyList = [sdk getUserSurveyList:&error];// Getting list of Surveys assigned to user
    }
    else{
        self.surveyList = [sdk getUserSurveyListWithPanelID:self.panelField.text error:&error]; // Getting list of Surveys for particular panel
    }
    
    
}

#pragma mark - Segues Operations
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"getUserSurvey"]) {
        // Get the SurveyList view
        SurveyTableViewController *viewController = [segue destinationViewController];
        viewController.surveyListArray = self.surveyList;
    }
    
}

#pragma mark - TextField delegates
-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}

@end
