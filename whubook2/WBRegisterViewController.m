//
//  WBRegisterViewController.m
//  whubook2
//
//  Created by lxyy on 15/3/19.
//  Copyright (c) 2015年 lxyy. All rights reserved.
//

#import "WBRegisterViewController.h"

@interface WBRegisterViewController ()

@end

@implementation WBRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cancelAddAccount {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)whuregister:(id)sender {
    
    NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfig delegate:self delegateQueue:nil];
    NSString *noteDataString = [NSString stringWithFormat:@"who=m&name=%@&email=%@&password=%@",self.registerIDTextField.text,self.registerEmailTextField.text,self.registerPasswordTextField.text];
    NSString *url = [NSString stringWithFormat:@"http://www.whubook.com/user/register"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    request.HTTPMethod = @"POST";
    request.HTTPBody = [noteDataString dataUsingEncoding:NSUTF8StringEncoding];
    //NSURLRequest *request = [NSURLRequest requestWithURL:];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data,NSURLResponse *response,NSError *error) {
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            NSString *str1 = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"%@",str1);
            
        }];
    }];
    [dataTask resume];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
