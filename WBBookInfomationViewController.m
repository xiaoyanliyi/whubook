//
//  WBBookInfomationViewController.m
//  whubook2
//
//  Created by lxyy on 15/5/7.
//  Copyright (c) 2015年 lxyy. All rights reserved.
//

#import "WBBookInfomationViewController.h"
#import "EMAsyncImageView/EMAsyncImageView.h"
#import "WBTime.h"

@interface WBBookInfomationViewController ()

@end

@implementation WBBookInfomationViewController
@synthesize tableView;
@synthesize tableViewFlag;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableViewFlag = 0;

//    [self.navigationController setNavigationBarHidden:NO];
//    self.title = @"书本信息";
    
    [self.navigationController setNavigationBarHidden:NO];
    //[[UINavigationBar appearance] setTintColor:[UIColor colorWithWhite:0.0 alpha:0.5]];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"640x88_transparent.png"] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
    
    // Do any additional setup after loading the view.
    
    
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO];
    NSLog(@"goodsId ==== %@",[self.dic objectForKey:@"goodsId"]);
    [self getupdatewithgoodsId:[self.dic objectForKey:@"goodsId"]];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Post请求获取评论数据

- (void)getupdatewithgoodsId:(NSString *)goodsId
{
    NSLog(@"getupdatewithgoodsId:%@",goodsId);
    
    
    NSMutableDictionary *mutDic = [[NSMutableDictionary alloc] init];
    
    NSDictionary *userAndDoIdDic = [WBTime userIdAnddoId];
    
    [mutDic setObject:[userAndDoIdDic objectForKey:@"userId"] forKey:@"userId"];
    [mutDic setObject:[userAndDoIdDic objectForKey:@"doId"] forKey:@"doId"];
    [mutDic setObject:goodsId forKey:@"goodsId"];

    NSData *mutDicdata = [NSJSONSerialization dataWithJSONObject:mutDic options:NSJSONWritingPrettyPrinted error:nil];
    NSString *datastr = [NSString stringWithFormat:@"doId=%@&userId=%@&goodsId=%@&who=m",[mutDic objectForKey:@"doId"], [mutDic objectForKey:@"userId"], [mutDic objectForKey:@"goodsId"]];
    
    NSLog(@"datastr = %@",datastr);
    
    NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfig delegate:self delegateQueue:nil];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://www.whubook.com/msg/commentsget"]];
    request.HTTPMethod = @"POST";
    request.HTTPBody = [datastr dataUsingEncoding:NSUTF8StringEncoding];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data,NSURLResponse *response,NSError *error) {
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            NSString *str1 = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"getUpdateWithgoodsId");
            NSLog(@"发布返回：  %@",str1);
            
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            
//            id object;        //遍历输出dic
//            NSEnumerator * enumerator = [dic keyEnumerator];
//            while(object = [enumerator nextObject])
//            {
//                id objectValue = [dic objectForKey:object];
//                if(objectValue != nil)
//                {
//                    NSLog(@"%@所对应的value是 %@",object,objectValue);
//                }
//            }
            
            
        }];
    }];
    
    [dataTask resume];
}




