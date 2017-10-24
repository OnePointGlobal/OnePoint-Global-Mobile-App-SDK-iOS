//
//  OPGUploadResult.h
//  OnePointSDK
//
//  Created by OnePoint Global on 17/01/17.
//  Copyright © 2017 OnePointGlobal. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OPGUploadResult : NSObject<NSCoding>
/*! @brief isSuccess : bool value of true indicates success and false indicates failure. */
@property (nonatomic,strong) NSNumber *isSuccess;
/*! @brief statusMessage : Authentication Status. */
@property (nonatomic,strong) NSString *statusMessage;
@end
