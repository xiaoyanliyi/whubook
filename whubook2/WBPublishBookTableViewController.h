//
//  WBPublishBookTableViewController.h
//  whubook2
//
//  Created by lxyy on 15/3/6.
//  Copyright (c) 2015年 lxyy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZBarSDK.h"
#import "ViewController.h"


@interface WBPublishBookTableViewController : UITableViewController<UINavigationControllerDelegate,UIAlertViewDelegate,ZBarReaderDelegate>
{
    
}

@property NSDictionary *dic;

@property(nonatomic,retain) IBOutlet UITextView *contenttextview;
@property(nonatomic,retain)  IBOutlet   UIImageView *contentimageview;
@property(nonatomic,copy)        NSString *lastChosenMediaType;
@property BOOL *imageExist1;
@property BOOL *imageExist2;
@property BOOL *imageExist3;
@property BOOL *imageExist4;
@property UIImage *image1;
@property UIImage *image2;
@property UIImage *image3;
@property UIImage *image4;
@property NSString *imageURL1;
@property NSString *imageURL2;
@property NSString *imageURL3;
@property NSString *imageURL4;
@property NSString *stringURL;
@property NSString *updateType;


@end
