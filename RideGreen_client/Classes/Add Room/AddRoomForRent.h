//
//  AddRoomForRent.h
//  ridegreen
//
//  Created by Ridegreen on 28/10/2015.
//  Copyright (c) 2015 Ridegreen. All rights reserved.
//

#import "AppDelegate.h"

@interface AddRoomForRent : UIViewController<CustomIOSAlertViewDelegate,GMSMapViewDelegate,BSForwardGeocoderDelegate,UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate,UITextViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate, UIPopoverControllerDelegate,CustomIOSAlertViewDelegate,VPImageCropperDelegate,UITextViewDelegate>

{
    UIImagePickerController *imagePickerController;
    
    AppDelegate    *delg;
    NSUserDefaults *userdefault;
    GMSMapView     *mView;
    MapView        *mapView;
    BSKmlResult    *place;

    CustomIOSAlertView *alertView ;
    __block NSString   *locatedaddress;
    NSString           *currentCoordinats;
    
    NSMutableArray *stateNames;
    NSMutableArray *stateIds;
    NSMutableArray *cityNames;
    NSMutableArray *cityIds;
    NSMutableArray *paymentOptions;
    NSMutableArray *roomTypes;
    BOOL isViewUp;
    BOOL isPayMentOptions;
    BOOL isRoomAddress;
    BOOL isname;
    BOOL isphone;
    BOOL isRoomType;
    BOOL isClientAddress;
    BOOL isPrice;
    BOOL isState;
    BOOL isCity;
    BOOL isRooms;
    BOOL isBeds;
    BOOL isDes;
    BOOL isSecurityDeposit;
    int  aid ;
    int keybordHigt;
    int totalUpLoadedImages;
    
    
    BOOL isQuickPay;




}

@property (strong, nonatomic) AFJSONRequestOperation* httpOperation;
@property (nonatomic, retain) BSForwardGeocoder *forwardGeocoder;
@property (retain, nonatomic) IBOutlet UIView *formView;
@property (retain, nonatomic) IBOutlet UIView *pictureView;

@property (retain, nonatomic) IBOutlet UIImageView *roomImageView;
@property (nonatomic, strong) NSString    *selectedStateId;
@property (nonatomic, strong) NSString    *selectedCityId;
@property (nonatomic, strong) NSString    *selectedStateName;
@property (nonatomic, strong) NSString    *selectedCityName;
@property (nonatomic, strong) NSString     *selectedRooms;
@property (nonatomic, strong) NSString     *selectedBeds;
@property (nonatomic, strong) NSString     *selectedOptions;
@property (nonatomic, strong) NSString     *selectedRoomtype;
@property (strong ,nonatomic) UITableView *selectionTable;
@property (retain, nonatomic) IBOutlet UIButton *formBackbtn;
@property (retain, nonatomic) IBOutlet UIButton *nextBtn;
@property (retain, nonatomic) IBOutlet UIButton *viewBackBtn;
@property (retain, nonatomic) IBOutlet UIButton *submitBtn;
@property (retain, nonatomic) IBOutlet UIView *nameView;


@property (nonatomic,retain)  NSString *userId;
@property (nonatomic,assign)  NSInteger imgBtntag;
@property (strong, nonatomic) GCPlaceholderTextView *addressTextView;
@property (strong, nonatomic) GCPlaceholderTextView *descrip;


@property (strong, nonatomic)          UITextField *alertextField;
@property (retain, nonatomic) IBOutlet UITextField *roomTypeTF;

@property (strong, nonatomic) IBOutlet UITextField *nameTF;
@property (strong, nonatomic) IBOutlet UITextField *phoneTF;
@property (strong, nonatomic) IBOutlet UITextField *stateTF;
@property (strong, nonatomic) IBOutlet UITextField *cityTF;
@property (strong, nonatomic) IBOutlet UITextField *roomsTF;
@property (strong, nonatomic) IBOutlet UITextField *bedsTF;
@property (strong, nonatomic) IBOutlet UITextField *roomAddressTF;
@property (strong, nonatomic) IBOutlet UITextField *clientAddressTF;
@property (strong, nonatomic) IBOutlet UITextField *priceTF;
@property (strong, nonatomic) IBOutlet UITextField *paymentOptionTF;
@property (strong, nonatomic) IBOutlet UITextField *txt_Description;

@property (retain, nonatomic) IBOutlet UITextField *txt_SecurityDeposit;


- (IBAction)imageBtnPressed:(id)sender;
- (IBAction)submitBtnPressed:(id)sender;
- (IBAction)fromBackBtnPressed:(id)sender;
- (IBAction)nextBtnPressed:(id)sender;

@end
