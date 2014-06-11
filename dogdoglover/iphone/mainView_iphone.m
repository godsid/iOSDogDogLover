//
//  mainView_iphone.m
//  dogdoglover
//
//  Created by katobit on 6/5/2557 BE.
//  Copyright (c) 2557 katobit. All rights reserved.
//

#import "mainView_iphone.h"
#import "MorePageCell.h"
#import "CustomMain.h"
#import "SBJson.h"
#import <Twitter/Twitter.h>
#import "DSActivityView.h"

#import "AppDelegate.h"
#import "GADInterstitial.h"
#import "GADInterstitialDelegate.h"

@interface mainView_iphone ()

@end

@implementation mainView_iphone

@synthesize urlMain,tableElements,tableElementsImg,tableElementsTitle,tableElementsUrl,imgCache,netxPage;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        urlMain = [[NSString alloc]init];
        tableElements = [[NSMutableArray alloc]init];
        tableElementsTitle = [[NSMutableArray alloc]init];
        tableElementsImg = [[NSMutableArray alloc]init];
        tableElementsUrl = [[NSMutableArray alloc]init];
        imgCache = [[NSMutableDictionary alloc]init];
        
        netxPage = [[NSString alloc]init];
        
        // Custom initialization
    }
    return self;
}

#pragma mark GADRequest implementation

- (GADRequest *)request {
    GADRequest *request = [GADRequest request];
    
    // Make the request for a test ad. Put in an identifier for the simulator as well as any devices
    // you want to receive test ads.
    request.testDevices = @[
                            // TODO: Add your device/simulator test identifiers here. Your device identifier is printed to
                            // the console when the app is launched.
                            GAD_SIMULATOR_ID
                            ];
    return request;
}

-(void)viewDidAppear:(BOOL)animated
{

    
    NSArray *ver = [[UIDevice currentDevice].systemVersion componentsSeparatedByString:@"."];
    if ([[ver objectAtIndex:0] intValue] >= 7) {
        self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:(68/255.0f) green:(71/255.0f) blue:(79/255.0f) alpha:1];
        self.navigationController.navigationBar.translucent = NO;
    }else {
        self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:(68/255.0f) green:(71/255.0f) blue:(79/255.0f) alpha:1];
    }
    [super viewDidAppear:animated];
}

- (void)viewDidLoad
{
     self.screenName = @"mainView_iphone";

    _admobBannerView = [[GADBannerView alloc] initWithAdSize:kGADAdSizeBanner];
    _admobBannerView.adUnitID = @"ca-app-pub-4631743491157031/9727647077";
    _admobBannerView.rootViewController = self;
    [self.view addSubview:_admobBannerView];
    //self.mainTable.tableHeaderView =_admobBannerView;
    
    [_admobBannerView loadRequest:[GADRequest request]];
    
    @try {
        [DSBezelActivityView removeViewAnimated:YES];
        [DSBezelActivityView activityViewForView:self.view ];
    }
    @catch (NSException *exception) {
        [DSBezelActivityView removeViewAnimated:YES];
    }
    
    
    self.urlMain = @"https://www.googleapis.com/plus/v1/people/105673786726226588803/activities/public?maxResults=20&orderBy=recent&fields=items(actor/image,object(attachments(image(type,url),objectType)),published,title,url),nextPageToken,updated&key=AIzaSyB3Mde-V5jR7RgKTg5EIw-2nRQHZ-vhAcs";
    
    [NSThread detachNewThreadSelector: @selector(runLoop:) toTarget:self withObject:nil];
    [super viewDidLoad];
    
    self.interstitial = [[GADInterstitial alloc] init];
    self.interstitial.delegate = self;
    
    // Note: Edit SampleConstants.h to update kSampleAdUnitId with your interstitial ad unit id.
    self.interstitial.adUnitID = @"ca-app-pub-4631743491157031/5018245876";
    [self.interstitial loadRequest:[GADRequest request]];
  
    // Do any additional setup after loading the view from its nib.
}

