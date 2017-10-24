//
//  OPGCryptoTransform.m
//  AES256Crypto
//
//  Copyright (c) 2012 One Point Surveys India. All rights reserved.
//

#import "OPGCryptoTransform.h"

const CCAlgorithm kOPGAlgorithm = kCCAlgorithmAES128;
const NSUInteger kOPGAlgorithmKeySize = kCCKeySizeAES128;
const NSUInteger kOPGAlgorithmBlockSize = kCCBlockSizeAES128;
const NSUInteger kOPGAlgorithmIVSize = kCCBlockSizeAES128;
const NSUInteger kOPGPBKDFSaltSize = 8;
const NSUInteger kOPGPBKDFRounds = 10000;  // ~80ms on an iPhone 4

@implementation OPGCryptoTransform


//+ (NSData*)encryptData:(NSData*)data :(NSData*)key :(NSData*)iv
+ (NSData*)createEncryptor:(NSData*)data :(NSData*)key :(NSData*)iv
{
    //    size_t bufferSize = [data length]*2;
    size_t bufferSize = [data length]*kCCBlockSizeAES128;
    
    void *buffer = malloc(bufferSize);
    size_t encryptedSize = 0;
    
    
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt, kCCAlgorithmAES128, kCCOptionPKCS7Padding,
                                          [key bytes], kCCKeySizeAES256, [iv bytes], [data bytes], [data length],
                                          buffer, bufferSize, &encryptedSize);
    if (cryptStatus == kCCSuccess)
        return [NSData dataWithBytesNoCopy:buffer length:encryptedSize];
    else
        free(buffer);
    return NULL;
    
    
    
}

//+ (NSData*)decryptData:(NSData*)data :(NSData*)key :(NSData*)iv//;
+ (NSData*)createDecryptor:(NSData*)data :(NSData*)key :(NSData*)iv
{
    NSData* result = nil;
    
    
    size_t bufferSize = [data length]*kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    
	if (buffer != nil)
	{
		size_t dataOutMoved = 0;
        
		CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt,
                                              kCCAlgorithmAES128,
                                              kCCOptionPKCS7Padding,
                                              [key bytes],
                                              kCCKeySizeAES256,
                                              [iv bytes],
                                              [data bytes],
                                              [data length],
                                              buffer,
                                              bufferSize,
                                              &dataOutMoved
                                              );
        
		if (cryptStatus == kCCSuccess) {
            result =  [NSData dataWithBytesNoCopy:buffer length:dataOutMoved];
        } else {
            NSLog(@"[ERROR] failed to decrypt| CCCryptoStatus: %d", cryptStatus);
			free(buffer);
		}
	}
    
	return result;
}

@end
