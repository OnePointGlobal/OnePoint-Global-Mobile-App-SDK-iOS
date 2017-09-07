//
//  DemoSurveyViewController.h
//  SDKDemoApp
//
//  Created by OnePoint Global on 06/10/16.
//  Copyright © 2016 opg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DemoSurveyViewController : UIViewController<UITextFieldDelegate>
@property(weak, nonatomic) IBOutlet UITextField *txtUsername;
@property(weak, nonatomic) IBOutlet UITextField *txtSharedKey;

@property(weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@end
