//
//  WBPublishBookTableViewController.m
//  whubook2
//
//  Created by lxyy on 15/3/6.
//  Copyright (c) 2015年 lxyy. All rights reserved.
//

#import "WBPublishBookTableViewController.h"
#import "WBPublishedTableViewController.h"
#import <QuartzCore/QuartzCore.h>
#import <QuartzCore/CoreAnimation.h>
#import <MobileCoreServices/UTCoreTypes.h>
#import "ZBarSDK.h"
#import "QiniuSDK.h"
#import "WBTime.h"


@interface WBPublishBookTableViewController ()

@end

@implementation WBPublishBookTableViewController

@synthesize dic;
@synthesize contentimageview;
@synthesize contenttextview;
@synthesize lastChosenMediaType;
@synthesize imageExist1;
@synthesize imageExist2;
@synthesize imageExist3;
@synthesize imageExist4;
@synthesize image1;
@synthesize image2;
@synthesize image3;
@synthesize image4;
@synthesize updateType;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:NO animated:nil];
    imageExist1 = YES;
    imageExist2 = YES;
    imageExist3 = YES;
    imageExist4 = YES;
    if ([[self.dic objectForKey:@"pic1"] isKindOfClass:[NSNull class]]) {
        imageExist1 = NO;
    }
    if ([[self.dic objectForKey:@"pic2"] isKindOfClass:[NSNull class]]) {
        imageExist2 = NO;
    }
    if ([[self.dic objectForKey:@"pic3"] isKindOfClass:[NSNull class]]) {
        imageExist3 = NO;
    }
    if ([[self.dic objectForKey:@"pic4"] isKindOfClass:[NSNull class]]) {
        imageExist4 = NO;
    }
    

    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"下一步"
                                                                    style:UIBarButtonItemStyleDone
                                                                   target:self
                                                                   action:@selector(clickRightButton)];
    [self.navigationItem setTitle:@"书本信息"];
    self.navigationItem.rightBarButtonItem = rightButton;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)clickRightButton {
    
    [self performSegueWithIdentifier:@"publishedSegue" sender:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    WBPublishedTableViewController *published = segue.destinationViewController;
    if ([segue.identifier isEqualToString:@"publishedSegue"]) {
        [self updatedicwith:published];
        published.isbn = [dic objectForKey:@"isbn"];
        published.title = [dic objectForKey:@"title"];
        published.myBookId = [dic objectForKey:@"myBookId"];
        published.publisher = [dic objectForKey:@"publisher"];
        published.summary = [dic objectForKey:@"summary"];
        published.priceY = [dic objectForKey:@"priceY"];
        published.author = [dic objectForKey:@"author"];
        published.pic1 = [dic objectForKey:@"pic1"];
        published.pic2 = [dic objectForKey:@"pic2"];
        published.pic3 = [dic objectForKey:@"pic3"];
        published.pic4 = [dic objectForKey:@"pic4"];
        published.type = [dic objectForKey:@"type"];
    }
}

-(void)updatedicwith:(WBPublishedTableViewController *)publishedVC {
    UITableViewCell *cell;
    UITextField *textField;
    cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    textField = [cell.contentView viewWithTag:8601];
    publishedVC.title = textField.text;
    NSLog(@"tag = 8601 result = %@",textField.text);
    
    cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    textField = [cell.contentView viewWithTag:8610];
    publishedVC.priceY = textField.text;
    NSLog(@"tag = 8610 result = %@",textField.text);
    
    cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:1]];
    textField = [cell.contentView viewWithTag:8611];
    publishedVC.author = textField.text;
    NSLog(@"tag = 8611 result = %@",textField.text);
    
    cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:1]];
    textField = [cell.contentView viewWithTag:8612];
    publishedVC.publisher = textField.text;
    NSLog(@"tag = 8612 result = %@",textField.text);
    
    cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:1]];
    textField = [cell.contentView viewWithTag:8613];
    publishedVC.summary = textField.text;
    NSLog(@"tag = 8613 result = %@",textField.text);
    
    cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:1]];
    textField = [cell.contentView viewWithTag:8614];
    publishedVC.isbn = textField.text;
    NSLog(@"tag = 8614 result = %@",textField.text);
    
    publishedVC.image1 = self.image1;
    publishedVC.image2 = self.image2;
    publishedVC.image3 = self.image3;
    publishedVC.image4 = self.image4;
}

