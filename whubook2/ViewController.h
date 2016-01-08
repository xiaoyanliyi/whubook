//
//  ViewController.h
//  whubook2
//
//  Created by lxyy on 15/3/6.
//  Copyright (c) 2015年 lxyy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZBarSDK.h"


@interface ViewController : UIViewController<ZBarReaderDelegate>
{
    
}

- (IBAction)scan:(id)sender;

@property NSDictionary *dic;
@property NSString *typeStr;

@end

