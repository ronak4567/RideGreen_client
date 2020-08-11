//
//  TourPaymentView.h
//  ridegreendriver
//
//  Created by Ridegreen on 02/09/2015.
//  Copyright (c) 2015 Ridegreen. All rights reserved.
//
#import "AppDelegate.h"
#import "MyTour.h"
#import "NetworkHelper.h"
#import "MBProgressHUD.h"
#import "CurrentLocatioView.h"
#import <UIKit/UIKit.h>
#import "TQStarRatingView.h"


@interface TourPaymentView : UIViewController<StarRatingViewDelegate> 
{
    NSUserDefaults *prefs;
    AppDelegate *delg;

}
@property (strong, nonatomic) AFJSONRequestOperation* httpOperation;

@property (retain ,nonatomic) MyTour *tour;
@property (strong, nonatomic) NSString  *totalHours;
@property (strong, nonatomic) NSString  *totalbil;
@property (strong, nonatomic) IBOutlet UILabel *totalHoursLabel;
@property (strong, nonatomic) IBOutlet UILabel *totalBillLabel;
@property (strong, nonatomic) IBOutlet UILabel *successLabel;

@property (retain ,nonatomic) NSString *userId;
@property (retain, nonatomic) IBOutlet UIImageView *reatingStarsImageview;
@property (retain, nonatomic) IBOutlet UILabel *scoreLabel;

@property (retain, nonatomic) IBOutlet UIImageView *rateyourClientImage;
@property (retain, nonatomic) IBOutlet UIImageView *donBtnBg;
@property (retain, nonatomic) IBOutlet UIButton *doneBtn;


@property (nonatomic,strong) IBOutlet TQStarRatingView *starRatingView;
@property (retain, nonatomic) IBOutlet UIImageView *reatingLabel;


- (IBAction)doneBtnPressed:(id)sender;

@end
