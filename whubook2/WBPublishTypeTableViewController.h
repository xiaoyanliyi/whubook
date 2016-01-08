//
//  WBPublishTypeTableViewController.h
//  whubook2
//
//  Created by lxyy on 15/3/27.
//  Copyright (c) 2015年 lxyy. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol setTypeDelegate <NSObject>
-(void) setTypestr:(NSString *)Typestr;
@end

@interface WBPublishTypeTableViewController : UITableViewController
{
    id<setTypeDelegate> delegate;
}

@property (nonatomic, assign) id delegate;

@end
