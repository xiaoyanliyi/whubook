//
//  WBPublishedTableViewController.m
//  whubook2
//
//  Created by lxyy on 15/3/26.
//  Copyright (c) 2015年 lxyy. All rights reserved.
//

#import "WBPublishedTableViewController.h"
#import "WBTime.h"
#import "QiniuSDK.h"

@interface WBPublishedTableViewController ()

@end

@implementation WBPublishedTableViewController
@synthesize isbn;
@synthesize title;
@synthesize summary;
@synthesize price;
@synthesize priceY;
@synthesize type;
@synthesize pic1;
@synthesize pic2;
@synthesize pic3;
@synthesize pic4;
@synthesize publisher;
@synthesize author;
@synthesize updateType;
@synthesize image1;
@synthesize image2;
@synthesize image3;
@synthesize image4;
@synthesize stringURL;
@synthesize mutDic;

- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"发布"
                                                                    style:UIBarButtonItemStyleDone
                                                                   target:self
                                                                   action:@selector(clickRightButton)];
    [self.navigationItem setTitle:@"发布旧书"];
    self.navigationItem.rightBarButtonItem = rightButton;
    
    self.mutDic = [[NSMutableDictionary alloc] init];


    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)clickRightButton {
    NSLog(@"self.pic1 --=-=-=-=  %@",self.pic1);
    //上传图片到QiNiu
    if ([self.pic1 rangeOfString:@"douban.com"].location!=NSNotFound) {
        NSLog(@"douban.com");
        if (image1) {
            NSLog(@"image1 update");
            [self uploadImageToQiNiuWithType:1 image:image1];
        }
    }
    else {
        [self updatesDic];
        
        NSLog(@"self.mutDic  ------   %@",self.mutDic);
        NSData *strdata = [NSJSONSerialization dataWithJSONObject:self.mutDic options:NSJSONWritingPrettyPrinted error:nil];
        NSString *book = [[NSString alloc] initWithData:strdata encoding:NSUTF8StringEncoding];
        NSString *datastr = [NSString stringWithFormat:@"doId=%@&userId=%@&who=m&book=%@",[WBTime doId], [WBTime userId], book];

        [self getupdatePublishing:datastr url:@"http:www.whubook.com/books/addbook"];
    }
    
    
    if (image2) {
        [self uploadImageToQiNiuWithType:2 image:image2];
    }
    if (image3) {
        [self uploadImageToQiNiuWithType:3 image:image3];
    }
    if (image4) {
        [self uploadImageToQiNiuWithType:4 image:image4];
    }
    
//    NSLog(@"!!!doid = %@",[WBTime doId]);
//    NSLog(@"!!!userid = %@",[WBTime userId]);
    }


-(void)updatesDic {
    //设置发布请求的数据
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    //[self.mutDic setObject:[defaults objectForKey:@"userId"] forKey:@"userId"];
    NSString *userid = @"2";
    [self.mutDic setObject:[NSNumber numberWithInt:[userid intValue]] forKey:@"userId"];
    [self.mutDic setObject:[NSNumber numberWithInt:[self.myBookId intValue]] forKey:@"myBookId"];
    [self.mutDic setObject:self.isbn forKey:@"isbn"];
    [self.mutDic setObject:[NSNumber numberWithInt:[self.type intValue]] forKey:@"type"];
    [self.mutDic setObject:self.title forKey:@"title"];
    [self.mutDic setObject:self.author forKey:@"author"];
    [self.mutDic setObject:self.publisher forKey:@"publisher"];
    [self.mutDic setObject:self.summary forKey:@"summary"];
    [self.mutDic setObject:self.priceY forKey:@"priceY"];
    [self.mutDic setObject:[NSNumber numberWithInt:[@"3" intValue]] forKey:@"level"];
    
    if (self.pic1 == NULL) {
        [self.mutDic setObject:@"null" forKey:@"pic1"];
    }
    else {
        [self.mutDic setObject:self.pic1 forKey:@"pic1"];
    }
    if (self.pic2 == NULL) {
        [self.mutDic setObject:@"null" forKey:@"pic2"];
    }
    else {
        [self.mutDic setObject:self.pic2 forKey:@"pic2"];
    }
    if (self.pic3 == NULL) {
        [self.mutDic setObject:@"null" forKey:@"pic3"];
    }
    else {
        [self.mutDic setObject:self.pic3 forKey:@"pic3"];
    }
    if (self.pic4 == NULL) {
        [self.mutDic setObject:@"null" forKey:@"pic4"];
    }
    else {
        [self.mutDic setObject:self.pic4 forKey:@"pic4"];
    }
    
    UITableViewCell *cell;
    UITextField *textField;
    cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0]];
    textField = [cell.contentView viewWithTag:3004];
    [self.mutDic setObject:textField.text forKey:@"description"];
    
    cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    textField = [cell.contentView viewWithTag:3002];
    [self.mutDic setObject:textField.text forKey:@"price"];
}