- (void)updateImageToQiNiuWithType:(NSInteger *)type image:(NSData *)imgData{
    
    NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfig delegate:self delegateQueue:nil];
    NSString *url = [NSString stringWithFormat:@"http://www.whubook.com/gettoken"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    request.HTTPMethod = @"GET";
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler: ^(NSData *data,NSURLResponse *response,NSError *error) {
        NSString *token = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        //上传图片到QiNiu
        QNUploadManager *upManager = [[QNUploadManager alloc] init];
       
        long x = arc4random() % 100000;
        NSString *random = [NSString stringWithFormat:@"%ld",x];
        self.stringURL = [NSString stringWithFormat:@"IMG_%@_%@.jpg",[WBTime unixTimestampWithNow],random];
        [upManager putData:imgData key:self.stringURL token:token
                  complete: ^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
                      NSLog(@"info  =  %@", info);
                      NSLog(@"resp  =  %@", resp);
                      if (type == 0 || type == 1) {
                          self.imageURL1 = [NSString stringWithFormat:@"http://img.whubook.com/%@",[resp objectForKey:@"key"]];
                      }
                      else if (type == 2) {
                          self.imageURL2 = [NSString stringWithFormat:@"http://img.whubook.com/%@",[resp objectForKey:@"key"]];
                      }
                      else if (type == 3) {
                          self.imageURL3 = [NSString stringWithFormat:@"http://img.whubook.com/%@",[resp objectForKey:@"key"]];
                      }
                      else if (type == 4) {
                          self.imageURL4 = [NSString stringWithFormat:@"http://img.whubook.com/%@",[resp objectForKey:@"key"]];
                      }
                      
                  } option:nil];
        }];
    [dataTask resume];
}

