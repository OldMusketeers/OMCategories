//
//  NSString+Halo.m
//  HaloSlimFramework
//
//  Created by Jet on 16/1/21.
//
//

#import "NSString+Halo.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>
#import <CommonCrypto/CommonHMAC.h>
#import "Base64.hh"
#import "NSArray+Halo.h"
#import "UIColor+Halo.h"
#import <objc/runtime.h>
#import "NSData+Halo.h"
#import <CoreText/CTFont.h>
#import <CoreText/CTStringAttributes.h>

const NSString *kRegexHttpLinkPattern = @"(?=[\\x00-\\x7f])(((([hH][tT][tT][pP]|[fF][tT][pP]|[hH][tT][tT][pP][sS]):\\/\\/){0}[a-zA-Z-_]+)|((([hH][tT][tT][pP]|[fF][tT][pP]|[hH][tT][tT][pP][sS]):\\/\\/){1}[\\da-zA-Z-_]+))(\\.[\\w\\-_]+)+([\\w\\-\\.,@?^=%&amp;:/~\\+#]*[\\w\\-\\@?^=%&amp;/~\\+#])?(?<=[\\x00-\\x7f])";
const NSString *kRegexPhoneNmuberPattern = @"([+]{0,1}[0-9]{1,3}[-| ]{0,1}[0-9]{1,4}[-| ]{0,1}[0-9]{1,4}[-| ]{0,1}[0-9]{1,4})";
const NSString *kRegexEmailAddrPattern = @"[\\b\\w-]+(\\.[\\w-]+)*@[\\w-]+(\\.[\\w-]+)+\\b";

const NSString *kStringHyperLinkTel = @"tel:";
const NSString *kStringHyperLinkHttp = @"http:";
const NSString *kStringHyperLinkEmail = @"email:";


@interface NSTextCheckingResult(test)
@property(nonatomic,strong)id userInfo;
@end

@implementation NSTextCheckingResult(test)
static char const * const userInfoKey = "userInfo";
- (id)userInfo
{
    return (id)objc_getAssociatedObject(self, userInfoKey);
}

