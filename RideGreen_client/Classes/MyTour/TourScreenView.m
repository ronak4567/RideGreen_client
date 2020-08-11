//
//  TourScreenView.m
//  ridegreen
//
//  Created by Ridegreen on 01/09/2015.
//  Copyright (c) 2015 Ridegreen. All rights reserved.
//

#import "TourScreenView.h"

@interface TourScreenView ()

@end

@implementation TourScreenView

- (void)viewDidLoad {
    
    driverMarker =[[GMSMarker alloc] init];
    sourceMarker =[[GMSMarker alloc] init];
    placemark =[[SVPlacemark alloc] init];
    _coordinates = [NSMutableArray new];
    markers =[NSMutableArray new];
    _routeController = [LRouteController new];

    delg = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    pickUpannotation = [[GMSMarker alloc] init] ;
    prefs =[NSUserDefaults standardUserDefaults];
    self.tourId =[prefs objectForKey:@"tourId"];
    self.driverId =[prefs objectForKey:@"driverId"];
    self.userId = [prefs stringForKey:@"user_id"];
    [self.atMeetupLocartionBg setHidden:YES];
    [self.atMeetupLocationBtn setHidden:YES];
    
    self.titelLabel.text = @"Tour";
    [super viewDidLoad];
    
    [self showMapView];
    [self fetchDriverLocationWithDriverId];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(BOOL)isReachable
{
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];   
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];    
    if (networkStatus == NotReachable)
    {        
        NSLog(@"There IS NO internet connection");  
        return NO;
    } else {        
        NSLog(@"There IS internet connection"); 
        return YES;
    }
}
-(void)updateTitelLabel
{
self.titelLabel.text = @"Tour continue..";
}
-(void)showMapView
{


    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:delg.locationManager.location.coordinate.latitude
                                                            longitude:delg.locationManager.location.coordinate.longitude
                                                                 zoom:11];
    
    _mapView = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    _mapView = [GMSMapView mapWithFrame:CGRectMake(0,0, self.mainView.frame.size.width,self.mainView.frame.size.height) camera:camera];
    _mapView.delegate = self;
    _mapView.myLocationEnabled = YES;
    [self.mainView addSubview: _mapView];
    SEL callMethod = @selector(fetchDriverLocationWithDriverId);
    [self startTimerWithTimeInterval:10 prformSelector:callMethod];
    
}
-(void)ShowTourPaymentScreenView
{
    [self.checkingTimer invalidate];
    self.checkingTimer = nil;
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName: @"Main" bundle: nil];
    TourPaymentView * sv = [storyboard instantiateViewControllerWithIdentifier:@"TourPayment"];
    sv.tour = self.tour;
    sv.totalHours = self.totalHours;
    sv.totalbil = self.totalbil;
    sv.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self.navigationController pushViewController:sv animated:NO];
   
    
}
-(void)startTimerWithTimeInterval:(float)timeInter prformSelector :(SEL)prformSelector 
{ 
   
    [self.checkingTimer invalidate];
    self.checkingTimer = nil;
    if (![self.checkingTimer isValid] && self.checkingTimer == nil) 
    {
        
        UIBackgroundTaskIdentifier bgTask = UIBackgroundTaskInvalid;
        
        UIApplication  *app = [UIApplication sharedApplication];
        bgTask = [app beginBackgroundTaskWithExpirationHandler:^
                  {
                      
                  }];
        
        self.checkingTimer = [NSTimer scheduledTimerWithTimeInterval:timeInter
                                                              target:self
                                                            selector:prformSelector
                                                            userInfo:nil
                                                             repeats:YES];
        
        [app endBackgroundTask:bgTask];

    }

}
-(void)getCurrentAddress 
{
    [SVGeocoder reverseGeocode:CLLocationCoordinate2DMake(delg.locationManager.location.coordinate.latitude,delg.locationManager.location.coordinate.longitude)
                    completion:^(NSArray *placemarks, NSHTTPURLResponse *urlResponse, NSError *error) {
                        SVPlacemark *placemarkN=[[SVPlacemark alloc] init];
                        // ////NSLog(@"%@",[placemarks objectAtIndex:0]);
                        
                        if (placemarks.count !=0)
                        {
                            placemarkN =[placemarks objectAtIndex:0];
                            
                            // ////NSLog(@"placemark %@",placemarks);
                            NSString *locatedaddress = [NSString stringWithFormat:@"%@,%@,%@",placemarkN.thoroughfare,placemarkN.subLocality,placemarkN.locality];
                            
                            NSString *coordinate =[NSString stringWithFormat:@"%f,%f",placemarkN.coordinate.latitude,placemarkN.coordinate.longitude];
                            [self updateCurrentAddress:locatedaddress currentCoordinate:coordinate];
                            
                           
                            
                            
                            
                        }
                        
                        
                        
                    }];

}
#pragma mark Web Services


