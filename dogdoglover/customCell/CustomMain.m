//
//  MorePageCell.m
//  LifeStation
//
//  Created by arkom on 9/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CustomMain.h"


@implementation CustomMain

@synthesize txtName,mainImg,btShare;

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end