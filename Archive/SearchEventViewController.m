//
//  SearchEventViewController.m
//  London Club Nights
//
//  Created by NITS_IPhone on 6/9/15.
//  Copyright (c) 2015 Manab Kumar Mal. All rights reserved.
//

#import "SearchEventViewController.h"
#import "AppDelegate.h"
#import "CategorySearchController.h"
#import "AutoSearchCell.h"
#import "EventDetailsController.h"
#import "MenuViewController2.h"
#import "ChatController.h"
#import "YouTubeListController.h"
#include "Reachability.h"
#import "UberRidesViewController.h"


@interface SearchEventViewController ()

{
    BOOL isEvent;
    BOOL isFeatured;
}

@end

@implementation SearchEventViewController


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    isEvent=NO;
    isFeatured=NO;
    AppDelegate *appDel=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    appDel.navViewController=@"SearchEventViewController";
    
    
    
    // If no pickup location is specified, the default is to use current location
    //UBSDKRideParameters *parameters = [[[UBSDKRideParametersBuilder alloc] init] build];
    // You can also explicitly the parameters to use current location
    
    //UBSDKRideRequestButton *btnUber=[[UBSDKRideRequestButton alloc]initWithFrame:CGRectMake(100, 10, 40, 40)];
    
    scrlsearch.hidden=YES;
    scrlsearch.scrollEnabled=YES;
    
    tblsearch.frame=CGRectMake(0,66 , self.view.frame.size.width, self.view.frame.size.height-112-66-110);
    
    tblsearch.hidden=YES;
    isEvent=YES;
    tblAutoSearch.hidden=YES;
    
    reloads_ = 1;
    [self getEventList];
    
}

/*- (void)textViewText:(id)notification {
    
    NSLog(@"Do something here...");
}*/



-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [[UINavigationBar appearance] setTintColor:nil];
    [[UINavigationBar appearance] setTitleTextAttributes:@{ NSForegroundColorAttributeName : [UIColor blackColor]}];
    [[UINavigationBar appearance] setBarTintColor:nil];
    [[self navigationController]setNavigationBarHidden:NO];
    
    [MMNeedMethods GATracker:@"SearchEventViewController"];
    self.view.userInteractionEnabled=YES;
    tblAutoSearch.hidden=YES;
    
    
    [self.bannerView removeFromSuperview];
    self.bannerView = [[GADBannerView alloc] initWithAdSize:kGADAdSizeSmartBannerPortrait];
    self.bannerView.delegate = self;
    self.bannerView.adUnitID = ADUNITID;
    self.bannerView.rootViewController = self.navigationController;
    [self.bannerView loadRequest:[GADRequest request]];
    
    if (IS_IPAD)
    {
        scrlsearch.contentSize=CGSizeMake(self.view.frame.size.width, 1100);
    }
    else if(IS_IPHONE)
    {
        scrlsearch.frame=CGRectMake(0, 112, self.view.frame.size.width, self.view.frame.size.height-self.bannerView.frame.size.height);
        scrlsearch.contentSize=CGSizeMake(self.view.frame.size.width, self.view.frame.size.height+100);
    }
    
    ////////////////////////////CODE CHANGE START MANAB/////////////////////////////
    
    self.navigationItem.titleView = nil;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"menu_text_new"] forBarMetrics:UIBarMetricsDefault];
    
    [[self navigationController]setNavigationBarHidden:NO];
    [self.navigationItem setHidesBackButton:YES];
    
    //........navigation view
    
    UIView *vw=[[UIView alloc] initWithFrame:CGRectMake(30,0,IS_IPHONE?self.view.frame.size.width-100:self.view.frame.size.width-120,30)];
    UILabel *navLabel = [[UILabel alloc] initWithFrame:CGRectMake(IS_IPHONE?0:-5,0,200,30)];
    navLabel.text = @"Menu";
    navLabel.textColor = [UIColor whiteColor];
    [vw addSubview:navLabel];
    
    //.........Back arrow
    
    UIImage *buttonImage = [UIImage imageNamed:@"back_arrow"];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:buttonImage forState:UIControlStateNormal];
    button.frame = CGRectMake(0,0, 25, 25);
    [button addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *customBarItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = customBarItem;
    //..........Youtube button
    
    UIButton *btnYoutube=[[UIButton alloc]initWithFrame:CGRectMake(vw.frame.size.width-40, 0, 30, 29)];
    [btnYoutube setBackgroundImage:[UIImage imageNamed:@"youtube"] forState:UIControlStateNormal];
    [btnYoutube addTarget:self action:@selector(youtubeList:) forControlEvents:UIControlEventTouchUpInside];
    [vw addSubview:btnYoutube];
    
    //..........Uber Button
    
    UIButton *btnUber=[[UIButton alloc]initWithFrame:CGRectMake(vw.frame.size.width-90, 0, 30, 30)];
    [btnUber setBackgroundImage:[UIImage imageNamed:@"uber_badge.png"] forState:UIControlStateNormal];
    [btnUber addTarget:self action:@selector(UberRidePageOpen:) forControlEvents:UIControlEventTouchUpInside];
    [vw addSubview:btnUber];
    
    //..............Chat Button
    
    UIButton *btnChat=[[UIButton alloc]initWithFrame:CGRectMake(vw.frame.size.width-140, 0, 30, 30)];
    [btnChat setBackgroundImage:[UIImage imageNamed:@"chat_live"] forState:UIControlStateNormal];
    [btnChat addTarget:self action:@selector(chatAction:) forControlEvents:UIControlEventTouchUpInside];
    [vw addSubview:btnChat];
    
    //.........Label chat unread count....
    
    lblUnreadCount=[[UILabel alloc]initWithFrame:CGRectMake(vw.frame.size.width-120, -10, 20, 20)];
    lblUnreadCount.layer.cornerRadius=10.0f;
    lblUnreadCount.clipsToBounds=YES;
    lblUnreadCount.textAlignment=NSTextAlignmentCenter;
    lblUnreadCount.textColor=[UIColor whiteColor];
    lblUnreadCount.backgroundColor=[UIColor redColor];
    lblUnreadCount.hidden=YES;
    [vw addSubview:lblUnreadCount];
    [self performSelector:@selector(updateUnreadLebel)  withObject:nil afterDelay:2.0];

    self.navigationItem.titleView = vw;
    
    /////////////////////////CODE CHANGE END MANAB//////////////////////////////////
}
-(void)updateUnreadLebel
{
    AppDelegate *appDel=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    if (appDel.countUnreadChat>0)
    {
        lblUnreadCount.hidden=NO;
        lblUnreadCount.text=[NSString stringWithFormat:@"%d",appDel.countUnreadChat];
    }
    else
    {
        lblUnreadCount.hidden=YES;
    }
}

