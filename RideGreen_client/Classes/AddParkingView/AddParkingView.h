//
//  AddParkingView.h
//  ridegreen
//
//  Created by Ridegreen on 30/08/2015.
//  Copyright (c) 2015 Ridegreen. All rights reserved.
//


#import "AppDelegate.h"

#import <UIKit/UIKit.h>
@interface AddParkingView : UIViewController <GMSMapViewDelegate,CustomIOSAlertViewDelegate,BSForwardGeocoderDelegate,UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,UITextFieldDelegate>
{
    NSMutableArray *cityNames ;
    NSMutableArray *cityIds ;
    NSMutableArray *marry_parkingSpace;
    BOOL isParkingSpace;
    

}

@property (nonatomic, strong) IGLDropDownMenu *dropDownMenu;
@property (nonatomic, retain) BSForwardGeocoder *forwardGeocoder;


@property (nonatomic,strong) NSString *selectedCityId;
@property (strong, nonatomic) IBOutlet UITextField *parkingNameTF;
@property (strong, nonatomic) IBOutlet UITextField *perHourRateTF;


@property (retain, nonatomic) IBOutlet UITextField *txt_Spaces;


@property (strong ,nonatomic) UITableView *selectionTable;
@property (strong, nonatomic) UITextField *alertextField;



@property (nonatomic, strong) NSString *selectedParkingSpace,*Spaceparking;

@property (strong, nonatomic) IBOutlet UITextField *parkingLocationTF;
@property (strong, nonatomic) IBOutlet UISwitch *disableEnableSwitch;
@property (strong, nonatomic) IBOutlet UIButton *useCurrentLocationBtn;
@property (strong, nonatomic) IBOutlet UIButton *selectFromMapBtn;

@property (strong, nonatomic) IBOutlet UILabel *disableParkingLb;

- (IBAction)currentLocationBtnPressed:(id)sender;
- (IBAction)selectFromMapBtnPressed:(id)sender;
- (IBAction)backBtnPressed:(id)sender;

- (IBAction)submitBtnPressed:(id)sender;

- (IBAction)disableEnableSwitchChanged:(id)sender;

@end