- (void)setUserInfo:(id)userInfo
{
    objc_setAssociatedObject(self, userInfoKey, userInfo, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
@end


@implementation NSString (Halo)

#define CHUNK_SIZE 1024
+(NSString*)fileMD5:(NSString*)path
{
    NSFileHandle *handle = [NSFileHandle fileHandleForReadingAtPath:path];
    if( handle== nil )return nil; // file didnt exist
    
    CC_MD5_CTX md5;
    
    CC_MD5_Init(&md5);
    
    BOOL done = NO;
    while(!done)
    {
        NSData *fileData = [handle readDataOfLength: CHUNK_SIZE ];
        CC_MD5_Update(&md5, [fileData bytes], (CC_LONG)[fileData length]);
        if( [fileData length] == 0 )done = YES;
    }
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5_Final(digest, &md5);
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

- (NSString*)MD5String
{
    if (self.length == 0)
    {
        return @"";
    }
    const char *cStr = [self UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), digest);
    
    char md5string[CC_MD5_DIGEST_LENGTH*2];
    
    int i;
    for(i = 0; i < CC_MD5_DIGEST_LENGTH; i++){
        sprintf(md5string+i*2, "%02x", digest[i]);
    }
    
    return [NSString stringWithCString:md5string encoding:NSASCIIStringEncoding];
    // return [NSString stringWithCString:md5string length:CC_MD5_DIGEST_LENGTH*2];
}

- (NSString *)base64Encode
{
    if (self.length == 0)
    {
        return self;
    }
    const char *cStr = [self UTF8String];
    char *tmp = Base64Encode(cStr, (int)strlen(cStr));
    NSString *result = [NSString stringWithCString:tmp encoding:NSUTF8StringEncoding];
    free(tmp);
    
    return result;
}

- (NSString*) base64Decode
{
    if (self.length == 0)
    {
        return self;
    }
    unsigned char DataBuffer[1];
    DataBuffer[0] = 0;
    
    
    NSMutableData *data = [NSMutableData dataWithData:[self base64DecodeData]];
    [data appendBytes:&DataBuffer length:1];
    
    NSString *result = [NSString stringWithUTF8String:(char*)[data bytes]];
    return result;
}

- (NSData*) base64DecodeData
{
    if (self.length == 0)
    {
        return nil;
    }
    int aOutLen = 0;
    const char *cStr = [self UTF8String];
    char *tmp = Base64Decode(cStr, (int)strlen(cStr), aOutLen);
    NSData *data = [NSData dataWithBytes:tmp length:aOutLen];
    free(tmp);
    return data;
}
- (NSString*)toHex
{
    NSMutableString *hex = [NSMutableString string];
    for (int i=0; i<[self length]; i++)
    {
        unichar c = [self characterAtIndex:i] & 0xFF;
        [hex appendFormat:@"%02x",c];
    }
    return hex;
}

- (NSData*)toBinData
{
    NSMutableData *data = [NSMutableData data];
    int idx;
    for (idx = 0; idx+2 <= self.length; idx+=2){
        NSRange range = NSMakeRange(idx, 2);
        NSString *hexStr = [self substringWithRange:range];
        NSScanner *scanner = [NSScanner scannerWithString:hexStr];
        unsigned int intValue;
        [scanner scanHexInt:&intValue];
        [data appendBytes:&intValue length:1];
    }
    return data;
}

- (NSString*)encryptWithKey:(NSString*)key
{
    NSData *data = [[self dataUsingEncoding:NSUTF8StringEncoding] encryptWithKey:key];
    NSString *result = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
    return [result toHex];
}

- (NSString*)decryptWithKey:(NSString*)key
{
    NSData *data = [[self toBinData] decryptWithKey:key];
    NSString *result = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
    return result;
}

+ (NSString*)stringWithLong:(long)number
{
    NSNumber *num = [NSNumber numberWithLong:number];
    return [num stringValue];
}
+ (NSString*)stringwithDouble:(double)number
{
    NSNumber *num = [NSNumber numberWithDouble:number];
    return [num stringValue];
}

+ (NSString*)stringWithChar:(char)aChar
{
    NSString *string = [NSString stringWithFormat:@"%hhd",aChar];
    return string;
}

- (NSString*)unFormatNumber
{
    NSCharacterSet *nonDecimalDigits = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    NSMutableString *numberString = [NSMutableString stringWithCapacity:11];
    
    NSUInteger i, count;
    for (i=0, count=CFStringGetLength((CFStringRef)self); i<count; ++i)
    {
        unichar character = CFStringGetCharacterAtIndex((CFStringRef)self, i);
        if (character == '@')
        {
            return @"";
        }
        if (![nonDecimalDigits characterIsMember:character] || character=='p' || character==','
            || character=='#' || character=='*')
        {
            CFStringAppendCharacters((CFMutableStringRef)numberString, &character, 1);
        }
        else if ( i==0  && character=='+')
        {
            CFStringAppendCharacters((CFMutableStringRef)numberString, &character, 1);
        }
    }
    return numberString;
}

//- (NSString*)fileExt
//{
//	NSRange range = [self rangeOfString:@"." options:NSBackwardsSearch];
//	range.length = self.length - range.location;
//	return [self substringWithRange:range];
//}
//for  example "0xfafaf4ff" to int
- (NSUInteger)hexStringToInt
{
    unsigned int hexValue = 0;
    NSScanner *scanner = [[NSScanner alloc] initWithString:self];
    [scanner scanHexInt:&hexValue];
    return hexValue;
}

- (NSString*)hideNumber
{
    NSMutableString *number = [NSMutableString stringWithString:[self unFormatNumber]];
    if (number.length < 8)
    {
        return @"******";
    }
    NSInteger pos = number.length - 8;
    [number replaceCharactersInRange:NSMakeRange(pos, 4)withString:@"****"];
    return number;
}

- (NSString*)generateKey:(NSInteger)number
{
    NSInteger sum = 0;
    for (NSInteger i = self.length - 1; i>=0; i--)
    {
        sum += [self characterAtIndex:i];
    }
    NSInteger code = sum ^ number;
    NSString *codeMd5 = [[NSString stringWithFormat:@"%ld",(long)code] MD5String];
    NSMutableString *key = [NSMutableString stringWithCapacity:16];
    
    for (NSInteger i = 0; i < codeMd5.length; i += 2)
    {
        unichar c = [codeMd5 characterAtIndex:i];
        [key appendFormat:@"%C",c];
    }
    return key;
}

- (NSString*)trimSpaceAndReturn
{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (NSString *)stringByURLEncode {
    if ([self respondsToSelector:@selector(stringByAddingPercentEncodingWithAllowedCharacters:)]) {
        /**
         AFNetworking/AFURLRequestSerialization.m
         
         Returns a percent-escaped string following RFC 3986 for a query string key or value.
         RFC 3986 states that the following characters are "reserved" characters.
         - General Delimiters: ":", "#", "[", "]", "@", "?", "/"
         - Sub-Delimiters: "!", "$", "&", "'", "(", ")", "*", "+", ",", ";", "="
         In RFC 3986 - Section 3.4, it states that the "?" and "/" characters should not be escaped to allow
         query strings to include a URL. Therefore, all "reserved" characters with the exception of "?" and "/"
         should be percent-escaped in the query string.
         - parameter string: The string to be percent-escaped.
         - returns: The percent-escaped string.
         */
        static NSString * const kAFCharactersGeneralDelimitersToEncode = @":#[]@"; // does not include "?" or "/" due to RFC 3986 - Section 3.4
        static NSString * const kAFCharactersSubDelimitersToEncode = @"!$&'()*+,;=";
        
        NSMutableCharacterSet * allowedCharacterSet = [[NSCharacterSet URLQueryAllowedCharacterSet] mutableCopy];
        [allowedCharacterSet removeCharactersInString:[kAFCharactersGeneralDelimitersToEncode stringByAppendingString:kAFCharactersSubDelimitersToEncode]];
        static NSUInteger const batchSize = 50;
        
        NSUInteger index = 0;
        NSMutableString *escaped = @"".mutableCopy;
        
        while (index < self.length) {
            NSUInteger length = MIN(self.length - index, batchSize);
            NSRange range = NSMakeRange(index, length);
            // To avoid breaking up character sequences such as 👴🏻👮🏽
            range = [self rangeOfComposedCharacterSequencesForRange:range];
            NSString *substring = [self substringWithRange:range];
            NSString *encoded = [substring stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacterSet];
            [escaped appendString:encoded];
            
            index += range.length;
        }
        return escaped;
    } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        CFStringEncoding cfEncoding = CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding);
        NSString *encoded = (__bridge_transfer NSString *)
        CFURLCreateStringByAddingPercentEscapes(
                                                kCFAllocatorDefault,
                                                (__bridge CFStringRef)self,
                                                NULL,
                                                CFSTR("!#$&'()*+,/:;=?@[]"),
                                                cfEncoding);
        return encoded;
#pragma clang diagnostic pop
    }
}

- (NSString *)stringByURLDecode {
    if ([self respondsToSelector:@selector(stringByRemovingPercentEncoding)]) {
        return [self stringByRemovingPercentEncoding];
    } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        CFStringEncoding en = CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding);
        NSString *decoded = [self stringByReplacingOccurrencesOfString:@"+"
                                                            withString:@" "];
        decoded = (__bridge_transfer NSString *)
        CFURLCreateStringByReplacingPercentEscapesUsingEncoding(
                                                                NULL,
                                                                (__bridge CFStringRef)decoded,
                                                                CFSTR(""),
                                                                en);
        return decoded;
#pragma clang diagnostic pop
    }
}

