//
//  WBPersonalCenterViewController.h
//  whubook2
//
//  Created by lxyy on 15/3/6.
//  Copyright (c) 2015年 lxyy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WBLoginViewController.h"

@interface WBPersonalCenterViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate,pushToPersonalCenterViewDelegate>
{

}



- (void)setEmailLabel:(NSString *)userEmailLabelStr;
@property (weak, nonatomic) IBOutlet UILabel *userEmailLabel;

@property (weak, nonatomic) IBOutlet UITableView *PCtableView;





@end