-(void)showPicture {
    NSLog(@"showPicture");
    UIViewController *showPicVC = [[UIViewController alloc] init];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    imageView.image = image1;
    [showPicVC.view addSubview:imageView];
    [self.navigationController pushViewController:showPicVC animated:YES];
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    if (section == 0) {
        return 2;
    }
    else return 5;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0 && indexPath.section == 0) {
        return 100;
    }
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    if (indexPath.section == 0) {
        if(indexPath.row == 0) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"imageCell"];
            
            
            NSLog(@"pic1 = %@",[self.dic objectForKey:@"pic1"]);
            NSString *pic1 = [self.dic objectForKey:@"pic1"];
            
            if (![[self.dic objectForKey:@"myBookId"] isKindOfClass:[NSNull class]])  //myBookId非null
            {
                if (![pic1 isKindOfClass:[NSNull class]])
                {
                    if([pic1 rangeOfString:@"douban.com"].location!=NSNotFound)  //匹配到@"douban.com"
                    {
                        UIButton *imageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                        imageBtn.frame = CGRectMake(89, 10, 60, 80);
                        self.image1 = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[self.dic objectForKey:@"pic1"]]]];
                        [imageBtn setImage:self.image1 forState:UIControlStateNormal];
                        [imageBtn addTarget:self action:@selector(showPicture) forControlEvents:UIControlEventTouchUpInside];
                        [cell.contentView addSubview:imageBtn];
                    }
                    else                            //匹配到@“whubook.com”
                    {
                        UIButton *imageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                        imageBtn.frame = CGRectMake(89, 10, 60, 80);
                        self.image1 = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[self.dic objectForKey:@"pic1"]]]];
                        [imageBtn setImage:self.image1 forState:UIControlStateNormal];
                        [imageBtn addTarget:self action:@selector(showPicture) forControlEvents:UIControlEventTouchUpInside];
                        [cell.contentView addSubview:imageBtn];
                    }
                }
            }
            else {                              //muBookId为null,用户自己添加照片;
                //判断pic1是否为null
                if ([pic1 isKindOfClass:[NSNull class]] || pic1 == nil || pic1 == NULL) {
                    if (imageExist1) {
                        NSLog(@"imageExist1");
                        UIButton *imageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                        imageBtn.frame = CGRectMake(89, 10, 60, 80);
                        [imageBtn setImage:self.image1 forState:UIControlStateNormal];
                        [imageBtn addTarget:self action:@selector(showPicture) forControlEvents:UIControlEventTouchUpInside];
                        [cell.contentView addSubview:imageBtn];
                    }
                    else {
                        // +
                        UIImage *image = [UIImage imageNamed:@"0x1f4a9.png"];
                        UIButton *addImageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                        addImageBtn.frame =CGRectMake(89, 10, 60, 80);
                        [addImageBtn setImage:image forState:UIControlStateNormal];
                        [addImageBtn addTarget:self action:@selector(addPicTure) forControlEvents:UIControlEventTouchUpInside];
                        addImageBtn.tag = 86001;
                        [cell.contentView addSubview:addImageBtn];
                    }
                }
                else {
                    imageExist1 = YES;
                    NSURL *imageURL = [NSURL URLWithString:[self.dic objectForKey:@"pic1"]];
                    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:imageURL]];
                    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
                    imageView.frame = CGRectMake(89, 10, 60, 80);
                    imageView.tag = 8600;
                    [cell.contentView addSubview:imageView];
                }
                
                //判断pic2是否为null
                NSLog(@"pic2 = %@",[self.dic objectForKey:@"pic2"]);
                NSString *pic2 = [self.dic objectForKey:@"pic2"];
                if (self.imageExist1 && ([pic2 isKindOfClass:[NSNull class]] || pic2 == nil || pic2 == NULL)) {
                    if (imageExist2) {
                        NSLog(@"imageExist2");
                        UIImageView *imageView = [[UIImageView alloc] initWithImage:self.image2];
                        imageView.frame = CGRectMake(149, 10, 60, 80);
                        [cell.contentView addSubview:imageView];
                    }
                    else {
                        UIImage *image = [UIImage imageNamed:@"0x1f4a9.png"];
                        UIButton *addImageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                        addImageBtn.frame =CGRectMake(149, 10, 60, 80);
                        [addImageBtn setImage:image forState:UIControlStateNormal];
                        [addImageBtn addTarget:self action:@selector(addPicTure) forControlEvents:UIControlEventTouchUpInside];
                        addImageBtn.tag = 86002;
                        [cell.contentView addSubview:addImageBtn];
                    }
                }
                
                //判断pic3是否为null
                NSLog(@"pic3 = %@",[self.dic objectForKey:@"pic3"]);
                NSString *pic3 = [self.dic objectForKey:@"pic3"];
                if (self.imageExist2 && ([pic3 isKindOfClass:[NSNull class]] || pic3 == nil || pic3 == NULL)) {
                    if (imageExist3) {
                        NSLog(@"imageExist3");
                        UIImageView *imageView = [[UIImageView alloc] initWithImage:self.image3];
                        imageView.frame = CGRectMake(209, 10, 60, 80);
                        [cell.contentView addSubview:imageView];
                    }
                    else {
                        UIImage *image = [UIImage imageNamed:@"0x1f4a9.png"];
                        UIButton *addImageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                        addImageBtn.frame =CGRectMake(209, 10, 60, 80);
                        [addImageBtn setImage:image forState:UIControlStateNormal];
                        [addImageBtn addTarget:self action:@selector(addPicTure) forControlEvents:UIControlEventTouchUpInside];
                        addImageBtn.tag = 86003;
                        [cell.contentView addSubview:addImageBtn];
                    }
                }
                
                //判断pic4是否为null
                NSLog(@"pic4 = %@",[self.dic objectForKey:@"pic4"]);
                NSString *pic4 = [self.dic objectForKey:@"pic4"];
                if (self.imageExist3 && ([pic4 isKindOfClass:[NSNull class]] || pic4 == nil || pic4 == NULL)) {
                    if (imageExist3) {
                        NSLog(@"imageExist4");
                        UIImageView *imageView = [[UIImageView alloc] initWithImage:self.image4];
                        imageView.frame = CGRectMake(269, 10, 60, 80);
                        [cell.contentView addSubview:imageView];
                    }
                    else {
                        UIImage *image = [UIImage imageNamed:@"0x1f4a9.png"];
                        UIButton *addImageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                        addImageBtn.frame =CGRectMake(269, 10, 60, 80);
                        [addImageBtn setImage:image forState:UIControlStateNormal];
                        [addImageBtn addTarget:self action:@selector(addPicTure) forControlEvents:UIControlEventTouchUpInside];
                        addImageBtn.tag = 86004;
                        [cell.contentView addSubview:addImageBtn];
                    }
                }
            }
        
            
        } else if (indexPath.row == 1){
            cell = [tableView dequeueReusableCellWithIdentifier:@"titleCell"];
            
            UITextField *titleTextField = [[UITextField alloc] init];
            titleTextField.frame = CGRectMake(89, 8, 229, 30);
            titleTextField.text = [self.dic objectForKey:@"title"];
            titleTextField.tag = 8601;
            [cell.contentView addSubview:titleTextField];
        }
    }
    else if (indexPath.section == 1) {
        if(indexPath.row == 0) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"priceCell"];
            UITextField *priceTextField = [[UITextField alloc] init];
            priceTextField.frame = CGRectMake(89, 8, 229, 30);
            priceTextField.text = [self.dic objectForKey:@"priceY"];
            priceTextField.tag = 8610;
            [cell.contentView addSubview:priceTextField];
        }
        else if (indexPath.row == 1){
            cell = [tableView dequeueReusableCellWithIdentifier:@"authorCell"];
            
            UITextField *authorTextField = [[UITextField alloc] init];
            authorTextField.frame = CGRectMake(89, 8, 229, 30);
            authorTextField.text = [self.dic objectForKey:@"author"];
            authorTextField.tag = 8611;
            [cell.contentView addSubview:authorTextField];
        }
        else if (indexPath.row == 2){
            cell = [tableView dequeueReusableCellWithIdentifier:@"publishCell"];
            
            UITextField *publishTextField = [[UITextField alloc] init];
            publishTextField.frame = CGRectMake(89, 8, 229, 30);
            publishTextField.text = [self.dic objectForKey:@"publish"];
            publishTextField.tag = 8612;
            [cell.contentView addSubview:publishTextField];
        }
        else if (indexPath.row == 3){
            cell = [tableView dequeueReusableCellWithIdentifier:@"summaryCell"];
            
            UITextField *summaryTextField = [[UITextField alloc] init];
            summaryTextField.frame = CGRectMake(89, 8, 229, 30);
            summaryTextField.text = [self.dic objectForKey:@"summary"];
            summaryTextField.tag = 8613;
            [cell.contentView addSubview:summaryTextField];
        }
        else if (indexPath.row == 4){
            cell = [tableView dequeueReusableCellWithIdentifier:@"isbnCell"];
            
            UITextField *isbnTextField = [[UITextField alloc] init];
            isbnTextField.frame = CGRectMake(89, 8, 229, 30);
            isbnTextField.text = [self.dic objectForKey:@"isbn"];
            isbnTextField.tag = 8614;
            [cell.contentView addSubview:isbnTextField];
        }
    }
    
    return cell;
}


