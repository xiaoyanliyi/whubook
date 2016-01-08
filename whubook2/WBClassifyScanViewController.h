//
//  WBClassifyScanViewController.h
//  whubook2
//
//  Created by lxyy on 15/4/7.
//  Copyright (c) 2015年 lxyy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface WBClassifyScanViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    
}
@property MBProgressHUD *HUD;
@property (weak, nonatomic) IBOutlet UITableView *classifyTableView;
@property NSMutableArray *mutArray;   //整个tableView数据Array
@property NSMutableArray *imgArray;   //imageurl1数据Array
@property BOOL *tableViewHidden;
@property BOOL *loadMoreCellHidden;
@property NSString *orderBy;
@property NSNumber *type;
@property NSNumber *currentPage;
@property NSNumber *beginId;
@property NSNumber *each;
@property NSString *orderUp;



@end