-(IBAction)closeAds:(id)sender
{
    [self.interstitial presentFromRootViewController:self];
}

- (void) runLoop:(id)object
{

    self.title = @"";
    
    UILabel *myLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 40)];
    [myLabel setFont:[UIFont boldSystemFontOfSize:23]];
    [myLabel setTextColor:[UIColor whiteColor]];
    [myLabel setBackgroundColor:[UIColor clearColor]];
    [myLabel setText:@"Dog dog Lover"];
    [self.navigationItem setTitleView:myLabel];
    @try
    {
        NSArray *items = nil;
        NSURL *urlLoop = [NSURL URLWithString:self.urlMain];
        NSString *jsonreturn = [[NSString alloc] initWithContentsOfURL:urlLoop encoding:NSUTF8StringEncoding error:nil];
        SBJsonParser *json = [SBJsonParser new];
        
        NSDictionary *parsedJSON = [json objectWithString:jsonreturn];
        items = [parsedJSON objectForKey:@"items"];
        
        netxPage = [parsedJSON objectForKey:@"nextPageToken"];
        
        
            //int countFirst=0;
            for (NSDictionary *photo in items)
            {
                // Get text
                NSString *title = [NSString stringWithFormat:@"%@",[photo objectForKey:@"title"]];
                NSString *img = [NSString stringWithFormat:@"%@",[[[[[photo objectForKey:@"object"] objectForKey:@"attachments"] objectAtIndex:0] objectForKey:@"image"] objectForKey:@"url"]];
                NSString *url = [NSString stringWithFormat:@"%@",[photo objectForKey:@"url"]];
                
                
                
                [self.tableElementsTitle addObject:title];
                [self.tableElementsImg addObject:img];
                [self.tableElementsUrl addObject:url];
                
                //[self.imgCache setValue:@"" forKey:url];
                [self.imgCache setObject:@"" forKey:url];
                
            }
        
        if (_refreshHeaderView == nil)
        {
            EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.mainTable.bounds.size.height, self.view.frame.size.width, self.mainTable.bounds.size.height)];
            view.delegate = self;
            [self.mainTable addSubview:view];
            _refreshHeaderView = view;
        }
        
        //  update the last update date
        [_refreshHeaderView refreshLastUpdatedDate];
        
        [_mainTable reloadData];
        [_mainTable setHidden:NO];
        
        @try {
            [DSBezelActivityView removeViewAnimated:YES];
        }
        @catch (NSException *exception) {
            [DSBezelActivityView removeViewAnimated:YES];
        }
    }
    @catch (NSException *exception)
    {
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"เกิดข้อผิดพลาด" message: @"ระบบไม่สามารถดึงข้อมูลจาก Server ได้ กรุณาลองใหม่อีกครั้ง" delegate: self cancelButtonTitle:@"กรุณาลองใหม่อีกครั้ง" otherButtonTitles:nil  ,nil];
        
        alert.tag = 1;
        [alert show];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark UITableView Datasource Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	
	return 1;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int returnNum=215;
    if(indexPath.row == [self.tableElementsTitle count])
    {
        returnNum=69;
    }
    
    return returnNum;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    int count = (int)[self.tableElementsTitle count];
    if (count >0)
    {
        count=count+1;
    }
    
	return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row == [self.tableElementsTitle count])
    {
        if([self.tableElementsTitle count]>0)
        {
            static NSString *sampleIndentifier = @"morePageCell";
            MorePageCell *cell = (MorePageCell*)[tableView dequeueReusableCellWithIdentifier:sampleIndentifier];
            if (cell == nil)
            {
                cell = [[MorePageCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:sampleIndentifier];
                NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"MorePageCell" owner:nil options:nil];
                
                for(id currentObject in topLevelObjects)
                {
                    if([currentObject isKindOfClass:[UITableViewCell class]])
                    {
                        cell  = (MorePageCell*)currentObject;
                        break;
                    }
                }
            }
            
            [cell.actionLoad setHidden:NO];
            [cell.actionLoad startAnimating];
            
            return cell;
        }
        else
        {
            static NSString *CellIdentifier = @"CellIdentifier";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            
            return cell;
        }
    }
    else
    {
        if([self.tableElementsTitle count]>0)
        {
            static NSString *sampleIndentifier = @"CustomMain";
            CustomMain *cell = (CustomMain*)[tableView dequeueReusableCellWithIdentifier:sampleIndentifier];
            if (cell == nil)
            {
                cell = [[CustomMain alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:sampleIndentifier];
                NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"CustomMain" owner:nil options:nil];
                
                for(id currentObject in topLevelObjects)
                {
                    if([currentObject isKindOfClass:[UITableViewCell class]])
                    {
                        cell  = (CustomMain*)currentObject;
                        break;
                    }
                }
            }
            cell.txtName.text = [self.tableElementsTitle objectAtIndex:indexPath.row];
            [cell.mainImg setImage:[UIImage imageNamed:@"img-preview_iphone"]];
            
            UIImage *imgC = [self.imgCache objectForKey:[self.tableElementsUrl objectAtIndex:indexPath.row]];
            
            
            if (![[self.imgCache objectForKey:[self.tableElementsUrl objectAtIndex:indexPath.row]] isEqual:@""]) {
                [cell.mainImg setImage:imgC];
            } else {
                // set default user image while image is being downloaded
                
                // download the image asynchronously
                
                [self downloadImageWithURL:[NSURL URLWithString:[self.tableElementsImg objectAtIndex:indexPath.row]] completionBlock:^(BOOL succeeded, UIImage *image) {
                    
                    //[cellnearBy.imgMain setImage:[UIImage imageNamed:@"img-preview"] forState:UIControlStateNormal];
                    // [cellnearBy.imgMain setBackgroundColor:[UIColor grayColor]];
                    if (succeeded) {
                        
                        
                        
                        [UIView animateWithDuration:0.7f
                                         animations:^
                         {
                             [cell.mainImg setAlpha:0.0f];
                         }
                                         completion:^(BOOL finished)
                         {
                             [cell.mainImg setAlpha:1.0f];
                             [cell.mainImg setImage:image];
                             [self.imgCache setValue:image forKey:[self.tableElementsUrl objectAtIndex:indexPath.row]];
                         }
                         ];
                        
                        
                    }
                }];
            }
            
            [cell.btShare addTarget:self action:@selector(showActionSheet:) forControlEvents:UIControlEventTouchUpInside];
            cell.btShare.tag = indexPath.row;
            
            return cell;
        }
        else
        {
            
            static NSString *CellIdentifier = @"CellIdentifier";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            
            return cell;
        }
    }
}