#pragma mark - 添加图片

-(void)addPicTure
{
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"请选择图片来源" message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"拍照",@"从手机相册选择", nil];
    [alert show];
}

#pragma 拍照选择模块

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex==1)
        [self shootPiicturePrVideo];
    else if(buttonIndex==2)
        [self selectExistingPictureOrVideo];
}

#pragma  mark- 拍照模块

//从相机上选择
-(void)shootPiicturePrVideo{
    [self getMediaFromSource:UIImagePickerControllerSourceTypeCamera];
}
//从相册中选择
-(void)selectExistingPictureOrVideo{
    [self getMediaFromSource:UIImagePickerControllerSourceTypePhotoLibrary];
}

#pragma 拍照模块

-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    self.lastChosenMediaType=[info objectForKey:UIImagePickerControllerMediaType];
    if([lastChosenMediaType isEqual:(NSString *) kUTTypeImage])
    {
        UIImage *chosenImage=[info objectForKey:UIImagePickerControllerEditedImage];
        //contentimageview.image=chosenImage;
        if (!imageExist1) {
            self.image1 = chosenImage;
            self.imageExist1 = YES;
        } else if (!imageExist2) {
            self.image2 = chosenImage;
            self.imageExist2 = YES;
        } else if (!imageExist3) {
            self.image3 = chosenImage;
            self.imageExist3 = YES;
        } else if (!imageExist4) {
            self.image4 = chosenImage;
            self.imageExist4 = YES;
        }
        [self.tableView reloadData];
        NSLog(@"setimagewithbtn");
        //[self.tableView reloadData];
    }
    if([lastChosenMediaType isEqual:(NSString *) kUTTypeMovie])
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示信息!" message:@"系统只支持图片格式" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles: nil];
        [alert show];
        
    }
    [picker dismissModalViewControllerAnimated:YES];
}

-(void) imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissModalViewControllerAnimated:YES];
}

-(void)getMediaFromSource:(UIImagePickerControllerSourceType)sourceType
{
    NSArray *mediatypes=[UIImagePickerController availableMediaTypesForSourceType:sourceType];
    if([UIImagePickerController isSourceTypeAvailable:sourceType] &&[mediatypes count]>0){
        NSArray *mediatypes=[UIImagePickerController availableMediaTypesForSourceType:sourceType];
        UIImagePickerController *picker=[[UIImagePickerController alloc] init];
        picker.mediaTypes=mediatypes;
        picker.delegate=self;
        picker.allowsEditing=YES;
        picker.sourceType=sourceType;
        NSString *requiredmediatype=(NSString *)kUTTypeImage;
        NSArray *arrmediatypes=[NSArray arrayWithObject:requiredmediatype];
        [picker setMediaTypes:arrmediatypes];
        [self presentModalViewController:picker animated:YES];
    }
    else{
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"错误信息!" message:@"当前设备不支持拍摄功能" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles: nil];
        [alert show];
    }
}

static UIImage *shrinkImage(UIImage *orignal,CGSize size)
{
    CGFloat scale=[UIScreen mainScreen].scale;
    CGColorSpaceRef colorSpace=CGColorSpaceCreateDeviceRGB();
    CGContextRef context=CGBitmapContextCreate(NULL, size.width *scale,size.height*scale, 8, 0, colorSpace, kCGImageAlphaPremultipliedFirst);
    CGContextDrawImage(context, CGRectMake(0, 0, size.width*scale, size.height*scale), orignal.CGImage);
    CGImageRef shrunken=CGBitmapContextCreateImage(context);
    UIImage *final=[UIImage imageWithCGImage:shrunken];
    CGContextRelease(context);
    CGImageRelease(shrunken);
    return  final;
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