-(void)updateCurrentAddress:(NSString *)currentAddress currentCoordinate:(NSString *)currentCoordinate
{
   //airadsapp.com/ridegreen/mappservicesia/index.php?command=start_tour_update_locations_after_15_mint&tour_id=2&tour_current_address=fasial%20masjid%20&tour_current_location=0.000000,00000000

    NSMutableDictionary *params=[[NSMutableDictionary alloc]initWithObjectsAndKeys:@"start_tour_update_locations_after_15_mint",@"command",self.tourId,@"tour_id",currentAddress,@"tour_current_address",currentCoordinate,@"tour_current_location", nil];
    
    
    [[NetworkHelper sharedInstance] commandWithParams:params onCompletion:^(NSDictionary *json) {
        
        // NSArray *results=[json objectForKey:@"result"];
        //{"result":[{"id":"112","first_name":"Driver","last_name":"Test","latitude":"33.697001","longitude":"72.980655"}]}
        
        if (![json objectForKey:@"error"]&&json!=nil)
        {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }
        else
        {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            NSString *errortourActivity =[json objectForKey:@"error"];
            if ([errortourActivity isEqualToString:@"request body stream exhausted"]||[errortourActivity isEqualToString:@"The request timed out."])
            {
                [self updateCurrentAddress:currentAddress currentCoordinate:currentCoordinate];
            }
            else if ([errortourActivity isEqualToString:@"No record Found"])
            {
            
                [self updateCurrentAddress:currentAddress currentCoordinate:currentCoordinate];

            }
            else
            {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                NSString *errorMsg =[json objectForKey:@"error"];
                if ([ErrorFunctions isError:errorMsg])
                {
                    [self updateCurrentAddress:currentAddress currentCoordinate:currentCoordinate];    
                }
                else
                {
                    
                     [self showCustomUIAlertViewWithtilet:@"Info" andWithMessage:[json objectForKey:@"error"]];
                    
                }
                
               
                
            }
            
            ////NSLog(@"error is %@",[json objectForKey:@"error"]);
            
            
            
        }
        
    }];
    
    
}

