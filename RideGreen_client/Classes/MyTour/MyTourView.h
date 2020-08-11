//
//  MyTourView.h
//  ridegreen
//
//  Created by Ridegreen on 01/09/2015.
//  Copyright (c) 2015 Ridegreen. All rights reserved.
//
#import "AppDelegate.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import "SDImageCache.h"
#import "MWCommon.h"


#import <UIKit/UIKit.h>
#import "CMyTours.h"

@interface MyTourView : UIViewController<GMSMapViewDelegate,CustomIOSAlertViewDelegate>
{
    NSMutableArray *allTours;
      NSUserDefaults *prefs;
    CustomIOSAlertView *alertView ;
    MapView *mapView;
    GMSMapView *mView;
    NSInteger deleteIndex ;
    MyTour *tour;
    
}

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSString *userId;

@property (strong, nonatomic) AFJSONRequestOperation* httpOperation;


- (IBAction)backBtnPressed:(id)sender;

@end
