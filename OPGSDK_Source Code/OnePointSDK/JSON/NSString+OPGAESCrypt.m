//
//  NSString+AESCrypt.m
//
//  Created by Michael Sedlaczek, Gone Coding on 2011-02-22
//

#import "NSString+OPGAESCrypt.h"
#import "NSData+OPGBase64.h"
#import "OPGCryptoTransform.h"


#define OPG_MAX_VALUE 10000000000000000
#define OPG_MIN_VALUE 1000000000000000

#define OPG_IV_LENGTH 16

NSData *keyDataOPG;

@implementation NSString (OPGAESCrypt)

+ (NSString *)base64String:(NSString *)str
{
    NSData *theData = [str dataUsingEncoding: NSASCIIStringEncoding];
    const uint8_t* input = (const uint8_t*)[theData bytes];
    NSInteger length = [theData length];
    
    static char table[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";
    
    NSMutableData* data = [NSMutableData dataWithLength:((length + 2) / 3) * 4];
    uint8_t* output = (uint8_t*)data.mutableBytes;
    
    NSInteger i;
    for (i=0; i < length; i += 3) {
        NSInteger value = 0;
        NSInteger j;
        for (j = i; j < (i + 3); j++) {
            value <<= 8;
            
            if (j < length) {
                value |= (0xFF & input[j]);
            }
        }
        
        NSInteger theIndex = (i / 3) * 4;
        output[theIndex + 0] =                    table[(value >> 18) & 0x3F];
        output[theIndex + 1] =                    table[(value >> 12) & 0x3F];
        output[theIndex + 2] = (i + 1) < length ? table[(value >> 6)  & 0x3F] : '=';
        
        output[theIndex + 3] = (i + 2) < length ? table[(value >> 0)  & 0x3F] : '=';
    }
    
    return [[[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding]autorelease];
}

-(NSData *)GenerateIV
{
    unsigned long long iv;
    iv = arc4random()%(OPG_MAX_VALUE-OPG_MIN_VALUE)+OPG_MIN_VALUE; // this number is the random 16 digit IV that needs to be prefixed
    NSString *IVString = [NSString base64String:[NSString stringWithFormat:@"%llu",iv]];
    //NSLog(@"IVString %@", IVString);

      return  [[[NSData alloc]initWithBase64EncodedString:IVString] autorelease];// iv is converted base 64
}


- (NSString *)AES256EncryptWithKey:(NSString *)key
{
    //Create new random IV (self is the plainText)
    NSData *IVData = [self GenerateIV];
    
    //Initialize encryptor now that the IV is set
    keyDataOPG = [[[NSData alloc]initWithBase64EncodedString:key] autorelease];
    
    //Convert string to Bytes as Unicode to ensure all languages are handled
    NSData *plainBytes = [self dataUsingEncoding:NSUTF16LittleEndianStringEncoding]; 

    //Encrypt plain bytes
    NSData *encryptedData = [OPGCryptoTransform createEncryptor:plainBytes:keyDataOPG:IVData];
    
    //Add IV to the beginning of the encrypted bytes
    NSMutableData *secureBytes = [[[NSMutableData alloc]init] autorelease];
    [secureBytes appendData:IVData];
    [secureBytes appendData:encryptedData];

    // return encrypted bytes as a string
    return [secureBytes base64Encoding];
}



- (NSString *)AES256DecryptWithKey:(NSString *)key
{
    //Convert encrypted string to bytes (self is the secureText)
    NSData *secureBytes = [[NSData alloc]initWithBase64EncodedString:self]; 
    
    //Take IV from the beginning of secureBytes
    NSData *IVData =[secureBytes subdataWithRange:NSMakeRange(0, OPG_IV_LENGTH)]; //= [[[NSData alloc]init] autorelease];
    
    //Initialize decryptor now that the IV is set
    NSData *enclosedData=[secureBytes subdataWithRange:NSMakeRange(OPG_IV_LENGTH, [secureBytes length]-OPG_IV_LENGTH)];// = [[[NSData alloc]init] autorelease];
    
    //decrypt bytes after IV
    NSData *decryptedData = [OPGCryptoTransform createDecryptor:enclosedData:[[[NSData alloc]initWithBase64EncodedString:key] autorelease]:IVData];
     
    //return decrypted bytes as a string base on NSUTF16 LE to cover all languages
    return [[[NSString alloc] initWithData:decryptedData encoding:NSUTF16LittleEndianStringEncoding] autorelease];
    
}




@end