-(void)fetchDriverLocationWithDriverId 
{
    
    NSMutableDictionary *params=[[NSMutableDictionary alloc]initWithObjectsAndKeys:@"get_tour_and_driver_current_location",@"command",self.tourId,@"tour_id", nil];
    
    
    [[NetworkHelper sharedInstance] commandWithParams:params onCompletion:^(NSDictionary *json) {
        
        // NSArray *results=[json objectForKey:@"result"];
        //{"result":[{"id":"112","first_name":"Driver","last_name":"Test","latitude":"33.697001","longitude":"72.980655"}]}
        
        if (![json objectForKey:@"error"]&&json!=nil)
        {
            NSString *dName;
            CLLocationCoordinate2D driverCoordinate;
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            if ([json objectForKey:@"register"] != nil) 
            {
                NSArray *result =[json objectForKey:@"register"];
                NSDictionary *res =[result objectAtIndex:0]; 
                NSString *driverStatus =[res objectForKey:@"driver_status"];
                NSString *clientStatus =[res objectForKey:@"client_status"];
                dName =[NSString stringWithFormat:@"%@",[res objectForKey:@"first_name"]];
                driverCoordinate =CLLocationCoordinate2DMake([[res objectForKey:@"latitude"] floatValue], [[res objectForKey:@"longitude"] floatValue]);
                NSString *meetupLocation =[res objectForKey:@"meetup_location"];
                NSArray  *latlongarry =[meetupLocation componentsSeparatedByString:@","];
                NSString *lat =[latlongarry objectAtIndex:0];
                NSString *lng =[latlongarry objectAtIndex:1];
                _carType = [res objectForKey:@"car_type"];
                meetupCoordinats =CLLocationCoordinate2DMake([lat doubleValue], [lng doubleValue]);

                if ([driverStatus isEqualToString:@"accepted"] ||[driverStatus isEqualToString:@"Going to meetup location"] ) 
                {
                    
                    [self drawRoutFromLocation:driverCoordinate to:meetupCoordinats markerTitel:@"Meetup Location"];
                }
                if ([clientStatus isEqualToString:@"Going to meetup location"]) 
                {
                    [self.atMeetupLocartionBg setHidden:NO];
                    [self.atMeetupLocationBtn setHidden:NO];
                }
                else if ([clientStatus isEqualToString:@"Reached meetup location"]) 
                {
                    [self.atMeetupLocartionBg setHidden:YES];
                    [self.atMeetupLocationBtn setHidden:YES];
                }

                
            }else 
            {
                
                NSArray *result =[json objectForKey:@"live"];
                NSDictionary *res =[result objectAtIndex:0];
                dName =[NSString stringWithFormat:@"%@",[res objectForKey:@"first_name"]];
                driverCoordinate =CLLocationCoordinate2DMake([[res objectForKey:@"latitude"] floatValue], [[res objectForKey:@"longitude"] floatValue]);
                
                
                NSString *status =[res objectForKey:@"status"];
                
                if ([status isEqualToString:@"Tour started"]) 
                {
                    SEL callMethod = @selector(getCurrentAddress);
                    [self startTimerWithTimeInterval:900 prformSelector:callMethod];
                    [self.titelLabel setText:@"Tour started"];
                    [self performSelector:@selector(updateTitelLabel) withObject:self afterDelay:5];
                    [self driverLocationWithoutAddress:driverCoordinate];
                    [self updateLocationoordinates];
                }
                if ([status isEqualToString:@"Tour ended"]) 
                {
                    [self.atMeetupLocartionBg setHidden:YES];
                    [self.atMeetupLocationBtn setHidden:YES];
                    [self.titelLabel setText:@"Tour Ended"];
                    [self performSelector:@selector(setTitelLabel) withObject:self afterDelay:5];
                    
                }else  if ([status isEqualToString:@"Waiting for payment"]) 
                {
                    self.totalbil    = [res objectForKey:@"total_bill"];
                    self.totalHours  = [res objectForKey:@"tour_hours"];
                    [self ShowTourPaymentScreenView];
                
                }
                
            }
            
            
            
            
            [self addMarkerOnMapAtPoint:_mapView.myLocation.coordinate withDriveName:@"My Location"];
        }
        else{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            NSString *errortourActivity =[json objectForKey:@"error"];
            if ([ErrorFunctions isError:errortourActivity])
            {
                [self fetchDriverLocationWithDriverId];
            }
            else
            {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                NSLog(@"Error :%@",[json objectForKey:@"error"]);
                
                [self showCustomUIAlertViewWithtilet:@"Info" andWithMessage:[json objectForKey:@"error"]];
                
            }
            
            ////NSLog(@"error is %@",[json objectForKey:@"error"]);
            
            
            
        }
        
    }];


           


}
-(void)setTitelLabel
{
    [self.titelLabel setText:@"Calculating Bill"];

}
-(void)updateLocationoordinates 
{
    CLLocationCoordinate2D coordinats = _mapView.myLocation.coordinate;    
    if (driverMarker == nil)
    {
        driverMarker = [GMSMarker markerWithPosition:coordinats];
        
        driverMarker.map = _mapView;
    } 
    else
    driverMarker.appearAnimation = kGMSMarkerAnimationNone;
    [CATransaction begin];
    [CATransaction setAnimationDuration:1.0];
    driverMarker.position = coordinats;
    [CATransaction commit];
    driverMarker.position = coordinats;
}
-(void)updateTourStatusWithId :(NSString *) tId withdriverId:(NSString *)driverId status :(NSString *) status
{
    
    //    
    
    
    NSMutableDictionary *params=[[NSMutableDictionary alloc]initWithObjectsAndKeys:@"client_tour_status",@"command",tId,@"tour_id",status,@"status",driverId,@"driver_id",nil];
    NSLog(@"params %@",params);
    MBProgressHUD *hude=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hude.labelText = @"";
    [[NetworkHelper sharedInstance] commandWithParams:params onCompletion:^(NSDictionary *json) {
        
        if (![json objectForKey:@"error"]&&json!=nil) 
        {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            NSDictionary *res=[json objectForKey:@"result"];
            NSString *status=[NSString stringWithFormat:@"%@",[res objectForKey:@"successful"]];
            if ([status isEqualToString:@"1"])
            {
            
                [self.atMeetupLocartionBg setHidden:YES];
                 [self.atMeetupLocationBtn setHidden:YES];
                
            }    
            
        }
        else{
            ////NSLog(@"Error : %@",[json objectForKey:@"error"]);
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            NSString *errortourActivity =[json objectForKey:@"error"];
            if ([ErrorFunctions isError:errortourActivity])
            {
                [self updateTourStatusWithId:tId withdriverId:driverId status:status];
            }
            else
            {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                ////NSLog(@"Error is %@",[json objectForKey:@"error"]);
                [self showCustomUIAlertViewWithtilet:@"Info" andWithMessage:[json objectForKey:@"error"]];
                
                
            }
            
        }
    }];
    
    
    
    
}
 
