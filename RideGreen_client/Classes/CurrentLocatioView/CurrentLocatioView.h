//
//  CurrentLocatioView.h
//  fiveStarLuxuryCars
//
//  Created by Ridegreen on 07/05/2014.
//  Copyright (c) 2014 Ridegreen. All rights reserved.
//
#import "AppDelegate.h"
#import "EXPhotoViewer.h"
#import <UIKit/UIKit.h>
#import "AppConstant.h"

static NSString * const kOpenInMapsSampleURLScheme = @"OpenInGoogleMapsSample://";
@interface CurrentLocatioView : UIViewController<MKMapViewDelegate,CLLocationManagerDelegate,UIGestureRecognizerDelegate,AVAudioPlayerDelegate, UISearchBarDelegate, BSForwardGeocoderDelegate,GMSMapViewDelegate,CustomIOSAlertViewDelegate>
{
    NSString *btnTag;
    BOOL userLocationShown;
    TourScreenView *tourScreen;
    AppDelegate *delg;
    GMSMarker *pickUpannotation ;
    GMSMarker *destinationAnnotation ;
    BOOL isSourceLock;
    BOOL isdestinationLock;
    BOOL isSourceAnnotation;
    BOOL isDestanceInMiles;
    BOOL isdestinationAnnotation;
    NSUserDefaults *prefs;
    MKDirections *directions;
    CLPlacemark *thePlacemark;
    MKRoute *routeDetails;
    CLLocation *currLocation;
    NSMutableArray *markers;
    float distance;
    BSKmlResult *place;
    NSMutableArray *allDriversOnMap;
    NSMutableArray *allMarkers;
    NSMutableArray *allCars;
    NSMutableArray *waypoints_;
    NSMutableArray *waypointStrings_;
    UIAlertView *AlertView;
    CLLocationCoordinate2D longPressedCoordinates;
    CLLocation *currentLocation;
    BOOL islongPessed;
    
    CLLocationCoordinate2D  sourecCoordinate;
    CLLocationCoordinate2D  driverCoordinate;
    CLLocationCoordinate2D fromCoordinates ;
    
    BOOL driverReachedAtsourceLocation;
    BOOL isJourneyStart;
    BOOL isDriverReached;
    BOOL iswaiting;
    BOOL isStripeCalled;
    bool isPiad;
    BOOL isNotification;
    BOOL IsConnectViewShown;
    // for connacting driver
    CLLocationCoordinate2D coord;
    
    
    
    float driverCurrentLat,driverCurretLog;
    
    float minimumDis;
    float distance1;
    MBProgressHUD *hude;
    NSString *allValues;
    int newditance;
    UILabel *label;
    NSString *lati;
    NSString *longi;
    NSString *tripString;
    GMSMarker*locationMarker;
    BOOL isLoad;
    
    CLLocationManager *locationManager;
    Signature *sig;
    NSMutableArray *_coordinates;
    NSMutableArray *allDrivers;
    LRouteController *_routeController;
    GMSPolyline *_polyline;
    GMSMarker *_markerStart;
    GMSMarker *_markerFinish;
    GMSMarker *driverMarker;
    
    NSString *latitude;
    NSString *longitude;
    
    NSString *clientSourceLatitude;
    NSString *clientSourceLongitude;
    NSString *clientDestinationLatitude;
    NSString *clientDestinationLongitude;
    NSString *isLiveTour;
    
    TJSpinner *dSpinner;
    TJSpinner *vSpinner;
    CustomIOSAlertView *customAlertView;
    
    NSString *mes_FarePaid;
    NSString *str_amount;
    
    NSString *drID,*drCarID;
    
    NSNumber *selRow;
}
@property (strong ,nonatomic) NSString *str_amount;

@property BOOL isPickupRouteDrawed;
@property BOOL isDropRouteDrawed;

@property BOOL isDriverImage;
@property BOOL isCarImage;
@property (strong, nonatomic) NSString *selectedDriver;
@property (strong ,nonatomic)UITableView *driverListTable;

@property (retain, nonatomic) IBOutlet UIButton *currentLocationBtn;
- (IBAction)backBtnPressed:(id)sender;

- (IBAction)currentLocationBtnPressed:(id)sender;
@property (retain,retain) NSTimer *checkingTimer;
@property (strong, nonatomic) CLLocationManager *locationManager2;
@property (retain, nonatomic) IBOutlet UIButton *clearbtn;

@property (strong, nonatomic) CLLocation *startLocation;
@property (nonatomic, retain) IBOutlet UISearchBar *searchBar;
@property (nonatomic, retain) BSForwardGeocoder *forwardGeocoder;
@property (retain, nonatomic) IBOutlet UIView *googleMap;
@property (retain, nonatomic) IBOutlet UILabel *locationtitleLabel;
@property (strong, nonatomic, readwrite)   GMSMapView *mapView;
@property (strong, nonatomic) NSString *allSteps;
@property (strong, nonatomic) IBOutlet UITableView *tableView;


- (IBAction)clearBtnpressed:(id)sender;
- (IBAction)reservstionBtnPressed:(id)sender;


//=====================================================================//


@property (strong, nonatomic) IBOutlet UIView *connectView;
@property (strong, nonatomic) IBOutlet UILabel *titelLabel;

@property (retain, nonatomic) IBOutlet UILabel *distanceLabel;
@property (strong, nonatomic, readwrite) IBOutlet  GMSMapView *afterConnectMapView;
@property (retain, nonatomic) IBOutlet UIView *afterConnectMap;
@property (retain, nonatomic) IBOutlet UIImageView *driverImageView;
@property (retain, nonatomic) IBOutlet UILabel *driverName;
@property (retain, nonatomic) IBOutlet UIButton *afterConnectCancelBtn;
@property (retain, nonatomic) IBOutlet UIImageView *vehicleImageView;
- (IBAction)afterConnectCancelBtnPressed:(id)sender;
- (IBAction)vehicelImgBtnPressed:(id)sender;
- (IBAction)driverImgBtnPressed:(id)sender;



@end
