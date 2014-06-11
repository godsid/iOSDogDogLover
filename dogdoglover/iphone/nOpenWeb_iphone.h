//
//  nOpenWeb.h
//  janbin
//
//  Created by katobit on 10/25/2556 BE.
//  Copyright (c) 2556 Kittipong Kulapruk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface nOpenWeb_iphone : UIViewController<UIWebViewDelegate>
{
    NSString *urlMain;
    NSString *type;
    NSString *link;
}
@property (strong, nonatomic) NSString *urlMain;
@property (strong, nonatomic) NSString *type;
@property (strong, nonatomic) NSString *link;


@property (strong, nonatomic) IBOutlet UIWebView *webMain;



@end
