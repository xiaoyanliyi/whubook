//
//  AddPictureViewController.h
//  whubook2
//
//  Created by lxyy on 15/3/12.
//  Copyright (c) 2015年 lxyy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddPictureViewController : UIViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIAlertViewDelegate>
{
    UITextView *contenttextview;
    UIImageView *contentimageview;
    NSString *lastChosenMediaType;

}
@property(nonatomic,retain) IBOutlet UITextView *contenttextview;
@property(nonatomic,retain)  IBOutlet   UIImageView *contentimageview;
@property(nonatomic,copy)        NSString *lastChosenMediaType;
-(IBAction)buttonclick:(id)sender;

@end