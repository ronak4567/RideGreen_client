//
//  AvailableDriverCell.h
//  ridegreen
//
//  Created by Ridegreen on 31/08/2015.
//  Copyright (c) 2015 Ridegreen. All rights reserved.
//
#import "EXPhotoViewer.h"
#import <UIKit/UIKit.h>

@interface AvailableDriverCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *driverImageView;
@property (strong, nonatomic) IBOutlet UILabel *driverName;
@property (strong, nonatomic) IBOutlet UILabel *perHourRate;
@property (strong, nonatomic) IBOutlet UILabel *cityName;
@property (strong, nonatomic) IBOutlet UIButton *regidterTourBtn;
@property (retain, nonatomic) IBOutlet UIView *bgView;
@property (assign) BOOL isImage;
- (IBAction)driverImgBtnPressed:(id)sender;

@end
