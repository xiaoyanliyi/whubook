//
//  ZBarViewController.h
//  whubook2
//
//  Created by lxyy on 15/3/14.
//  Copyright (c) 2015年 lxyy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZBarSDK.h"

@interface ZBarViewController : UIViewController<ZBarReaderDelegate>

//@property (weak, nonatomic) IBOutlet UIImageView *imageView;
- (IBAction)scan:(id)sender;
//@property (weak, nonatomic) IBOutlet UILabel *label;


@end
