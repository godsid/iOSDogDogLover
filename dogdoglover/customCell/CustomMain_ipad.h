//
//  MorePageCell.h
//  LifeStation
//
//  Created by arkom on 9/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CustomMain_ipad : UITableViewCell
{
    UILabel *txtName;
    UIImageView *mainImg;
    UIButton *btShare;
}
@property (strong, nonatomic) IBOutlet UIImageView *mainImg;
@property (strong, nonatomic) IBOutlet UILabel *txtName;
@property (strong, nonatomic) IBOutlet UIButton *btShare;
@end