-(IBAction)youtubeList:(id)sender
{
    YouTubeListController *vc=(YouTubeListController*)[[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"YouTubeListController"];
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)UberRidePageOpen:(id)sender
{
    UberRidesViewController *vc=(UberRidesViewController*)[[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"UberRidesViewController"];
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)modalViewControllerWillDismiss:(UBSDKModalViewController * _Nonnull)modalViewController
{
    
}
- (void)modalViewControllerDidDismiss:(UBSDKModalViewController * _Nonnull)modalViewController
{
    
}

-(IBAction)chatAction:(id)sender
{
    ChatController *vc=(ChatController*)[[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"ChatController"];
    // [self.navigationController pushViewController:vc animated:YES];
    
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)adViewDidReceiveAd:(GADBannerView *)bannerView
{
    dispatch_async(dispatch_get_main_queue(), ^{
    @try
    {
        [self.bannerView removeFromSuperview];
    }
    @catch (NSException *exception)
    {
        
    }
    @finally
    {
        [self.view addSubview:self.bannerView];
        bannerView.frame = CGRectMake(0.0,
                                      self.view.frame.size.height -
                                      bannerView.frame.size.height,
                                      bannerView.frame.size.width,
                                      bannerView.frame.size.height);
    }
        });
}



-(void)getEventList
{
    //if (arrEvents.count==0) {
         //http://londonclubnights.net/webservice/service.php?auth=fcea920f7412b5da7be0cf42b8c93759&action=allevents
        NSString *dataString = [NSString stringWithFormat:@"auth=%@&action=%@&page=%ld",AUTH,@"allEventsForAndroid",(unsigned long)reloads_];
    //NSString *dataString = [NSString stringWithFormat:@"auth=%@&action=%@&page=%ld",AUTH,@"allevents",(unsigned long)reloads_];
    //NSString *dataString = [NSString stringWithFormat:@"auth=%@&action=%@",AUTH,@"allevents"];
        [self serviceCall:@"allevents":dataString];
    //}
    /*
    else
    {
        //[tblvw reloadData];
        [tblvw reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
    }*/
}

-(void)getFeaturedList
{
    if (arrfeatured.count==0) {
        // http://londonclubnights.net/webservice/service.php?auth=fcea920f7412b5da7be0cf42b8c93759&action=featuredevents
        NSString *dataString = [NSString stringWithFormat:@"auth=%@&action=%@",AUTH,@"featuredevents"];
        [self serviceCall:@"featuredevents":dataString];
    }
    else
    {
        //[tblvw reloadData];
        [tblvw reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
    }
}

-(void)serviceCall:(NSString*)serviceName :(NSString*)DataString
{
    if([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == NotReachable)
    {
        [MMNeedMethods showNetworkError];
        return;
    }
    if([serviceName isEqualToString:@"allevents"] || [serviceName isEqualToString:@"featuredevents"] || [serviceName isEqualToString:@"searcheventlists"])
    {
        [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication] delegate].window animated:YES];
        [MBProgressHUD HUDForView:[[UIApplication sharedApplication] delegate].window].labelText = @"Please wait...";
        [timerForHud invalidate];
        timerForHud=[NSTimer scheduledTimerWithTimeInterval:5.0f target:self selector:@selector(changeHudTitle) userInfo:nil repeats:NO];
    }
    else if([serviceName isEqualToString:@"autosearcheventlists"])
    {
        
    }
    else
    {
        [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication] delegate].window animated:YES];
        [MBProgressHUD HUDForView:[[UIApplication sharedApplication] delegate].window].labelText = @"Please wait...";
    }
    
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    [sessionConfiguration setAllowsCellularAccess:YES];
    [sessionConfiguration setHTTPAdditionalHeaders:@{ @"Accept" : @"application/json" }];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",BASE_URL]];
    
    NSLog(@"BaseUrl....=%@%@",BASE_URL,DataString);
    
    // Configure the Request
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setValue:[NSString stringWithFormat:@"%@=%@", strSessName, strSessVal] forHTTPHeaderField:@"Cookie"];
    
    request.HTTPBody = [DataString dataUsingEncoding:NSUTF8StringEncoding];
    request.HTTPMethod = @"POST";
    
    NSLog(@"View Controller registration Data String: %@",DataString);
    // post the request and handle response
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
                                          {
                                              // Handle the Response
                                              if(error)
                                              {
                                                  NSLog(@"%@",[NSString stringWithFormat:@"Connection failed.: %@.", [error description]]);
                                                  
                                                  // Update the View
                                                  dispatch_async(dispatch_get_main_queue(), ^{
                                                      
                                                      // Hide the Loader
                                                      [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication] delegate].window animated:YES];
                                                      [MMNeedMethods showConnectionError];
                                                      reloads_=reloads_>1?reloads_-1:1;
                                                  });
                                                  return;
                                              }
                                              NSArray * cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:request.URL];
                                              for (NSHTTPCookie * cookie in cookies)
                                              {
                                                  NSLog(@"%@=%@", cookie.name, cookie.value);
                                                  strSessName=cookie.name;
                                                  strSessVal=cookie.value;
                                                  
                                                  NSLog(@"%@=%@", strSessName, strSessVal);
                                                  // Here you can store the value you are interested in for example
                                              }
                                              
                                              
                                              
                                              NSString *retVal = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                              
                                              
                                              // NSMutableDictionary *DictUser=[[NSMutableDictionary alloc] initWithDictionary:[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error]];
                                              
                                              NSLog(@"Dict: %@",retVal);
                                              
                                              
                                              
                                              // Update the View
                                              dispatch_async(dispatch_get_main_queue(), ^{
                                                  [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication] delegate].window animated:YES];
                                                  if([serviceName isEqualToString:@"allevents"])
                                                  {
                                                      NSMutableDictionary *dict=[[NSMutableDictionary alloc] initWithDictionary:[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil]];
                                                      
                                                      long int existingCount = 0;
                                                      NSMutableArray *tempArr;
                                                      if ([[dict valueForKey:@"Ack"] integerValue]==1) {
                                                          /*
                                                          tempArr=[[NSMutableArray alloc]initWithArray:[dict objectForKey:@"EventsList"]];
                                                          arrEvents=[[NSMutableArray alloc]initWithArray:tempArr];
                                                      }*/
                                                          
                                                          tempArr=[[NSMutableArray alloc]initWithArray:[dict objectForKey:@"EventsList"]];
                                                          if(arrEvents.count>0)
                                                          {
                                                              existingCount=arrEvents.count;
                                                              if(tempArr.count>0)
                                                              {
                                                                  [arrEvents addObjectsFromArray:tempArr];
                                                                  NSOrderedSet *orderedSet = [NSOrderedSet orderedSetWithArray:arrEvents];
                                                                  arrEvents=[[NSMutableArray alloc]initWithArray:[orderedSet array]];
                                                              }
                                                              else
                                                              {
                                                                  reloads_=reloads_>1?reloads_-1:1;
                                                              }
                                                              
                                                              
                                                          }
                                                          
                                                          
                                                          else
                                                          {
                                                              arrEvents=[[NSMutableArray alloc]initWithArray:tempArr];
                                                          }
                                                          
                                                          
                                                          //[tblvw reloadData];
                                                          
                                                          
                                                      }
                                                      else if ([[dict valueForKey:@"Ack"] integerValue]==0 && [[dict valueForKey:@"COUNT"] integerValue]==0)
                                                      {
                                                          
                                                          reloads_=reloads_>1?reloads_-1:1;
                                                      }
                                                      else{
                                                          arrEvents=[[NSMutableArray alloc]init];
                                                          //[tblvw reloadData];
                                                          
                                                      }
                                                      //=====
                                                      if (arrEvents.count==0) {
                                                          [tblvw reloadData];
                                                      }
                                                      else
                                                      {
                                                          [tblvw reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
                                                      }
                                                      
                                                      if(tempArr.count>0 && arrEvents.count>existingCount && existingCount>0)
                                                      {
                                                          NSIndexPath *indexPath = [NSIndexPath indexPathForRow:existingCount inSection:0];
                                                          existingCount=existingCount-1;
                                                          //if ([self isRowPresentInTableView:existingCount withSection:0])
                                                          if ([self isIndexPathValidInTableView:indexPath inTable:tblvw])
                                                          {
                                                              [tblvw scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionNone animated:NO];
                                                          }
                                                          
                                                      }
                                                  }
                                                  else if ([serviceName isEqualToString:@"featuredevents"]){
                                                      NSMutableDictionary *dict=[[NSMutableDictionary alloc] initWithDictionary:[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil]];
                                                      
                                                      if ([[dict valueForKey:@"Ack"] integerValue]==1) {
                                                          arrfeatured=[[NSMutableArray alloc]init];
                                                          arrfeatured=[dict objectForKey:@"EventsList"];
                                                          
                                                          //[tblvw reloadData];
                                                          
                                                          
                                                      }
                                                      else{
                                                          arrfeatured=[[NSMutableArray alloc]init];
                                                          //[tblvw reloadData];
                                                          
                                                      }
                                                      if (arrfeatured.count==0) {
                                                          [tblvw reloadData];
                                                      }
                                                      else
                                                      {
                                                          [tblvw reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
                                                      }
                                                      
                                                    
                                                  }
                                                  else if ([serviceName isEqualToString:@"searcheventlists"]){
                                                      NSMutableDictionary *dict=[[NSMutableDictionary alloc] initWithDictionary:[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil]];
                                                      
                                                      if ([[dict valueForKey:@"Ack"] integerValue]==1) {
                                                          arrSearchedList=[[NSMutableArray alloc]initWithArray:[dict objectForKey:@"EventsList"]];
                                                          
                                                      }
                                                      else{
                                                          arrSearchedList=[[NSMutableArray alloc]init];
                                                      }
                                                      if (arrSearchedList.count==0) {
                                                          [tblsearch reloadData];
                                                          tblsearch.hidden=YES;
                                                          scrlsearch.scrollEnabled=true;
                                                      }
                                                      else
                                                      {
                                                          scrlsearch.scrollEnabled=false;
                                                          tblsearch.hidden=NO;
                                                          [tblsearch reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
                                                      }
                                                  }
                                                  else if ([serviceName isEqualToString:@"autosearcheventlists"]){
                                                      NSMutableDictionary *dict=[[NSMutableDictionary alloc] initWithDictionary:[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil]];
                                                      
                                                      if ([[dict valueForKey:@"Ack"] integerValue]==1)
                                                      {
                                                          if(tfSearch.text.length>0)
                                                          {
                                                              arrSearchedList=[[NSMutableArray alloc]init];
                                                              arrAutoSearch=[dict objectForKey:@"EventsList"];
                                                              
                                                              //[tblAutoSearch reloadData];
                                                              tblAutoSearch.hidden=NO;
                                                          }
                                                          else
                                                          {
                                                              arrAutoSearch=[[NSMutableArray alloc]init];
                                                              //[tblAutoSearch reloadData];
                                                              tblAutoSearch.hidden=YES;
                                                          }
                                                          
                                                      }
                                                      else{
                                                          arrAutoSearch=[[NSMutableArray alloc]init];
                                                          //[tblAutoSearch reloadData];
                                                          tblAutoSearch.hidden=YES;
                                                      }
                                                      
                                                      //Stopping the collition between two tableview load to stop the crash
                                                      if(tblsearch.isDragging==false)
                                                      {
                                                          if (arrAutoSearch.count==0) {
                                                              [tblAutoSearch reloadData];
                                                          }
                                                          else
                                                          {
                                                              [tblAutoSearch reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
                                                          }
                                                          
                                                      }
                                                  }
                                              });
                                          }];
    
    // Initiate the Request
    [postDataTask resume];
    
}

