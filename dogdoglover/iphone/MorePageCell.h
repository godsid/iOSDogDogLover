//
//  MorePageCell.h
//  LifeStation
//
//  Created by arkom on 9/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MorePageCell : UITableViewCell
{
    UIActivityIndicatorView *actionLoad;
    UILabel *name ;
    
}
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *actionLoad;
@property (strong, nonatomic) IBOutlet UILabel *name;
@end
