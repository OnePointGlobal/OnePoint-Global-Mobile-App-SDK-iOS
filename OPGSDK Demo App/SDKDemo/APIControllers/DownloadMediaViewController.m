//
//  DownloadMediaViewController.m
//  SDKDemo
//
//  Created by OnePoint Global on 04/10/16.
//  Copyright © 2016 opg. All rights reserved.
//

#import "DownloadMediaViewController.h"
#import <OPGSDK/OPGSDK.h>


@interface DownloadMediaViewController ()

@end

@implementation DownloadMediaViewController

@synthesize mediaId,mediaType;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.mediaType.delegate=self;
    self.mediaId.delegate=self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBAction
-(IBAction)downloadMedia:(id)sender
{
    OPGSDK* sdk = [OPGSDK new];                   // Creating OPGSDK instance
    NSError *error;
    OPGDownloadMedia *obj = [sdk downloadMediaFile:self.mediaId.text mediaType:self.mediaType.text error:&error];
    
    if ([obj.isSuccess intValue]==1 && error==nil)
    {
        UIAlertController * alert = [UIAlertController
                                     alertControllerWithTitle:@"OPGSDK"
                                     message:@"Media Downloaded Successfully!"
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

