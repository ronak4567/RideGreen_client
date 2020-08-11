//
//  CustomAlertview.h
//  fivestartdriver
//
//  Created by Ridegreen on 25/08/2015.
//  Copyright (c) 2015 Ridegreen. All rights reserved.
//
#import "UIPlaceHolderTextView.h"
#import <UIKit/UIKit.h>

@interface CustomAlertview : UIView
@property (retain, nonatomic) IBOutlet UILabel *titelLabel;
@property (retain, nonatomic) IBOutlet UIPlaceHolderTextView *AddressTV;
@property (retain, nonatomic) IBOutlet UITextField *zipCodeTF;
@property (retain, nonatomic) IBOutlet UIButton *cancelBtn;
@property (retain, nonatomic) IBOutlet UIButton *doneBtn;





@end
