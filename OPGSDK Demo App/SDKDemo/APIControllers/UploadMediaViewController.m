//
//  UploadMediaViewController.m
//  SDKDemo
//
//  Created by OnePoint Global on 04/10/16.
//  Copyright © 2016 opg. All rights reserved.
//

#import "UploadMediaViewController.h"
#import <OPGSDK/OPGSDK.h>

@interface UploadMediaViewController ()

@property(strong, nonatomic) NSString* mediaID;

@end

@implementation UploadMediaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)imagePickerController:(UIImagePickerController *)picker
        didFinishPickingImage:(UIImage *)image
                  editingInfo:(NSDictionary *)editingInfo
{
   NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,     NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSURL *photoUrl = [NSURL fileURLWithPath:documentsDirectory];
    NSURL *localPath = [photoUrl URLByAppendingPathComponent:@"savedImage"];
    NSData *data = UIImageJPEGRepresentation(image, 0.9);
    NSError *error = nil;
    [data writeToURL:localPath options:NSDataWritingAtomic error:&error];

    
    OPGSDK* sdk = [OPGSDK new];                   // Creating OPGSDK instance
    self.mediaID = [sdk uploadMediaFile:localPath.absoluteString error:&error];
    NSLog(@"Uploaded media ID is %@",_mediaID);
    
    [self dismissViewControllerAnimated:YES completion:nil];
    [self showAlert];
}

#pragma mark - IBAction
-(IBAction)uploadImage:(id)sender
{
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc]init];
    imagePickerController.delegate = self;
    imagePickerController.sourceType =  UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:imagePickerController animated:YES completion:nil];
}


-(void) showAlert
{
    if (self.mediaID==nil)
    {
        UIAlertController * alert = [UIAlertController
                                     alertControllerWithTitle:@"OPGSDKv1.5"
                                     message:@"Media upload failed!"
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
                                     alertControllerWithTitle:@"OPGSDKv1.5"
                                     message:[NSString stringWithFormat:@"Uploaded media ID is %@", self.mediaID]
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

@end