#pragma mark -
#pragma mark UITableView Delegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([indexPath row] == [self.tableElementsTitle count])
    {
        if([self.tableElementsTitle count]!=0)
        {
            if([indexPath row]!=0)
            {
                MorePageCell *cell = (MorePageCell *)[self.mainTable cellForRowAtIndexPath:indexPath];
                [cell.actionLoad startAnimating];
                
                [self refreshMore];
                
            }
        }
    }
    else if([indexPath row] == [self.tableElementsTitle count]-1)
    {
        if([self.tableElementsTitle count]!=0)
        {
            if([indexPath row]!=0)
            {
                
                MorePageCell *cell = (MorePageCell *)[self.mainTable cellForRowAtIndexPath:indexPath];
                [cell.actionLoad startAnimating];
            }
        }
    }
}


-(void)showActionSheet:(id)sender
{
    UIActionSheet *actionSheetShow = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Facebook",@"Twitter",@"Email",@"SMS",nil];
    actionSheetShow.tag =[sender tag];
    
    [actionSheetShow showInView:[UIApplication sharedApplication].keyWindow];
}


-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *titleShare = [self.tableElementsTitle objectAtIndex:actionSheet.tag];
    NSString *urlShare = [self.tableElementsUrl objectAtIndex:actionSheet.tag];
    NSString *urlImgShare = [self.tableElementsImg objectAtIndex:actionSheet.tag];
    if(buttonIndex == 0)
    {
        SLComposeViewController *mySLComposerSheet = [[SLComposeViewController alloc] init];
        if(NSClassFromString(@"SLComposeViewController") != nil)//check if Facebook Account is linked
        {
            // mySLComposerSheet = [[SLComposeViewController alloc] init]; //initiate the Social Controller
            mySLComposerSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook]; //Tell him with what social plattform to use it, e.g. facebook or twitter
            
            
            
            //Adding the Text to the facebook post value from iOS
            [mySLComposerSheet setInitialText:titleShare];
            
            //Adding the URL to the facebook post value from iOS
            [mySLComposerSheet addURL:[NSURL URLWithString:urlShare]];
            
            //Adding the IMG to the facebook post value from iOS
            [mySLComposerSheet addImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:urlImgShare]]]];
            
            [self presentViewController:mySLComposerSheet animated:YES completion:nil];
        }
        [mySLComposerSheet setCompletionHandler:^(SLComposeViewControllerResult result) {
            NSString *output;
            switch (result) {
                case SLComposeViewControllerResultCancelled:
                    output = @"ยกเลิก เรียบร้อย!!";
                    break;
                case SLComposeViewControllerResultDone:
                    output = @"Post สำเร็จ!!";
                    break;
                default:
                    break;
            } //check if everythink worked properly. Give out a message on the state.
           // UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Facebook" message:output delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            //[alert show];
        }];

        
    }
    else if(buttonIndex == 1)
    {
        if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
        {
            NSString *bodyMessageTwiiter=[NSString stringWithFormat:@"%@ ",titleShare];
            
            bodyMessageTwiiter= [bodyMessageTwiiter stringByAppendingFormat:@"%@ via @dogdoglover",urlShare];
            
            SLComposeViewController *tweetSheet = [SLComposeViewController
                                                   composeViewControllerForServiceType:SLServiceTypeTwitter];
            [tweetSheet setInitialText:bodyMessageTwiiter];
            [tweetSheet addImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:urlImgShare]]]];
            [self presentViewController:tweetSheet animated:YES completion:nil];
            tweetSheet.completionHandler = ^(TWTweetComposeViewControllerResult res) {
                
                if(res == TWTweetComposeViewControllerResultDone) {
                    
                    NSLog(@"Success!");
                    
                }
                if(res == TWTweetComposeViewControllerResultCancelled) {
                    
                    
                    NSLog(@"");
                    
                }
                [self dismissViewControllerAnimated:YES completion:nil];
                
            };
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"คุณต้องเข้าไปตั้งค่า twitter ใน settings ของโทรศัพท์ก่อน" delegate:self cancelButtonTitle:@"ยกเลิก" otherButtonTitles: nil];
            [alert show];
        }
    }
    else if(buttonIndex == 2)
    {
        @try {
            
            if ([MFMailComposeViewController canSendMail])
            {
                NSString *bodyMessageSendEmail=@"";
                
                bodyMessageSendEmail= [bodyMessageSendEmail stringByAppendingFormat:@"<img src='%@' width=320 height=231><p />%@",urlImgShare,titleShare];
                bodyMessageSendEmail= [bodyMessageSendEmail stringByAppendingFormat:@"<p /><a href='%@'>%@</a> via @dogdoglover",urlShare,urlShare];
                
                MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
                mc.mailComposeDelegate = self;
                [mc setSubject:[NSString stringWithFormat:@"เพื่อนของคุณส่ง %@ จาก App dogdoglover",titleShare]];
                [mc setMessageBody:bodyMessageSendEmail isHTML:YES];
                [mc setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
                
                [self presentViewController:mc animated:YES completion:nil];
                
            }
            else{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"คุณต้องเข้าไปตั้งค่า email ใน settings ของโทรศัพท์ก่อน" delegate:self cancelButtonTitle:@"ยกเลิก" otherButtonTitles: nil];
                [alert show];
            }
            // releasing the controller
        }
        @catch (NSException *exception)
        {
            
        }
        
    }
    else if(buttonIndex == 3)
    {
        
        NSString *bodyMessageSendEmail=[NSString stringWithFormat:@"%@ ",titleShare];
        bodyMessageSendEmail= [bodyMessageSendEmail stringByAppendingFormat:@"%@",urlShare];
        
        MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init];
        if([MFMessageComposeViewController canSendText])
        {
            controller.body = bodyMessageSendEmail;
            controller.messageComposeDelegate = self;
            [self presentViewController:controller animated:YES completion:nil];
        }
    }
    
}

