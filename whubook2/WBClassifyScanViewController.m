//
//  WBClassifyScanViewController.m
//  whubook2
//
//  Created by lxyy on 15/4/7.
//  Copyright (c) 2015年 lxyy. All rights reserved.
//

#import "WBClassifyScanViewController.h"
#import "WBTime.h"
#import "ClassifyScanTableViewCell.h"
#import "ODRefreshControl.h"
#import "WBBookInfomationViewController.h"
#import "AsynImageView.h"

@interface WBClassifyScanViewController ()

@end

@implementation WBClassifyScanViewController
@synthesize classifyTableView;
@synthesize HUD;
@synthesize mutArray;
@synthesize imgArray;
@synthesize tableViewHidden;
@synthesize loadMoreCellHidden;
@synthesize type;
@synthesize currentPage;
@synthesize beginId;
@synthesize each;
@synthesize orderBy;
@synthesize orderUp;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.classifyTableView setSeparatorInset:UIEdgeInsetsZero];
    
    //显示NavigationBar
    [self.navigationController setNavigationBarHidden:NO];
    self.title = @"教材";
    //初始化下拉刷新控件
    ODRefreshControl *refreshControl = [[ODRefreshControl alloc] initInScrollView:self.classifyTableView];
    [refreshControl addTarget:self action:@selector(dropViewDidBeginRefreshing:) forControlEvents:UIControlEventValueChanged];
    
    
    self.tableViewHidden = YES;
    self.loadMoreCellHidden = YES;
    self.mutArray = [[NSMutableArray alloc] init];
    
    //初始化UISegmentControl
    UISegmentedControl *segment = [[UISegmentedControl alloc] init];
    segment.frame = CGRectMake(16, 71, 288, 29);
    [segment insertSegmentWithTitle:@"默认" atIndex:0 animated:YES];
    [segment insertSegmentWithTitle:@"价格" atIndex:1 animated:YES];
    [segment insertSegmentWithTitle:@"卖家信用" atIndex:2 animated:YES];
    [segment insertSegmentWithTitle:@"书本成色" atIndex:3 animated:YES];
    segment.selectedSegmentIndex = 0;
    [segment addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:segment];
    
    //初始化MBProgressHUD
    self.HUD = [[MBProgressHUD alloc] initWithView:self.view];
    self.HUD.frame = CGRectMake(100, 300, 50, 50);
    [self.view addSubview:self.HUD];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.orderBy = @"goodsId";
    self.classifyTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.orderUp = @"up";
    self.each = [NSNumber numberWithInt:10];
    self.currentPage = [NSNumber numberWithInt:1];
    self.beginId = [NSNumber numberWithInt:-1];
    
    
    // Do any additional setup after loading the view.
}


-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [self.mutArray removeAllObjects];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    NSLog(@"viewwilldisappear typeStr = %@",self.type);
    
    [self getupdatewithBeginId:self.beginId orderBy:self.orderBy orderUp:self.orderUp currentPage:self.currentPage type:[NSNumber numberWithInt:[self.type intValue]]];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"prepareforsegue");
    WBBookInfomationViewController *bookInfoVC = segue.destinationViewController;
    if ([segue.identifier isEqualToString:@"bookInfomationSegue"]) {
        bookInfoVC.dic = sender;
    }
}


#pragma mark - segmentedControl Delegate

-(void)segmentAction:(UISegmentedControl *)Seg{
    NSInteger Index = Seg.selectedSegmentIndex;
    //NSLog(@"Index %i", Index);
    switch (Index) {
        case 0:
            [self.mutArray removeAllObjects];
            self.orderBy = @"goodsId";
            break;
        case 1:
            [self.mutArray removeAllObjects];
            self.orderBy = @"price";
            break;
        case 2:
            [self.mutArray removeAllObjects];
            self.orderBy = @"score";
            break;
        case 3:
            [self.mutArray removeAllObjects];
            self.orderBy = @"level";
            break;
        default:
            break;
    }
    [self getupdatewithBeginId:[NSNumber numberWithInteger:-1] orderBy:self.orderBy orderUp:self.orderUp currentPage:[NSNumber numberWithInteger:1] type:[NSNumber numberWithInteger:[self.type intValue]]];
}

#pragma mark - 下拉刷新 ODRefreshControl

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

