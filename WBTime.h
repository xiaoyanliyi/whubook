//
//  WBTime.h
//  whubook2
//
//  Created by lxyy on 15/3/15.
//  Copyright (c) 2015年 lxyy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>

@interface WBTime : NSObject

+(NSDictionary *)userIdAnddoId;
+(NSString *)userId;
+(NSString *)doId;
+(NSString *)unixTimestampWithNow;


@end
