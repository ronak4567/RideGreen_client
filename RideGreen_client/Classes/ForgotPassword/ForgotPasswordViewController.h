//
//  ForgotPasswordViewController.h
//  ridegreendriver
//
//  Created by VGS_036 on 19/01/16.
//  Copyright © 2016 Ridegreen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "AppDelegate.h"

@interface ForgotPasswordViewController : UIViewController<UITextFieldDelegate,UIViewControllerTransitioningDelegate>
{
    AppDelegate *delg;
    NSUserDefaults *prefs;
}

@property (retain, nonatomic) IBOutlet UITextField *txt_Email;

- (IBAction)action_Back:(id)sender;
- (IBAction)action_Submit:(id)sender;
@end
