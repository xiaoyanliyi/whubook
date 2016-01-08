//
//  ViewController.m
//  whubook2
//
//  Created by lxyy on 15/3/6.
//  Copyright (c) 2015年 lxyy. All rights reserved.
//

#import "ViewController.h"
#import "QiniuSDK.h"
#import "WBLoginViewController.h"
#import "WBPersonalCenterViewController.h"
#import <QuartzCore/QuartzCore.h>
#import <QuartzCore/CoreAnimation.h>
#import <MobileCoreServices/UTCoreTypes.h>
#import "ZBarSDK.h"
#import "WBPublishBookTableViewController.h"
#import "WBClassifyScanViewController.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize dic;
@synthesize typeStr;

- (void)viewDidLoad {
    [super viewDidLoad];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@"0" forKey:@"islogin"];
    [self.navigationController setNavigationBarHidden:YES animated:nil];
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)personalCenterButton:(id)sender {
    NSLog(@"pCBtn");
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    UIStoryboard *storyBoard = self.storyboard;
    
    if ([[defaults objectForKey:@"islogin"] isEqualToString:@"0"]) {  //尚未登录，跳转到loginView
        [self performSegueWithIdentifier:@"loginSegue" sender:self];
    }
    else {  //已登录，跳转到personalCenterView
        [self performSegueWithIdentifier:@"personalCenterSegue" sender:self];
    }
}

- (IBAction)upDate:(id)sender {
    
    NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfig delegate:self delegateQueue:nil];
    NSString *url = [NSString stringWithFormat:@"http://www.whubook.com/gettoken"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    request.HTTPMethod = @"GET";
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
    NSString *url = [NSString stringWithFormat:@"http://www.whubook.com/gettoken"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    request.HTTPMethod = @"GET";
//    request.HTTPBody = [noteDataString dataUsingEncoding:NSUTF8StringEncoding];
    //NSURLRequest *request = [NSURLRequest requestWithURL:];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler: ^(NSData *data,NSURLResponse *response,NSError *error) {
        NSDictionary *jsondata = [NSJSONSerialization JSONObjectWithData:data                                                                                               options:0 error:0];
        NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"token---%@",str);
        //        NSArray *array = [jsondata objectForKey:@"results"];
        //        NSDictionary *dic = [array objectAtIndex:0];
        //        NSString *latestVersion = [dic objectForKey:@"version"];
        //        NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    }];
    [dataTask resume];
}

- (void)getupdatewithisbn:(NSString *)isbn
{
    
    NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfig delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    NSString *noteDataString = [NSString stringWithFormat:isbn];
    NSString *url = [NSString stringWithFormat:@"http://www.whubook.com/books/getbook/%@",isbn];
    NSLog(@"url = %@",url);
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    request.HTTPMethod = @"GET";
    //request.HTTPBody = [noteDataString dataUsingEncoding:NSUTF8StringEncoding];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data,NSURLResponse *response,NSError *error) {
        NSString *unicodeStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];

        NSData *datastr = [unicodeStr dataUsingEncoding:NSUTF8StringEncoding];
        self.dic = [NSJSONSerialization JSONObjectWithData:datastr options:NSJSONReadingAllowFragments error:nil];
        
        id object;        //遍历输出dic
        NSEnumerator * enumerator = [self.dic keyEnumerator];
        while(object = [enumerator nextObject])
        {
            id objectValue = [self.dic objectForKey:object];
            if(objectValue != nil)
            {
                NSLog(@"%@所对应的value是 %@",object,objectValue);  
            }
        }

        [self performSegueWithIdentifier:@"publishBookSegue" sender:self];
    }];
    
    [dataTask resume];
}

#pragma mark - button and segue

- (IBAction)jiaoCaiButton:(id)sender {
    self.typeStr = @"0";
    [self performSegueWithIdentifier:@"classifyScanSegue" sender:self.typeStr];
}

- (IBAction)kaoYanButton:(id)sender {
    self.typeStr = @"1";
    [self performSegueWithIdentifier:@"classifyScanSegue" sender:self.typeStr];
}

- (IBAction)yingYuButton:(id)sender {
    self.typeStr = @"2";
    [self performSegueWithIdentifier:@"classifyScanSegue" sender:self.typeStr];
}

- (IBAction)wenXueButton:(id)sender {
    self.typeStr = @"3";
    [self performSegueWithIdentifier:@"classifyScanSegue" sender:self.typeStr];
}

- (IBAction)qiTaButton:(id)sender {
    self.typeStr = @"4";
    [self performSegueWithIdentifier:@"classifyScanSegue" sender:self.typeStr];
}

- (IBAction)suoYouButton:(id)sender {
    self.typeStr = @"-1";
    [self performSegueWithIdentifier:@"classifyScanSegue" sender:self.typeStr];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"publishBookSegue"]) {
        WBPublishBookTableViewController *pub = segue.destinationViewController;
        pub.dic = self.dic;
    }
    else if([segue.identifier isEqualToString:@"loginSegue"])
    {
        WBLoginViewController *loginVC = segue.destinationViewController;
        loginVC.delegate = self;
    }
    else if([segue.identifier isEqualToString:@"classifyScanSegue"]) {
        WBClassifyScanViewController *VC = segue.destinationViewController;
        VC.type = [NSNumber numberWithInt:[sender intValue]];
    }
}

