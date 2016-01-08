//
//  WBPublishBookTableViewController.h
//  whubook2
//
//  Created by lxyy on 15/3/6.
//  Copyright (c) 2015年 lxyy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WBPublishBookTableViewController : UITableViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIAlertViewDelegate>

{
//         UITextView *contenttextview;
//         UIImageView *contentimageview;
//         NSString *lastChosenMediaType;
    
}


@property(nonatomic,copy)        NSString *lastChosenMediaType;

- (IBAction)buttonclick:(id)sender;

@property (weak, nonatomic) IBOutlet UIImageView *contentimageview;
@property (weak, nonatomic) IBOutlet UITextView *contenttextview;

@end