-(void)addMarkerOnMapAtPoint:(CLLocationCoordinate2D )coordinates withDriveName :(NSString *)driverName
{

    if (pickUpannotation.map == nil) 
    {
        [SVGeocoder reverseGeocode:coordinates
                        completion:^(NSArray *placemarks, NSHTTPURLResponse *urlResponse, NSError *error) {
                            SVPlacemark *placemarkN=[[SVPlacemark alloc] init];
                            
                            if (placemarks.count != 0)
                            {
                                placemarkN =[placemarks objectAtIndex:0];
                                NSString *locatedaddress = [NSString stringWithFormat:@"%@,%@,%@",placemarkN.thoroughfare,placemarkN.subLocality,placemarkN.locality];
                                
                                
                                
                                pickUpannotation.position = coordinates;
                                pickUpannotation.title = driverName;
                                pickUpannotation.appearAnimation = kGMSMarkerAnimationPop;
                                pickUpannotation.snippet =locatedaddress;
                                pickUpannotation.icon = [GMSMarker markerImageWithColor:[UIColor greenColor]];
                                pickUpannotation.draggable = YES;
                                pickUpannotation.appearAnimation = kGMSMarkerAnimationPop;
                                pickUpannotation.map = _mapView;
                               

                            }
                            else 
                            {
                                [self showHudWithText:@"Invaild driver location"];
                            }
                           
                                                        
                            
                            
                        }];
  
        
    }else 
    {
    
        [CATransaction begin];
        [CATransaction setAnimationDuration:1.0];
        pickUpannotation.position = coordinates;
        [CATransaction commit];

    }
}
-(void)drawRoutFromLocation :(CLLocationCoordinate2D )fromLocation to :(CLLocationCoordinate2D) toLocation markerTitel :(NSString *) markerTitel
{
    
    //[self.mapView clear];
    [self driverLocationWithoutAddress:fromLocation];
    [_coordinates removeAllObjects];
     
    [_coordinates addObject:[[CLLocation alloc] initWithLatitude:fromLocation.latitude longitude:fromLocation.longitude]];
    
    [markers addObject:driverMarker];
    [SVGeocoder reverseGeocode:toLocation
                    completion:^(NSArray *placemarks, NSHTTPURLResponse *urlResponse, NSError *error) {
                        
                        if (placemarks.count != 0)
                        {
                            placemark =[placemarks objectAtIndex:0];
                        }
                        
                        
                        // //NSLog(@"placemark %@",placemarks);
                        
                        NSString *locatedaddress = [NSString stringWithFormat:@"%@,%@,%@",placemark.thoroughfare,placemark.subLocality,placemark.locality];
                       
                        
                        sourceMarker.position =toLocation;
                        sourceMarker.title = markerTitel;
                        sourceMarker.appearAnimation = kGMSMarkerAnimationNone;
                        sourceMarker.snippet = locatedaddress;
                        sourceMarker.infoWindowAnchor = CGPointMake(0.0f, 0.0f);
                        sourceMarker.icon = [GMSMarker markerImageWithColor:[UIColor redColor]];
                        [_coordinates addObject:[[CLLocation alloc] initWithLatitude:toLocation.latitude longitude:toLocation.longitude]];
                        
                        
                        sourceMarker.map = self.mapView;
                       
                        sourceMarker.draggable = NO;
                        [markers addObject:sourceMarker];
                        GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:fromLocation.latitude
                                                                                longitude:fromLocation.longitude
                                                                                     zoom:15];
                        [self.mapView animateToCameraPosition:camera];
                        
                        // [self focusMapToShowAllMarkers];
                       
                        if ([_coordinates count] > 1)
                        {
                            [_routeController getPolylineWithLocations:_coordinates travelMode:TravelModeDriving andCompletitionBlock:^(GMSPolyline *polyline, NSError *error) {
                                if (error)
                                {
                                    ////NSLog(@"%@", error);
                                }
                                else if (!polyline)
                                {
                                    ////NSLog(@"No route");
                                    [_coordinates removeAllObjects];
                                }
                                else
                                {
                                    
                                    
                                    _polyline = polyline;
                                    _polyline.strokeWidth = 3;
                                    _polyline.strokeColor = [UIColor redColor];
                                    _polyline.map = _mapView;
                                    
                                    
                                }
                            }];
                        }
                        
                        
                    }]; 
    
    
    
    
}
-(void)driverLocationWithoutAddress :(CLLocationCoordinate2D )coordinates
{
    [self.mapView clear];
    [SVGeocoder reverseGeocode:coordinates
                    completion:^(NSArray *placemarks, NSHTTPURLResponse *urlResponse, NSError *error)
    { 
    
        placemark =[placemarks objectAtIndex:0];
           NSString *locatedaddress = [NSString stringWithFormat:@"%@,%@,%@",placemark.thoroughfare,placemark.subLocality,placemark.locality];
        driverMarker.position =coordinates;
        driverMarker.title = @"Driver Location";
        driverMarker.snippet = locatedaddress;
        if ([_carType integerValue] == 1)
        {
            driverMarker.icon = [UIImage imageNamed:@"car-black-map.png"];
        }
        else if ([_carType integerValue] == 2)
        {
            driverMarker.icon = [UIImage imageNamed:@"car-suv-map.png"];
        }
        else if ([_carType integerValue] == 3)
        {
            driverMarker.icon = [UIImage imageNamed:@"car-wagon-map.png"];
        }
        
        driverMarker.map = self.mapView;
        driverMarker.draggable = NO;
        self.mapView.selectedMarker = driverMarker;
        
    }];
   
    
    
    
}
-(void)showHudWithText:(NSString *)text
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    MBProgressHUD *hud =[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    hud.animationType = MBProgressHUDAnimationZoomIn;
    hud.mode = MBProgressHUDModeText;
    hud.minSize = CGSizeMake(100, 50);
    //hud.yOffset = 220.0; 
    hud.labelText = text;
    [hud hide:YES afterDelay:3];
    
}

