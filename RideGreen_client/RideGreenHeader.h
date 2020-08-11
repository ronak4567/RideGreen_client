//
//  RideGreenHeader.h
//  ridegreendriver
//
//  Created by Ridegreen on 07/09/2015.
//  Copyright (c) 2015 Ridegreen. All rights reserved.
//

#ifndef ridegreendriver_RideGreenHeader_h
#define ridegreendriver_RideGreenHeader_h

#define LETTERS  @"0123456789abcdefghijkABCDEFGHIJKLMNOPlmnopqrstuvwxyzQRSTUVWXYZ0123456789"

#define kSegmentedIndicatorColor	[UIColor colorWithRed:0.0 / 255.0 green:131.0 / 255.0 blue:75.0 / 255.0 alpha:1.0]
#define kSegmentedBgColor  [UIColor colorWithRed:0.0 / 255.0 green:164.0 / 255.0 blue:88.0 / 255.0 alpha:1.0]
#define Cell_Bg_color [UIColor colorWithRed: 220.0/255.0 green: 220.0/255.0 blue: 220.0/255.0 alpha: 0.8];
#define COMPANY_NUMBER @"206-637-6627"

// App fonts
#define  Heading_font ((UIFont *)[UIFont fontWithName:@"Roboto-BoldItalic" size:30])
#define  Lable_font ((UIFont *)[UIFont fontWithName:@"Roboto-Light" size:14])
#define  TextField_font ((UIFont *)[UIFont fontWithName:@"Roboto-Bold" size:20])
#define  Button_font ((UIFont *)[UIFont fontWithName:@"Roboto-Bold" size:20])


#define White_ColorCG [[UIColor whiteColor] CGColor]
#define Gray_colorCG  [[UIColor grayColor]  CGColor]
#define Black_colorCG [[UIColor blackColor]  CGColor]
#define Black_Color   [UIColor blackColor]
#define White_Color   [UIColor whiteColor]
#define Gray_color    [UIColor grayColor] 

#define kShadowColor1		[UIColor blackColor]
#define kShadowColor2		[UIColor colorWithWhite:0.0 alpha:0.75]
#define kShadowOffset1		CGSizeMake(0.0, UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? 4.0 : 2.0)
#define kShadowOffset2		CGSizeMake(0.0, UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? 2.0 : 1.0)
#define kShadowBlur1		(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? 10.0 : 5.0)
#define kShadowBlur2		(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? 4.0 : 2.0)

#define kStrokeColor		[UIColor whiteColor]
#define kStrokeSize			(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? 6.0 : 2.0)

#define kGradientStartColor	[UIColor colorWithRed:255.0 / 255.0 green:193.0 / 255.0 blue:127.0 / 255.0 alpha:1.0]
#define kGradientEndColor	[UIColor colorWithRed:255.0 / 255.0 green:163.0 / 255.0 blue:64.0 / 255.0 alpha:1.0]

#define isiPhone4  ([[UIScreen mainScreen] bounds].size.height == 480)?TRUE:FALSE
#define isiPhone5  ([[UIScreen mainScreen] bounds].size.height == 568)?TRUE:FALSE
#define isiPhone6  ([[UIScreen mainScreen] bounds].size.height == 667)?TRUE:FALSE
#define isiPhone6_plus  ([[UIScreen mainScreen] bounds].size.height == 667)?TRUE:FALSE
#define isiPhone  (UI_USER_INTERFACE_IDIOM() == 0)?TRUE:FALSE

#define KBase_MAP_URL @"https://maps.googleapis.com/maps/api/distancematrix/json?"
#define Get_Destance_URL @"http://maps.google.com//maps/api/distancematrix/json?"

#define KBaseUrl    @"http://192.168.2.176/"

#define kAPIHost   @"http://192.168.2.176/ridegreen/mappservicesia/"

#define kBASE_ROOM_IMG_URL   @"http://192.168.2.176/ridegreen/mappservicesia/upload/roomImages/"

#define KStripUrl  @"http://192.168.2.176/ridegreen/mappservicesia/tocken-test/Stripe1.php?"

#define KRefundUrl @"http://192.168.2.176/ridegreen/mappservicesia/tocken-test/Refund/payment.php?"

#define Kregister_stripe_url @"http://192.168.2.176/ridegreen/mappservicesia/tocken-test/register_stripe.php?"

#define STRIPE_TEST_PUBLIC_KEY @"pk_test_KkiDtZbA89VZwmH16FtKr1of" //pk_test_3E1aCiSrl2mIbAEYseunkKs8

#define STRIPE_TEST_POST_URL @"http://192.168.2.176/"  //airadsapp.com

