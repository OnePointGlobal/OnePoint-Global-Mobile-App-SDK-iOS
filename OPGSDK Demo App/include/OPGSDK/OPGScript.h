//
//  OPGScript.h
//  OnePointSDK
//
//  Created by OnePoint Global on 01/08/16.
//  Copyright © 2016 OnePointGlobal. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OPGScript : NSObject<NSCoding>
/*!
 * @brief surveyReference : The survey reference to the Survey.
 */
@property(nonatomic,strong) NSString *surveyReference;
/*!
 * @brief scriptFilePath : Path to the downloaded script.
 */
@property (nonatomic,strong) NSString *scriptFilePath;
/*!
 * @brief isSuccess : bool value of true indicates success and false indicates failure.
 */
@property (nonatomic,strong) NSNumber *isSuccess;
/*!
 * @brief statusMessage : Download status message.
 */
@property (nonatomic,strong) NSString *statusMessage;
@end
