//
//  OPGDownloadMedia.h
//  OnePointSDK
//
//  Created by OnePoint Global on 02/08/16.
//  Copyright © 2016 OnePointGlobal. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OPGDownloadMedia : NSObject<NSCoding>
/*!
 * @brief isSuccess : bool value of true indicates success and false indicates failure.
 */
@property (nonatomic,strong) NSNumber *isSuccess;
/*!
 * @brief mediaFilePath : Path to the downloaded media file.
 */
@property (nonatomic,strong) NSString *mediaFilePath;

/*!
 * @brief statusMessage : Download status message.
 */
@property (nonatomic,strong) NSString *statusMessage;
@end
