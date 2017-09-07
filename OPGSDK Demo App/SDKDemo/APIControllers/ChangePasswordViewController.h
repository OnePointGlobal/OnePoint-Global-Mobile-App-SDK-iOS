//
//  ChangePasswordViewController.h
//  SDKDemo
//
//  Created by OnePoint Global on 04/10/16.
//  Copyright © 2016 opg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChangePasswordViewController : UIViewController<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *currPassword;
@property (weak, nonatomic) IBOutlet UITextField *newwPassword;

@end
