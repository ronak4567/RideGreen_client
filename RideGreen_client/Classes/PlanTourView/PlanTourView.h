//
//  PlanTourView.h
//  ridegreen
//
//  Created by Ridegreen on 31/08/2015.
//  Copyright (c) 2015 Ridegreen. All rights reserved.
//


#import "AppDelegate.h"


#import <UIKit/UIKit.h>


@interface PlanTourView : UIViewController<UITextFieldDelegate,CustomIOSAlertViewDelegate>
{
    AppDelegate *delg;
    CustomIOSAlertView *alertView ;
    NSMutableArray *cityNames ;
    NSMutableArray *cityIds,*marray_CityTax ;
    NSMutableArray *stateNames ;
    NSMutableArray *stateIds ;
    NSMutableArray *allDrivers;
    BOOL isTableViewShown;
    BOOL doesContain;
    BOOL isState;
    BOOL isCity;

}
@property (retain, nonatomic) IBOutlet UITextField *stateTF;
@property (retain, nonatomic) IBOutlet UITextField *cityTf;
@property (strong, nonatomic) IBOutlet UIView      *availableView;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong ,nonatomic)          UITableView *selectionTable;
@property (strong, nonatomic) IBOutlet IQDropDownTextField *tourDateTf;
@property (strong, nonatomic) IBOutlet IQDropDownTextField *tour_numberOfHourTF;
@property (strong, nonatomic) IBOutlet IQDropDownTextField *tour_startTimeTF;
@property (strong, nonatomic) IBOutlet IQDropDownTextField *tour_endTimeTf;

@property (nonatomic, strong) NSString *selectedStateId;
@property (nonatomic, strong) NSString *selectedCityId;
@property (nonatomic, strong) NSString *selectedStateName;
@property (nonatomic, strong) NSString *selectedCityName;

@property (nonatomic, strong) NSString *str_CityTaxRate;

@property (nonatomic, strong) IGLDropDownMenu *StateDropDownMenu;
@property (nonatomic, strong) IGLDropDownMenu *citiesDropDownMenu;
- (IBAction)availableDriversBtnPressed:(id)sender;
- (IBAction)backBtnPressed:(id)sender;

@end
