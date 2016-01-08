//
//  WBPersonalCenterViewController.m
//  whubook2
//
//  Created by lxyy on 15/3/6.
//  Copyright (c) 2015年 lxyy. All rights reserved.
//

#import "WBPersonalCenterViewController.h"
#import "WBLoginViewController.h"
#import "WBTime.h"

@interface WBPersonalCenterViewController ()

@end

@implementation WBPersonalCenterViewController

@synthesize userEmailLabel;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    //[self.view setBackgroundColor:[UIColor colorWithRed:108/255.0 green:179/255.0 blue:26/255.0 alpha:1]];
    
    [self.navigationController setNavigationBarHidden:NO];
    //[[UINavigationBar appearance] setTintColor:[UIColor colorWithWhite:0.0 alpha:0.5]];

    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"640x88_transparent.png"] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    if ([defaults objectForKey:@"islogin"] == 1) {
        self.userEmailLabel.text = [defaults objectForKey:@"userId"];
    }
    // Do any additional setup after loading the view.
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)cancelAddAccount {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - Table View Data Source

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 2;
    }
    else if (section == 1) {
        return 2;
    }
    else if (section == 2) {
        return 2;
    }
    else return 1;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) return 200;
        else if (indexPath.row == 1) return 80;
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
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cell.backgroundColor = [UIColor colorWithRed:108/255.0 green:179/255.0 blue:26/255.0 alpha:1];
            //头像Btn
            UIButton *imgBtn = [[UIButton alloc] init];
            imgBtn.frame = CGRectMake(120, 30, 80, 80);
            [imgBtn setImage:[UIImage imageNamed:@"0x1f4a9.png"] forState:UIControlStateNormal];
            [cell.contentView addSubview:imgBtn];
            //昵称Lbl
            UILabel *nameLbl = [[UILabel alloc] init];
            nameLbl.frame = CGRectMake(0, 130, 320, 20);
            nameLbl.text = @"昵称";
            nameLbl.textColor = [UIColor whiteColor];
            nameLbl.font = [UIFont boldSystemFontOfSize:20];
            nameLbl.textAlignment = UITextAlignmentCenter;
            [cell.contentView addSubview:nameLbl];
            //学院Lbl;
            UILabel *academyLbl = [[UILabel alloc] init];
            academyLbl.frame = CGRectMake(0, 160, 320, 20);
            academyLbl.text = @"学院";
            academyLbl.textColor = [UIColor whiteColor];
            academyLbl.font = [UIFont boldSystemFontOfSize:15];
            academyLbl.textAlignment = UITextAlignmentCenter;
            [cell.contentView addSubview:academyLbl];
        }
        else if (indexPath.row == 1) {
            //分割线
            UIView *lineview1 = [[UIView alloc] init];
            lineview1.frame = CGRectMake(107, 15, 1, 50);
            lineview1.backgroundColor = [UIColor grayColor];
            [cell.contentView addSubview:lineview1];
            
            UIView *lineview2 = [[UIView alloc] init];
            lineview2.frame = CGRectMake(214, 15, 1, 50);
            lineview2.backgroundColor = [UIColor grayColor];
            [cell.contentView addSubview:lineview2];
            
            
            //已发布
            UIButton *Btn1 = [[UIButton alloc] init];
            Btn1.frame = CGRectMake(0, 0, 107, 80);
            
            UILabel *lbl1 = [[UILabel alloc] init];
            lbl1.frame = CGRectMake(20, 10, 67, 35);
            lbl1.font = [UIFont boldSystemFontOfSize:24];
            lbl1.textAlignment = UITextAlignmentCenter;
            lbl1.text = @"0";
            
            UILabel *faBuLbl = [[UILabel alloc] init];
            faBuLbl.frame = CGRectMake(20, 45, 67, 20);
            faBuLbl.font = [UIFont boldSystemFontOfSize:15];
            faBuLbl.textAlignment = UITextAlignmentCenter;
            faBuLbl.textColor = [UIColor grayColor];
            faBuLbl.text = @"已发布";
            
            [cell.contentView addSubview:Btn1];
            [cell.contentView addSubview:lbl1];
            [cell.contentView addSubview:faBuLbl];
            
            
            //收藏
            UIButton *Btn2 = [[UIButton alloc] init];
            Btn2.frame = CGRectMake(107, 0, 107, 80);
            
            UILabel *lbl2 = [[UILabel alloc] init];
            lbl2.frame = CGRectMake(127, 10, 67, 35);
            lbl2.font = [UIFont boldSystemFontOfSize:24];
            lbl2.textAlignment = UITextAlignmentCenter;
            lbl2.text = @"0";
            
            UILabel *shouCangLbl = [[UILabel alloc] init];
            shouCangLbl.frame = CGRectMake(127, 45, 67, 20);
            shouCangLbl.font = [UIFont boldSystemFontOfSize:15];
            shouCangLbl.textAlignment = UITextAlignmentCenter;
            shouCangLbl.textColor = [UIColor grayColor];
            shouCangLbl.text = @"收藏";
            
            [cell.contentView addSubview:Btn2];
            [cell.contentView addSubview:lbl2];
            [cell.contentView addSubview:shouCangLbl];
            
            
            //已购买
            UIButton *Btn3 = [[UIButton alloc] init];
            Btn3.frame = CGRectMake(214, 0, 107, 80);
            
            UILabel *lbl3 = [[UILabel alloc] init];
            lbl3.frame = CGRectMake(234, 10, 67, 35);
            lbl3.font = [UIFont boldSystemFontOfSize:24];
            lbl3.textAlignment = UITextAlignmentCenter;
            lbl3.text = @"0";
            
            UILabel *gouMaiLbl = [[UILabel alloc] init];
            gouMaiLbl.frame = CGRectMake(234, 45, 67, 20);
            gouMaiLbl.font = [UIFont boldSystemFontOfSize:15];
            gouMaiLbl.textAlignment = UITextAlignmentCenter;
            gouMaiLbl.textColor = [UIColor grayColor];
            gouMaiLbl.text = @"收藏";
            
            [cell.contentView addSubview:Btn3];
            [cell.contentView addSubview:lbl3];
            [cell.contentView addSubview:gouMaiLbl];
        }
    }
    else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            UIImage *img10 = [UIImage imageNamed:@"0x1f4a9.png"];
            UIImageView *imgView = [[UIImageView alloc] init];
            [imgView setImage:img10];
            imgView.frame = CGRectMake(12, 7, 30, 30);
            [cell.contentView addSubview:imgView];
            
            UILabel *jiaoWuLbl = [[UILabel alloc] init];
            jiaoWuLbl.frame = CGRectMake(54, 0, 150, 44);
            jiaoWuLbl.text = @"教务认证";
            jiaoWuLbl.font = [UIFont fontWithName:@"STHeitiSC-Light" size:17];
            [cell.contentView addSubview:jiaoWuLbl];
        }
        else if (indexPath.row == 1) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            UIImage *img11 = [UIImage imageNamed:@"0x1f4a9.png"];
            UIImageView *imgView = [[UIImageView alloc] init];
            [imgView setImage:img11];
            imgView.frame = CGRectMake(12, 7, 30, 30);
            [cell.contentView addSubview:imgView];
            
            UILabel *ziLiaoLbl = [[UILabel alloc] init];
            ziLiaoLbl.frame = CGRectMake(54, 0, 150, 44);
            ziLiaoLbl.text = @"修改个人资料";
            ziLiaoLbl.font = [UIFont fontWithName:@"STHeitiSC-Light" size:17];
            [cell.contentView addSubview:ziLiaoLbl];
        }
    }
    else if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            UIImage *img20 = [UIImage imageNamed:@"0x1f4a9.png"];
            UIImageView *imgView = [[UIImageView alloc] init];
            [imgView setImage:img20];
            imgView.frame = CGRectMake(12, 7, 30, 30);
            [cell.contentView addSubview:imgView];
            
            UILabel *yiJianLbl = [[UILabel alloc] init];
            yiJianLbl.frame = CGRectMake(54, 0, 150, 44);
            yiJianLbl.text = @"意见反馈";
            yiJianLbl.font = [UIFont fontWithName:@"STHeitiSC-Light" size:17];
            [cell.contentView addSubview:yiJianLbl];
        }
        else if (indexPath.row == 1) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            UIImage *img21 = [UIImage imageNamed:@"0x1f4a9.png"];
            UIImageView *imgView = [[UIImageView alloc] init];
            [imgView setImage:img21];
            imgView.frame = CGRectMake(12, 7, 30, 30);
            [cell.contentView addSubview:imgView];
            
            UILabel *guanYuLbl = [[UILabel alloc] init];
            guanYuLbl.frame = CGRectMake(54, 0, 150, 44);
            guanYuLbl.text = @"关于我们";
            guanYuLbl.font = [UIFont fontWithName:@"STHeitiSC-Light" size:17];
            [cell.contentView addSubview:guanYuLbl];
        }
    }
    else if (indexPath.section == 3) {
        //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        UIImage *img30 = [UIImage imageNamed:@"0x1f4a9.png"];
        UIImageView *imgView = [[UIImageView alloc] init];
        [imgView setImage:img30];
        imgView.frame = CGRectMake(12, 7, 30, 30);
        [cell.contentView addSubview:imgView];
        
        UILabel *tuiChuLbl = [[UILabel alloc] init];
        tuiChuLbl.frame = CGRectMake(54, 0, 150, 44);
        tuiChuLbl.text = @"退出登录";
        tuiChuLbl.font = [UIFont fontWithName:@"STHeitiSC-Light" size:17];
        [cell.contentView addSubview:tuiChuLbl];
    }

    return cell;
}

#pragma mark - Table View Delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            //教务认证
        }
        else if(indexPath.row == 1) {
            //修改个人资料
            [self performSegueWithIdentifier:@"PersonalInformationSegue" sender:nil];
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




- (void)setEmailLabel:(NSString *)userEmailLabelStr
{
    self.userEmailLabel.text = userEmailLabelStr;
}

-(void)changeId:(NSString *)id
{
    self.userEmailLabel.text = id;
    NSLog(@"changeId");
}





@end
