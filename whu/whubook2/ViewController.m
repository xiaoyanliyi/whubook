//
//  ViewController.m
//  whubook2
//
//  Created by lxyy on 15/3/6.
//  Copyright (c) 2015年 lxyy. All rights reserved.
//

#import "ViewController.h"
#import "QiniuSDK.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)upDate:(id)sender {
    
    NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfig delegate:self delegateQueue:nil];
    //    NSString *noteDataString = [NSString stringWithFormat:@"name=xiaoyanliyi@126.com&password=xiaoyanliyi"];
    NSString *url = [NSString stringWithFormat:@"http://www.whubook.com/gettoken"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    request.HTTPMethod = @"GET";
    //    request.HTTPBody = [noteDataString dataUsingEncoding:NSUTF8StringEncoding];
    //NSURLRequest *request = [NSURLRequest requestWithURL:];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler: ^(NSData *data,NSURLResponse *response,NSError *error) {
        NSDictionary *jsondata = [NSJSONSerialization JSONObjectWithData:data                                                                                               options:0 error:0];
        NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];

        NSLog(@"token  =  %@",str);
        
        NSString *token = str;
        QNUploadManager *upManager = [[QNUploadManager alloc] init];
        NSData *dataa = [@"Hello, World!" dataUsingEncoding : NSUTF8StringEncoding];
        [upManager putData:dataa key:@"hello" token:token
                  complete: ^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
                      NSLog(@"info  =  %@", info);
                      NSLog(@"resp  =  %@", resp);
                  } option:nil];

    }];
    [dataTask resume];
    
    

}


- (void)getupdatetoken {
    
    NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfig delegate:self delegateQueue:nil];
//    NSString *noteDataString = [NSString stringWithFormat:@"name=xiaoyanliyi@126.com&password=xiaoyanliyi"];
    NSString *url = [NSString stringWithFormat:@"http://www.whubook.com/gettoken"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    request.HTTPMethod = @"GET";
//    request.HTTPBody = [noteDataString dataUsingEncoding:NSUTF8StringEncoding];
    //NSURLRequest *request = [NSURLRequest requestWithURL:];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler: ^(NSData *data,NSURLResponse *response,NSError *error) {
        NSDictionary *jsondata = [NSJSONSerialization JSONObjectWithData:data                                                                                               options:0 error:0];
        NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        //        NSArray *array = [jsondata objectForKey:@"results"];
        //        NSDictionary *dic = [array objectAtIndex:0];
        //        NSString *latestVersion = [dic objectForKey:@"version"];
        //        NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    }];
    [dataTask resume];

    
}



@end