#pragma mark - Table View Data Source

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    if (section == 0) {
        return 4;
    }
    else return 1;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return 300;
        }
        else if (indexPath.row == 1) {
            return 120;
        }
        else if (indexPath.row == 2) {
            return 60;
        }
        else if (indexPath.row == 3) {
            if (self.tableViewFlag) {
                return 250;
            }
            else return 0;
        }
    }
    else if (indexPath.section == 1) {
        return 60;
    }
    return 44;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    else return 10;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            EMAsyncImageView *asyncImageView = [[EMAsyncImageView alloc] init];   //图片asyncImgView
            asyncImageView.frame = CGRectMake(100, 64, 120, 160);
            asyncImageView.imageUrl = [self.dic objectForKey:@"pic1"];
            [cell.contentView addSubview:asyncImageView];
            
            UILabel *titleLbl = [[UILabel alloc] init];     //书名Lbl
            titleLbl.frame = CGRectMake(20, 235, 300, 30);
            titleLbl.text = [self.dic objectForKey:@"title"];
            titleLbl.font = [UIFont boldSystemFontOfSize:18];
            [cell.contentView addSubview:titleLbl];
            
            UILabel *priceLbl = [[UILabel alloc] init];     //价格Lbl
            priceLbl.frame = CGRectMake(20, 265, 100, 20);
            [priceLbl setTextColor:[UIColor redColor]];
            NSString *priceString = @"￥";
            priceString = [priceString stringByAppendingString:[self.dic objectForKey:@"price"]];
            priceString = [priceString stringByAppendingString:@".00"];
            priceLbl.text = priceString;
            priceLbl.font = [UIFont boldSystemFontOfSize:20];
            [cell.contentView addSubview:priceLbl];
            
            UILabel *priceYLbl = [[UILabel alloc] init];    //原价Lbl
            priceYLbl.frame = CGRectMake(100, 266, 100, 20);
            [priceYLbl setTextColor:[UIColor grayColor]];
            NSString *priceYString = @"标价:￥";
            priceYString = [priceYString stringByAppendingString:[self.dic objectForKey:@"priceY"]];
            priceYLbl.text = priceYString;
            priceYLbl.font = [UIFont boldSystemFontOfSize:14];
            [cell.contentView addSubview:priceYLbl];
            
            UIView *lineView = [[UIView alloc] init];   //原价分割线
            lineView.frame = CGRectMake(145, 276, 40, 1);
            lineView.backgroundColor = [UIColor grayColor];
            [cell.contentView addSubview:lineView];
            
            UILabel *levelLbl = [[UILabel alloc] init];     //几成新Lbl
            levelLbl.frame = CGRectMake(200, 266, 100, 20);
            [levelLbl setTextColor:[UIColor grayColor]];
            NSString *levelString = [self.dic objectForKey:@"level"];
            levelString = [levelString stringByAppendingString:@"成新"];
            levelLbl.text = levelString;
            levelLbl.font = [UIFont boldSystemFontOfSize:14];
            [cell.contentView addSubview:levelLbl];
        }
        else if (indexPath.row == 1) {
            UIImageView *headIconImgView = [[UIImageView alloc] init];     //头像ImgView
            headIconImgView.frame = CGRectMake(20, 10, 40, 40);
            [headIconImgView setImage:[UIImage imageNamed:@"0x1f4a9.png"]];
            [cell.contentView addSubview:headIconImgView];
            
            UILabel *nickNameLbl = [[UILabel alloc] init];      //卖家昵称Lbl
            nickNameLbl.frame = CGRectMake(80, 10, 100, 20);
            nickNameLbl.text = @"卖家昵称";
            nickNameLbl.font = [UIFont boldSystemFontOfSize:16];
            [cell.contentView addSubview:nickNameLbl];
            
            UIImageView *academyIconImgView = [[UIImageView alloc] init];   //学院IconImgView
            academyIconImgView.frame = CGRectMake(80, 32, 15, 15);
            [academyIconImgView setImage:[UIImage imageNamed:@"0x1f4a9.png"]];
            [cell.contentView addSubview:academyIconImgView];
            
            UILabel *academyLbl = [[UILabel alloc] init];       //学院Lbl
            academyLbl.frame = CGRectMake(100, 30, 100, 20);
            academyLbl.text = @"国际软件学院";
            academyLbl.font = [UIFont boldSystemFontOfSize:14];
            [academyLbl setTextColor:[UIColor grayColor]];
            [cell.contentView addSubview:academyLbl];
            
            UILabel *timeLbl = [[UILabel alloc] init];        //发布时间Lbl
            timeLbl.frame = CGRectMake(200, 10, 100, 20);
            timeLbl.text = @"3天前";
            timeLbl.font = [UIFont boldSystemFontOfSize:14];
            timeLbl.textAlignment = UITextAlignmentRight;
            [timeLbl setTextColor:[UIColor grayColor]];
            [cell.contentView addSubview:timeLbl];
            
            UILabel *descriptionLbl = [[UILabel alloc] init];   //卖家描述Lbl
            descriptionLbl.frame = CGRectMake(20, 60, 280, 40);
            descriptionLbl.text = @"卖家描述：很经典的书，计算机专业必读，很爱惜所以几乎是新的";
            descriptionLbl.font = [UIFont boldSystemFontOfSize:14];
            [descriptionLbl setTextColor:[UIColor grayColor]];
            descriptionLbl.numberOfLines = 2;
            [cell.contentView addSubview:descriptionLbl];
        }
        else if (indexPath.row == 2) {
            UILabel *lbl = [[UILabel alloc] init];      //查看书籍详细信息Lbl
            lbl.frame = CGRectMake(20, 0, 150, 60);
            lbl.text = @"查看书籍详细信息";
            lbl.font = [UIFont boldSystemFontOfSize:18];
            [lbl setTextColor:[UIColor grayColor]];
            [cell.contentView addSubview:lbl];
            
            UIImageView *iconImgView = [[UIImageView alloc] init];
            iconImgView.frame = CGRectMake(170, 20, 20, 20);
            [iconImgView setImage:[UIImage imageNamed:@"0x1f4a9.png"]];
            [cell.contentView addSubview:iconImgView];
        }
        else if (indexPath.row == 3 && self.tableViewFlag) {
            UILabel *Lbl1 = [[UILabel alloc] init];     //详细信息-书名Lbl
            Lbl1.text = @"书名";
            Lbl1.frame = CGRectMake(20, 10, 60, 25);
            Lbl1.font = [UIFont boldSystemFontOfSize:14];
            [Lbl1 setTextColor:[UIColor grayColor]];
            [cell.contentView addSubview:Lbl1];
            
            UILabel *titleLbl = [[UILabel alloc] init];
            titleLbl.text = [self.dic objectForKey:@"title"];
            titleLbl.frame = CGRectMake(80, 10, 220, 25);
            titleLbl.font = [UIFont boldSystemFontOfSize:14];
            [titleLbl setTextColor:[UIColor grayColor]];
            [cell.contentView addSubview:titleLbl];
            
            UILabel *Lbl2 = [[UILabel alloc] init];     //详细信息-作者Lbl
            Lbl2.text = @"作者";
            Lbl2.frame = CGRectMake(20, 35, 60, 25);
            Lbl2.font = [UIFont boldSystemFontOfSize:14];
            [Lbl2 setTextColor:[UIColor grayColor]];
            [cell.contentView addSubview:Lbl2];
            
            UILabel *authorLbl = [[UILabel alloc] init];
            authorLbl.text = [self.dic objectForKey:@"author"];
            authorLbl.frame = CGRectMake(80, 35, 220, 25);
            authorLbl.font = [UIFont boldSystemFontOfSize:14];
            [authorLbl setTextColor:[UIColor grayColor]];
            [cell.contentView addSubview:authorLbl];
            
            UILabel *Lbl3 = [[UILabel alloc] init];     //详细信息-出版社Lbl
            Lbl3.text = @"出版社";
            Lbl3.frame = CGRectMake(20, 60, 60, 25);
            Lbl3.font = [UIFont boldSystemFontOfSize:14];
            [Lbl3 setTextColor:[UIColor grayColor]];
            [cell.contentView addSubview:Lbl3];
            
            UILabel *publisherLbl = [[UILabel alloc] init];
            publisherLbl.text = [self.dic objectForKey:@"publisher"];
            publisherLbl.frame = CGRectMake(80, 60, 220, 25);
            publisherLbl.font = [UIFont boldSystemFontOfSize:14];
            [publisherLbl setTextColor:[UIColor grayColor]];
            [cell.contentView addSubview:publisherLbl];
            
            UILabel *Lbl4 = [[UILabel alloc] init];     //详细信息-定价Lbl
            Lbl4.text = @"定价";
            Lbl4.frame = CGRectMake(20, 85, 60, 25);
            Lbl4.font = [UIFont boldSystemFontOfSize:14];
            [Lbl4 setTextColor:[UIColor grayColor]];
            [cell.contentView addSubview:Lbl4];
            
            UILabel *priceYLbl = [[UILabel alloc] init];
            NSString *str = @"￥";
            priceYLbl.text = [str stringByAppendingString:[self.dic objectForKey:@"priceY"]];
            priceYLbl.frame = CGRectMake(80, 85, 220, 25);
            priceYLbl.font = [UIFont boldSystemFontOfSize:14];
            [priceYLbl setTextColor:[UIColor grayColor]];
            [cell.contentView addSubview:priceYLbl];
            
            UILabel *Lbl5 = [[UILabel alloc] init];     //详细信息-ISBNLbl
            Lbl5.text = @"ISBN";
            Lbl5.frame = CGRectMake(20, 110, 60, 25);
            Lbl5.font = [UIFont boldSystemFontOfSize:14];
            [Lbl5 setTextColor:[UIColor grayColor]];
            [cell.contentView addSubview:Lbl5];
            
            UILabel *isbnLbl = [[UILabel alloc] init];
            isbnLbl.text = [self.dic objectForKey:@"isbn"];
            isbnLbl.frame = CGRectMake(80, 110, 220, 25);
            isbnLbl.font = [UIFont boldSystemFontOfSize:14];
            [isbnLbl setTextColor:[UIColor grayColor]];
            [cell.contentView addSubview:isbnLbl];
            
            UILabel *Lbl6 = [[UILabel alloc] init];     //详细信息-摘要Lbl
            Lbl6.text = @"摘要";
            Lbl6.frame = CGRectMake(20, 135, 60, 25);
            Lbl6.font = [UIFont boldSystemFontOfSize:14];
            [Lbl6 setTextColor:[UIColor grayColor]];
            [cell.contentView addSubview:Lbl6];
            
            UILabel *summaryLbl = [[UILabel alloc] init];
            summaryLbl.text = [self.dic objectForKey:@"summary"];
            summaryLbl.frame = CGRectMake(80, 139, 220, 25);
            summaryLbl.font = [UIFont boldSystemFontOfSize:14];
            [summaryLbl setTextColor:[UIColor grayColor]];
            summaryLbl.numberOfLines = 5;
            [summaryLbl sizeToFit];
            
//            NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:summaryLbl.text];
//            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
//            [paragraphStyle setLineSpacing:3];//调整行间距
//            [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [summaryLbl.text length])];
//            summaryLbl.attributedText = attributedString;
            [cell.contentView addSubview:summaryLbl];
        }
    }
    else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            UILabel *messageLbl = [[UILabel alloc] init];
            messageLbl.frame = CGRectMake(20, 0, 150, 60);
            messageLbl.text = @"留言";
            messageLbl.font = [UIFont boldSystemFontOfSize:18];
            [messageLbl setTextColor:[UIColor grayColor]];
            [cell.contentView addSubview:messageLbl];
        }
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 2) {
            if (self.tableViewFlag) {
                self.tableViewFlag = 0;
                UITableViewCell *cell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
                
            }
            else {
                self.tableViewFlag = 1;
                UITableViewCell *cell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
                
            }

            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            [tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:3 inSection:0]] withRowAnimation:UITableViewRowAnimationBottom];
            [tableView reloadData];
        }
    }
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