#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
#define IS_IOS_AT_LEAST(ver)    ([[[UIDevice currentDevice] systemVersion] compare:ver] != NSOrderedAscending)

#define kPayPalEnvironment PayPalEnvironmentSandbox

#define kShadowColor1		[UIColor blackColor]
#define kShadowColor2		[UIColor colorWithWhite:0.0 alpha:0.75]
#define kShadowOffset1		CGSizeMake(0.0, UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? 4.0 : 2.0)
#define kShadowOffset2		CGSizeMake(0.0, UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? 2.0 : 1.0)
#define kShadowBlur1		(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? 10.0 : 5.0)
#define kShadowBlur2		(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? 4.0 : 2.0)

#define kStrokeColor		[UIColor whiteColor]
#define kStrokeSize			(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? 6.0 : 2.0)

#define kGradientStartColor	[UIColor colorWithRed:255.0 / 255.0 green:193.0 / 255.0 blue:127.0 / 255.0 alpha:1.0]
#define kGradientEndColor	[UIColor colorWithRed:255.0 / 255.0 green:163.0 / 255.0 blue:64.0 / 255.0 alpha:1.0]

#define kLabelAllowance 30.0f
#define kStarViewHeight 25.0f
#define kStarViewWidth 157.0f
#define kLeftPadding 15.0f
#define all_Drivers @"car_drivers"
#define Black_Car @"1"
#define SUV @"2"
#define Wagon @"3"

#define  Balck_Car_Image @"car_black.png"
#define  SUV_Image       @"car_suv.png"
#define  Wagon_Image     @"car-wagon.png"

// Networks Errors

#define  GOT_500         @"Expected status code in (200-299), got 500"
#define NETWORK_LOST     @"The network connection was lost."
#define STREAM_EXHAUSTED @"request body stream exhausted"
#define TIME_OUT         @"The request timed out."


@class AppDelegate;
@class StatusViewController;

@class MyTour;
@class MapView;
@class TourScreenView;
@class TQStarRatingView;


// customClasses
#import "API.h"
#import "STPopup.h"
#import "TJSpinner.h"
#import "Stripe.h"
#import "SVGeocoder.h"
#import "Signature.h"
#import "AFNetworking.h"
#import "NetworkHelper.h"
#import "MBProgressHUD.h"
#import "MZRSlideInMenu.h"
#import "UIImage+Resize.h"
#import "IGLDropDownMenu.h"
#import "LRouteController.h"
#import "InfoWindowView.h"
#import "RWStripeViewController.h"
#import "StarRatingView.h"
#import "TQStarRatingView.h"
#import "BSForwardGeocoder.h"
#import "IQDropDownTextField.h"
#import "GCPlaceholderTextView.h"
#import "NSDictionary_JSONExtensions.h"
#import "VPImageCropperViewController.h"
#import "AFURLConnectionOperation.h"
#import "NYAlertViewController.h"
#import "DALinedTextView.h"
#import "TQStarRatingView.h"
#import "NSDate+Utilities.h"
#import "ErrorFunctions.h"
#import "MapView.h"
#import "PopupView.h"
#import "Reachability.h"
#import "CustomIOSAlertView.h"
#import "IGLDropDownMenu.h"
#import "HMSegmentedControl.h"
#import "PopupViewController1.h"
#import "MWPhotoBrowser.h"
// project Classes 
#import "MapView.h"
#import "Driver.h"

#import "DriverCell.h"
#import "MainViewController.h"
#import "RegisterViewController.h"

#import "CurrentLocatioView.h"
#import "ProfileViewController.h"
#import "FareRatingViewController.h"
#import "TermsAndConditionsView.h"
#import "HowToUseView.h"

// parking 


#import "Parking.h"
#import "AddParkingView.h"
#import "MyParkingView.h"
#import "MyParkingCell.h"

// Tour
#import "MyTour.h"
#import "TourCell.h"
#import "MyTourView.h"
#import "TourScreenView.h"
#import "TourPaymentView.h"
#import "RegisterTourView.h"
#import "AvailableDriver.h"
#import "AvailableDriverCell.h"
#import "PlanTourView.h"


// rental rooms
#import "AddRoomForRent.h"
#import "MyRentalView.h"
#import "MyRentalCell.h"
#import "RequestCell.h"
#import "RentalRooms.h"
#import "RenterRequest.h"
#import "FindRoomView.h"
#import "FindRoomCell.h"
// Frameworks 

#import <MapKit/MapKit.h>
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

#import <GoogleMaps/GoogleMaps.h>
#import <AVFoundation/AVFoundation.h>
#import <CFNetwork/CFNetwork.h>
#import <CoreLocation/CoreLocation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>


#endif