#pragma mark - ZBarSDK扫描isbn

- (IBAction)scan:(id)sender {
    //    ZBarReaderViewController * reader = [ZBarReaderViewController new];
    //    reader.readerDelegate = self;
    //    ZBarImageScanner * scanner = reader.scanner;
    //    [scanner setSymbology:ZBAR_I25 config:ZBAR_CFG_ENABLE to:0];
    //    reader.showsZBarControls = YES;
    //    [self presentViewController:reader animated:YES completion:nil];

    [self QRscan];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    id<NSFastEnumeration> results = [info objectForKey:ZBarReaderControllerResults];
    ZBarSymbol * symbol;
    for(symbol in results)
        break;
    [picker dismissViewControllerAnimated:YES completion:nil];
    //NSString *isbn = symbol.data;
    [self getupdatewithisbn:symbol.data];
    
}

//自定义ZBar扫描界面
- (void)QRscan
{
    ZBarReaderViewController *reader = [ZBarReaderViewController new];
    reader.readerDelegate = self;
    //非全屏
    reader.wantsFullScreenLayout = NO;
    //隐藏底部控制按钮
    reader.showsZBarControls = NO;
    //设置自己定义的界面
    [self setOverlayPickerView:reader];
    ZBarImageScanner *scanner = reader.scanner;
    [scanner setSymbology: ZBAR_I25
                   config: ZBAR_CFG_ENABLE
                       to: 0];
    [self presentModalViewController: reader
                            animated: YES];
}

- (void)setOverlayPickerView:(ZBarReaderViewController *)reader
{
    //清除原有控件
    for (UIView *temp in [reader.view subviews]) {
        for (UIButton *button in [temp subviews]) {
            if ([button isKindOfClass:[UIButton class]]) {
                [button removeFromSuperview];
            }
        }
        for (UIToolbar *toolbar in [temp subviews]) {
            if ([toolbar isKindOfClass:[UIToolbar class]]) {
                [toolbar setHidden:YES];
                [toolbar removeFromSuperview];
            }
        }
    }
    //画中间的基准线
    UIView* line = [[UIView alloc] initWithFrame:CGRectMake(40, 220, 240, 1)];
    line.backgroundColor = [UIColor redColor];
    [reader.view addSubview:line];
    //最上部view
    UIView* upView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 100)];
    upView.alpha = 0.4;
    upView.backgroundColor = [UIColor blackColor];
    [reader.view addSubview:upView];
    //用于说明的label+view
    UILabel * labIntroudction= [[UILabel alloc] init];
    labIntroudction.backgroundColor = [UIColor clearColor];
    labIntroudction.frame=CGRectMake(15, 400, 290, 90);
    labIntroudction.numberOfLines=2;
    labIntroudction.textColor=[UIColor whiteColor];
    labIntroudction.text=@"将条形码放入框内，即可自动扫描，添加书籍信息。";
    [upView addSubview:labIntroudction];
    UIView* labelView = [[UIView alloc] initWithFrame:CGRectMake(0, 380, 320, 139)];
    labelView.alpha = 0.5;
    labelView.backgroundColor = [UIColor blackColor];
    [reader.view addSubview:labelView];
    //左侧的view
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 100, 20, 280)];
    leftView.alpha = 0.4;
    leftView.backgroundColor = [UIColor blackColor];
    [reader.view addSubview:leftView];
    //右侧的view
    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(300, 100, 20, 280)];
    rightView.alpha = 0.4;
    rightView.backgroundColor = [UIColor blackColor];
    [reader.view addSubview:rightView];
    //底部view
    UIView * downView = [[UIView alloc] initWithFrame:CGRectMake(0, 519, 320, 49)];
    downView.alpha = 0.7;
    downView.backgroundColor = [UIColor blackColor];
    [reader.view addSubview:downView];
    //用于取消操作的button
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    cancelButton.alpha = 0.4;
    [cancelButton setFrame:CGRectMake(10, 521, 60, 45)];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton.titleLabel setFont:[UIFont boldSystemFontOfSize:18]];
    [cancelButton addTarget:self action:@selector(dismissOverlayView:)forControlEvents:UIControlEventTouchUpInside];
    [reader.view addSubview:cancelButton];
    //手写输入button
    UIButton *manualInputButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    manualInputButton.alpha = 0.4;
    [manualInputButton setFrame:CGRectMake(220, 521, 100, 45)];
    [manualInputButton  setTitle:@"手动输入" forState:UIControlStateNormal];
    [manualInputButton.titleLabel setFont:[UIFont boldSystemFontOfSize:18]];
    [manualInputButton addTarget:self action:@selector(pushToPublishView)forControlEvents:UIControlEventTouchUpInside];
    [reader.view addSubview:manualInputButton];
}

//取消button方法
- (void)dismissOverlayView:(id)sender{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)pushToPublishView {
    NSLog(@"pushToPublishView");
    [self performSegueWithIdentifier:@"publishBookSegue" sender:self];

}

#pragma mark - pushToPersonalCenterDelegate

- (void)pushToPCView {
    NSLog(@"pushToPCView");
    [self performSegueWithIdentifier:@"personalCenterSegue" sender:self];
}


@end