- (void)uploadImageToQiNiuWithType:(NSInteger *)type image:(UIImage *)img{
    NSLog(@"updateImageToQiNiu");
    NSData *imgData = UIImageJPEGRepresentation(img, 1);
    
    NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfig delegate:self delegateQueue:nil];
    NSString *url = [NSString stringWithFormat:@"http://www.whubook.com/gettoken"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    request.HTTPMethod = @"GET";
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler: ^(NSData *data,NSURLResponse *response,NSError *error) {
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            NSString *token = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"token = %@",token);
            //上传图片到QiNiu
            
            QNUploadManager *upManager = [[QNUploadManager alloc] init];
            
            long x = arc4random() % 100000;
            NSString *random = [NSString stringWithFormat:@"%ld",x];
            self.stringURL = [NSString stringWithFormat:@"IMG_%@_%@.jpg",[WBTime unixTimestampWithNow],random];
            [upManager putData:imgData key:self.stringURL token:token
                      complete: ^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
                          [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                              
                              NSLog(@"info  =  %@", info);
                              NSLog(@"resp  =  %@", resp);
                              
                              
                              if (type == 0 || type == 1) {
                                  self.pic1 = [NSString stringWithFormat:@"http://img.whubook.com/%@",[resp objectForKey:@"key"]];
                              }
                              else if (type == 2) {
                                  self.pic2 = [NSString stringWithFormat:@"http://img.whubook.com/%@",[resp objectForKey:@"key"]];
                              }
                              else if (type == 3) {
                                  self.pic3 = [NSString stringWithFormat:@"http://img.whubook.com/%@",[resp objectForKey:@"key"]];
                              }
                              else if (type == 4) {
                                  self.pic4 = [NSString stringWithFormat:@"http://img.whubook.com/%@",[resp objectForKey:@"key"]];
                              }
                              
                              [self updatesDic];
                              
                              NSLog(@"self.mutDic  ------   %@",self.mutDic);
                              NSData *strdata = [NSJSONSerialization dataWithJSONObject:self.mutDic options:NSJSONWritingPrettyPrinted error:nil];
                              NSString *book = [[NSString alloc] initWithData:strdata encoding:NSUTF8StringEncoding];
                              NSString *datastr = [NSString stringWithFormat:@"doId=%@&userId=%@&who=m&book=%@",[WBTime doId], [WBTime userId], book];
                              
                              [self getupdatePublishing:datastr url:@"http:www.whubook.com/books/addbook"];
                              
                          }];
                      } option:nil];
        }];
    }];
    [dataTask resume];
}

- (void)getupdatePublishing:(NSString *)datastr url:(NSString *)url
{
    NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfig delegate:self delegateQueue:nil];
    NSString *noteDataString = [NSString stringWithFormat:datastr];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    request.HTTPMethod = @"POST";
    request.HTTPBody = [noteDataString dataUsingEncoding:NSUTF8StringEncoding];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data,NSURLResponse *response,NSError *error) {
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            NSString *str1 = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"发布返回：%@",str1);
            if ([str1 intValue] > 0) {
                [self performSegueWithIdentifier:@"publishSuccessSegue" sender:nil];
            }
            //code
        }];
    }];
    [dataTask resume];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"publishTypeSegue"]) {
        WBPublishTypeTableViewController *publishType = segue.destinationViewController;
        publishType.delegate = self;
    }
    else if ([segue.identifier isEqualToString:@"publishSuccessSegue"]) {
        
    }
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 1) {
        [self performSegueWithIdentifier:@"publishTypeSegue" sender:nil];
    }
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    if (indexPath.section == 0) {
        if (indexPath.row == 0){
            cell = [tableView dequeueReusableCellWithIdentifier:@"titleCell"];
            
            UITextField *titleTextField = [[UITextField alloc] init];
            titleTextField.frame = CGRectMake(89, 8, 229, 30);
            titleTextField.text = self.title;
            titleTextField.tag = 3000;
            [cell.contentView addSubview:titleTextField];
        } else if (indexPath.row == 1){
            cell = [tableView dequeueReusableCellWithIdentifier:@"typeCell"];
            UILabel *typeLabel = [[UILabel alloc] init];
            typeLabel.frame = CGRectMake(89, 8, 229, 30);
            typeLabel.text = @"未填写";
            typeLabel.tag = 3001;
            [cell.contentView addSubview:typeLabel];
        } else if (indexPath.row == 2){
            cell = [tableView dequeueReusableCellWithIdentifier:@"priceCell"];
            
            UITextField *titleTextField = [[UITextField alloc] init];
            titleTextField.frame = CGRectMake(89, 8, 229, 30);
            titleTextField.text = @"0";
            titleTextField.tag = 3002;
            [cell.contentView addSubview:titleTextField];
        } else if (indexPath.row == 3){
            cell = [tableView dequeueReusableCellWithIdentifier:@"oldCell"];
            
            UITextField *titleTextField = [[UITextField alloc] init];
            titleTextField.frame = CGRectMake(89, 8, 229, 30);
            titleTextField.text = @"8";
            titleTextField.tag = 3003;
            [cell.contentView addSubview:titleTextField];
        } else if (indexPath.row == 4){
            cell = [tableView dequeueReusableCellWithIdentifier:@"descriptionCell"];
            
            UITextField *titleTextField = [[UITextField alloc] init];
            titleTextField.frame = CGRectMake(89, 8, 229, 30);
            titleTextField.text = self.title;
            titleTextField.tag = 3004;
            [cell.contentView addSubview:titleTextField];
        }
    }
    
    return cell;
}

#pragma mark - setTypeDelegate

-(void)setTypestr:(NSString *)Typestr
{
    self.type = Typestr;
    NSLog(@"delegate   %@",self.type);

//    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
//    UILabel *label = [cell.contentView viewWithTag:3001];
//    label.text = Typestr;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