-(IBAction)backAction:(id)sender
{
    NSUserDefaults *prefs=[NSUserDefaults standardUserDefaults];
    
    if ([[prefs valueForKey:@"usertype"] isEqualToString:@"1"]) {
        for (long int i=self.navigationController.viewControllers.count-1;i>=0; i--) {
            UIViewController *vc=self.navigationController.viewControllers[i];
            if ([vc isKindOfClass:[MenuViewController class]]) {
                [self.navigationController popViewControllerAnimated:YES];
                break;
            }
        }
    }
    else{
        for (long int i=self.navigationController.viewControllers.count-1;i>=0; i--) {
            UIViewController *vc=self.navigationController.viewControllers[i];
            if ([vc isKindOfClass:[MenuViewController2 class]]) {
                [self.navigationController popViewControllerAnimated:YES];
                break;
            }
        }
    }
}

#pragma mark - SlideNavigationController Methods -

- (BOOL)slideNavigationControllerShouldDisplayRightMenu
{
    return YES;
}

#pragma mark Uitable-delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    if (tableView.tag==1) {
        if (isEvent==YES) {
            return arrEvents.count;
        }
        else{
            return arrfeatured.count;
        }
    }
    else if(tableView.tag==2){
        return arrSearchedList.count;
    }
    else if (tableView.tag==3){
        return arrAutoSearch.count;
    }
    return arrEvents.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;

