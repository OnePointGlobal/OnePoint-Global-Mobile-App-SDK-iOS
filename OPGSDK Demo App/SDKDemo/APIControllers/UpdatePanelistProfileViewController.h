//
//  UpdatePanelistProfileViewController.h
//  SDKDemo
//
//  Created by OnePoint Global on 04/10/16.
//  Copyright © 2016 opg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UpdatePanelistProfileViewController : UIViewController<UITextFieldDelegate>
{
    UIDatePicker *datePicker;
}

@property (weak, nonatomic) IBOutlet UITextField *panelTitle;
@property (weak, nonatomic) IBOutlet UITextField *firstName;
@property (weak, nonatomic) IBOutlet UITextField *lastName;
@property (weak, nonatomic) IBOutlet UITextField *email;
@property (weak, nonatomic) IBOutlet UITextField *mobileNumber;
@property (weak, nonatomic) IBOutlet UITextField *address1;
@property (weak, nonatomic) IBOutlet UITextField *address2;
@property (weak, nonatomic) IBOutlet UITextField *dob;
@property (weak, nonatomic) IBOutlet UITextField *gender;
@property (weak, nonatomic) IBOutlet UITextField *postalCode;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewHeight;

@end
