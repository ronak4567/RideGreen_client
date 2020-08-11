//
//  DriverCell.h
//  ridegreen
//
//  Created by Ridegreen on 20/10/2015.
//  Copyright (c) 2015 Ridegreen. All rights reserved.
//
#import "EXPhotoViewer.h"
#import <UIKit/UIKit.h>

@interface DriverCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *BgImageView;

@property (strong, nonatomic) IBOutlet UIImageView *driverImageView;
@property (strong, nonatomic) IBOutlet UIImageView *carImageView;

@property (strong, nonatomic) IBOutlet UILabel *driverName;
@property (strong, nonatomic) IBOutlet UILabel *carNumber;
@property (strong, nonatomic) IBOutlet UILabel *distanceLabel;
@property (strong, nonatomic) IBOutlet UILabel *baseFarelabel;
@property (strong, nonatomic) IBOutlet UILabel *perMileLabel;
- (IBAction)carBtnPReesed:(id)sender;
- (IBAction)DriverImageBtnPressed:(id)sender;


@property (retain, nonatomic) IBOutlet UILabel *lbl_AvailableSeats;

@end