- (NSString*)encodeAsURIComponent
{
    const char *p = [self UTF8String];
    NSMutableString *result = [NSMutableString string];
    
    for (;*p ;p++){
        unsigned char c = *p;
        if (('0' <= c && c <= '9') || ('a' <= c && c <= 'z') || ('A' <= c && c <= 'Z') || c == '-' || c == '_'){
            [result appendFormat:@"%c", c];
        } else {
            [result appendFormat:@"%%%02X", c];
        }
    }
    return result;
}

- (NSString*)escapeHTML
{
    NSMutableString *s = [NSMutableString string];
    
    int start = 0;
    int len = (int)[self length];
    NSCharacterSet *chs = [NSCharacterSet characterSetWithCharactersInString:@"<>&\""];
    
    while (start < len){
        NSRange r = [self rangeOfCharacterFromSet:chs options:0 range:NSMakeRange(start, len-start)];
        if (r.location == NSNotFound){
            [s appendString:[self substringFromIndex:start]];
            break;
        }
        
        if (start < r.location){
            [s appendString:[self substringWithRange:NSMakeRange(start, r.location-start)]];
        }
        
        switch ([self characterAtIndex:r.location]){
            case '<':
                [s appendString:@"&lt;"];
                break;
            case '>':
                [s appendString:@"&gt;"];
                break;
            case '"':
                [s appendString:@"&quot;"];
                break;
            case '&':
                [s appendString:@"&amp;"];
                break;
        }
        
        start = (int)r.location + 1;
    }
    
    return s;
}

