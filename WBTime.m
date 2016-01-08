//
//  WBTime.m
//  whubook2
//
//  Created by lxyy on 15/3/15.
//  Copyright (c) 2015年 lxyy. All rights reserved.
//

#import "WBTime.h"

@implementation WBTime



+(NSString *)unixTimestampWithNow
{
    NSDate *datenow = [NSDate date];//现在时间
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate:datenow];
    NSDate *localeDate = [datenow  dateByAddingTimeInterval: interval];
    //NSLog(@"localDate = %@", localeDate);
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[localeDate timeIntervalSince1970]];
    return timeSp;
}

+ (NSString *)getupdateTimeSp
{
    NSURL *url = [NSURL URLWithString:@"http://www.whubook.com/secure/time"];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    NSData *someData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString *strrr = [[NSString alloc] initWithData:someData encoding:NSUTF8StringEncoding];
    NSInteger *i = [strrr intValue];
    i = i-10;
    return [NSString stringWithFormat:@"%d",i];
}

+(NSDictionary *)userIdAnddoId
{
    NSString *timeSp = [self getupdateTimeSp];
    NSString *userId = [self useridEncryptionWithTimeSp:timeSp];
    
    NSMutableString *doIdstr = [NSMutableString stringWithString:timeSp];
    [doIdstr appendString:@"whubook"];
    NSString *doIdmd5 = [self md5:doIdstr];
    NSMutableString *doId = [NSMutableString stringWithString:@"85dc"];
    [doId appendString:doIdmd5];
    //NSLog(@"doId = %@",doId);
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:userId, @"userId", doId, @"doId", nil];
    return dic;
}

+(NSString *)userId
{
//    NSDate *datenow = [NSDate date];//现在时间,你可以输出来看下是什么格式
//    NSTimeZone *zone = [NSTimeZone systemTimeZone];
//    NSInteger interval = [zone secondsFromGMTForDate:datenow];
//    NSDate *localeDate = [datenow  dateByAddingTimeInterval: interval];
//    //NSLog(@"localDate = %@", localeDate);
//    
//    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[localeDate timeIntervalSince1970]];
    //NSLog(@"timespppp = %@",[self getupdateTimeSp]);
    //NSLog(@"timeSp = %@",timeSp); //时间戳的值
    //NSLog(@"finalstring = %@",[self useridEncryptionWithTimeSp:timeSp]);
    NSString *timeSp = [self getupdateTimeSp];
    NSString *userId = [self useridEncryptionWithTimeSp:timeSp];
    return userId;
}

+(NSString *)doId
{
//    NSDate *datenow = [NSDate date];//现在时间,你可以输出来看下是什么格式
//    NSTimeZone *zone = [NSTimeZone systemTimeZone];
//    NSInteger interval = [zone secondsFromGMTForDate:datenow];
//    NSDate *localeDate = [datenow  dateByAddingTimeInterval: interval];
//    //NSLog(@"localDate = %@", localeDate);
//    
//    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[localeDate timeIntervalSince1970]];
    
    NSString *timeSp = [self getupdateTimeSp];
    //NSLog(@"doId时间戳 = %@",timeSp);
    NSMutableString *doIdstr = [NSMutableString stringWithString:timeSp];
    [doIdstr appendString:@"whubook"];
    NSString *doIdmd5 = [self md5:doIdstr];
    NSMutableString *doId = [NSMutableString stringWithString:@"85dc"];
    [doId appendString:doIdmd5];
    //NSLog(@"doId = %@",doId);
    return doId;
}


+ (NSString *)md5:(NSString *)str
{
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, strlen(cStr), result); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

+ (NSString *)useridEncryptionWithTimeSp:(NSString *)timeSpp {
    NSMutableString *str = [NSMutableString stringWithString:@"WIoQ"];
    NSLog(@"useridEncryptionWithTimeSp   timeSpp = %@",timeSpp);
    for (NSInteger i = 0; i < 10; i++)
    {
        NSString *s = [timeSpp substringWithRange:NSMakeRange(i, 1)];
        if ([s  isEqual: @"0"]) {
            [str appendString:@"k"];
        } else if ([s  isEqual: @"1"]) {
            [str appendString:@"v"];
        } else if ([s  isEqual: @"2"]) {
            [str appendString:@"C"];
        } else if ([s  isEqual: @"3"]) {
            [str appendString:@"D"];
        } else if ([s  isEqual: @"4"]) {
            [str appendString:@"o"];
        } else if ([s  isEqual: @"5"]) {
            [str appendString:@"f"];
        } else if ([s  isEqual: @"6"]) {
            [str appendString:@"G"];
        } else if ([s  isEqual: @"7"]) {
            [str appendString:@"r"];
        } else if ([s  isEqual: @"8"]) {
            [str appendString:@"I"];
        } else if ([s  isEqual: @"9"]) {
            [str appendString:@"J"];
        }
    }
    return str;
}


@end
