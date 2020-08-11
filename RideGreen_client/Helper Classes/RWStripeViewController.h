//
//  RWPaymentViewController.h
//  RWPuppies
//
//  Created by Pietro Rea on 12/25/12.
//  Copyright (c) 2012 Pietro Rea. All rights reserved.
//
#import "AppDelegate.h"
#import "MBProgressHUD.h"
#import "RWCheckoutInputCell.h"
#import "RWCheckoutDisplayCell.h"
#import "RegisterViewController.h"
#import "AFNetworking.h"
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "Stripe.h"
//#define STRIPE_TEST_PUBLIC_KEY @"pk_test_3E1aCiSrl2mIbAEYseunkKs8"
//#define STRIPE_TEST_POST_URL @"http://airadsapp.com"


@protocol SampleProtocolDelegate <NSObject>
- (void) expirationDate :(NSString *)str_date CardNumber :(NSString *)str_CardNo;

@end



@class RegisterViewController;


@interface RWStripeViewController : UIViewController<NSURLConnectionDelegate>
{
    RegisterViewController *registerView;
     id<SampleProtocolDelegate> delegate;
}

@property (retain, nonatomic) IBOutlet UIButton *bckBtn;
- (IBAction)bckBtnPressed:(id)sender;
@property (nonatomic,assign) id<SampleProtocolDelegate> delegate;



@end