- (NSString*)unescapeHTML
{
    NSMutableString *s = [NSMutableString string];
    NSMutableString *target = [self mutableCopy];
    NSCharacterSet *chs = [NSCharacterSet characterSetWithCharactersInString:@"&"];
    
    while ([target length] > 0){
        NSRange r = [target rangeOfCharacterFromSet:chs];
        if (r.location == NSNotFound){
            [s appendString:target];
            break;
        }
        
        if (r.location > 0){
            [s appendString:[target substringToIndex:r.location]];
            [target deleteCharactersInRange:NSMakeRange(0, r.location)];
        }
        
        if ([target hasPrefix:@"&lt;"]){
            [s appendString:@"<"];
            [target deleteCharactersInRange:NSMakeRange(0, 4)];
        } else if ([target hasPrefix:@"&gt;"]){
            [s appendString:@">"];
            [target deleteCharactersInRange:NSMakeRange(0, 4)];
        } else if ([target hasPrefix:@"&quot;"]){
            [s appendString:@"\""];
            [target deleteCharactersInRange:NSMakeRange(0, 6)];
        } else if ([target hasPrefix:@"&amp;"]){
            [s appendString:@"&"];
            [target deleteCharactersInRange:NSMakeRange(0, 5)];
        } else {
            [s appendString:@"&"];
            [target deleteCharactersInRange:NSMakeRange(0, 1)];
        }
    }
    
    return s;
}

- (NSString *)stringByTrimmingTrailingWhitespaceAndNewlineCharacters
{
    NSMutableString *result = [NSMutableString stringWithString:self];
    int count = (int)CFStringGetLength((CFStringRef)self);
    for (int i=count-1;i>=0; i--)
    {
        unichar character = CFStringGetCharacterAtIndex((CFStringRef)self, i);
        if (character == ' ' || character == '\r' || character == '\n')
        {
            CFStringDelete((CFMutableStringRef)result, CFRangeMake(i, 1));
        }
        else
        {
            break;
        }
    }
    return result;
    
}

- (BOOL)hasEmoji
{
    NSInteger count = self.length;
    for (NSInteger i = 0; i < count; i++)
    {
        NSInteger uicode = [self characterAtIndex:i];
        
        if (uicode >= 0xD83C && uicode <=0xD83D)
        {
            return YES;
        }
        if ((uicode >= 0x2100 && uicode < 0x3001) || (uicode >0x3011 && uicode <=0x3040))
        {
            return YES;
        }
        if (uicode >= 0x3200 && uicode <=0x32ff)
        {
            return YES;
        }
        else if ( uicode == 0x20e3 || uicode == 0x00A9 || uicode == 0x00AE)
        {
            return YES;
        }
        
    }
    return NO;
}


- (BOOL)oauthIsNumeric
{
    const char	*raw = (const char *) [self UTF8String];
    
    for (int i = 0; i < strlen(raw); i++)
    {
        if (raw[i] < '0' || raw[i] > '9')
        {
            return NO;
        }
    }
    return YES;
}

//判断是否为整形：
- (BOOL)isPureInt
{
    NSScanner* scan = [NSScanner scannerWithString:self];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
}

//判断是否为浮点形：
- (BOOL)isPureFloat
{
    NSScanner* scan = [NSScanner scannerWithString:self];
    float val;
    return[scan scanFloat:&val] && [scan isAtEnd];
}

- (BOOL)isNumeric
{
    return [self isPureInt] || [self isPureFloat];
}

+ (NSString *)getSingularOrPlural:(NSInteger)count singular:(NSString*)singular plural:(NSString *)plural
{
    return count != 1 ? plural : singular;
}

+ (NSString *)formatSingularOrPlural:(NSInteger)count singular:(NSString*)singular plural:(NSString *)plural
{
    NSString *fmt = count != 1 ? plural : singular;
    return [NSString stringWithFormat:fmt,count];
}

- (NSString *)format:(id)first, ...
{
    NSUInteger len = self.length;
    NSUInteger index = 0;
    BOOL passed = NO;
    do {
        unichar chr = [self characterAtIndex:index];
        if (chr == '%') {
            if (passed) {
                if ([self characterAtIndex:index - 1] == '%') {
                    passed = NO;
                } else {
                    break;
                }
            } else {
                passed = YES;
            }
        }
        index += 1;
    } while (index < len);
    
    if (index == len) {
        return [NSString stringWithFormat:self, first];
    } else {
        va_list args;
        va_start(args, first);
        NSString *result = [[NSString stringWithFormat:[self substringToIndex:index], first] stringByAppendingString:[NSString stringWithFormat:[self substringFromIndex:index] arguments:args]];
        va_end(args);
        return result;
    }
}

