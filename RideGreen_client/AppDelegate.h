//
//  AppDelegate.h
//  fiveStarLuxuryCars
//
//  Created by Ridegreen on 06/05/2014.
//  Copyright (c) 2014 Ridegreen. All rights reserved.
//


#import "RideGreenHeader.h"
#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>
#import <CoreData/CoreData.h>



@interface AppDelegate : UIResponder <UIApplicationDelegate,CLLocationManagerDelegate,UIAlertViewDelegate>
{
    CLLocationManager *locationManager;
    NSUserDefaults *prefs;
    UIAlertView *alertView;
    NSString *imgTitel;
}

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (nonatomic, retain) NSString *currentCoordinats;

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSString *clientName;
@property (strong, nonatomic) NSString *ClientEmail;
@property (strong, nonatomic) NSString *bgImageName;
@property (strong, nonatomic) NSString *fontName;
@property (strong, nonatomic) NSString *userId;
@property (strong, nonatomic) NSString *userImageName;
@property (strong, nonatomic) NSString *selectedDriverId;
@property (strong, nonatomic) NSString *distinationId;
@property (strong, nonatomic) NSString *getCarBtntag;
@property (strong, nonatomic) NSString *drieverLatitude;
@property (strong, nonatomic) NSString *driverlongitude;
@property (strong, nonatomic) NSString *driverName;
@property (strong, nonatomic) NSString *driverpic;
@property (strong, nonatomic) NSString *driverNumber;
@property (strong, nonatomic) NSString *distanceIs;
@property (strong, nonatomic) NSString *soureceDestinationDistance;
@property (strong, nonatomic) NSString *profileImageName;
@property (assign) BOOL isSelectedSourecAndDistination;

@property (assign) BOOL isResevationSeen;
@property (strong, nonatomic) UIImage *image;
@property (strong, nonatomic) NSString *sourceLatitude;
@property (strong, nonatomic) NSString *sourceLongitude;
@property (strong, nonatomic) NSString *destinationLatitude;
@property (strong, nonatomic) NSString *destinationLongitude;
@property (strong, nonatomic) NSString *finalFare;
@property (strong, nonatomic) NSString *estimatedTime;
@property (strong, nonatomic) NSString *discount;
@property (strong, nonatomic) NSString *cardTokenId;
@property (strong, nonatomic) NSString *custromId;
@property (strong ,nonatomic) NSString *pickDropAddress;
@property (strong ,nonatomic) NSString *zipCode;
@property (assign, nonatomic) BOOL isConected;
@property (assign, nonatomic) BOOL isregisterview;
@property (assign, nonatomic) BOOL isgotToken;
@property (assign, nonatomic) BOOL isActivityPaid;
@property (assign, nonatomic) BOOL isEidtParking;
@property (assign, nonatomic) BOOL isRigesterTour;
@property (strong ,nonatomic) NSString *fare;
@property (assign, nonatomic) BOOL isEdited;
@property (strong ,nonatomic) NSString *selectedCarType;
@property (strong ,nonatomic) NSString *whenRide;
@property (strong ,nonatomic) NSString  *selectedTypeId;
@property (strong ,nonatomic) NSString  *selectedBtnIndex;
@property (strong ,nonatomic) NSString  *vehicleImg;
@property (strong ,nonatomic) NSString  *totalRent;
@property (strong ,nonatomic) NSString *imgTitel;
@property (retain,retain) NSTimer *checkingTimer;




// tour
@property (strong, nonatomic) NSString *tourSelectedDate;
@property (strong, nonatomic) NSString *tourStartUpTime;
@property (strong, nonatomic) NSString *tourTravelHours;
@property (strong, nonatomic) NSString *tourTaxRate;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
