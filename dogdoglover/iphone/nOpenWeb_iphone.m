//
//  nOpenWeb.m
//  janbin
//
//  Created by katobit on 10/25/2556 BE.
//  Copyright (c) 2556 Kittipong Kulapruk. All rights reserved.
//

#import "nOpenWeb_iphone.h"
#import "AppDelegate.h"



@interface nOpenWeb_iphone ()

@end

@implementation nOpenWeb_iphone

@synthesize urlMain,type,link;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        urlMain = [[NSString alloc]init];
        type = [[NSString alloc]init];
        link = [[NSString alloc]init];
        // Custom initialization
    }
    
    
    return self;
}

- (void)viewDidLoad
{
    
    
    NSString *urlMaintext=self.urlMain;
    
    NSURL *url = [[NSURL alloc]initWithString:urlMaintext];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [_webMain loadRequest:request];
    
    
    
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

-(BOOL)webView:(UIWebView *)descriptionTextView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if (UIWebViewNavigationTypeLinkClicked == navigationType)
    {
        
        if(descriptionTextView.tag == 1)
        {
            NSURL *URL = [request URL];
            NSString *urlReal =[[NSString alloc]initWithFormat:@"%@",URL];
            
            nOpenWeb_iphone *OpenWeb = [[nOpenWeb_iphone alloc]initWithNibName:@"nOpenWeb_iphone" bundle:nil];
            OpenWeb.urlMain = urlReal;

            
            
            [self.navigationController pushViewController:OpenWeb animated:YES];
            
        }
        else
        {
            
            //
            
            NSURL *URL = [request URL];
            
            
            if ([URL.scheme isEqualToString:@"tel"]) {
                //[[UIApplication sharedApplication] openURL:URL];
                return YES;
            }
            
            NSLog(@"This is Click 2 :%@",URL);
            NSString *urlReal =[[NSString alloc]initWithFormat:@"%@",URL];
            
            nOpenWeb_iphone *OpenWeb = [[nOpenWeb_iphone alloc]initWithNibName:@"nOpenWeb_iphone" bundle:nil];
            OpenWeb.urlMain = urlReal;
            
            [self.navigationController pushViewController:OpenWeb animated:YES];
        }
        return NO;
    }
    return YES;
}


- (void)webViewDidStartLoad: (UIWebView *)webView
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}
- (void)webViewDidFinishLoad: (UIWebView *)webView
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;

    
    UIButton *a2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [a2 setFrame:CGRectMake(0, 0, 20, 20)];
    [a2 addTarget:self action:@selector(closePage:) forControlEvents:UIControlEventTouchUpInside];
    //[a2 setImage:[UIImage imageNamed:@"menu-arrow.png"] forState:UIControlStateNormal];
    [a2 setImage:[UIImage imageNamed:@"member-arrow.png"] forState:UIControlStateNormal];
    UIBarButtonItem *random2 = [[UIBarButtonItem alloc] initWithCustomView:a2];
    
    self.navigationItem.leftBarButtonItem = random2;
}

- (void)viewDidAppear:(BOOL)animated
{

    [super viewDidAppear:animated];
}

- (IBAction)closePage:(id)sender
{
    @try
    {

        [self.navigationController popViewControllerAnimated:YES];

    }
    @catch (NSException *exception)
    {
        NSLog(@"ERROR : %@",exception);
    }
}

- (void)didReceiveMemoryWarning
{
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
