//
//  TourCell.h
//  ridegreen
//
//  Created by Ridegreen on 01/09/2015.
//  Copyright (c) 2015 Ridegreen. All rights reserved.
//
#import "EXPhotoViewer.h"
#import <UIKit/UIKit.h>

@interface TourCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *driverImageView;
@property (strong, nonatomic) IBOutlet UILabel *driverNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *driverRateLabel;
@property (strong, nonatomic) IBOutlet UIButton *phonebtn;
@property (strong, nonatomic) IBOutlet UILabel *expectedHoursLabel;
@property (strong, nonatomic) IBOutlet UILabel *meetupAddress;
@property (strong, nonatomic) IBOutlet UIButton *mapBtn;
@property (strong, nonatomic) IBOutlet UILabel *meetupTimeLabel;
@property (strong, nonatomic) IBOutlet UIButton *goToMeetupLocationBtn;
@property (retain, nonatomic) IBOutlet UIImageView *goToMeetUpLocationBg;
@property (assign) BOOL isImage;

@property(strong, nonatomic) IBOutlet UIButton* btn_CancelTour;
@property(strong, nonatomic) IBOutlet UIImageView* img_CancelTour;

@property (retain, nonatomic) IBOutlet UIButton *btn_DriverInfo;

- (IBAction)driverImgBtnPressed:(id)sender;

@end
