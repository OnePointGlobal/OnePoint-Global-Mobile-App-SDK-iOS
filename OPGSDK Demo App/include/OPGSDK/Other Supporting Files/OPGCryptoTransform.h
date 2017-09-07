//
//  OPGCryptoTransform.h
//  AES256Crypto
//
//  Copyright (c) 2012 One Point Surveys India. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonCryptor.h>
#import <CommonCrypto/CommonKeyDerivation.h>

@interface OPGCryptoTransform : NSObject
//+ (NSData*)encryptData:(NSData*)data :(NSData*)key :(NSData*)iv;
+ (NSData*)createEncryptor:(NSData*)data :(NSData*)key :(NSData*)iv;
//+ (NSData*)decryptData:(NSData*)data :(NSData*)key :(NSData*)iv;
+ (NSData*)createDecryptor:(NSData*)data :(NSData*)key :(NSData*)iv;
@end