+ (NSString *)stringWithFormat:(NSString *)format arguments:(va_list)argList
{
    return [[self alloc] initWithFormat:format arguments:argList];
}

- (NSString *)richTextWith:(RichType)type
{
    NSArray *emailFilterArray = [NSArray array];
    NSArray *phoneFilterArray = [NSArray array];
    NSArray *linkFilterArray = [NSArray array];
    NSMutableArray *filterResult = [NSMutableArray array];
    
    NSMutableString *resultString = [NSMutableString string];
    NSRegularExpression* regex = nil;
    if (type & ERichTypeEmail)
    {
        regex = [[NSRegularExpression alloc]
                 initWithPattern:(NSString *)kRegexEmailAddrPattern
                 options:NSRegularExpressionCaseInsensitive|NSRegularExpressionDotMatchesLineSeparators
                 error:nil];
        emailFilterArray = [regex matchesInString:self options:0
                                            range:NSMakeRange(0, [self length])];
    }
    
    if (type & ERichTypeLink)
    {
        regex = [[NSRegularExpression alloc]
                 initWithPattern:(NSString *)kRegexHttpLinkPattern
                 options:NSRegularExpressionCaseInsensitive|NSRegularExpressionDotMatchesLineSeparators
                 error:nil];
        linkFilterArray = [regex matchesInString:self options:0
                                           range:NSMakeRange(0, [self length])];
    }
    
    if (type & ERichTypePhone)
    {
        regex = [[NSRegularExpression alloc]
                 initWithPattern:(NSString *)kRegexPhoneNmuberPattern
                 options:NSRegularExpressionCaseInsensitive|NSRegularExpressionDotMatchesLineSeparators
                 error:nil];
        phoneFilterArray = [regex matchesInString:self options:0
                                            range:NSMakeRange(0, [self length])];
    }
    //加入被识别的结果，按照优先级 email>link>phone
    [filterResult addObjectsFromArray:emailFilterArray];
    [self addRexArray:linkFilterArray targetArray:filterResult type:ERichTypeLink];
    [self addRexArray:phoneFilterArray targetArray:filterResult type:ERichTypePhone];
    
    //生成结果
    NSInteger locOffset = 0;
    NSString *tempStr = nil;
    NSString *typeString = nil;
    for(NSTextCheckingResult *textRes in filterResult)
    {
        if (textRes.userInfo)
        {
            typeString = [textRes.userInfo isEqual: @(ERichTypeLink)] ? (NSString *)kStringHyperLinkHttp : (NSString *)kStringHyperLinkTel ;
        }
        else
        {
            typeString = (NSString *)kStringHyperLinkEmail;
        }
        
        if ((NSInteger)textRes.range.location - locOffset > 0)
        {
            [resultString appendString:[self substringWithRange:NSMakeRange(locOffset, textRes.range.location - locOffset)]];
        }
        tempStr = [self substringWithRange:textRes.range];
        [resultString appendFormat:@"<a href='%@%@'>%@</a>",typeString,tempStr,tempStr];
        locOffset = NSMaxRange(textRes.range);
    }
    if (locOffset < self.length)
    {
        [resultString appendString:[self substringWithRange:NSMakeRange(locOffset, self.length - locOffset)]];
    }
    
    return resultString;
}

- (void)addRexArray:(NSArray *)rexArray targetArray:(NSMutableArray *)array type:(RichType)type;
{
    //降低了时间复杂度
    NSInteger i = 0;
    for(NSTextCheckingResult *textRes in rexArray)
    {
        BOOL couldRex = YES;
        for(; i < array.count ;)
        {
            NSTextCheckingResult *existRes = array[i];
            NSTextCheckingResult *existNextRes = array[i+1];
            if (textRes.range.location > NSMaxRange(existRes.range))
            {
                if (existNextRes && textRes.range.location < NSMaxRange(existRes.range))
                {
                    break;
                }
            }
            else if (NSLocationInRange(existRes.range.location, textRes.range) || NSLocationInRange(textRes.range.location, existRes.range))
            {
                couldRex = NO;
                break;
            }
            
            i++;
        }
        if (couldRex)
        {
            textRes.userInfo = @(type);
            [array insertObject:textRes atIndex:(i-1)];
        }
    }
}

