//
//  NSData+Halo.m
//  HaloSlimFramework
//
//  Created by Jet on 16/1/21.
//
//
#import "NSData+Halo.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>
#import "Base64.hh"
#import "zlib.h"


@implementation NSData (Halo)
- (NSString *) base64Encode
{
    char *cStr = (char*)[self bytes];
    char *tmp = Base64Encode(cStr, (int)[self length]);
    NSString *result = [NSString stringWithCString:tmp encoding:NSASCIIStringEncoding];
    free(tmp);
    return result;
}

- (NSData *)gzipInflate
{
    if ([self length] == 0)return self;
    
    unsigned full_length = (unsigned)[self length];
    unsigned half_length = (unsigned)[self length] / 2;
    
    NSMutableData *decompressed = [NSMutableData dataWithLength: full_length + half_length];
    BOOL done = NO;
    int status;
    
    z_stream strm;
    strm.next_in = (Bytef *)[self bytes];
    strm.avail_in = (uInt)[self length];
    strm.total_out = 0;
    strm.zalloc = Z_NULL;
    strm.zfree = Z_NULL;
    
    if (inflateInit2(&strm, (15+32))!= Z_OK)return nil;
    while (!done)
    {
        // Make sure we have enough room and reset the lengths.
        if (strm.total_out >= [decompressed length])
            [decompressed increaseLengthBy: half_length];
        strm.next_out = (Bytef*)[decompressed mutableBytes] + strm.total_out;
        strm.avail_out = (uInt)([decompressed length] - strm.total_out);
        
        // Inflate another chunk.
        status = inflate (&strm, Z_SYNC_FLUSH);
        if (status == Z_STREAM_END)done = YES;
        else if (status != Z_OK)break;
    }
    if (inflateEnd (&strm)!= Z_OK)return nil;
    
    // Set real length.
    if (done)
    {
        [decompressed setLength: strm.total_out];
        return [NSData dataWithData: decompressed];
    }
    else return nil;
}

- (NSData *)gzipDeflate
{
    if ([self length] == 0)return self;
    
    z_stream strm;
    
    strm.zalloc = Z_NULL;
    strm.zfree = Z_NULL;
    strm.opaque = Z_NULL;
    strm.total_out = 0;
    strm.next_in=(Bytef *)[self bytes];
    strm.avail_in = (uInt)[self length];
    
    // Compresssion Levels:
    //   Z_NO_COMPRESSION
    //   Z_BEST_SPEED
    //   Z_BEST_COMPRESSION
    //   Z_DEFAULT_COMPRESSION
    
    if (deflateInit2(&strm, Z_DEFAULT_COMPRESSION, Z_DEFLATED, (15+16), 8, Z_DEFAULT_STRATEGY)!= Z_OK)return nil;
    
    NSMutableData *compressed = [NSMutableData dataWithLength:16384];  // 16K chunks for expansion
    
    do {
        
        if (strm.total_out >= [compressed length])
            [compressed increaseLengthBy: 16384];
        
        strm.next_out = (Bytef*)[compressed mutableBytes] + strm.total_out;
        strm.avail_out = (uInt)([compressed length] - strm.total_out);
        
        deflate(&strm, Z_FINISH);
        
    } while (strm.avail_out == 0);
    
    deflateEnd(&strm);
    
    [compressed setLength: strm.total_out];
    return [NSData dataWithData:compressed];
}

- (NSString*)MD5String
{
    char *cStr = (char*)[self bytes];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, (CC_LONG)[self length], digest );
    NSString *s = [NSString stringWithFormat: @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                   digest[0], digest[1],
                   digest[2], digest[3],
                   digest[4], digest[5],
                   digest[6], digest[7],
                   digest[8], digest[9],
                   digest[10], digest[11],
                   digest[12], digest[13],
                   digest[14], digest[15]];
    return s;
    
}

- (int8_t)readInt8:(NSNumber**)offset
{
    NSInteger off = [*offset intValue];
    int8_t result = *((int8_t*)[self subdataWithRange:NSMakeRange(off,1)].bytes);
    *offset = [NSNumber numberWithInt:(int)(off+1)];
    return result;
}

- (int16_t)readInt16:(NSNumber**)offset
{
    NSInteger off = [*offset intValue];
    int16_t result = *((int16_t*)[self subdataWithRange:NSMakeRange(off,2)].bytes);
    *offset = [NSNumber numberWithInt:(int)off+2];
    return result;
}

