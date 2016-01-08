//
//  WBUpdate.m
//  whubook2
//
//  Created by lxyy on 15/3/13.
//  Copyright (c) 2015年 lxyy. All rights reserved.
//

#import "WBUpdate.h"

@implementation WBUpdate


- (void)getupdatewithdata:(NSString *)data url:(NSString *)url
{
    
    NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfig delegate:self delegateQueue:nil];
    NSString *noteDataString = [NSString stringWithFormat:data];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    request.HTTPMethod = @"POST";
    request.HTTPBody = [noteDataString dataUsingEncoding:NSUTF8StringEncoding];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data,NSURLResponse *response,NSError *error) {
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            NSString *str1 = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"%@",str1);
            //code
        }];
    }];

    [dataTask resume];
}

@end