- (NSString *)richTextWithSpecialColor:(UIColor *)color matchString:(NSString*)matchString subRange:(NSRange)subRange
{
    if (subRange.length == 0)
    {
        return self;
    }
    
    NSMutableString *resultString = [NSMutableString stringWithString:self];
    NSString *replaceString = [NSString stringWithFormat:@"<font color='%@'>%@</font>",[color hexString],matchString];
    [resultString replaceOccurrencesOfString:matchString withString:replaceString options:NSCaseInsensitiveSearch range:subRange];
    return resultString;
}

@end

@implementation NSString (Size)
- (CGSize)sizeForFont:(UIFont *)font
{
    CGSize size;
    
    NSDictionary* attribs = @{NSFontAttributeName:font};
    size = [self sizeWithAttributes:attribs];
    
    size = CGSizeMake(ceil(size.width), ceil(size.height));
    
    return size;
}

- (CGSize)sizeForFont:(UIFont*)font
    constrainedToSize:(CGSize)constraint
        lineBreakMode:(NSLineBreakMode)lineBreakMode
{
    return [self sizeForFont:font constrainedToSize:constraint lineBreakMode:lineBreakMode lineSpacing:0];
}

- (CGSize)sizeForFont:(UIFont*)font
    constrainedToSize:(CGSize)constraint
        lineBreakMode:(NSLineBreakMode)lineBreakMode
          lineSpacing:(CGFloat)lineSpacing
{
    CGSize size;
    
    NSMutableParagraphStyle *textStyle = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
    textStyle.lineBreakMode = lineBreakMode;
    textStyle.lineSpacing = lineSpacing;
    
    NSDictionary *attributes = @{
                                 NSFontAttributeName:font,
                                 NSParagraphStyleAttributeName:textStyle
                                 };
    
    size = [self boundingRectWithSize:constraint options: NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    
    size = CGSizeMake(ceil(size.width), ceil(size.height));
    
    return size;
}

- (NSInteger)charLength
{
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSData* da = [self dataUsingEncoding:enc];
    NSInteger count = [da length];
    
    return count;
}

- (NSInteger)hanziLength
{
    NSInteger count = ceil( ((double)[self charLength]) / 2 );
    
    return count;
}
@end


@implementation NSString (attributedString)

+ (NSMutableAttributedString *)getAttributedStringWithString:(NSString *)string color:(UIColor *)color font:(UIFont *)font {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string?:@""];
    [attributedString addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(0, string.length)];
    CTFontRef ctFont2 = CTFontCreateWithName((__bridge CFStringRef)font.fontName, font.pointSize,NULL);
    [attributedString addAttribute:(NSString *)(kCTFontAttributeName) value:(__bridge id)ctFont2 range:NSMakeRange(0, string.length)];
    CFRelease(ctFont2);
    
    return attributedString;
}

+ (NSMutableAttributedString *)getAttributedStringWithString:(NSString *)string color:(UIColor *)color {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string?:@""];
    [attributedString addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(0, string.length)];
    return attributedString;
}

+ (NSMutableAttributedString *)getAttributedStringWithStringStrike:(NSString *)string color:(UIColor *)color {
    NSMutableAttributedString *attributedString =
    [[NSMutableAttributedString alloc] initWithString:string?:@"" attributes:@{
                                                                               NSStrikethroughColorAttributeName:color,
                                                                               NSStrikethroughStyleAttributeName:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle)
                                                                               }];
    return attributedString;
}


+ (NSMutableAttributedString *)getAttributedStringWithStringUnderStrike:(NSString *)string color:(UIColor *)color {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
    
    [attributedString addAttribute:NSUnderlineColorAttributeName value:color range:NSMakeRange(0,string.length)];
    [attributedString addAttribute:NSUnderlineStyleAttributeName value:@(NSUnderlineStyleSingle|NSUnderlinePatternSolid) range:NSMakeRange(0,string.length)];
    [attributedString addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(0,string.length)];
    
    //    [attributedString addAttribute:NSUnderlineStyleAttributeName
    //                         value:[NSNumber numberWithInt:NSUnderlineStyleNone]
    //                         range:NSMakeRange(0, string.length)];
    //    [attributedString addAttribute:NSUnderlineStyleAttributeName
    //                         value:[NSNumber numberWithInt:NSUnderlineStyleSingle]
    //                         range:contentRange];
    //	[[NSMutableAttributedString alloc] initWithString:string?:@"" attributes:@{
    //					NSUnderlineColorAttributeName:color,
    //			NSUnderlineStyleAttributeName:@(NSUnderlineStyleNone)
    //			}];
    return attributedString;
}

@end