- (void)dropViewDidBeginRefreshing:(ODRefreshControl *)refreshControl
{
    double delayInSeconds = 3.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        //更新数据
        [self.mutArray removeAllObjects];
        self.currentPage = [NSNumber numberWithInt:1];
        self.tableViewHidden = YES;
        self.loadMoreCellHidden = YES;
        [self.classifyTableView reloadData];
        [self getupdatewithBeginId:self.beginId orderBy:self.orderBy orderUp:self.orderUp currentPage:self.currentPage type:self.type];
        [refreshControl endRefreshing];
    });
}



#pragma mark - Post请求获取TableView数据

- (void)getupdatewithBeginId:(NSNumber *)beginId orderBy:(NSString *)orderBy orderUp:(NSString *)orderUp currentPage:(NSNumber *)currentPage type:(NSNumber *)type
{
    NSLog(@"getupdatewithBeginId:%@ orderBy:%@ orderUp:%@ currentPage:%@ type:%@",beginId, orderBy, orderUp, currentPage, type);
    [self.HUD show:YES];
    
    NSMutableDictionary *mutDic = [[NSMutableDictionary alloc] init];

    NSDictionary *userAndDoIdDic = [WBTime userIdAnddoId];
    
    [mutDic setObject:[userAndDoIdDic objectForKey:@"userId"] forKey:@"userId"];
    [mutDic setObject:[userAndDoIdDic objectForKey:@"doId"] forKey:@"doId"];
    [mutDic setObject:@"m" forKey:@"who"];
    [mutDic setObject:type forKey:@"type"];
    [mutDic setObject:currentPage forKey:@"currentPage"];
    [mutDic setObject:[NSNumber numberWithInt:10] forKey:@"each"];
    [mutDic setObject:beginId forKey:@"beginId"];
    [mutDic setObject:orderBy forKey:@"orderBy"];
    [mutDic setObject:orderUp forKey:@"orderUp"];
    [mutDic setObject:[NSNumber numberWithInt:1] forKey:@"school"];
    [mutDic setObject:[NSNumber numberWithInt:26] forKey:@"academy"];
    
    NSData *mutDicdata = [NSJSONSerialization dataWithJSONObject:mutDic options:NSJSONWritingPrettyPrinted error:nil];
    //NSString *datastr = [[NSString alloc] initWithData:mutDicdata encoding:NSUTF8StringEncoding];
    NSString *datastr = [NSString stringWithFormat:@"doId=%@&userId=%@&who=m&type=%@&currentPage=%@&each=%@&beginId=%@&orderBy=%@&orderUp=%@&school=%@&academy=%@",[mutDic objectForKey:@"doId"], [mutDic objectForKey:@"userId"], [mutDic objectForKey:@"type"], [mutDic objectForKey:@"currentPage"], [mutDic objectForKey:@"each"], [mutDic objectForKey:@"beginId"], [mutDic objectForKey:@"orderBy"], [mutDic objectForKey:@"orderUp"], [mutDic objectForKey:@"school"], [mutDic objectForKey:@"academy"]];
    
    NSLog(@"datastr = %@",datastr);
    
    NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfig delegate:self delegateQueue:nil];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://www.whubook.com/books/getbooks"]];
    request.HTTPMethod = @"POST";
    request.HTTPBody = [datastr dataUsingEncoding:NSUTF8StringEncoding];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data,NSURLResponse *response,NSError *error) {
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            NSString *str1 = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"getUpdateWithTableView");
            //NSLog(@"发布返回：  %@",str1);
            
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
            
            NSString *total = [dic objectForKey:@"total"];
            NSString *currentTotal = [dic objectForKey:@"currentTotal"];
            NSNumber *currentPageStr = [dic objectForKey:@"currentPage"];
            NSLog(@"total = %@",total);
            NSLog(@"currentTotal = %@",currentTotal);
            NSLog(@"currentPage = %@",currentPageStr);
            self.currentPage = currentPageStr;
            NSLog(@"self.currentPage = %@",self.currentPage);
            
            if ([total intValue] <= [currentPage intValue] * 10) {
                NSLog(@"loadMoreCellHidden");
                self.loadMoreCellHidden = YES;
            }
            else {
                self.loadMoreCellHidden = NO;
            }
            
            NSMutableArray *arr = [dic objectForKey:@"result"];
            [self.mutArray addObjectsFromArray:arr];
            
            //NSLog(@"self.mutArray.count = %lu",(unsigned long)[self.mutArray count]);

