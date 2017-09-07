//
//  DownloadMediaViewController.h
//  SDKDemo
//
//  Created by OnePoint Global on 04/10/16.
//  Copyright © 2016 opg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DownloadMediaViewController : UIViewController<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *mediaId;
@property (weak, nonatomic) IBOutlet UITextField *mediaType;

@end
