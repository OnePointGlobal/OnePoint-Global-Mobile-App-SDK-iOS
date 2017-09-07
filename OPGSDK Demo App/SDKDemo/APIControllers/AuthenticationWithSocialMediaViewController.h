//
//  AuthenticationWithSocialMediaViewController.h
//  SDKDemoApp
//
//  Created by OnePoint Global on 01/12/16.
//  Copyright © 2016 opg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AuthenticationWithSocialMediaViewController : UIViewController<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *googleToken;
@property (weak, nonatomic) IBOutlet UITextField *facebookToken;
@end
