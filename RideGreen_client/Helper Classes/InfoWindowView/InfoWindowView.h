//
//  InfoWindowView.h
//  fivestartdriver
//
//  Created by Ridegreen on 05/09/2014.
//  Copyright (c) 2014 Ridegreen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InfoWindowView : UIView
@property (retain, nonatomic) IBOutlet UIImageView *clientImageView;
@property (retain, nonatomic) IBOutlet UILabel *ClientNameLabel;
@property (retain, nonatomic) IBOutlet UILabel *clientPhoneNumLabel;
@property (retain, nonatomic) IBOutlet UILabel *locationLabel;
@property (retain, nonatomic) IBOutlet UIButton *asPickupLocationBtn;

@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *activityIndecator;
@end
