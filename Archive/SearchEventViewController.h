//
//  SearchEventViewController.h
//  London Club Nights
//
//  Created by NITS_IPhone on 6/9/15.
//  Copyright (c) 2015 Manab Kumar Mal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MenuViewController.h"
#import "SlideNavigationController.h"
#import "FeaturedTableViewCell.h"
#import <iAd/iAd.h>
#import <CoreLocation/CoreLocation.h>
#import "HCSStarRatingView.h"
#import <HCSStarRatingView/HCSStarRatingView.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>

@import GoogleMobileAds;

@interface SearchEventViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,GADBannerViewDelegate>
{
    NSUInteger reloads_;

    IBOutlet UILabel *lblUnreadCount;
    
    IBOutlet UITableView *tblvw;
    IBOutlet UITableView *tblsearch;
    IBOutlet UILabel *lblHeader;

    IBOutlet UITableView *tblAutoSearch;
    NSMutableArray *arrAutoSearch;
    
    IBOutlet UIButton *btnEvents;
    IBOutlet UIButton *btnFeatured;
    IBOutlet UIButton *btnSearch;
    
    
    IBOutlet UIScrollView *scrlsearch;
    IBOutlet UITextField *tfSearch;
    
    NSTimer *aTimer;
    NSTimer *timerForHud;
    NSMutableArray *arrEvents;
    NSMutableArray *arrfeatured;
    NSMutableArray *arrSearchedList;
    NSMutableArray *searchedListAge;
    
    NSString *strSessName;
    NSString *strSessVal;
    
    CLGeocoder *geocoder;
    CLPlacemark *placemark;
    NSString *strAddr;
    NSString *newString;
}
@property (strong, nonatomic) GADBannerView  *bannerView;
-(IBAction)btnEventsPressed:(id)sender;
-(IBAction)btnFeaturedPressed:(id)sender;
-(IBAction)btnSearchPressed:(id)sender;


-(IBAction)btnR_BPressed:(id)sender;
-(IBAction)btnHipHopPressed:(id)sender;
-(IBAction)btnGaragePressed:(id)sender;
-(IBAction)btnHousePressed:(id)sender;
-(IBAction)btnAfrobeatPressed:(id)sender;
-(IBAction)btnDanceHallPressed:(id)sender;
-(IBAction)btnGrimePressed:(id)sender;
-(IBAction)btnD_BPressed:(id)sender;
-(IBAction)btnBirthdayPressed:(id)sender;
-(IBAction)btnConcertsPressed:(id)sender;
-(IBAction)btnFestivalPressed:(id)sender;
-(IBAction)btnStudentPressed:(id)sender;
-(IBAction)btnUKPressed:(id)sender;
-(IBAction)btnSmartPressed:(id)sender;
-(IBAction)btnLatePressed:(id)sender;



-(IBAction)btn18PlusPressed:(id)sender;
-(IBAction)btn24PlusPressed:(id)sender;
-(IBAction)btn30PlusPressed:(id)sender;


-(IBAction)btnSearch:(id)sender;
-(IBAction)btnSearchCrossPressed:(id)sender;

//-(IBAction)btnRateItNowTap:(id)sender;
//-(IBAction)btnRemindMeLaterTap:(id)sender;
//-(IBAction)btnNoThanksTap:(id)sender;
-(void)updateUnreadLebel;

@end
