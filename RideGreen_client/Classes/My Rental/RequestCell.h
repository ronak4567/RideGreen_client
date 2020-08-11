//
//  RequestCell.h
//  ridegreen
//
//  Created by Ridegreen on 29/10/2015.
//  Copyright (c) 2015 Ridegreen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RequestCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *roomsAndBedslabel;
@property (strong, nonatomic) IBOutlet UILabel *pricePerMonth;
@property (strong, nonatomic) IBOutlet UILabel *roomAdressLabel;

@property (retain, nonatomic) IBOutlet UIButton *cilentInfoBtn;
@property (retain, nonatomic) IBOutlet UIButton *rejectBtn;
@property (retain, nonatomic) IBOutlet UIButton *acceptBtn;
@property (retain, nonatomic) IBOutlet UIImageView *roomImgView;
@property (retain, nonatomic) IBOutlet UILabel *statusLabel;
@property (assign) BOOL isImage;
@property (retain, nonatomic) IBOutlet UIButton *imgBtn;
@property (retain, nonatomic) IBOutlet UILabel *roomType;
@property (retain, nonatomic) IBOutlet UIButton *checkInOutBtn;
@property (retain, nonatomic) IBOutlet UIImageView *checkInOutBg;
@property (retain, nonatomic) IBOutlet UILabel *checkinDateLabel;
//@property (retain, nonatomic) IBOutlet UIImageView *editDateBg;
//@property (retain, nonatomic) IBOutlet UIButton *editDateBtn;

@property (retain, nonatomic) IBOutlet UIImageView *img_CancelRoom;
@property (retain, nonatomic) IBOutlet UIButton *btn_CancelRoom;
@property (retain, nonatomic) IBOutlet UILabel *lbl_CheckInDate;
@property (retain, nonatomic) IBOutlet UILabel *lbl_RoomStatus;

@end
