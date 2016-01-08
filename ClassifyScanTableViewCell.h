//
//  ClassifyScanTableViewCell.h
//  whubook2
//
//  Created by lxyy on 15/4/7.
//  Copyright (c) 2015年 lxyy. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "EGOImageView/EGOImageView.h"
#import "EMAsyncImageView/EMAsyncImageView.h"
//@class EGOImageView;

@interface ClassifyScanTableViewCell : UITableViewCell
{

//    __weak IBOutlet EGOImageView *egoImgView;
//    IBOutlet UILabel *titleLbl;
//    IBOutlet UILabel *priceLbl;
//    IBOutlet UILabel *levelLbl;
//    IBOutlet UILabel *academyLbl;
//    IBOutlet UILabel *descriptionLbl;
    
}

@property (weak, nonatomic) IBOutlet EMAsyncImageView *asyncImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UILabel *priceLbl;
@property (weak, nonatomic) IBOutlet UILabel *levelLbl;
@property (weak, nonatomic) IBOutlet UILabel *academyLbl;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLbl;




@end
