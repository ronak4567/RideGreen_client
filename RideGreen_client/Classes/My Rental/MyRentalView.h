//
//  MyRentalView.h
//  ridegreen
//
//  Created by Ridegreen on 28/10/2015.
//  Copyright (c) 2015 Ridegreen. All rights reserved.
//
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import "SDImageCache.h"
#import "MWCommon.h"

#import "AppDelegate.h"
#import "CMyRental.h"
#import "CMyRented.h"
#import "CMyRequested.h"
#import "RenterRequest.h"

@interface MyRentalView : UIViewController<UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate,MWPhotoBrowserDelegate,CustomIOSAlertViewDelegate,UITextFieldDelegate>
{
    NSMutableArray *myRentalrooms;
    NSMutableArray *allRentedrooms;
    NSMutableArray *allRequestes;

    NSUserDefaults *userdefault;
    NSInteger  selectedSegment;
   

    STPopupTransitionStyle _transitionStyle;
    STPopupController *popupController ;
    
    NSMutableArray *_selections;
    BOOL displayActionButton;
    BOOL displaySelectionButtons;
    BOOL displayNavArrows;
    BOOL enableGrid;
    BOOL startOnGrid;
    BOOL autoPlayOnAppear;
    
    CustomIOSAlertView *alertView;
    CustomIOSAlertView *daysAlertView;
    UITextField *noofDaysTF;
    
    RenterRequest *lastRented;
    NSInteger changeIndex;
    BOOL isChangeIndex;
   NSString *str_amount,*str_RefundAmount,*str_TotalAmoun;
       
}


@property (strong ,nonatomic) NSString *str_amount,*str_RefundAmount,*str_TotalAmoun;

@property (assign) BOOL isMyRented;
@property (nonatomic, strong) NSMutableArray *photos;
@property (nonatomic, strong) NSMutableArray *thumbs;
@property (nonatomic, strong) NSMutableArray *assets;
@property (nonatomic, strong) ALAssetsLibrary *ALAssetsLibrary;

@property (retain, nonatomic) IBOutlet UIImageView *screentitelImageView;

@property (nonatomic,retain) NSString *userId;

@property (nonatomic,retain) NSString *str_MyRequest;

@property (nonatomic,retain) NSString *tokenId;
@property (nonatomic,retain) NSString *totalRent;
@property (strong, nonatomic) AFJSONRequestOperation* httpOperation;

@property (nonatomic, strong) HMSegmentedControl *segmentedControl;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong ,nonatomic) UITableView *selectionTable;
@property (nonatomic, strong) NSString *selectedNumberofDays;
@property (retain, nonatomic) IBOutlet IQDropDownTextField *dateTf;
@property (retain, nonatomic) IBOutlet UIImageView *img_ReserveRoom;

@end
