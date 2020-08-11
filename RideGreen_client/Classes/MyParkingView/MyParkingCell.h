//
//  MyParkingCell.h
//  ridegreen
//
//  Created by Ridegreen on 30/08/2015.
//  Copyright (c) 2015 Ridegreen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyParkingCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *parkingNameLb;
@property (strong, nonatomic) IBOutlet UILabel *rateLb;
@property (strong, nonatomic) IBOutlet UILabel *pakringLocationLb;
@property (strong, nonatomic) IBOutlet UIButton *deletBtn;
@property (strong, nonatomic) IBOutlet UIButton *renewBtn;
@property (strong, nonatomic) IBOutlet UIImageView *renewBtnBG;
@property (strong, nonatomic) IBOutlet UILabel *disableLb;
@property (strong, nonatomic) IBOutlet UISwitch *disableSwitch;

@end
