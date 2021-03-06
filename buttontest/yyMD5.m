//
//  yyMD5.m
//  TaiduTrip
//
//  Created by yy on 15/12/9.
//  Copyright © 2015年 yy. All rights reserved.
//

#import "yyMD5.h"
#import "CommonCrypto/CommonDigest.h"

@interface NSString (md5)
-(NSString *) md5HexDigest;
@end

@implementation yyMD5

+(NSString *) md5: (NSString *) inPutText
{
    const char *cStr = [inPutText UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, strlen(cStr), result);
    
    return [[NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
             result[0], result[1], result[2], result[3],
             result[4], result[5], result[6], result[7],
             result[8], result[9], result[10], result[11],
             result[12], result[13], result[14], result[15]
             ] lowercaseString];
}

@end
