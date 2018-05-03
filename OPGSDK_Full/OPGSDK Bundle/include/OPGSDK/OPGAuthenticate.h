//
//  OPGAuthentication.h
//  OnePointSDK
//
//  Created by OnePoint Global on 01/08/16.
//  Copyright © 2016 OnePointGlobal. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OPGAuthenticate : NSObject<NSCoding>

/*! @brief httpStatusCode : HTTP Status Code */
@property (nonatomic,strong) NSNumber *httpStatusCode;
/*! @brief statusMessage : Authentication Status. */
@property (nonatomic,strong) NSString *statusMessage;
/*! @brief isSuccess : bool value of true indicates success and false indicates failure. */
@property (nonatomic,strong) NSNumber *isSuccess;
@end
