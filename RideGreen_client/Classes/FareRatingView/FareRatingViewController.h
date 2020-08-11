//
//  FareRatingViewController.h
//  fivestar
//
//  Created by Ridegreen on 15/09/2014.
//  Copyright (c) 2014 Ridegreen. All rights reserved.
//
#import "AppDelegate.h"
#import <UIKit/UIKit.h>

@interface FareRatingViewController : UIViewController<StarRatingViewDelegate,AVAudioPlayerDelegate>

@property (nonatomic,strong)IBOutlet TQStarRatingView *starRatingView;
@property (retain, nonatomic) IBOutlet UIImageView *reatingStarsImageview;

@property (strong, nonatomic) IBOutlet UILabel *fareLabel;
- (IBAction)proceedBtnPressed:(id)sender;
@property (retain, nonatomic) IBOutlet UILabel *scoreLabel;


@property (retain, nonatomic) IBOutlet UIView *cashAndCCView;
@property (retain, nonatomic) IBOutlet UITextField *totalPaidTF;
@property (retain, nonatomic) IBOutlet UIButton *cashBtn;
@property (retain, nonatomic) IBOutlet UIButton *ccBtn;

@property (retain, nonatomic) IBOutlet UILabel *waitingLabel;
@property (retain, nonatomic) IBOutlet UIImageView *rateTitleImageView;
@property (nonatomic,retain) NSString *isMyRental;
@property (nonatomic, retain) NSString *roomid;
@property (nonatomic, retain) NSString *roomfare;


@end