- (int32_t)readInt32:(NSNumber**)offset
{
    NSInteger off = [*offset intValue];
    int32_t result = *((int32_t*)[self subdataWithRange:NSMakeRange(off,4)].bytes);
    *offset = [NSNumber numberWithInt:(int)off+4];
    return result;
}

- (int64_t)readInt64:(NSNumber**)offset
{
    NSInteger off = [*offset intValue];
    int64_t result = *((int64_t*)[self subdataWithRange:NSMakeRange(off,8)].bytes);
    *offset = [NSNumber numberWithInt:(int)off+8];
    return result;
}

- (NSString*)readCharacter:(NSNumber**)offset
{
    NSInteger off = [*offset intValue];
    int32_t textLength = *((int32_t*)[self subdataWithRange:NSMakeRange(off,4)].bytes);
    off += 4;
    NSString *result = [NSString stringWithUTF8String:(char*)[self subdataWithRange:NSMakeRange(off,textLength)].bytes];
    *offset = [NSNumber numberWithInt:(int)off+textLength];
    return result;
}

- (NSData*)readData:(NSNumber**)offset
{
    NSInteger off = [*offset intValue];
    int32_t length = *((int32_t*)[self subdataWithRange:NSMakeRange(off,4)].bytes);
    off += 4;
    NSData *subData = [self subdataWithRange:NSMakeRange(off,length)];
    *offset = [NSNumber numberWithInt:[*offset intValue]+length];
    return subData;
}


- (NSData*)encryptWithKey:(NSString*)key
{
    // 'key' should be 32 bytes for AES256, will be null-padded otherwise
    char keyPtr[kCCKeySizeAES256 + 1]; // room for terminator (unused)
    bzero(keyPtr, sizeof(keyPtr)); // fill with zeroes (for padding)
    
    // fetch key data
    [key getCString:keyPtr maxLength:sizeof(keyPtr)encoding:NSUTF8StringEncoding];
    
    NSUInteger dataLength = [self length];
    
    //See the doc: For block ciphers, the output size will always be less than or
    //equal to the input size plus the size of one block.
    //That's why we need to add the size of one block here
    size_t bufferSize           = dataLength + kCCBlockSizeAES128;
    void *buffer                = malloc(bufferSize);
    
    size_t numBytesEncrypted    = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt, kCCAlgorithmAES128, kCCOptionECBMode+kCCOptionPKCS7Padding,
                                          keyPtr, kCCKeySizeAES128,
                                          NULL /*initialization vector (optional)*/,
                                          [self bytes], dataLength, /*input */
                                          buffer, bufferSize, /*output */
                                          &numBytesEncrypted);
    
    if (cryptStatus == kCCSuccess)
    {
        //the returned NSData takes ownership of the buffer and will free it on deallocation
        return [NSMutableData dataWithBytesNoCopy:buffer length:numBytesEncrypted];
    }
    
    free(buffer); //free the buffer;
    return nil;
}

- (NSData*)decryptWithKey:(NSString*)key
{
    char keyPtr[kCCKeySizeAES128+1]; // room for terminator (unused)// oorspronkelijk 256
    bzero(keyPtr, sizeof(keyPtr)); // fill with zeroes (for padding)
    
    // fetch key data
    [key getCString:keyPtr maxLength:sizeof(keyPtr)encoding:NSUTF8StringEncoding];
    
    NSUInteger dataLength = [self length];
    
    //See the doc: For block ciphers, the output size will always be less than or
    //equal to the input size plus the size of one block.
    //That's why we need to add the size of one block here
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    
    size_t numBytesDecrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt, kCCAlgorithmAES128, kCCOptionECBMode+kCCOptionPKCS7Padding,
                                          keyPtr, kCCKeySizeAES128, // oorspronkelijk 256
                                          NULL /*initialization vector (optional)*/,
                                          [self bytes], dataLength, /*input */
                                          buffer, bufferSize, /*output */
                                          &numBytesDecrypted);
    
    if (cryptStatus == kCCSuccess)
    {
        //the returned NSData takes ownership of the buffer and will free it on deallocation
        return [NSData dataWithBytesNoCopy:buffer length:numBytesDecrypted];
    }
    free(buffer); //free the buffer;
    return nil;
}
@end