// delegate function callback
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    // switchng the result
    switch (result) {
        case MFMailComposeResultCancelled:
        {
            NSLog(@"Mail send canceled.");
            /*
             Execute your code for canceled event here ...
             */
            break;
        }
        case MFMailComposeResultSaved:
        {
            NSLog(@"Mail saved.");
            /*
             Execute your code for email saved event here ...
             */
            break;
        }
        case MFMailComposeResultSent:
        {
            NSLog(@"Mail sent.");
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Send Mail" message:@"SUCCESS!!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];

            /*
             Execute your code for email sent event here ...
             */
            break;
        }
        case MFMailComposeResultFailed:
        {
            NSLog(@"Mail send error: %@.", [error localizedDescription]);
            /*
             Execute your code for email send failed event here ...
             */
            break;
        }
        default:
            break;
    }
    // hide the modal view controller
    //[self dismissModalViewControllerAnimated:NO];
    [self dismissViewControllerAnimated:NO completion:nil];
    
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
	switch (result) {
		case MessageComposeResultCancelled:
			NSLog(@"Cancelled");
			break;
		case MessageComposeResultFailed:
			/*UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"MyApp" message:@"Unknown Error" delegate:self cancelButtonTitle:@”OK” otherButtonTitles: nil];
             [alert show];
             [alert release];*/
            
            NSLog(@"Error");
			break;
		case MessageComposeResultSent:
            
			break;
		default:
			break;
	}
    
	//[self dismissModalViewControllerAnimated:NO];
    [self dismissViewControllerAnimated:NO completion:nil];
}


