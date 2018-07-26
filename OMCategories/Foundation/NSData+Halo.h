//
//  NSData+Halo.h
//  HaloSlimFramework
//
//  Created by Jet on 16/1/21.
//
//

#import <Foundation/Foundation.h>

@interface NSData (Halo)
- (NSString *)base64Encode;
- (NSData *)gzipInflate;
- (NSData *)gzipDeflate;
- (NSString*)MD5String;
- (int8_t)readInt8:(NSNumber**)offset;
- (int16_t)readInt16:(NSNumber**)offset;
- (int32_t)readInt32:(NSNumber**)offset;
- (int64_t)readInt64:(NSNumber**)offset;
- (NSString*)readCharacter:(NSNumber**)offset;
- (NSData*)readData:(NSNumber**)offset;
- (NSData*)encryptWithKey:(NSString*)key;
- (NSData*)decryptWithKey:(NSString*)key;
@end
