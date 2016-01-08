//
//  WBBookInfomationViewController.h
//  whubook2
//
//  Created by lxyy on 15/5/7.
//  Copyright (c) 2015年 lxyy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WBBookInfomationViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property NSDictionary *dic; //书籍详细信息
@property BOOL *tableViewFlag;
@end
