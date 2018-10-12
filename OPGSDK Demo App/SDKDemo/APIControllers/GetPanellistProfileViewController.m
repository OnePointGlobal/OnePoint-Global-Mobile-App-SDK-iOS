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
    //NSLog(@"The additional Field String is %@", profile.additionalParams);
    //NSDictionary *dict = [self parseAdditionalFields:profile.additionalParams panelID:@"51599"];
    //NSLog(@"The additional Field Dictionary is %@", [dict allValues]);
    NSDictionary *profileDict = [self convertProfileToDictionary:profile panelID:@"51599"];
    NSLog(@"Final Panellist Profile is %@", profileDict);
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


-(NSDictionary*) parseAdditionalFields: (NSString*) additionalFieldStr panelID:(NSString*) panelID {
    NSMutableDictionary *additionalFieldsDict = [NSMutableDictionary new];
    NSArray *additionalFieldArray = [additionalFieldStr componentsSeparatedByString:@","];
    NSString* panelIDToRemove = [panelID stringByAppendingString:@"-"];
    for (NSString* field in additionalFieldArray) {
        if ([field containsString:panelIDToRemove]) {
            NSString* keyValuePair = [field stringByReplacingOccurrencesOfString:panelIDToRemove withString:@""];
            NSArray *keyValueArray = [keyValuePair componentsSeparatedByString:@":"];
            if([keyValueArray count]==2) {
                [additionalFieldsDict setObject:keyValueArray[1] forKey:keyValueArray[0]];
            }
        }
    }
    return additionalFieldsDict;
}


-(NSDictionary*) convertProfileToDictionary: (OPGPanellistProfile*) profile panelID:(NSString*) panelID{
    // WORK IN PROGRESS
    NSMutableDictionary *profileDict = [NSMutableDictionary new];
    if (profile == nil) {
        // empty dictionary
        return profileDict;
    }

    [profileDict setValue:profile.title forKey:@"Title"];
    [profileDict setValue:profile.address1 forKey:@"Address1"];
    [profileDict setValue:profile.address2 forKey:@"Address2"];
    [profileDict setValue:profile.DOB forKey:@"DOB"];
    [profileDict setValue:profile.email forKey:@"Email"];
    [profileDict setValue:profile.mobileNumber forKey:@"MobileNumber"];
    [profileDict setValue:profile.firstName forKey:@"FirstName"];
    [profileDict setValue:profile.lastName forKey:@"LastName"];
    [profileDict setValue:[profile.gender stringValue] forKey:@"Gender"];
    [profileDict setValue:profile.postalCode forKey:@"PostalCode"];
    [profileDict setValue:profile.mediaID forKey:@"MediaID"];

    // ADD ADDITIONAL FIELDS TO THE DICTIONARY
    NSString *additionalFieldString = profile.additionalParams;
    NSDictionary *additionalFieldsDict = [self parseAdditionalFields:additionalFieldString panelID:panelID];
    [profileDict addEntriesFromDictionary:additionalFieldsDict];
    return profileDict;
}

@end
