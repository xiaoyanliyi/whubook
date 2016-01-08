//
//  WBLoginViewController.m
//  whubook2
//
//  Created by lxyy on 15/3/17.
//  Copyright (c) 2015年 lxyy. All rights reserved.
//

#import "WBLoginViewController.h"
#import "WBPersonalCenterViewController.h"
#import "WBRegisterViewController.h"

@interface WBLoginViewController ()

@end

@implementation WBLoginViewController


@synthesize loginIDTextField;
@synthesize loginPasswordTextField;
@synthesize loginButton;


- (void)handleSwipeFrom:(UITapGestureRecognizer*)recognizer {
    // 触发手勢事件后，在这里作些事情
    [loginIDTextField resignFirstResponder];
    [loginPasswordTextField resignFirstResponder];
    // 底下是刪除手势的方法
    //[self.view removeGestureRecognizer:recognizer];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
//    UIBarButtonItem *registerButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(pushToRegisterView)];
//    registerButton.title = @"注册";
//    self.navigationItem.rightBarButtonItem = registerButton;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)login:(id)sender {
    
    NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfig delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    NSString *noteDataString = [NSString stringWithFormat:@"who=m&email=%@&password=%@",self.loginIDTextField.text,self.loginPasswordTextField.text];
    NSString *url = [NSString stringWithFormat:@"http://www.whubook.com/user/login"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    request.HTTPMethod = @"POST";
    request.HTTPBody = [noteDataString dataUsingEncoding:NSUTF8StringEncoding];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data,NSURLResponse *response,NSError *error) {
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"%@",str);
            if ([str intValue] == -1) {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"登录失败" message:@"用户不存在！" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                [alertView show];
            } else if ([str intValue] == -2) {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"登录失败" message:@"此账号以被封号！" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                [alertView show];
            } else if ([str intValue] == -3) {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"登录失败" message:@"密码错误！" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                [alertView show];
            } else if ([str intValue] >= 0) {
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                [defaults setObject:self.loginIDTextField.text forKey:@"userEmail"];
                [defaults setObject:self.loginPasswordTextField.text forKey:@"userPassword"];
                [defaults setObject:@"1" forKey:@"islogin"];
                [defaults setObject:@"2" forKey:@"userId"];
                [defaults synchronize];
                if ([[defaults objectForKey:@"islogin"] isEqualToString:@"1"]) {
                    NSLog(@"islogin = %@",[defaults objectForKey:@"islogin"]);
                    [self.navigationController popToRootViewControllerAnimated:NO];
                    [self.delegate pushToPCView];
                    //[self performSegueWithIdentifier:@"personalCenterSegue" sender:self];
                }
            }
        }];
        
    }];
    NSLog(@"ddddddddd");
    [dataTask resume];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSLog(@"userEmail = %@",[defaults objectForKey:@"userEmail"]);
    NSLog(@"islogin = %@",[defaults objectForKey:@"islogin"]);

}

- (void)pushToRegisterView {
    NSLog(@"pushToRegisterView");
    UIStoryboard *storyBoard = self.storyboard;
    WBRegisterViewController *registerVC = [storyBoard instantiateViewControllerWithIdentifier:@"registerView"];
    //[self.navigationController pushViewController:registerVC animated:YES];
    [self presentViewController:registerVC animated:UIModalTransitionStyleCoverVertical completion:nil];
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
