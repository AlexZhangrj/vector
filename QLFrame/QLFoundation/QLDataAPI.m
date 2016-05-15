//
//  QLDataTool.m
//  QLFoundation
//
//  Created by 王青海 on 16/1/28.
//  Copyright © 2016年 王青海. All rights reserved.
//

#import "QLDataAPI.h"
#import <CommonCrypto/CommonCryptor.h>
#import <CommonCrypto/CommonDigest.h>



@implementation QLDataAPI

+ (NSData*)AES256EncryptData:(NSData *)data key:(NSString*)key
{
    // 'key' should be 32 bytes for AES256, will be null-padded otherwise
    char keyPtr[kCCKeySizeAES256 + 1]; // room for terminator (unused)
    bzero(keyPtr, sizeof(keyPtr)); // fill with zeroes (for padding)
    
    // fetch key data
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    NSUInteger dataLength = [data length];
    
    //See the doc: For block ciphers, the output size will always be less than or
    //equal to the input size plus the size of one block.
    //That's why we need to add the size of one block here
    size_t bufferSize           = dataLength + kCCBlockSizeAES128;
    void* buffer                = malloc(bufferSize);
    
    size_t numBytesEncrypted    = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt, kCCAlgorithmAES128, kCCOptionPKCS7Padding,
                                          keyPtr, kCCKeySizeAES128,
                                          NULL /* initialization vector (optional) */,
                                          [data bytes], dataLength, /* input */
                                          buffer, bufferSize, /* output */
                                          &numBytesEncrypted);
    
    
    if (cryptStatus == kCCSuccess)
    {
        //the returned NSData takes ownership of the buffer and will free it on deallocation
        return [NSMutableData dataWithBytesNoCopy:buffer length:numBytesEncrypted];
    }
    
    free(buffer); //free the buffer;
    return nil;
}

+ (NSData*)AES256DecryptData:(NSData *)data key:(NSString*)key
{
    // 'key' should be 32 bytes for AES256, will be null-padded otherwise
    char keyPtr[kCCKeySizeAES256 + 1]; // room for terminator (unused)
    bzero(keyPtr, sizeof(keyPtr)); // fill with zeroes (for padding)
    
    // fetch key data
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    NSUInteger dataLength = [data length];
    
    //See the doc: For block ciphers, the output size will always be less than or
    //equal to the input size plus the size of one block.
    //That's why we need to add the size of one block here
    size_t bufferSize           = dataLength + kCCBlockSizeAES128;
    void* buffer                = malloc(bufferSize);
    
    size_t numBytesDecrypted    = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt, kCCAlgorithmAES128, kCCOptionPKCS7Padding,
                                          keyPtr, kCCKeySizeAES128,
                                          NULL /* initialization vector (optional) */,
                                          [data bytes], dataLength, /* input */
                                          buffer, bufferSize, /* output */
                                          &numBytesDecrypted);
    
    if (cryptStatus == kCCSuccess)
    {
        //the returned NSData takes ownership of the buffer and will free it on deallocation
        return [NSMutableData dataWithBytesNoCopy:buffer length:numBytesDecrypted];
    }
    
    free(buffer); //free the buffer;
    return nil;
}

+ (NSString *)AES256Create
{
    char tempKey[33];
    
    for (NSInteger i=0; i<32; i++) {
        NSInteger mm = arc4random() % 52;
        
        int8_t sec = mm / 26;
        int8_t offSet = mm % 26;
        
        switch (sec) {
            case 0:
            {
                tempKey[i] = ('a' + offSet);
            }
                break;
            case 1:
            {
                tempKey[i] = ('A' + offSet);
            }
                break;
            default:
                break;
        }
    }
    tempKey[32] = 0;
    return [NSString stringWithCString:tempKey encoding:NSUTF8StringEncoding];
}

+ (NSString *)base64EncodedData:(NSData *)data
{
    return [[NSString alloc] initWithData:[data base64EncodedDataWithOptions:NSDataBase64Encoding64CharacterLineLength] encoding:NSUTF8StringEncoding];
}

+ (NSData *)base64DecodedDataStr:(NSString *)str
{
    return [[NSData alloc] initWithBase64EncodedString:str options:NSDataBase64DecodingIgnoreUnknownCharacters];
}


//md5 32位 加密 （小写）
+ (NSString *)md5_32:(NSData *)data
{
    const void *cData = [data bytes];
    
    unsigned char result[32];
    //    CC_MD5_DIGEST_LENGTH
    CC_MD5(cData, data.length, result);
    NSMutableString * retStr = [NSMutableString string];
    for(int i = 0; i < 16; i++)
        [retStr appendFormat:@"%02x", result[i]];
    
    return [retStr lowercaseString];
}

+ (NSData *)dataWithUint32:(uint32_t)num
{
    uint32_t temNum = num;
    NSData *data = [NSData dataWithBytes:&temNum length:sizeof(uint32_t)];
    
    return data;
}

+ (NSMutableData *)mutableDataWithUint32:(uint32_t)num
{
    uint32_t temNum = num;
    NSMutableData *mdata = [NSMutableData dataWithBytes:&temNum length:sizeof(uint32_t)];
    
    return mdata;
}

@end
