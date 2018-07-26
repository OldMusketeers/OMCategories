//
//  NSString+Halo.h
//  HaloSlimFramework
//
//  Created by Jet on 16/1/21.
//
//

#import <UIKit/UIKit.h>

typedef enum
{
    ERichTypeEmail = 1<<0,
    ERichTypePhone = 1<<1,
    ERichTypeLink = 1<<2,
    ERichTypeAll = 1<<0|1<<1|1<<2,
}RichType;

extern const NSString *kRegexHttpLinkPattern;
extern const NSString *kRegexPhoneNmuberPattern;
extern const NSString *kRegexEmailAddrPattern;
extern const NSString *kStringHyperLinkTel;
extern const NSString *kStringHyperLinkHttp;
extern const NSString *kStringHyperLinkEmail ;

@interface NSString (Halo)

+ (NSString*)fileMD5:(NSString*)path;
+ (NSString*)stringWithLong:(long)number;
+ (NSString*)stringwithDouble:(double)number;
+ (NSString*)stringWithChar:(char)aChar;

//区分单复数返回字符串
+ (NSString *)getSingularOrPlural:(NSInteger)count singular:(NSString*)singular plural:(NSString *)plural;
+ (NSString *)formatSingularOrPlural:(NSInteger)count singular:(NSString*)singular plural:(NSString *)plural;

//decrypt & encrypt
- (NSString*)encryptWithKey:(NSString*)key;
- (NSString*)decryptWithKey:(NSString*)key;

//encode & decode
- (NSString*)MD5String;
- (NSString*)base64Encode;
- (NSString*)base64Decode;
- (NSData*)base64DecodeData;
- (NSString*)toHex;
- (NSData*)toBinData;
- (NSString*)unFormatNumber;
- (NSUInteger)hexStringToInt;
- (NSString*)hideNumber;
- (NSString*)generateKey:(NSInteger)number;
- (NSString*)trimSpaceAndReturn;

//encode all charaters
/**
 URL encode a string in utf-8.
 @return the encoded string.
 */
- (NSString *)stringByURLEncode;

/**
 URL decode a string in utf-8.
 @return the decoded string.
 */
- (NSString *)stringByURLDecode;

- (NSString*)encodeAsURIComponent;
- (NSString*)escapeHTML;
- (NSString*)unescapeHTML;
- (NSString *)stringByTrimmingTrailingWhitespaceAndNewlineCharacters;

- (BOOL)hasEmoji;
- (BOOL)oauthIsNumeric;
- (BOOL)isPureInt;
- (BOOL)isPureFloat;
- (BOOL)isNumeric;

//use for [@"%@ is test" format:str];
- (NSString *)format:(id)first, ...;

//get rich text to html
- (NSString *)richTextWith:(RichType)type;
- (NSString *)richTextWithSpecialColor:(UIColor *)color matchString:(NSString*)matchString subRange:(NSRange)subRange;

@end


@interface NSString (Size)

- (CGSize)sizeForFont:(UIFont *)font;

- (CGSize)sizeForFont:(UIFont*)font
    constrainedToSize:(CGSize)constraint
        lineBreakMode:(NSLineBreakMode)lineBreakMode;

- (CGSize)sizeForFont:(UIFont*)font
    constrainedToSize:(CGSize)constraint
        lineBreakMode:(NSLineBreakMode)lineBreakMode
          lineSpacing:(CGFloat)lineSpacing;

//字符长度
- (NSInteger)charLength;

//折算成汉字的长度, 两个英文字母占一个
- (NSInteger)hanziLength;

@end


@interface NSString (attributedString)
+ (NSMutableAttributedString *)getAttributedStringWithString:(NSString *)string color:(UIColor *)color font:(UIFont *)font;
+ (NSMutableAttributedString *)getAttributedStringWithString:(NSString *)string color:(UIColor *)color;
+ (NSMutableAttributedString *)getAttributedStringWithStringStrike:(NSString *)string color:(UIColor *)color;
+ (NSMutableAttributedString *)getAttributedStringWithStringUnderStrike:(NSString *)string color:(UIColor *)color;
@end
