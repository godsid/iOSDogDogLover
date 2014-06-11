//
//  mainView_iphone.h
//  dogdoglover
//
//  Created by katobit on 6/5/2557 BE.
//  Copyright (c) 2557 katobit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "EGORefreshTableHeaderView.h"

#import "GADBannerView.h"

#import "GADInterstitialDelegate.h"

#import "GAI.h"

@class GADInterstitial;
@class GADRequest;


@interface mainView_iphone : GAITrackedViewController<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,MFMailComposeViewControllerDelegate,MFMessageComposeViewControllerDelegate,EGORefreshTableHeaderDelegate,GADBannerViewDelegate,GADInterstitialDelegate>
{
    NSString *urlMain;
    NSMutableArray *tableElements;
    NSMutableArray *tableElementsTitle;
    NSMutableArray *tableElementsImg;
    NSMutableArray *tableElementsUrl;
    NSMutableDictionary *imgCache;
    
    EGORefreshTableHeaderView *_refreshHeaderView;
    BOOL _reloading;
    
    NSString *netxPage;
    

}
@property(nonatomic, strong) GADInterstitial *interstitial;

@property (strong, nonatomic) IBOutlet UITableView *mainTable;
@property (strong, nonatomic) NSString *urlMain;
@property (strong, nonatomic) NSMutableArray *tableElements;
@property (strong, nonatomic) NSMutableArray *tableElementsTitle;
@property (strong, nonatomic) NSMutableArray *tableElementsImg;
@property (strong, nonatomic) NSMutableArray *tableElementsUrl;
@property (strong, nonatomic) NSMutableDictionary *imgCache;

@property (strong, nonatomic) NSString *netxPage;

@property (nonatomic, strong) GADBannerView *admobBannerView;

- (GADRequest *)request;

@end