- (void)downloadImageWithURL:(NSURL *)url completionBlock:(void (^)(BOOL succeeded, UIImage *image))completionBlock
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               if ( !error )
                               {
                                   
                                   UIImage *image = [[UIImage alloc] initWithData:data];
                                   completionBlock(YES,image);
                               } else{
                                   completionBlock(NO,nil);
                               }
                           }];
}

#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods
- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view
{
	[self reloadTableViewDataSource];
	[self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:2.0];
}
- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view
{
	return _reloading; // should return if data source model is reloading
}
- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view
{
	return [NSDate date]; // should return date data source was last changed
}

#pragma mark -
#pragma mark Data Source Loading / Reloading Methods
- (void)reloadTableViewDataSource
{
	//  should be calling your tableviews data source model to reload
	_reloading = YES;
}

- (void)doneLoadingTableViewData
{
	//  model should call this when its done loading
    [self refresh];
    
	_reloading = NO;
	[_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.mainTable];
}

- (void)refresh
{
    @try {
        [DSBezelActivityView removeViewAnimated:YES];
        [DSBezelActivityView activityViewForView:self.view ];
    }
    @catch (NSException *exception) {
        [DSBezelActivityView removeViewAnimated:YES];
    }
    
    
    [NSThread detachNewThreadSelector: @selector(runLoop:) toTarget:self withObject:nil];
}

#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
}

- (void)refreshMore
{

    
    self.urlMain = [NSString stringWithFormat:@"%@&pageToken=%@",self.urlMain,netxPage];
    
    [NSThread detachNewThreadSelector: @selector(runLoop:) toTarget:self withObject:nil];
}


@end
