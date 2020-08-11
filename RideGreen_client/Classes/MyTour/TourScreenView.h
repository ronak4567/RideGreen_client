//
//  TourScreenView.h
//  ridegreen
//
//  Created by Ridegreen on 01/09/2015.
//  Copyright (c) 2015 Ridegreen. All rights reserved.
//

#import "MyTour.h"
#import "AppDelegate.h"

#import "NetworkHelper.h"
#import "MBProgressHUD.h"
#import "TourPaymentView.h"
#import "SVGeocoder.h"
#import <GoogleMaps/GoogleMaps.h>
#import <UIKit/UIKit.h>

@interface TourScreenView : UIViewController<GMSMapViewDelegate>
{
    AppDelegate *delg;
    GMSMarker *pickUpannotation ;
    NSUserDefaults *prefs;
    NSMutableArray *_coordinates;
    GMSMarker *driverMarker;
    GMSMarker *sourceMarker;
    NSMutableArray *markers;
    SVPlacemark *placemark;
    LRouteController *_routeController;
    GMSPolyline *_polyline;
    CLLocationCoordinate2D meetupCoordinats;

    


}
@property (readwrite) CLLocationCoordinate2D currentCoordinats;
@property (strong, nonatomic) MyTour *tour;
@property (strong, nonatomic) NSString  *carType;
@property (strong, nonatomic) NSString  *totalHours;
@property (strong, nonatomic) NSString  *totalbil;
@property (strong, nonatomic) NSString  *userId;
@property (strong, nonatomic) NSString  *tourId;
@property (strong, nonatomic) NSString  *driverId;//
@property (strong, nonatomic) IBOutlet UIButton *atMeetupLocationBtn;
@property (strong, nonatomic) IBOutlet UIImageView *atMeetupLocartionBg;
@property (strong, nonatomic) IBOutlet UILabel *headingLabel;



@property (retain,retain) NSTimer *checkingTimer;
@property (strong, nonatomic, readwrite) GMSMapView *mapView;

@property (strong, nonatomic) IBOutlet UILabel *titelLabel;

@property (strong, nonatomic) IBOutlet UIView *mainView;

- (IBAction)backBtnPressed:(id)sender;

- (IBAction)reachedBtnPresssed:(id)sender;

@end
