//
//  RegisterTourView.h
//  ridegreen
//
//  Created by Ridegreen on 31/08/2015.
//  Copyright (c) 2015 Ridegreen. All rights reserved.
//
#import "AppDelegate.h"

#import <UIKit/UIKit.h>
#define MAXLENGTH 6
@interface RegisterTourView : UIViewController<GMSMapViewDelegate,CustomIOSAlertViewDelegate,BSForwardGeocoderDelegate,UITextViewDelegate>
{
    CustomIOSAlertView *alertView ;
    NSUserDefaults *prefs;
    AppDelegate *delg;
    MapView *mapView;
    GMSMapView *mView;
    BSKmlResult *place;
    
__block NSString *locatedaddress;
    BOOL IsMoveUp;
    __block NSString *currentCoordinats;

    NSString *str_CusId;
    NSString *str_TourId;
    NSString *str_amount;

}

@property (strong ,nonatomic) NSString *str_amount,*str_TotalPayment;

@property (nonatomic, retain) NSString *userId;

@property (strong, nonatomic) NSString *tourSelectedDate;
@property (strong, nonatomic) NSString *tourStartUpTime;
@property (strong, nonatomic) NSString *tourTravelHours;
@property (strong, nonatomic) NSString *tourTaxRate;



@property (strong, nonatomic) NSString *selectedDriverId;
@property (strong, nonatomic) NSString *selectedCityId;
@property (strong, nonatomic) NSString *perHourRate;
@property (strong, nonatomic) NSString *successMsg;
@property (strong, nonatomic) AFJSONRequestOperation* httpOperation;
@property (nonatomic, retain) BSForwardGeocoder *forwardGeocoder;
@property (strong, nonatomic) IBOutlet UITextField *tourDateTF;
@property (strong, nonatomic) IBOutlet IQDropDownTextField *numberOfHourTF;
@property (strong, nonatomic) IBOutlet IQDropDownTextField *startTimeTF;
@property (strong, nonatomic) IBOutlet IQDropDownTextField *endTimeTf;
@property (strong, nonatomic) IBOutlet IQDropDownTextField *meetupTimeTF;
@property (strong, nonatomic) IBOutlet UITextField *meetUpLocationTF;
@property (strong, nonatomic) IBOutlet GCPlaceholderTextView *commentsTV;
@property (retain, nonatomic) IBOutlet UIButton *myLocationBtn;
@property (retain, nonatomic) IBOutlet UIButton *fromMapBtn;

- (IBAction)backBtnPressed:(id)sender;

- (IBAction)checkFarebtnPressed:(id)sender;

- (IBAction)fromMapBtnPressed:(id)sender;


- (IBAction)myLocationBtnPressed:(id)sender;
- (IBAction)submitBtnPressed:(id)sender;
@end
