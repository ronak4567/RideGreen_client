//
//  FindRoomCell.h
//  ridegreen
//
//  Created by Ridegreen on 30/10/2015.
//  Copyright (c) 2015 Ridegreen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FindRoomCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *roomsAndBedslabel;
@property (strong, nonatomic) IBOutlet UILabel *pricePerMonth;
@property (strong, nonatomic) IBOutlet UILabel *roomAdressLabel;
@property (retain, nonatomic) IBOutlet UILabel *roomTypeLabel;
@property (retain, nonatomic) IBOutlet UIView *priceView;


@property (retain, nonatomic) IBOutlet UIView *bgView;

@property (retain, nonatomic) IBOutlet UIView *roomTypeView;
@property (retain, nonatomic) IBOutlet UIImageView *roomImgView;
@property (assign) BOOL isImage;

@end
