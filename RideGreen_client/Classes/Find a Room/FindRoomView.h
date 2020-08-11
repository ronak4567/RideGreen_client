//
//  FindRoomView.h
//  ridegreen
//
//  Created by Ridegreen on 30/10/2015.
//  Copyright (c) 2015 Ridegreen. All rights reserved.
//
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import "SDImageCache.h"
#import "MWCommon.h"
#import "AppDelegate.h"


#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "TQStarRatingView.h"


typedef  void (^roomResponseBlock) (BOOL status);

@interface FindRoomView : UIViewController<CustomIOSAlertViewDelegate,UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate,MWPhotoBrowserDelegate,MFMailComposeViewControllerDelegate,StarRatingViewDelegate>
{
    AppDelegate *delg;
    CustomIOSAlertView *alertView ;
    NSUserDefaults *userdefault;
    NSMutableArray *allRentedrooms;
    NSMutableArray *stateNames;
    NSMutableArray *stateIds;
    NSMutableArray *cityNames;
    NSMutableArray *cityIds;
    NSMutableArray *_selections;
    BOOL displayActionButton;
    BOOL displaySelectionButtons;
    BOOL displayNavArrows;
    BOOL enableGrid;
    BOOL startOnGrid;
    BOOL autoPlayOnAppear;

    BOOL isState;
    BOOL isCity;
    BOOL isRequest;
    NSString *totalRent;
    STPopupTransitionStyle _transitionStyle;
    STPopupController *popupController ;
    TJSpinner *cSpinner;
    
    NSMutableArray *taxRates;


}
@property (nonatomic, strong) NSMutableArray *photos;
@property (nonatomic, strong) NSMutableArray *thumbs;
@property (nonatomic, strong) NSMutableArray *assets;
@property (nonatomic, strong) ALAssetsLibrary *ALAssetsLibrary;

@property (retain, nonatomic) IBOutlet UILabel *lbl_priceperRate;


@property (retain, nonatomic) IBOutlet UITextView *txtview_Description;




@property (retain, nonatomic) IBOutlet UITextField *stateTF;
@property (retain, nonatomic) IBOutlet UITextField *cityTf;
@property (retain, nonatomic) IBOutlet IQDropDownTextField *dateTf;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong ,nonatomic) UITableView *selectionTable;

@property (nonatomic,retain)  NSString *userId;
@property (nonatomic, strong) NSString *selectedStateId;
@property (nonatomic, strong) NSString *selectedCityId;
@property (nonatomic, strong) NSString *selectedStateName;
@property (nonatomic, strong) NSString *selectedCityName;
@property (nonatomic, strong) NSString *selectedNumberofDays;

@property (nonatomic,readwrite) NSInteger   selectedIndex ;

//===================Room Detail ===========

@property (strong,readwrite)   RenterRequest *renRequest;
@property (retain, nonatomic) IBOutlet UIView *detailView;
@property (retain, nonatomic) IBOutlet UIImageView *roomImageView;
@property (retain, nonatomic) IBOutlet UILabel *roomAddressLabel;
@property (retain, nonatomic) IBOutlet UILabel *bedsRoomsLabel;
@property (retain, nonatomic) IBOutlet UIView *addressView;
@property (retain, nonatomic) IBOutlet UIImageView *ownerImageView;

@property (retain, nonatomic) IBOutlet UILabel *ownerNameLabel;
@property (retain, nonatomic) IBOutlet UILabel *ownerPhoneLabel;
@property (retain, nonatomic) IBOutlet UILabel *roomDescrip;

@property (nonatomic, strong) NSString *selectedTaxRate;

@property (retain, nonatomic) IBOutlet UILabel *lbl_SecurityDeposit;


- (IBAction)callBtnPressed:(id)sender;

- (IBAction)detailBackBtnPressed:(id)sender;
- (IBAction)requestBtnPressed:(id)sender;

- (void)loadAssets;

- (IBAction)action_Email:(id)sender;


@property (retain, nonatomic) IBOutlet TQStarRatingView *img_StarRating;
















@end
