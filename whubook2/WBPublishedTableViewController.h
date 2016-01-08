//
//  WBPublishedTableViewController.h
//  whubook2
//
//  Created by lxyy on 15/3/26.
//  Copyright (c) 2015年 lxyy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WBPublishTypeTableViewController.h"


@interface WBPublishedTableViewController : UITableViewController<setTypeDelegate>




@property NSString *isbn;
@property NSString *priceY;//原价
@property NSString *title;
@property NSString *type;
@property NSString *summary;
@property NSString *myBookId;
@property NSString *publisher;
@property NSString *author;
@property NSString *pic1;
@property NSString *pic2;
@property NSString *pic3;
@property NSString *pic4;
@property NSString *price;
@property NSString *description;
@property NSString *level;
@property NSString *updateType;
@property UIImage *image1;
@property UIImage *image2;
@property UIImage *image3;
@property UIImage *image4;
@property NSString *stringURL;
@property NSMutableDictionary *mutDic;

@end
