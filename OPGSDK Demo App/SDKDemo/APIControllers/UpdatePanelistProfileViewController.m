//
//  UpdatePanelistProfileViewController.m
//  SDKDemo
//
//  Created by OnePoint Global on 04/10/16.
//  Copyright © 2016 opg. All rights reserved.
//

#import "UpdatePanelistProfileViewController.h"
#import <OPGSDK/OPGSDK.h>

@interface UpdatePanelistProfileViewController ()

@end

@implementation UpdatePanelistProfileViewController

@synthesize panelTitle,firstName,lastName,mobileNumber,address1,address2,dob,gender,postalCode,email;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.panelTitle.delegate=self;
    self.firstName.delegate=self;
    self.lastName.delegate=self;
    self.mobileNumber.delegate=self;
    self.address1.delegate=self;
    self.address2.delegate=self;
    self.dob.delegate=self;
    self.gender.delegate=self;
    self.postalCode.delegate=self;
    self.email.delegate=self;
    
    
    datePicker=[[UIDatePicker alloc]init];
    datePicker.datePickerMode=UIDatePickerModeDate;
    [self.dob setInputView:datePicker];
    UIToolbar *toolBar=[[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
    [toolBar setTintColor:[UIColor grayColor]];
    UIBarButtonItem *doneBtn=[[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(ShowSelectedDate)];
    UIBarButtonItem *space=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *cancel=[[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(CancelPressed)];
    [toolBar setItems:[NSArray arrayWithObjects:cancel,space,doneBtn, nil]];
    [self.dob setInputAccessoryView:toolBar];

}

#pragma mark - Date Picker Methods
-(void)ShowSelectedDate
{   NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    self.dob.text=[NSString stringWithFormat:@"%@",[formatter stringFromDate:datePicker.date]];
    [self.dob resignFirstResponder];
}

-(void)CancelPressed
{
    [self.dob resignFirstResponder];
}

- (void)keyboardWillShow:(NSNotification *)notification
{
    self.viewHeight.constant = -170;//For example
    
    [self.view setNeedsUpdateConstraints];
}

-(void)keyboardWillHide:(NSNotification *)notification
{
    self.viewHeight.constant = 20;// iPhone5 height
    
    [self.view setNeedsUpdateConstraints];
}

#pragma mark - TextField delegates
-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if ([textField isEqual:postalCode] || [textField isEqual:gender] || [textField isEqual:dob] || [textField isEqual:address2] || [textField isEqual:address1])
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    }
}

-(void) textFieldDidEndEditing:(UITextField *)textField
{
    if ([textField isEqual:postalCode] || [textField isEqual:gender] || [textField isEqual:dob] || [textField isEqual:address2] || [textField isEqual:address1])
    {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    }
}




-(NSNumber*) stringToNumber : (NSString*) str
{
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    f.numberStyle = NSNumberFormatterDecimalStyle;
    NSNumber *myNumber = [f numberFromString:str];
    return myNumber;
}

-(OPGPanellistProfile*) getPanelistProfile
{
    OPGPanellistProfile *profileObj = [OPGPanellistProfile new];
    profileObj.title= self.panelTitle.text;
    profileObj.firstName = self.firstName.text;
    profileObj.lastName = self.lastName.text;
    profileObj.email = self.email.text;
    profileObj.mobileNumber = self.mobileNumber.text;
    profileObj.address1 = self.address1.text;
    profileObj.address2 = self.address2.text;
    profileObj.DOB= self.dob.text;
    profileObj.gender= [self stringToNumber:self.gender.text];
    profileObj.postalCode = self.postalCode.text;
    profileObj.std = @"213";                        //std is obtained from getCountries() api
    profileObj.mediaID = @"0";                      //New media ID can be obtained after uploading a new media using uploadMedia() api.
    return profileObj;
}

#pragma mark - IBAction
-(IBAction)updatePanelistProfile:(id)sender
{
    BOOL didUpdate;
    OPGSDK* sdk = [OPGSDK new];                   // Creating OPGSDK instance
    NSError *error;
    OPGPanellistProfile *profile = [self getPanelistProfile];
    if ([profile.firstName length]>0)
    {
        didUpdate = [sdk updatePanellistProfile:[self getPanelistProfile] error:&error];
    }
    else
    {
        didUpdate = NO;
    }
    
    
    if (didUpdate)
    {
        UIAlertController * alert = [UIAlertController
                                     alertControllerWithTitle:@"OPGSDK"
                                     message:@"Panelist Profile Updated Successfully!"
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
                                     message:@"Panelist Profile Update Failed"
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



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end

