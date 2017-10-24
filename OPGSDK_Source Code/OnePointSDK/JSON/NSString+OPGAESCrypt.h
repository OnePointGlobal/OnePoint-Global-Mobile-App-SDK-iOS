//
//  NSString+AESCrypt.h
//
//  Created by Michael Sedlaczek, Gone Coding on 2011-02-22
//

#import <Foundation/Foundation.h>
#import "NSData+OPGAESCrypt.h"
#import "NSData+OPGBase64.h"

@interface NSString (OPGAESCrypt)

- (NSString *)AES256EncryptWithKey:(NSString *)key;
- (NSString *)AES256DecryptWithKey:(NSString *)key;

//+ (NSData*)encryptData:(NSData*)data :(NSData*)key :(NSData*)iv;

@end