//            for (NSString *str in self.mutArray) {
//                NSLog(@"arrayfor -----  %@",str);
//            }
            NSMutableArray *someArray = [[NSMutableArray alloc] init];
            for (int i = 0; i < [self.mutArray count]; i++) {
                [someArray addObject:[[self.mutArray objectAtIndex:i] objectForKey:@"pic1"]];
            }
            self.imgArray = someArray;
            self.tableViewHidden = NO;
            
            [self.HUD hide:YES];
            
            self.classifyTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
            [classifyTableView reloadData];

        }];
    }];
    
    [dataTask resume];
}



#pragma mark - Table View Data Source

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.tableViewHidden) {
        return 0;
    }
    else if (self.loadMoreCellHidden) {
        return [self.mutArray count];
    }
    else if (!self.loadMoreCellHidden) {
        return [self.mutArray count]+1;
    }
    return 0;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == [self.mutArray count]) {
        return 60;
    }
    return 100;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row && indexPath.row == [mutArray count] && !self.loadMoreCellHidden) {
        UITableViewCell *loadMoreCell = [[UITableViewCell alloc] init];
        UILabel *loadMoreLbl = [[UILabel alloc] init];
        loadMoreLbl.frame = CGRectMake(60, 7, 200, 30);
        loadMoreLbl.text = @"点击加载更多";
        loadMoreLbl.textAlignment = NSTextAlignmentCenter;
        loadMoreLbl.tag = 5736;
        [loadMoreCell.contentView addSubview:loadMoreLbl];
        return loadMoreCell;
    }
    
    
    static NSString *Identifier = @"ClassifyScanTableViewCell";
    ClassifyScanTableViewCell *cell = (ClassifyScanTableViewCell *)[tableView dequeueReusableCellWithIdentifier:Identifier];

    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ClassifyScanTableViewCell" owner:nil options:nil];
        cell = [nib firstObject];
    }

    NSDictionary *dic = [self.mutArray objectAtIndex:indexPath.row];

    cell.titleLbl.text = [dic objectForKey:@"title"];
    cell.priceLbl.text = [dic objectForKey:@"price"];
    cell.levelLbl.text = [dic objectForKey:@"level"];
    cell.academyLbl.text = [dic objectForKey:@"academy"];
    cell.descriptionLbl.text = [dic objectForKey:@"description"];
    //cell.asyncImageView.imageUrl = [self.imgArray objectAtIndex:indexPath.row];
    
//    EMAsyncImageView *asyncImgView = [[EMAsyncImageView alloc] init];
//    asyncImgView.frame = CGRectMake(8, 10, 70, 80);
//    asyncImgView.imageUrl = [self.imgArray objectAtIndex:indexPath.row];
//    [cell.contentView addSubview:asyncImgView];
    
    AsynImageView *asyncImgView = [[AsynImageView alloc] init];
    asyncImgView.frame = CGRectMake(8, 10, 70, 80);
    asyncImgView.imageURL = [self.imgArray objectAtIndex:indexPath.row];
    [cell.contentView addSubview:asyncImgView];
    
    return cell;
}

#pragma mark - Table View Delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == [self.mutArray count]) {
        UITableViewCell *cell = [self.classifyTableView cellForRowAtIndexPath:indexPath];
        UILabel *Label = [cell.contentView viewWithTag:5736];
        Label.text = @"正在加载...";
        
        NSDictionary *adic = [self.mutArray objectAtIndex:0];
        NSString *goodsIdstr = [adic objectForKey:@"goodsId"];
        NSNumber *goodsId = [NSNumber numberWithInt:[goodsIdstr intValue]];
        NSLog(@"!!!!!!!  %@",self.currentPage);
        self.currentPage = [NSNumber numberWithInt:[self.currentPage intValue] + 1];
        NSLog(@"!!!!!!!  %@",self.currentPage);
        [self getupdatewithBeginId:goodsId orderBy:self.orderBy orderUp:self.orderUp currentPage:self.currentPage type:[NSNumber numberWithInteger:[self.type intValue]]];
        [self.classifyTableView reloadData];
    }
    else {
        NSDictionary *dic = [self.mutArray objectAtIndex:indexPath.row];
        [self performSegueWithIdentifier:@"bookInfomationSegue" sender:dic];
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
