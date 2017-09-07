//
//  GetPanelistProfileViewController.m
//  SDKDemo
//
//  Created by OnePoint Global on 04/10/16.
//  Copyright © 2016 opg. All rights reserved.
//

#import "GetPanellistProfileViewController.h"
#import <OPGSDK/OPGSDK.h>
#define kOFFSET_FOR_KEYBOARD 120.0

@interface GetPanellistProfileViewController ()

@end

@implementation GetPanellistProfileViewController
@synthesize panelTitle,firstName,lastName,mobileNumber,address1,address2,dob,gender,postalCode,email;


- (void)viewDidLoad
{
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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TextField delegates
-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - IBAction
-(IBAction)getPanelistProfile:(id)sender
{
    OPGSDK* sdk = [OPGSDK new];                   // Creating OPGSDK instance
    NSError *error;
    OPGPanellistProfile *profile = [sdk getPanellistProfile:&error];
    [self setProfile:profile];
}

-(void) setProfile : (OPGPanellistProfile*)profile
{
    self.panelTitle.text=profile.title;
    self.firstName.text=profile.firstName;
    self.lastName.text=profile.lastName;
    self.mobileNumber.text=profile.mobileNumber;
    self.address1.text=profile.address1;
    self.address2.text=profile.address2;
    self.dob.text=[profile.DOB substringWithRange:NSMakeRange(0, 10)];
    self.gender.text=[profile.gender stringValue];
    self.postalCode.text=profile.postalCode;
    self.email.text=profile.email;
}



@end
