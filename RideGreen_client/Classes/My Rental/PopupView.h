//
//  PopupView.h
//  ridegreen
//
//  Created by Ridegreen on 29/10/2015.
//  Copyright (c) 2015 Ridegreen. All rights reserved.
//
#import "EXPhotoViewer.h"
#import <UIKit/UIKit.h>

@interface PopupView : UIView
@property (retain, nonatomic) IBOutlet UIImageView *clientImageView;
@property (retain, nonatomic) IBOutlet UILabel *nameLabel;
@property (retain, nonatomic) IBOutlet UILabel *phoneLabel;

@property (retain, nonatomic) IBOutlet UIButton *callBtn;

@property (retain, nonatomic) IBOutlet UILabel *lbl_ClientRating;

@property (retain, nonatomic) IBOutlet UIView *bgView;

@property (assign) BOOL isImage;
- (IBAction)onButtonTUI:(id)sender ;
@end