- (IBAction)backBtnPressed:(id)sender 
{
    [self.navigationController popViewControllerAnimated:NO];
}

- (IBAction)reachedBtnPresssed:(id)sender 
{
    
    [self updateTourStatusWithId:self.tourId withdriverId:self.driverId status:@"Reached meetup location"];

}
#pragma mark - GoogleMaps Delegate
- (void)mapView:(GMSMapView *)mapView didTapOverlay:(GMSOverlay *)overlay
{

    NSLog(@"polyline taped");
    
}
- (void)showCustomUIAlertViewWithtilet :(NSString *)titel andWithMessage:(NSString *)message {
    NYAlertViewController *alertViewController = [[NYAlertViewController alloc] initWithNibName:nil bundle:nil];
    
    alertViewController.backgroundTapDismissalGestureEnabled = YES;
    alertViewController.swipeDismissalGestureEnabled = YES;
    
    alertViewController.title = NSLocalizedString(titel, nil);
    alertViewController.message = NSLocalizedString(message, nil);
    
    alertViewController.buttonCornerRadius = 20.0f;
    alertViewController.view.tintColor = self.view.tintColor;
    
    alertViewController.titleFont = [UIFont fontWithName:@"AvenirNext-Bold" size:18.0f];
    alertViewController.messageFont = [UIFont fontWithName:@"AvenirNext-Medium" size:16.0f];
    alertViewController.buttonTitleFont = [UIFont fontWithName:@"AvenirNext-Regular" size:alertViewController.buttonTitleFont.pointSize];
    alertViewController.cancelButtonTitleFont = [UIFont fontWithName:@"AvenirNext-Medium" size:alertViewController.cancelButtonTitleFont.pointSize];
    
    alertViewController.alertViewBackgroundColor = [UIColor colorWithWhite:0.19f alpha:1.0f];
    alertViewController.alertViewCornerRadius = 10.0f;
    
    alertViewController.titleColor = [UIColor colorWithRed:0.42f green:0.78 blue:0.32f alpha:1.0f];
    alertViewController.messageColor = [UIColor colorWithWhite:0.92f alpha:1.0f];
    
    alertViewController.buttonColor = [UIColor colorWithRed:0.42f green:0.78 blue:0.32f alpha:1.0f];
    alertViewController.buttonTitleColor = [UIColor colorWithWhite:0.19f alpha:1.0f];
    
    alertViewController.cancelButtonColor = [UIColor colorWithRed:0.42f green:0.78 blue:0.32f alpha:1.0f];
    alertViewController.cancelButtonTitleColor = [UIColor colorWithWhite:0.19f alpha:1.0f];
    
    [alertViewController addAction:[NYAlertAction actionWithTitle:NSLocalizedString(@"Dismiss", nil)style:UIAlertActionStyleDefault handler:^(NYAlertAction *action) 
                                    {
                                        [self dismissViewControllerAnimated:YES completion:nil];
                                        
                                    }]];
    
    //    [alertViewController addAction:[NYAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil)
    //                                                            style:UIAlertActionStyleCancel
    //                                                          handler:^(NYAlertAction *action) {
    //                                                              [self dismissViewControllerAnimated:YES completion:nil];
    //                                                          }]];
    
    [self presentViewController:alertViewController animated:YES completion:nil];
}

@end
