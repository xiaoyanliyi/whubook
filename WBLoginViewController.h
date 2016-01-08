//
//  WBLoginViewController.h
//  whubook2
//
//  Created by lxyy on 15/3/17.
//  Copyright (c) 2015年 lxyy. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol pushToPersonalCenterViewDelegate <NSObject>
-(void) pushToPCView;
@end


@interface WBLoginViewController : UIViewController
{
    id<pushToPersonalCenterViewDelegate> pushToPCViewdelegate;
}

@property (nonatomic, assign) id<pushToPersonalCenterViewDelegate> delegate;

@property (weak, nonatomic) IBOutlet UITextField *loginIDTextField;
@property (weak, nonatomic) IBOutlet UITextField *loginPasswordTextField;
- (IBAction)login:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;

@end