{
    if (tableView.tag==1 || tableView.tag==2) {
        return (IS_IPHONE)?340:517;
    }
    else
    {
        return 44;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *tCell;
    
    if (tableView.tag==1 || tableView.tag==2)
    {
        NSString *cellIdentifier=@"feauturedCell";
        FeaturedTableViewCell *cell=(FeaturedTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if (cell==nil)
        {
            NSArray *nib=[[NSBundle mainBundle] loadNibNamed:@"FeaturedTableViewCell" owner:self options:nil];
            if (IS_IPHONE) {
                cell=[nib objectAtIndex:0];
            }
            else{
                cell=[nib objectAtIndex:1];
            }
        }
        UIButton *btnBk=(UIButton*)[cell viewWithTag:10];
        cell.separatorInset=UIEdgeInsetsZero;
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        btnBk.layer.cornerRadius=5;
        btnBk.userInteractionEnabled=NO;
        btnBk.layer.masksToBounds=YES;
        
        NSDictionary *dict;
        if (tableView.tag==1)
        {
            if (isEvent==YES)
            {
                dict=[arrEvents objectAtIndex:indexPath.row];
            }
            else if(isFeatured==YES)
            {
                dict=[arrfeatured objectAtIndex:indexPath.row];
            }
        }
        else if (tableView.tag==2)
        {
            if(arrSearchedList.count>0)
            {
                dict=[arrSearchedList objectAtIndex:indexPath.row];
            }
            else
            {
                tblsearch.hidden=true;
                return [UITableViewCell new];
            }
            
        }
        //[self setImageWithurl:[dict valueForKey:@"image"] andImageView:cell.imgPhoto];
        [self setImage:[dict valueForKey:@"image"] imageHolder:cell.imgPhoto];
        cell.lblVenue.text=[dict valueForKey:@"app_venue"];
        //cell.lblLocation.text=[[dict valueForKey:@"app_location"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        UIColor *fColor=[MMNeedMethods colorWithHexString:@"2ab9e6"];
        NSString *Loc=[NSString stringWithFormat:@"Location: %@",[[dict valueForKey:@"app_location"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
        
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:Loc];
        [string addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0,9)];
        [string addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15.0f ] range:NSMakeRange(0,9)];
        [string addAttribute:NSForegroundColorAttributeName value:fColor range:NSMakeRange(9,string.length-9)];
        [string addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14.0f ] range:NSMakeRange(9,string.length-9)];
        cell.lblLocation.attributedText=string;
        cell.lblDate.textColor=fColor;
        cell.lblVenue.textColor=fColor;
        cell.lblTime.textColor=fColor;
        cell.lblPrice.textColor=fColor;
        cell.lblName.textColor=fColor;
        
        cell.lblDate.text=[dict valueForKey:@"app_event_date"];
        cell.lblTime.text=[dict valueForKey:@"app_event_time"];
        cell.lblPrice.text=[NSString stringWithFormat:@"%.02f",[[dict valueForKey:@"price"] floatValue]];
        cell.lblName.text=[[[dict valueForKey:@"name"] stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"]stringByReplacingOccurrencesOfString:@"&nbsp" withString:@"&"];
        
        cell.lblName.text=[[[dict valueForKey:@"name"] stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"]stringByReplacingOccurrencesOfString:@"&nbsp" withString:@"&"];

        cell.lblVenue.attributedText=[MMNeedMethods nsmutableStringFontColor:@"Venue: " :[dict valueForKey:@"app_venue"]];
        
        NSString *strLocation=[NSString stringWithFormat:@"%@",[[dict valueForKey:@"app_location"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
        
        cell.lblLocation.attributedText=[MMNeedMethods nsmutableStringFontColor:@"Location: " :strLocation];
        
        cell.lblDate.attributedText=[MMNeedMethods nsmutableStringFontColor:@"Date: " :[dict valueForKey:@"app_event_date"]];
        
        cell.lblTime.attributedText=[MMNeedMethods nsmutableStringFontColor:@"Time: " :[dict valueForKey:@"app_event_time"]];
        
        NSString *strPrice=[NSString stringWithFormat:@"%.02f",[[dict valueForKey:@"price"] floatValue]];
        
        cell.lblPrice.attributedText=[MMNeedMethods nsmutableStringFontColor:@"Price: " :[NSString stringWithFormat:@"£%@",strPrice]];
        
        return cell;
    }
    else if(tableView.tag==3)
    {
        NSString *cellIdentifier=@"feauturedCell";
        AutoSearchCell *cell=(AutoSearchCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if (cell==nil) {
            NSArray *nib=[[NSBundle mainBundle] loadNibNamed:@"AutoSearchCell" owner:self options:nil];
            cell=[nib objectAtIndex:0];
        }
        if(arrAutoSearch.count>0)
        {
            NSDictionary *dict=[arrAutoSearch objectAtIndex:indexPath.row];
            cell.lblName.text=[[[dict valueForKey:@"name"] stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"]stringByReplacingOccurrencesOfString:@"&nbsp" withString:@"&"];
            
            return cell;
        }
    }
    return tCell;
}

/*-(NSMutableAttributedString*)nsmutableStringFontColor:(NSString*)str1 :(NSString*)str2
{
    if(str1.length==0) str1=@"";
    if(str2.length==0) str2=@"";
    
    NSMutableAttributedString *theNames1 = [[NSMutableAttributedString alloc] initWithString:str1];
    
    UIFont *font1 = [UIFont fontWithName:@"Helvetica" size:15];
    [theNames1 addAttribute:NSFontAttributeName value:font1 range:NSMakeRange(0, [theNames1 length])];
    
    // Set background color, again for entire range
    [theNames1 addAttribute:NSForegroundColorAttributeName
                      value:[UIColor darkGrayColor]
                      range:NSMakeRange(0, [theNames1 length])];
    
    NSMutableAttributedString *theNames2 = [[NSMutableAttributedString alloc] initWithString:str2];
    
    UIFont *font2 = [UIFont fontWithName:@"Helvetica" size:15];
    [theNames2 addAttribute:NSFontAttributeName value:font2 range:NSMakeRange(0, [theNames2 length])];
    
    // Set background color, again for entire range
    [theNames2 addAttribute:NSForegroundColorAttributeName
                      value:[UIColor colorWithRed:62.0/255.0 green:163.0/255.0 blue:223.0/255.0 alpha:1]
                      range:NSMakeRange(0, [theNames2 length])];
    
    NSMutableAttributedString *theNames = [[NSMutableAttributedString alloc] init];
    [theNames appendAttributedString:theNames1];
    [theNames appendAttributedString:theNames2];
    return theNames;
}*/

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //[[Crashlytics sharedInstance] crash];
    if (tableView.tag==1)
    {
        NSDictionary *dict;
        if (isEvent==YES)
        {
            dict=[arrEvents objectAtIndex:indexPath.row];
        }
        else if(isFeatured==YES)
        {
            dict=[arrfeatured objectAtIndex:indexPath.row];
        }
        
        UIStoryboard *storyboard=[UIStoryboard storyboardWithName:(IS_IPHONE)?@"Main":@"Storyboard_ipad" bundle:nil];
        EventDetailsController *vc=(EventDetailsController *)[storyboard instantiateViewControllerWithIdentifier:@"EventDetailsController"];
        vc.product_id=[dict valueForKey:@"product_id"];
        vc.type=@"";
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (tableView.tag==2)
    {
        NSDictionary *dict=[arrSearchedList objectAtIndex:indexPath.row];
        
        UIStoryboard *storyboard=[UIStoryboard storyboardWithName:(IS_IPHONE)?@"Main":@"Storyboard_ipad" bundle:nil];
        EventDetailsController *vc=(EventDetailsController *)[storyboard instantiateViewControllerWithIdentifier:@"EventDetailsController"];
        vc.product_id=[dict valueForKey:@"product_id"];
        vc.type=@"";
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (tableView.tag==3){
        tblAutoSearch.hidden=YES;
        if(arrAutoSearch.count>0)
        {
            NSDictionary *dict=[arrAutoSearch objectAtIndex:indexPath.row];
            tfSearch.text=[[[dict valueForKey:@"name"] stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"]stringByReplacingOccurrencesOfString:@"&nbsp" withString:@"&"];
            [tfSearch resignFirstResponder];
            
            NSString *dataString = [NSString stringWithFormat:@"auth=%@&action=%@&key=%@",AUTH,@"searcheventlists",tfSearch.text];
            dataString=[dataString stringByReplacingOccurrencesOfString:@"'" withString:@""];
            [self serviceCall:@"searcheventlists":dataString];
        }
        [tfSearch resignFirstResponder];
    }
}

#pragma mark Uibutton-action

-(IBAction)btnEventsPressed:(id)sender{
    isEvent=YES;
    isFeatured=NO;
    
    if (IS_IPHONE)
    {
        [btnEvents setBackgroundImage:[UIImage imageNamed:@"event_active"] forState:UIControlStateNormal];
        [btnFeatured setBackgroundImage:[UIImage imageNamed:@"featured"] forState:UIControlStateNormal];
        [btnSearch setBackgroundImage:[UIImage imageNamed:@"searh_tab"] forState:UIControlStateNormal];
    }
    else if (IS_IPAD)
    {
        [btnEvents setBackgroundImage:[UIImage imageNamed:@"event_active-ipad"] forState:UIControlStateNormal];
        [btnFeatured setBackgroundImage:[UIImage imageNamed:@"featured-ipad"] forState:UIControlStateNormal];
        [btnSearch setBackgroundImage:[UIImage imageNamed:@"searh_tab-ipad"] forState:UIControlStateNormal];
    }
    
    
    scrlsearch.hidden=YES;
    
    [self getEventList];
}

-(IBAction)btnFeaturedPressed:(id)sender
{
    isEvent=NO;
    isFeatured=YES;
    
    if (IS_IPHONE)
    {
        [btnEvents setBackgroundImage:[UIImage imageNamed:@"event_off"] forState:UIControlStateNormal];
        [btnFeatured setBackgroundImage:[UIImage imageNamed:@"featured_active"] forState:UIControlStateNormal];
        [btnSearch setBackgroundImage:[UIImage imageNamed:@"searh_tab"] forState:UIControlStateNormal];
    }
    else if (IS_IPAD)
    {
        [btnEvents setBackgroundImage:[UIImage imageNamed:@"event-ipad"] forState:UIControlStateNormal];
        [btnFeatured setBackgroundImage:[UIImage imageNamed:@"featured_active-ipad"] forState:UIControlStateNormal];
        [btnSearch setBackgroundImage:[UIImage imageNamed:@"searh_tab-ipad"] forState:UIControlStateNormal];
    }
    
    scrlsearch.hidden=YES;
    
    [self getFeaturedList];
}

-(IBAction)btnSearchPressed:(id)sender
{
    if (IS_IPHONE)
    {
        [btnEvents setBackgroundImage:[UIImage imageNamed:@"event_off"] forState:UIControlStateNormal];
        [btnFeatured setBackgroundImage:[UIImage imageNamed:@"featured"] forState:UIControlStateNormal];
        [btnSearch setBackgroundImage:[UIImage imageNamed:@"search_tab_active"] forState:UIControlStateNormal];
    }
    else if (IS_IPAD)
    {
        [btnEvents setBackgroundImage:[UIImage imageNamed:@"event-ipad"] forState:UIControlStateNormal];
        [btnFeatured setBackgroundImage:[UIImage imageNamed:@"featured-ipad"] forState:UIControlStateNormal];
        [btnSearch setBackgroundImage:[UIImage imageNamed:@"search_tab_active-ipad"] forState:UIControlStateNormal];
    }
    
    scrlsearch.hidden=NO;
}

-(IBAction)btnR_BPressed:(id)sender
{
    UIStoryboard *storyboard=[UIStoryboard storyboardWithName:(IS_IPHONE)?@"Main":@"Storyboard_ipad" bundle:nil];
    CategorySearchController *vc=(CategorySearchController *)[storyboard instantiateViewControllerWithIdentifier:@"CategorySearchController"];
    vc.strCategoryName=@"R&B";
    vc.strCategoryId=@"57";
    [self.navigationController pushViewController:vc animated:YES];
}

-(IBAction)btnHipHopPressed:(id)sender
{
     UIStoryboard *storyboard=[UIStoryboard storyboardWithName:(IS_IPHONE)?@"Main":@"Storyboard_ipad" bundle:nil];
    CategorySearchController *vc=(CategorySearchController *)[storyboard instantiateViewControllerWithIdentifier:@"CategorySearchController"];
    vc.strCategoryName=@"Hip Hop";
    vc.strCategoryId=@"20";
    [self.navigationController pushViewController:vc animated:YES];
}

-(IBAction)btnGaragePressed:(id)sender
{
     UIStoryboard *storyboard=[UIStoryboard storyboardWithName:(IS_IPHONE)?@"Main":@"Storyboard_ipad" bundle:nil];
    CategorySearchController *vc=(CategorySearchController *)[storyboard instantiateViewControllerWithIdentifier:@"CategorySearchController"];
    vc.strCategoryName=@"Garage";
    vc.strCategoryId=@"70";
    [self.navigationController pushViewController:vc animated:YES];
}

-(IBAction)btnHousePressed:(id)sender
{
     UIStoryboard *storyboard=[UIStoryboard storyboardWithName:(IS_IPHONE)?@"Main":@"Storyboard_ipad" bundle:nil];
    CategorySearchController *vc=(CategorySearchController *)[storyboard instantiateViewControllerWithIdentifier:@"CategorySearchController"];
    vc.strCategoryName=@"House";
    vc.strCategoryId=@"66";
    [self.navigationController pushViewController:vc animated:YES];
}

-(IBAction)btnAfrobeatPressed:(id)sender
{
    UIStoryboard *storyboard=[UIStoryboard storyboardWithName:(IS_IPHONE)?@"Main":@"Storyboard_ipad" bundle:nil];
    CategorySearchController *vc=(CategorySearchController *)[storyboard instantiateViewControllerWithIdentifier:@"CategorySearchController"];
    vc.strCategoryName=@"Afrobeat";
    vc.strCategoryId=@"24";
    [self.navigationController pushViewController:vc animated:YES];
}

-(IBAction)btnDanceHallPressed:(id)sender
{
    UIStoryboard *storyboard=[UIStoryboard storyboardWithName:(IS_IPHONE)?@"Main":@"Storyboard_ipad" bundle:nil];
    CategorySearchController *vc=(CategorySearchController *)[storyboard instantiateViewControllerWithIdentifier:@"CategorySearchController"];
    vc.strCategoryName=@"Dancehall";
    vc.strCategoryId=@"75";
    [self.navigationController pushViewController:vc animated:YES];
}

-(IBAction)btnGrimePressed:(id)sender
{
    UIStoryboard *storyboard=[UIStoryboard storyboardWithName:(IS_IPHONE)?@"Main":@"Storyboard_ipad" bundle:nil];
    CategorySearchController *vc=(CategorySearchController *)[storyboard instantiateViewControllerWithIdentifier:@"CategorySearchController"];
    vc.strCategoryName=@"Grime";
    vc.strCategoryId=@"80";//@"76";
    [self.navigationController pushViewController:vc animated:YES];
}

-(IBAction)btnD_BPressed:(id)sender
{
    UIStoryboard *storyboard=[UIStoryboard storyboardWithName:(IS_IPHONE)?@"Main":@"Storyboard_ipad" bundle:nil];
    CategorySearchController *vc=(CategorySearchController *)[storyboard instantiateViewControllerWithIdentifier:@"CategorySearchController"];
    vc.strCategoryName=@"D&B";
    vc.strCategoryId=@"81";
    [self.navigationController pushViewController:vc animated:YES];
}

-(IBAction)btnBirthdayPressed:(id)sender
{
    UIStoryboard *storyboard=[UIStoryboard storyboardWithName:(IS_IPHONE)?@"Main":@"Storyboard_ipad" bundle:nil];
    CategorySearchController *vc=(CategorySearchController *)[storyboard instantiateViewControllerWithIdentifier:@"CategorySearchController"];
    vc.strCategoryName=@"Birthday/Table Deals";
    vc.strCategoryId=@"2";
    [self.navigationController pushViewController:vc animated:YES];
}

-(IBAction)btnConcertsPressed:(id)sender
{   //btn concerts action...
    UIStoryboard *storyboard=[UIStoryboard storyboardWithName:(IS_IPHONE)?@"Main":@"Storyboard_ipad" bundle:nil];
    CategorySearchController *vc=(CategorySearchController *)[storyboard instantiateViewControllerWithIdentifier:@"CategorySearchController"];
    vc.strCategoryName=@"Concerts";
    vc.strCategoryId=@"1";
    [self.navigationController pushViewController:vc animated:YES];
}

-(IBAction)btnFestivalPressed:(id)sender
{ //Festivals action...
    UIStoryboard *storyboard=[UIStoryboard storyboardWithName:(IS_IPHONE)?@"Main":@"Storyboard_ipad" bundle:nil];
    CategorySearchController *vc=(CategorySearchController *)[storyboard instantiateViewControllerWithIdentifier:@"CategorySearchController"];
    vc.strCategoryName=@"Festivals";//@"UK Funky";
    vc.strCategoryId=@"82";//@"74";
    [self.navigationController pushViewController:vc animated:YES];
}

-(IBAction)btnStudentPressed:(id)sender
{
    UIStoryboard *storyboard=[UIStoryboard storyboardWithName:(IS_IPHONE)?@"Main":@"Storyboard_ipad" bundle:nil];
    CategorySearchController *vc=(CategorySearchController *)[storyboard instantiateViewControllerWithIdentifier:@"CategorySearchController"];
    vc.strCategoryName=@"Student";
    vc.strCategoryId=@"77";
    [self.navigationController pushViewController:vc animated:YES];
}

-(IBAction)btnUKPressed:(id)sender
{
    UIStoryboard *storyboard=[UIStoryboard storyboardWithName:(IS_IPHONE)?@"Main":@"Storyboard_ipad" bundle:nil];
    CategorySearchController *vc=(CategorySearchController *)[storyboard instantiateViewControllerWithIdentifier:@"CategorySearchController"];
    vc.strCategoryName=@"UK/Int";
    vc.strCategoryId=@"76";//@"78";
    [self.navigationController pushViewController:vc animated:YES];
}

-(IBAction)btnSmartPressed:(id)sender
{
    UIStoryboard *storyboard=[UIStoryboard storyboardWithName:(IS_IPHONE)?@"Main":@"Storyboard_ipad" bundle:nil];
    CategorySearchController *vc=(CategorySearchController *)[storyboard instantiateViewControllerWithIdentifier:@"CategorySearchController"];
    vc.strCategoryName=@"Smart";
    vc.strCategoryId=@"78";//@"79";
    [self.navigationController pushViewController:vc animated:YES];
}

-(IBAction)btnLatePressed:(id)sender
{
    UIStoryboard *storyboard=[UIStoryboard storyboardWithName:(IS_IPHONE)?@"Main":@"Storyboard_ipad" bundle:nil];
    CategorySearchController *vc=(CategorySearchController *)[storyboard instantiateViewControllerWithIdentifier:@"CategorySearchController"];
    vc.strCategoryName=@"Late";
    vc.strCategoryId=@"79";//@"80";
    [self.navigationController pushViewController:vc animated:YES];
}

-(IBAction)btn18PlusPressed:(id)sender
{
     UIStoryboard *storyboard=[UIStoryboard storyboardWithName:(IS_IPHONE)?@"Main":@"Storyboard_ipad" bundle:nil];
    CategorySearchController *vc=(CategorySearchController *)[storyboard instantiateViewControllerWithIdentifier:@"CategorySearchController"];
    vc.strAge=@"18+";
    vc.isEventListByAge=YES;
    [self.navigationController pushViewController:vc animated:YES];
}

-(IBAction)btn24PlusPressed:(id)sender
{
     UIStoryboard *storyboard=[UIStoryboard storyboardWithName:(IS_IPHONE)?@"Main":@"Storyboard_ipad" bundle:nil];
    CategorySearchController *vc=(CategorySearchController *)[storyboard instantiateViewControllerWithIdentifier:@"CategorySearchController"];
    vc.strAge=@"24+";
    vc.isEventListByAge=YES;
    [self.navigationController pushViewController:vc animated:YES];
}

-(IBAction)btn30PlusPressed:(id)sender
{
     UIStoryboard *storyboard=[UIStoryboard storyboardWithName:(IS_IPHONE)?@"Main":@"Storyboard_ipad" bundle:nil];
    CategorySearchController *vc=(CategorySearchController *)[storyboard instantiateViewControllerWithIdentifier:@"CategorySearchController"];
    vc.strAge=@"30+";
    vc.isEventListByAge=YES;
    [self.navigationController pushViewController:vc animated:YES];
}

-(IBAction)btnSearch:(id)sender
{
    if (tfSearch.text.length==0)
    {
        tblsearch.hidden=YES;
        [tfSearch resignFirstResponder];
    }
    else
    {
        tblAutoSearch.hidden=YES;
        tblsearch.hidden=YES;
        [tfSearch resignFirstResponder];
       //  http://londonclubnights.net/webservice/service.php?auth=fcea920f7412b5da7be0cf42b8c93759&action=autosearcheventlists&key=test
        NSString *dataString = [NSString stringWithFormat:@"auth=%@&action=%@&key=%@",AUTH,@"searcheventlists",[tfSearch.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
        dataString=[dataString stringByReplacingOccurrencesOfString:@"'" withString:@""];
        [self serviceCall:@"searcheventlists":dataString];
    }
    [aTimer invalidate];
}

-(void)setImage:(NSString*)imageURL imageHolder:(UIImageView*)imgvw
{
    if([imageURL isEqualToString:@""])
    {
        imgvw.image=[UIImage imageNamed:@"user_default_icon"];
        return;
    }
    NSString* imageName=[imageURL lastPathComponent];
    NSString *docDir=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0];
    NSString *tempFolderPath = [docDir stringByAppendingPathComponent:@"tmp"];
    [[NSFileManager defaultManager] createDirectoryAtPath:tempFolderPath withIntermediateDirectories:YES attributes:nil error:NULL];
    NSString  *FilePath = [NSString stringWithFormat:@"%@/%@",tempFolderPath,imageName];
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:FilePath];
    if (fileExists)
    {
        imgvw.image=[UIImage imageWithContentsOfFile:FilePath];
        if(!imgvw.image)
        {
            imgvw.image=[UIImage imageNamed:@"user_default_icon"];
        }
    }
    else
    {
        imgvw.image=[UIImage imageNamed:@"user_default_icon"];
        [WebImageOperations processImageDataWithURLString:imageURL andBlock:^(NSData *imageData)
         {
             if(!imageData)
             {
                 imgvw.image=[UIImage imageNamed:@"user_default_icon"];
             }
             else
             {
                 imgvw.image=[UIImage imageWithData:imageData];
                 BOOL finished=[imageData writeToFile:FilePath atomically:YES];
                 if(finished)
                 {
                     [self addSkipBackupAttributeToItemAtURL:[NSURL fileURLWithPath:FilePath isDirectory:NO]];
                 }
             }
         }];
    }
    
}

-(BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL
{
    assert([[NSFileManager defaultManager] fileExistsAtPath: [URL path]]);
    
    const char* filePath = [[URL path] fileSystemRepresentation];
    
    const char* attrName = "com.apple.MobileBackup";
    u_int8_t attrValue = 1;
    
    int result = setxattr(filePath, attrName, &attrValue, sizeof(attrValue), 0, 0);
    return result == 0;
}


#pragma mark Uitextfield-delegate

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

-(void)timerCalled
{
    if (newString.length==0)    {
        tblAutoSearch.hidden=YES;
    }
    else
    {
        /*
        //tblAutoSearch.hidden=NO;
        tblsearch.hidden=YES;
        NSString *dataString = [NSString stringWithFormat:@"auth=%@&action=%@&key=%@",AUTH,@"autosearcheventlists",[newString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
        [self serviceCall:@"autosearcheventlists":dataString];*/
        
        tblsearch.hidden=YES;
        [tfSearch resignFirstResponder];
        //  http://londonclubnights.net/webservice/service.php?auth=fcea920f7412b5da7be0cf42b8c93759&action=autosearcheventlists&key=test
        NSString *dataString = [NSString stringWithFormat:@"auth=%@&action=%@&key=%@",AUTH,@"searcheventlists",[tfSearch.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
        dataString=[dataString stringByReplacingOccurrencesOfString:@"'" withString:@""];
        [self serviceCall:@"searcheventlists":dataString];
    }
    [aTimer invalidate];
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString * searchStr = [textField.text stringByReplacingCharactersInRange:range withString:string];
    NSLog(@"%@",searchStr);
    newString = searchStr;
    [aTimer invalidate];
    
    //aTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerCalled) userInfo:nil repeats:NO];
    
    return YES;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    tblAutoSearch.hidden=YES;
}

-(IBAction)btnSearchCrossPressed:(id)sender{
    tblsearch.hidden=YES;
    scrlsearch.scrollEnabled=true;
}

-(void)scrollViewDidScroll: (UIScrollView*)scrollView
{
    if ( scrollView==tblvw && scrollView.contentOffset.y + scrollView.frame.size.height == scrollView.contentSize.height)
    {
        reloads_++;
        [self getEventList];
    }
}

-(void)changeHudTitle
{
    if(![[MBProgressHUD HUDForView:[[UIApplication sharedApplication] delegate].window] isHidden])
    {
        [MBProgressHUD HUDForView:[[UIApplication sharedApplication] delegate].window].labelText = @"Please wait \n a few more seconds.";
        [timerForHud invalidate];
    }
    
}
-(BOOL) isRowPresentInTableView:(long int)row withSection:(int)section
{
    if(section < [tblsearch numberOfSections])
    {
        if(row < [tblsearch numberOfRowsInSection:section])
        {
            return YES;
        }
    }
    return NO;
}

-(BOOL)isIndexPathValidInTableView:(NSIndexPath*)indexPath inTable:(UITableView*)tableView
{
    CGRect rect = [tableView rectForRowAtIndexPath:indexPath];
    if(CGRectEqualToRect(rect, CGRectZero)) {
        //they are equal
        return false;
    }else{
        //they aren't equal
        return true;
    }
}

@end
