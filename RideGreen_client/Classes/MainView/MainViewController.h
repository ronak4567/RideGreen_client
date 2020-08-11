//
//  MainViewController.h
//  FiveStarLuxury_client
//
//  Created by Ridegreen on 22/06/2014.
//  Copyright (c) 2014 Ridegreen. All rights reserved.
//
#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>

@interface MainViewController : UIViewController<UITextFieldDelegate,AVAudioPlayerDelegate>


- (IBAction)logBtnPressed:(id)sender;
- (IBAction)regsBtnPressed:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField *emailTF;
@property (strong, nonatomic) IBOutlet UITextField *passwordTf;

- (IBAction)howToUseBtnPressed:(id)sender;


@end
