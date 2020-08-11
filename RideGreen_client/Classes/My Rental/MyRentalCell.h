//
//  MyRentalCell.h
//  ridegreen
//
//  Created by Ridegreen on 28/10/2015.
//  Copyright (c) 2015 Ridegreen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyRentalCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *roomsAndBedslabel;
@property (strong, nonatomic) IBOutlet UILabel *pricePerMonth;
@property (strong, nonatomic) IBOutlet UILabel *roomAdressLabel;
@property (strong, nonatomic) IBOutlet UILabel *rentedDate;
@property (strong, nonatomic) IBOutlet UISwitch *enableSwitch;

@property (retain, nonatomic) IBOutlet UIImageView *roomImgView;
@property (retain, nonatomic) IBOutlet UIButton *imgBtn;
@property (retain, nonatomic) IBOutlet UILabel *roomType;

@property (assign) BOOL isImage;
- (IBAction)onButtonTUI:(id)sender ;
@end
