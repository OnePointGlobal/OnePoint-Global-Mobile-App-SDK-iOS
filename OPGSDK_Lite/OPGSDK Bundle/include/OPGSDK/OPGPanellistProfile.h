//
//  OPGPanellistProfile.h
//  OnePointSDK
//
//  Created by OnePoint Global on 02/08/16.
//  Copyright © 2016 OnePointGlobal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OPGCountry.h"

@interface OPGPanellistProfile : NSObject<NSCoding>
/*!
 * @brief title : //Mr/Ms/Mrs values 1/2/3 respectively.
 */
@property (nonatomic,strong) NSString *title;
/*!
 * @brief firstName : firstname
 */
@property (nonatomic,strong) NSString *firstName;
/*!
 * @brief lastName : lastname
 */
@property (nonatomic,strong) NSString *lastName;
/*!
 * @brief email : email
 */
@property (nonatomic,strong) NSString *email;
/*!
 * @brief mobileNumber : mobile number
 */
@property (nonatomic,strong) NSString *mobileNumber;
/*!
 * @brief address1 : address1
 */
@property (nonatomic,strong) NSString *address1;
/*!
 * @brief address2 : address2
 */
@property (nonatomic,strong) NSString *address2;
/*!
 * @brief  DOB : Date of birth (YYYY-MM-DD)
 */
@property (nonatomic,strong) NSString *DOB;
/*!
 * @brief gender : Number value of 1-male, 2-female
 */
@property (nonatomic,strong) NSNumber *gender;
/*!
 * @brief postalCode : postal code
 */
@property (nonatomic,strong) NSString *postalCode;
/*!
 * @brief mediaID : media ID of the panellist.
 */
@property (nonatomic,strong) NSString *mediaID;

/*! @brief countryName : Name of the country. */
@property (nonatomic,strong) NSString *countryName;

/*! @brief std : STD Code of the country. */
@property (nonatomic,strong) NSString *std;
@end
