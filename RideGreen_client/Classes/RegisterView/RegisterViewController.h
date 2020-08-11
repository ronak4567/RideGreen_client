//
//  RegisterViewController.h
//  fiveStarLuxuryCars
//
//  Created by Ridegreen on 06/05/2014.
//  Copyright (c) 2014 Ridegreen. All rights reserved.
//
#import "AppDelegate.h"

#import "CustomIOSAlertView.h"
#import "RWStripeViewController.h"

@interface RegisterViewController : UIViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate,UIActionSheetDelegate, UIPopoverControllerDelegate,CustomIOSAlertViewDelegate>
{
  UIImagePickerController *imagePickerController;
    NSMutableArray *stateNames ;
    NSMutableArray *stateIds ;
    NSMutableArray *cityNames ;
    NSMutableArray *cityIds ;
    NSMutableArray *allDrivers;
    CustomIOSAlertView *alertView;
    NSString *selectedTextField;
    BOOL isViewUp;
    BOOL isTermsCondition;
}
- (IBAction)action_Terms:(id)sender;

@property (retain, nonatomic) IBOutlet UIButton *btn_Terms;

@property (nonatomic, strong) NSString *selectedStateId;
@property (nonatomic, strong) NSString *selectedCityId;
@property (nonatomic, strong) NSString *selectedStateName;
@property (nonatomic, strong) NSString *selectedCityName;
@property (strong ,nonatomic)UITableView *selectionTable;
- (IBAction)action_TermsConditions:(id)sender;



@property (strong, nonatomic) IBOutlet UITextField *stateTF;
@property (strong, nonatomic) IBOutlet UITextField *cityTF;

@property(nonatomic, strong, readwrite) UIPopoverController *flipsidePopoverController;
@property (retain, nonatomic) IBOutlet UIImageView *placeholderImgView;
@property (retain, nonatomic) IBOutlet UIButton *signBtn;
@property (retain, nonatomic) IBOutlet UITextField *countryCodeTf;
@property (retain, nonatomic) IBOutlet UIButton *registerBtn;
@property (retain, nonatomic) IBOutlet UITextField *emailTf;
@property (retain, nonatomic) IBOutlet UITextField *mobileTf;

@property (retain, nonatomic) IBOutlet UITextField *firstNameTf;
@property (retain, nonatomic) IBOutlet UITextField *lastNameTf;
@property (retain, nonatomic) IBOutlet UIImageView *imageView;
@property (retain, nonatomic) IBOutlet UITextField *passwordTf;
@property (strong, nonatomic) IBOutlet UITextField *confirmPasswordTF;
// for PayPal login


@property(nonatomic, strong, readwrite) NSString *environment;
@property(nonatomic, assign, readwrite) BOOL acceptCreditCards;
@property(nonatomic, strong, readwrite) NSString *resultText;
@property (retain, nonatomic) IBOutlet UIButton *submitBtn;
@property (retain, nonatomic) IBOutlet UIButton *nextBtn;
@property (retain, nonatomic) IBOutlet UIButton *backBtn;

//««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»

-(void)upLoadImageNew;
- (IBAction)signBtnPressed:(id)sender;



@property (nonatomic, strong) NSString *str_ExpirationDate;
@property (nonatomic, retain) NSString *str_CardNumber;




@property (retain, nonatomic) IBOutlet UIView *nextView;
- (IBAction)imageBtnPressed:(id)sender;
- (IBAction)backBtnPressed:(id)sender;
- (IBAction)nextBtnPressed:(id)sender;
- (IBAction)submitBtnPressed:(id)sender;

@end
