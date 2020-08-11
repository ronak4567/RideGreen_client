//
//  CurrentLocatioView.m
//  fiveStarLuxuryCars
//
//  Created by Ridegreen on 07/05/2014.
//  Copyright (c) 2014 Ridegreen. All rights reserved.
///Users/us14/Desktop/clint's project/fiveStarLuxuryCars Main/FiveStarLuxury_client/FiveStarLuxury_client/Images.xcassets: A 57x57 app icon is required for iPhone apps targeting releases of iOS prior to 7.0



#import "AppDelegate.h"

#import "CurrentLocatioView.h"

static NSString *const kButtonTitle0 = @"Hire a rideshare";
static NSString *const kButtonTitle1 = @"Reserve a Room";//Add Parking for Rent
static NSString *const kButtonTitle2 = @"Hire a Tour Guide";
static NSString *const kButtonTitle3 = @"Live Tours";
static NSString *const kButtonTitle4 = @"Add Parking for Rent";//Add Room for Rent
static NSString *const kButtonTitle5 = @"Add Room for Rent";//Reserve a Room
static NSString *const kButtonTitle6 = @"Terms and Conditions";

@interface CurrentLocatioView ()<MZRSlideInMenuDelegate>
{
}
@property (strong, nonatomic) AFJSONRequestOperation* httpOperation;

@end

@implementation CurrentLocatioView

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = YES;
    [self addShadowTo:_locationtitleLabel];
    
    isStripeCalled = YES;
    
    
    /*UIAlertController* alert = [UIAlertController alertControllerWithTitle:@""
                                                                   message:@"Fare has been paid successfully."
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"Dismiss" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
                                                              NSLog(@"view didload called");
                                                              [self viewDidLoad];
                                                          }];
    
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];*/
    
    
    

    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated
{
    
    self.searchBar.delegate = self;
    driverReachedAtsourceLocation = NO;
    islongPessed = NO;
    isJourneyStart = NO;
    isDriverReached = NO;
    iswaiting = NO;
    
    isPiad    = NO;
    isNotification = NO;
    isLoad = NO;
    isPiad = NO;
    isSourceLock = NO;
    isSourceAnnotation = NO;
    isdestinationAnnotation = NO;
    isDestanceInMiles = NO;
    IsConnectViewShown = NO;
    isNotification = NO;
    _isPickupRouteDrawed = NO;
    [self.connectView setAlpha:0.0];
    
    [self.currentLocationBtn setAlpha:1.0];
    delg =(AppDelegate *)[[UIApplication sharedApplication]delegate];
    prefs = [NSUserDefaults standardUserDefaults];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    delg.custromId = [prefs stringForKey:@"custrom_id"];
    
    delg.userId = [prefs stringForKey:@"user_id"];
    delg.discount =[prefs stringForKey:@"discount"];
    [self.locationtitleLabel setText:@"Choose Pickup Location"];
    isLiveTour = [prefs objectForKey:@"IsTourLive"];
    //_polyline = [GMSPolyline new];
    
    CGFloat imgviewHight = CGRectGetHeight(self.driverImageView.frame);
    CGFloat imgviewWidth = CGRectGetWidth (self.driverImageView.frame);
    dSpinner = [[TJSpinner alloc] initWithSpinnerType:kTJSpinnerTypeCircular];
    dSpinner.center = CGPointMake(imgviewWidth / 2, imgviewHight / 2);
    dSpinner.hidesWhenStopped = YES;
    [dSpinner setHidden:YES];
    [self.driverImageView addSubview:dSpinner];
    
    CGFloat vImgviewHight = CGRectGetHeight(self.vehicleImageView.frame);
    CGFloat vImgviewWidth = CGRectGetWidth (self.vehicleImageView.frame);
    dSpinner = [[TJSpinner alloc] initWithSpinnerType:kTJSpinnerTypeCircular];
    dSpinner.center = CGPointMake(vImgviewWidth / 2, vImgviewHight / 2);
    dSpinner.hidesWhenStopped = YES;
    [dSpinner setHidden:YES];
    [self.vehicleImageView addSubview:dSpinner];
    
    
    
    
    
    [self showMapView];
    
    
    
    
    if ([delg.checkingTimer isValid] == NO && delg.checkingTimer == nil)
    {
        [self startcheckingTimer];
    }
    
    
    allDrivers =[NSMutableArray new];
    currLocation =[[CLLocation alloc] init];
    //---------------------------------------------------------//
    
    pickUpannotation       = [[GMSMarker alloc] init];
    destinationAnnotation  = [[GMSMarker alloc] init];
    locationMarker         = [[GMSMarker alloc] init];
    driverMarker           = [[GMSMarker alloc] init];
    _markerFinish          = [[GMSMarker alloc] init];
    _markerStart           = [[GMSMarker alloc] init];
    currentLocation =[[CLLocation alloc] init];
    
    
    // [self.imageView setImage:[UIImage imageNamed:@"bar_image.png"]];
    
    
    //[self mapView];
    
    markers =[[NSMutableArray alloc] init];
    
    // Creates a marker in the center of the map.
    _coordinates     = [NSMutableArray new];
    _routeController = [LRouteController new];
    waypoints_       = [[NSMutableArray alloc]init];
    waypointStrings_ = [[NSMutableArray alloc]init];
    sig              =[[Signature alloc] init];
    allCars          =[NSMutableArray new];
    
    
    [self drawDriverListOnMap];
    [self.searchBar performSelector:@selector(resignFirstResponder)
                    withObject:nil
                    afterDelay:0];
    //================================//
    
}
-(void)drawDriverListOnMap
{
    NSString *currentLatitude =[NSString stringWithFormat:@"%f",delg.locationManager.location.coordinate.latitude];
    NSString *currentLongitude =[NSString stringWithFormat:@"%f",delg.locationManager.location.coordinate.longitude];
    
    NSMutableDictionary *params=[[NSMutableDictionary alloc]initWithObjectsAndKeys:@"all_driver_under_20_mile",@"command",currentLatitude,@"lat",currentLongitude,@"long", nil];
    
    [[NetworkHelper sharedInstance] commandWithParams:params onCompletion:^(NSDictionary *json) {
        
        if (![json objectForKey:@"error"]&&json!=nil)
        {
            NSArray *results=[json objectForKey:@"result"];
            //NSLog(@"result %@",results);
            
            for (int i=0; i<[results count]; i++)
            {
                NSDictionary *res=[results objectAtIndex:i];
                //get user location
                
                //get advertiser gps value
                NSString *driverLatitude =[res objectForKey:@"latitude"];
                NSString *driverLongitude =[res objectForKey:@"longitude"];
                NSString *carType =[res objectForKey:@"car_type"];
                NSString *driverDistance =[res objectForKey:@"distance"];
                
                // separatered gps value
                
                // advertiser location
                CLLocation *location =[[CLLocation alloc] initWithLatitude:[driverLatitude doubleValue] longitude:[driverLongitude doubleValue]];
                
                
                //NSString *driverLoction =[NSString stringWithFormat:@"%@,%@",lati,longi];
                GMSMarker *marker= [[GMSMarker alloc] init];
                marker=[GMSMarker markerWithPosition:location.coordinate];
                marker.position =location.coordinate;// CLLocationCoordinate2DMake([latitude doubleValue], [longitude doubleValue]);
                marker.title =[NSString stringWithFormat:@"%@",[res objectForKey:@"first_name"]];
                marker.snippet = [NSString stringWithFormat:@"Ditance :%@",driverDistance];
               
                if ([carType integerValue] == 1)
                {
                    marker.icon = [UIImage imageNamed:@"car-black-map.png"];
                }else if ([carType integerValue] == 2)
                {
                    marker.icon = [UIImage imageNamed:@"car-suv-map.png"];
                }
                else if ([carType integerValue] == 3)
                {
                    marker.icon = [UIImage imageNamed:@"car-wagon-map.png"];
                }
                marker.appearAnimation = YES;
                marker.map = _mapView;
            }
        }
        else
        {
            NSLog(@"the error is %@",[json objectForKey:@"error"]);
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            NSString *errorMsg =[json objectForKey:@"error"];
            if ([ErrorFunctions isError:errorMsg])
            {
                [self drawDriverListOnMap];
            }
            else
            {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            }
        }
    }];
    
    //dictionary to be sorted
    
    
    
    //[_locationManager2 stopUpdatingLocation];
}


-(void)drawConnectSetup
{
    
    
}
-(void)showMapView
{
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:delg.locationManager.location.coordinate.latitude
                                                            longitude:delg.locationManager.location.coordinate.longitude
                                                                 zoom:15];
    
    _mapView = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    _mapView = [GMSMapView mapWithFrame:CGRectMake(0,0, self.googleMap.frame.size.width,self.googleMap.frame.size.height) camera:camera];
    _mapView.delegate = self;
    _mapView.myLocationEnabled = YES;
    [self.afterConnectMap addSubview:_afterConnectMapView];
    
    
    _mapView.myLocationEnabled = NO;
    [self.googleMap addSubview: _mapView];
    [self performSelector:@selector(showMarkerOnCurrentLocation) withObject:self afterDelay:2];
    
}
-(void)showMarkerOnCurrentLocation
{
    [self showMarkerOnCoordinates:delg.locationManager.location.coordinate showMarker:locationMarker];
}
-(void)showMarkerOnCoordinates :(CLLocationCoordinate2D ) coordinates showMarker :(GMSMarker *) marker
{
    if (marker == locationMarker)
    {
        
        locationMarker.position = coordinates;
        locationMarker.title = @"Current Location";
        locationMarker.icon =[UIImage imageNamed:@"current_location_marker.png"];
        locationMarker.infoWindowAnchor = CGPointMake(0.2, 0.0f);
        locationMarker.appearAnimation = kGMSMarkerAnimationPop;
        locationMarker.map = _mapView;
        _mapView.selectedMarker = locationMarker;
        
    }
    
    
    
}

-(void)showNotificationAlertWithBody :(NSString *)alertBody
{
    UILocalNotification* localNotification = [[UILocalNotification alloc] init];
    localNotification.alertBody = alertBody;
    localNotification.alertAction =alertBody;
    localNotification.timeZone = [NSTimeZone defaultTimeZone];
    localNotification.soundName = @"Short Sound Effect.mp3";
    
    localNotification.applicationIconBadgeNumber = [[UIApplication sharedApplication] applicationIconBadgeNumber] + 1;
    
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    
    NSLog(@"Alert : %@",alertBody);
    if ([alertBody isEqualToString:@"you have a rent room request."])
    {
        NSString * str_MoveRequest = @"MyRequest";
        NSString * storyboardName = @"Main";
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle: nil];
        MyRentalView * Dvc = [storyboard instantiateViewControllerWithIdentifier:@"MyRental"];
        Dvc.str_MyRequest = str_MoveRequest;
        [self.navigationController pushViewController:Dvc animated:YES];
        
    }
    
    
}

- (void)mapView:(GMSMapView *)mapView didTapAtCoordinate:(CLLocationCoordinate2D)coordinate
{
    self.searchBar.text = @"";
    [self.searchBar resignFirstResponder];
}
- (void)mapView:(GMSMapView *)mapView didLongPressAtCoordinate:(CLLocationCoordinate2D)coordinate{
    
    
    islongPessed = YES;
    longPressedCoordinates = coordinate;
    if (isSourceAnnotation == NO)
    {
        
        [self showCancelUIAlertViewWithtilet:@"Alert" andWithMessage:@"Is this your pick up location"];
        
        
    }
    else if (isdestinationAnnotation == NO )
        
    {
        if (isSourceLock == YES)
        {
            [self showCancelUIAlertViewWithtilet:@"Alert" andWithMessage:@"Is this your destination location"];
        }
    }
    
    
    
    
    
}
- (void)addDirections:(NSDictionary *)json {
    
    NSDictionary *routes = [json objectForKey:@"routes"][0];
    
    NSDictionary *route = [routes objectForKey:@"overview_polyline"];
    NSString *overview_route = [route objectForKey:@"points"];
    GMSPath *path = [GMSPath pathFromEncodedPath:overview_route];
    GMSPolyline *polyline = [GMSPolyline polylineWithPath:path];
    polyline.map = _mapView;
}
#pragma mark - GMSMapViewDelegate
- (void) mapView:(GMSMapView *)mapView didEndDraggingMarker:(GMSMarker *)marker
{
    
}

- (void) mapView:(GMSMapView *)mapView didDragMarker:(GMSMarker *)marker
{
    
}

#pragma mark -
#pragma mark -GMSMarker InfoWindow
#pragma mark -
- (UIView *)mapView:(GMSMapView *)mapView markerInfoWindow:(GMSMarker *)marker
{
    
    if (marker == locationMarker)
    {
        InfoWindowView *view =  [[[NSBundle mainBundle] loadNibNamed:@"InfoWindowView" owner:self options:nil] objectAtIndex:0];
        
        view.ClientNameLabel.text = @"Current Location";
        
        [view.asPickupLocationBtn addTarget:self action:@selector(PickupBtnPressed) forControlEvents:UIControlEventTouchUpInside];
        
        [SVGeocoder reverseGeocode:CLLocationCoordinate2DMake(delg.locationManager.location.coordinate.latitude,delg.locationManager.location.coordinate.longitude)
                        completion:^(NSArray *placemarks, NSHTTPURLResponse *urlResponse, NSError *error) {
                            SVPlacemark *placemarkN=[[SVPlacemark alloc] init];
                            // ////NSLog(@"%@",[placemarks objectAtIndex:0]);
                            
                            if (placemarks.count !=0)
                            {
                                placemarkN =[placemarks objectAtIndex:0];
                                
                                // ////NSLog(@"placemark %@",placemarks);
                                NSString *locatedaddress = [NSString stringWithFormat:@"%@,%@,%@",placemarkN.thoroughfare,placemarkN.subLocality,placemarkN.locality];
                                locationMarker.snippet =locatedaddress;
                                
                                
                                
                                
                                
                            }
                            
                            
                            
                        }];
        
        
        
        
        
        return view;
        
    }
    
    return nil;
    
}
-(void)mapView:(GMSMapView *)mapView didTapInfoWindowOfMarker:(GMSMarker *)marker
{
    [self PickupBtnPressed];
}

- (void)focusMapToShowAllMarkers
{
    CLLocationCoordinate2D myLocation = ((GMSMarker *)markers.firstObject).position;
    GMSCoordinateBounds *bounds = [[GMSCoordinateBounds alloc] initWithCoordinate:myLocation coordinate:myLocation];
    
    for (GMSMarker *marker in markers)
        bounds = [bounds includingCoordinate:marker.position];
    
    [_mapView animateWithCameraUpdate:[GMSCameraUpdate fitBounds:bounds withPadding:15.0f]];
}


-(void)addShadowTo:(UILabel *)titallabel
{
    titallabel.layer.cornerRadius = 8.0f;
    titallabel.layer.masksToBounds = NO;
    titallabel.layer.shadowOpacity = 0.8;
    titallabel.layer.shadowRadius = 12;
    titallabel.layer.shadowOffset = CGSizeMake(5.0f, 5.0f);
}
-(void)addShadowToImageView:(UIImageView *)imageView
{
    imageView.layer.cornerRadius = 8.0f;
    imageView.layer.masksToBounds = NO;
    imageView.layer.shadowOpacity = 0.8;
    imageView.layer.shadowRadius = 12;
    imageView.layer.shadowOffset = CGSizeMake(5.0f, 5.0f);
    
}
#pragma mark -
#pragma mark checkDistinationData
-(void)checkDistinationData
{
    [self drawDriverListOnMap];
    
    if (isLoad)
    {
        MBProgressHUD *hue=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hue.labelText=@"Connecting to Driver";
    }
    NSMutableDictionary *params=[[NSMutableDictionary alloc]initWithObjectsAndKeys:@"check_destination_data_client",@"command",delg.userId,@"user_id",[[NSUserDefaults standardUserDefaults] objectForKey:@"city_id"],@"city_id", nil];
    
    [[NetworkHelper sharedInstance] commandWithParams:params onCompletion:^(NSDictionary *json) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        // NSArray *results=[json objectForKey:@"result"];
        NSLog(@"Json %@",json);
        
        if (![json objectForKey:@"error"]&&json!=nil)
        {
            if ([json objectForKey:@"result"] != nil)
            {
                NSArray *results=[json objectForKey:@"result"];
                
                NSDictionary *res=[results objectAtIndex:0];
                
                NSString *DBUUID = [res objectForKey:@"uid"];
                 NSString* Identifier = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
                 NSLog(@"output is : %@", Identifier);
                 
                 if (![DBUUID isEqualToString:Identifier]) {
                     [delg.checkingTimer invalidate];
                 [self logout];
                 return;
                 }
                delg.getCarBtntag =[res objectForKey:@"car_type"];
                delg.distinationId =[res objectForKey:@"d_id"];
                delg.drieverLatitude =[res objectForKey:@"latitude"];
                delg.driverlongitude =[res objectForKey:@"longitude"];
                delg.sourceLatitude =[res objectForKey:@"client_source_latitude"];
                delg.sourceLongitude =[res objectForKey:@"client_source_longitude"];
                delg.destinationLatitude=[res objectForKey:@"client_d_latitude"];
                delg.destinationLongitude =[res objectForKey:@"client_d_longitude"];
                delg.finalFare =[res objectForKey:@"fair"];
                self.driverName.text =[NSString stringWithFormat:@"%@",[res objectForKeyedSubscript:@"first_name"]];
                delg.driverpic = [res objectForKey:@"photo"];
                delg.driverNumber =[res objectForKey:@"mobile"];
                
                delg.vehicleImg =[NSString stringWithFormat:@"%@%@%@",KBaseUrl,[res objectForKey:@"doc4_path"],[res objectForKey:@"doc4_name"]];
                delg.selectedDriverId =[res objectForKey:@"driver_id"];
                NSLog(@"self.selec id   :%@",_selectedDriver);
                NSLog(@"delg id   :%@",delg.selectedDriverId);
                
                
                if (![self.selectedDriver isEqualToString:delg.selectedDriverId] && [_selectedDriver length] != 0 && ![_selectedDriver isEqualToString:@"0"])
                {
                    NSLog(@"driver id is different");
                    [self deleteData:[res objectForKey:@"d_id"]];
                    
                }
                _selectedDriver       =[res objectForKey:@"driver_id"];
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                NSString *cActivity =[res objectForKey:@"current_activity"];//
                
                if (!IsConnectViewShown && ![cActivity isEqualToString:@"Paid"] && ![cActivity isEqualToString:@"Waiting for driver"])
                {
                    [self showConnectView];
                }
                
                if ([cActivity isEqualToString:@"Waiting for driver"])
                {
//
                    
                    isLoad= YES;
                    _mapView.selectedMarker = nil;
                    
                    [self.locationtitleLabel setText:@"Wait For Driver"];
                }
                else if ([cActivity isEqualToString:@"Driver connected"])
                {
                    isLoad = NO;
                    [self.titelLabel setText:@"Driver Location"];
                    
                    
                    if (!isNotification)
                    {
                        isNotification = YES ;
                       
                       // [self showNotificationAlertWithBody:@"Now you are connected with driver" andAlertAction:@"Now you are connected with driver" sound:@"redeemSound.mp3"];
                        
                        //VGS
                        
                         [self showNotificationAlertWithBody:@"Your driver is on your way" andAlertAction:@"Your driver is on your way" sound:@"redeemSound.mp3"];
                        
                        
                        
                        
                        [self playSound];
                        
                    }
                }
                else if ([cActivity isEqualToString:@"Driver reached"])
                {
                    
                    [self.titelLabel setText:@"Driver Reached"];
                    
                    if (!isDriverReached)
                    {
                        
                        [self showNotificationAlertWithBody:@"Driver is at your door step" andAlertAction:@"Driver is at your door step" sound:@"redeemSound.mp3"];
                        [self playSound];
                        isDriverReached = YES;
                        
                        
                        [self dropRouteSetup];
                        
                        
                    }
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    
                }
                else if ([cActivity isEqualToString:@"Start Journey"])
                {
                    [self.titelLabel setText:@"Journey Started"];
                    
                    if (!isJourneyStart)
                    {
                        [MBProgressHUD hideHUDForView:self.view animated:YES];
                        
                        [self showNotificationAlertWithBody:@"Your Journey Started Now" andAlertAction:@"Your Journey Started Now" sound:@"redeemSound.mp3"];
                        
                        isJourneyStart = YES;
                    }
                    
                }
                else if ([cActivity isEqualToString:@"End Journey"])
                {
                    [self.titelLabel setText:@"Journey Ended"];
                }
                else if ([cActivity isEqualToString:@"Waiting for Payment"])
                {
                    if (isStripeCalled) {
                        isStripeCalled = NO;
                        if (!iswaiting)
                        {
                            
                            [MBProgressHUD hideHUDForView:self.view animated:YES];
                            [self showNotificationAlertWithBody:@"Journey Ended Driver Wiating for Payment.Please Pay fare"andAlertAction:@"Journey Ended Driver Waiting for Payment.Please Pay fare" sound:@"redeemSound.mp3"];
                            
                            
                            [self postStripeToken:delg.custromId whitAmount:delg.finalFare];
                            
                        }
                    }
                    
                    
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                }
                else if ([cActivity isEqualToString:@"Paid"])
                {
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                }
                if ([cActivity isEqualToString:@"Driver connected"])
                {
                    [self pickRouteSetup];
                }
                else if
                    ([cActivity isEqualToString:@"Driver reached"]||
                          [cActivity isEqualToString:@"Start Journey"])
                {
                    [self dropRouteSetup];
                    
                }
                
            } else
            {
                NSArray *results=[json objectForKey:@"messages"];
                NSDictionary *res=[results objectAtIndex:0];
                NSString *msg= [res objectForKey:@"msg_tittle"];
                tourScreen =[TourScreenView new];
                if ([msg isEqualToString:@"accepted"])
                {
                    [prefs setObject:msg forKey:@"tourActivity"];
                    
                }
                else if ([msg isEqualToString:@"Going to meetup location"])
                {
                    [prefs setObject:msg forKey:@"tourActivity"];
                    
                    [tourScreen.headingLabel setText:@"Driver going to meetup location"];
                }
                else  if ([msg isEqualToString:@"Reached meetup location"])
                {
                    [prefs setObject:msg forKey:@"tourActivity"];
                    
                    [tourScreen.headingLabel setText:@"Driver Reached meetup location"];
                    
                }
                else  if ([msg isEqualToString:@"Tour started"])
                {
                    [prefs setObject:msg forKey:@"tourActivity"];
                    [tourScreen.titelLabel setText:@"Tour started"];
                    
                    
                }
                else  if ([msg isEqualToString:@"Tour ended"])
                {
                    [prefs setObject:msg forKey:@"tourActivity"];
                    [tourScreen.titelLabel setText:@"Tour Ended"];
                    
                }
                else  if ([msg isEqualToString:@"Waiting for payment"])
                {
                    [prefs setObject:msg forKey:@"tourActivity"];
                    [tourScreen.titelLabel setText:@"Waiting for payment"];
                    NSString *fare =[res objectForKey:@"return_type"];
                    [prefs setObject:fare forKey:fare];
                    [self ShowTourScreenView];
                }
                
                
                [self showNotificationAlertWithBody:[res objectForKey:@"msg_body"]];
                
            }
        }
        else{
            NSString *errorMsg =[json objectForKey:@"error"];
            if ([ErrorFunctions isError:errorMsg])
            {
                //[self checkDistinationData];
            }
            else
            {
                if (![[json objectForKey:@"error"] isEqualToString:@"The network connection was lost."]) {
                    NSString *DBUUID = [json objectForKey:@"uid"];
                    NSString* Identifier = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
                    NSLog(@"output is : %@", Identifier);
                    
                    if (![DBUUID isEqualToString:Identifier])
                    {
                        [delg.checkingTimer invalidate];
                        [self logout];
                        
                        return;
                    }
                }
                
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                NSLog(@"Error is %@",[json objectForKey:@"error"]);
                
                
            }
        }
    }];
}
#pragma DrawRoute
-(void)pickRouteSetup
{
    CLLocationCoordinate2D driverCoordinats = CLLocationCoordinate2DMake([delg.drieverLatitude floatValue], [delg.driverlongitude floatValue]);
    
    CLLocationCoordinate2D pickupCoordinats = CLLocationCoordinate2DMake([delg.sourceLatitude floatValue], [delg.sourceLongitude floatValue]);
//    NSLog(@"isPickupRouteDrawed>>>>>>>>>>>>>>>>>>>>>> %d",_isPickupRouteDrawed);
//    if ( !_isPickupRouteDrawed)
//    {
//        [self drawRoutefromDriverLocation:driverCoordinats toPickupLocation:pickupCoordinats];
//        
//    }else if (_isPickupRouteDrawed)
//    {
//        
//        [self updateLocationoordinates:driverCoordinats];
//    }
    
     driverMarker.position = driverCoordinats;
     [self drawRoutefromDriverLocation:driverCoordinats toPickupLocation:pickupCoordinats];
   // [self updateLocationoordinates:driverCoordinats];

    
}
-(void)dropRouteSetup
{
    CLLocationCoordinate2D driverCoordinats = CLLocationCoordinate2DMake([delg.drieverLatitude floatValue], [delg.driverlongitude floatValue]);
    
    CLLocationCoordinate2D dropCoordinats = CLLocationCoordinate2DMake([delg.destinationLatitude floatValue], [delg.destinationLongitude floatValue]);
    if ( !_isDropRouteDrawed && dropCoordinats.latitude != 0.000000 && dropCoordinats.longitude != 0.000000)
    {
        
        
        [self drawRoutefromDriverLocation:driverCoordinats toDropLocation:dropCoordinats];
        
    }else if (_isDropRouteDrawed || ( dropCoordinats.latitude != 0.000000 && dropCoordinats.longitude != 0.000000))
    {
        
        [self updateLocationoordinates:driverCoordinats];
    }
    
}

#pragma mark - Draw Route
-(void)drawRoutefromDriverLocation :(CLLocationCoordinate2D )driverCoodinates toPickupLocation :(CLLocationCoordinate2D ) pickupCoordinates
{
    
  //  [self.mapView clear];
    [_coordinates removeAllObjects];
    [markers removeAllObjects];
    // driver marker
    if (driverMarker.map == nil)
    {
        driverMarker.position = driverCoodinates;
        driverMarker.title = NSLocalizedString(@"Driver location", nil);
        driverMarker.appearAnimation = kGMSMarkerAnimationPop;
        if ([delg.getCarBtntag integerValue] == 1)
        {
            driverMarker.icon = [UIImage imageNamed:@"car-black-map.png"];
        }
        else if ([delg.getCarBtntag integerValue] == 2)
        {
            driverMarker.icon = [UIImage imageNamed:@"car-suv-map.png"];
        }
        else if ([delg.getCarBtntag integerValue] == 3)
        {
            driverMarker.icon = [UIImage imageNamed:@"car-wagon-map.png"];
        }
        
        driverMarker.draggable = NO;
        driverMarker.appearAnimation = kGMSMarkerAnimationPop;
        driverMarker.map = _afterConnectMapView;
        
    }
    [_coordinates addObject:[[CLLocation alloc] initWithLatitude:driverCoodinates.latitude longitude:driverCoodinates.longitude]];
    [markers addObject:driverMarker];
    
    // pickup marker
    if (pickUpannotation.map == nil)
    {
        pickUpannotation.position = pickupCoordinates;
        pickUpannotation.title = NSLocalizedString(@"Pickup location", nil);
        pickUpannotation.appearAnimation = kGMSMarkerAnimationPop;
        pickUpannotation.icon = [UIImage imageNamed:@"pickUpannotation.png"];
        pickUpannotation.draggable = YES;
        pickUpannotation.appearAnimation = kGMSMarkerAnimationPop;
        pickUpannotation.map = _afterConnectMapView;
    }
    [_coordinates addObject:[[CLLocation alloc] initWithLatitude:pickupCoordinates.latitude longitude:pickupCoordinates.longitude]];
    [markers addObject:pickUpannotation];
    if ([_coordinates count] > 1)
    {
        //NSLog(@"PolyLine :%@",_polyline.map);
        //NSLog(@"Poly :%@",_polyline);
        
        //_polyline.map = nil;
   
        
        
        [_routeController getPolylineWithLocations:_coordinates travelMode:TravelModeDriving andCompletitionBlock:^(GMSPolyline *polyline, NSError *error) {
            [_coordinates removeAllObjects];
            
            if (error)
            {
                //NSLog(@"%@", error);
            }
            else if (!polyline)
            {
                ////NSLog(@"No route");
                [_coordinates removeAllObjects];
            }
            else
            {
                _polyline.map = nil;
                NSLog(@"12345678423523452345234523453453452345234534523452452345234523452345345245234523452345234523452345");
                _polyline = polyline;
                _polyline.strokeWidth = 3;
                _polyline.strokeColor = [UIColor redColor];
                _polyline.map = _afterConnectMapView;
                _isPickupRouteDrawed = YES;
                
            }
        }];
    }
    
    
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:driverCoodinates.latitude
                                                            longitude:driverCoodinates.longitude
                                                                 zoom:15.0];
    [_afterConnectMapView animateToCameraPosition:camera];
    [CATransaction begin];
    [CATransaction setAnimationDuration:1.0];
    
    [CATransaction commit];
    
    
    
    
    
}
-(void)drawRoutefromDriverLocation :(CLLocationCoordinate2D )driverCoodinates toDropLocation :(CLLocationCoordinate2D ) dropLocation
{
    //[self.mapView clear];
    [_coordinates removeAllObjects];
    [markers removeAllObjects];
    // driver marker
    if (driverMarker.map == nil)
    {
        driverMarker.position = driverCoodinates;
        driverMarker.title = NSLocalizedString(@"Driver location", nil);
        driverMarker.appearAnimation = kGMSMarkerAnimationPop;
        
        if ([delg.getCarBtntag integerValue] == 1)
        {
            driverMarker.icon = [UIImage imageNamed:@"car-black-map.png"];
        }
        else if ([delg.getCarBtntag integerValue] == 2)
        {
            driverMarker.icon = [UIImage imageNamed:@"car-suv-map.png"];
        }
        else if ([delg.getCarBtntag integerValue] == 3)
        {
            driverMarker.icon = [UIImage imageNamed:@"car-wagon-map.png"];
        }
        
        driverMarker.draggable = NO;
        driverMarker.appearAnimation = kGMSMarkerAnimationPop;
        driverMarker.map = _afterConnectMapView;
        
    }
    
    [_coordinates addObject:[[CLLocation alloc] initWithLatitude:driverCoodinates.latitude longitude:driverCoodinates.longitude]];
    [markers addObject:driverMarker];
    
    // pickup marker
    if (_markerFinish.map == nil)
    {
        _markerFinish.position = dropLocation;
        _markerFinish.title = NSLocalizedString(@"Drop location", nil);
        _markerFinish.appearAnimation = kGMSMarkerAnimationPop;
        _markerFinish.icon = [UIImage imageNamed:@"destinationAnnotation.png"];
        _markerFinish.draggable = YES;
        _markerFinish.appearAnimation = kGMSMarkerAnimationPop;
        _markerFinish.map = _afterConnectMapView;
    }
    [_coordinates addObject:[[CLLocation alloc] initWithLatitude:dropLocation.latitude longitude:dropLocation.longitude]];
    [markers addObject:_markerFinish];
    if ([_coordinates count] > 1)
    {
        
        //_polyline =[GMSPolyline new];
        [_routeController getPolylineWithLocations:_coordinates travelMode:TravelModeDriving andCompletitionBlock:^(GMSPolyline *polyline, NSError *error) {
            if (error)
            {
                //NSLog(@"%@", error);
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
                _polyline.map = _afterConnectMapView;
                _isDropRouteDrawed = YES;
            }
        }];
    }
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:driverCoodinates.latitude
                                                            longitude:driverCoodinates.longitude
                                                                 zoom:15.0];
    [_afterConnectMapView animateToCameraPosition:camera];
    [CATransaction begin];
    [CATransaction setAnimationDuration:1.0];
    
    [CATransaction commit];
    
}


-(void)deleteData : (NSString *)dId
{
    NSLog(@"d_id   :%@",dId);
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSMutableDictionary *params=[[NSMutableDictionary alloc]initWithObjectsAndKeys:@"removeride",@"command",dId,@"d_id", nil];
    
        [[NetworkHelper sharedInstance] commandWithParams:params onCompletion:^(NSDictionary *json) {
        
        // NSArray *results=[json objectForKey:@"result"];
        
        ////NSLog(@"result is %@",res);
        if (json != nil)
        {
            NSLog(@"result is %@",json);
            [self showNotificationAlertWithBody:@"Driver You have Selected is not available. please select another driver"];
            //isLoad = NO;
            
            [self fetch:all_Drivers of:Black_Car];
        }
           }];

}




#pragma mark -
- (void)postStripeToken:(NSString* )token whitAmount :(NSString *) amount
{
    //1
    
    NSLog(@"delg.custromId %@",delg.custromId);
    NSLog(@"amount %@",amount);
    self.str_amount = amount;

    NSString *finalAmount =[NSString stringWithFormat:@"%.0f",[amount floatValue]*100];
    
    NSURL *postURL = [NSURL URLWithString:STRIPE_TEST_POST_URL];
    AFHTTPClient* httpClient = [AFHTTPClient clientWithBaseURL:postURL];
    httpClient.parameterEncoding = AFJSONParameterEncoding;
    [httpClient registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [httpClient setDefaultHeader:@"Content-Type" value:@"application/json"];
    
    //4
    NSMutableString *stripUrl =[[NSMutableString alloc] init];
    
    [stripUrl appendString:KStripUrl];
    
    [stripUrl appendString:[NSString stringWithFormat:@"stripeCustomer=%@&stripeAmount=%@",token,finalAmount]];
    NSLog(@"stripUrl %@",stripUrl);
    NSMutableURLRequest* request = [httpClient requestWithMethod:@"GET" path:stripUrl parameters:nil];
    
    self.httpOperation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON)
                          
                          {
                               iswaiting = YES;
                              isStripeCalled = YES;
                              //[MBProgressHUD hideHUDForView:self.view animated:YES];
                              [self chargeDidSucceed1];
                              
                          }
                        failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON)
                          {
                              isStripeCalled = YES;
                              [MBProgressHUD hideHUDForView:self.view animated:YES];
                              NSLog(@"%@",JSON);
                              NSLog(@"error %@",error);
                              [self chargeDidNotSuceed];
                          }];
    
    [self.httpOperation start];
    
    
    
}
- (void)chargeDidSucceed1
{
    NSString *str_transactionType = @"4"; //guide_reservation
    NSMutableDictionary *params=[[NSMutableDictionary alloc]initWithObjectsAndKeys:@"payment_transaction",@"command",str_transactionType,@"transaction_type",self.str_amount,@"amount_paid",delg.userId,@"client_id", nil];
    
    [[NetworkHelper sharedInstance] commandWithParams:params onCompletion:^(NSDictionary *json) {
        //NSLog(@"the json return is %@",json);
        if (![json objectForKey:@"error"]&& json!=nil)
        {
            NSDictionary *res=[json objectForKey:@"result"];
            NSString *status=[NSString stringWithFormat:@"%@",[res objectForKey:@"successful"]];
            if ([status isEqualToString:@"1"])
            {
                mes_FarePaid = [NSString stringWithFormat:@" Total Fare \n $%@",self.str_amount];
                
                
                
                [self showCustomUIAlertViewWithtilet:mes_FarePaid andWithMessage:@"Fare has been paid successfully."];
                [self updateActivity:@"Paid"];
            }
        }
        else
        {
            NSString *errorMsg =[json objectForKey:@"error"];
            if ([ErrorFunctions isError:errorMsg])
            {
            }
            else
            {
                [self showHudWithText:errorMsg];
            }
        }
    }];
    
    
}

- (void)chargeDidNotSuceed {
    //2
    
    [self showCustomUIAlertViewWithtilet:@"Not successful" andWithMessage:@"Please try again later."];
    
}
-(void)updateActivity:(NSString *)activity
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSMutableDictionary *params=[[NSMutableDictionary alloc]initWithObjectsAndKeys:@"update_current_activity",@"command",delg.distinationId,@"d_id",activity,@"activity", nil];
    
    
    [[NetworkHelper sharedInstance] commandWithParams:params onCompletion:^(NSDictionary *json) {
        
        // NSArray *results=[json objectForKey:@"result"];
        
        ////NSLog(@"result is %@",res);
        if (json != nil)
        {
            NSLog(@"result is %@",json);
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            IsConnectViewShown =NO;
            isLoad = NO;
            isNotification = NO;
        }
        else{
            NSString *errorMsg =[json objectForKey:@"error"];
            if ([errorMsg isEqualToString:@"request body stream exhausted"]||[errorMsg isEqualToString:@"The request timed out."])
            {
                [self updateActivity:activity];
            }
            else
            {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                //NSLog(@"Error is %@",[json objectForKey:@"error"]);
                [self showCustomUIAlertViewWithtilet:@"Info" andWithMessage:[json objectForKey:@"error"]];
            }
        }
    }];
    
}


//ShowFareAndRatingView

-(void)showFareAndRatingView
{
    NSString * storyboardName = @"Main";
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle: nil];
    FareRatingViewController * Dvc = [storyboard instantiateViewControllerWithIdentifier:@"FareRating"];
    [self.navigationController pushViewController:Dvc animated:YES];
    
    
}
-(void)showAddRoomView;
{
    NSString * storyboardName = @"Main";
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle: nil];
    AddRoomForRent * Dvc = [storyboard instantiateViewControllerWithIdentifier:@"AddRoom"];
    [self.navigationController pushViewController:Dvc animated:YES];
}
-(void)showMyRentelView;
{
    NSString * storyboardName = @"Main";
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle: nil];
    MyRentalView * Dvc = [storyboard instantiateViewControllerWithIdentifier:@"MyRental"];
    [self.navigationController pushViewController:Dvc animated:YES];
}
- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    _polyline.map = nil;
    _markerStart.map = nil;
    _markerFinish.map = nil;
    [_mapView clear];
    [_coordinates removeAllObjects];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




-(void)clientSourceAndDestination
{
    NSMutableDictionary *params=[[NSMutableDictionary alloc]initWithObjectsAndKeys:@"client_s_d_gps",@"command",delg.sourceLongitude,@"client_source_longitude",delg.sourceLatitude,@"client_source_latitude",delg.destinationLongitude,@"client_d_longitude",delg.destinationLatitude,@"client_d_latitude",delg.userId,@"client_id", nil];
    ////NSLog(@"params %@",params);
    MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText=@"wait....";
    [[NetworkHelper sharedInstance] commandWithParams:params onCompletion:^(NSDictionary *json) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSArray *results=[json objectForKey:@"result"];
        NSDictionary *res=[results objectAtIndex:0];
        
        if (res != nil) {
            delg.distinationId =[res objectForKey:@"d_id"];
        }
        else{
            
            NSString *errorMsg =[json objectForKey:@"error"];
            if ([ErrorFunctions isError:errorMsg])
            {
                [self clientSourceAndDestination];
            }
            else
            {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
               // [self showCustomUIAlertViewWithtilet:@"Some thing wrong" andWithMessage:[json objectForKey:@"error"]];
            }
        }
    }];
}

-(void)playSound
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"redeemSound" ofType:@"mp3"]; /// set .mp3 name which you have in project
    AVAudioPlayer* theAudio=[[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:path] error:NULL];
    theAudio.delegate=self;
    [theAudio play];
}
- (IBAction)getSUVcarBtnPrassed:(id)sender
{
    btnTag = [NSString stringWithFormat:@"%td",[sender tag]];
    [self fetch:all_Drivers of:SUV];
}

- (IBAction)driverBtnPressed:(id)sender
{
    btnTag = [NSString stringWithFormat:@"%zd",[sender tag]];
    [self fetch:all_Drivers of:Black_Car];
}

- (IBAction)getWagonBtnPresssed:(id)sender
{
    btnTag = [NSString stringWithFormat:@"%zd",[sender tag]];
    [self fetch:all_Drivers of:Wagon];
}


- (IBAction)cancelBtnPressed:(id)sender
{
    [self showCancelUIAlertViewWithtilet:@"Are you sure ?" andWithMessage:@"Are you want to cancel this ride request ?"];
}
-(IBAction)reservstionBtnPressed:(id)sender
{
    [self.view endEditing:YES];
    [self showMenu];
}

-(void)ShowAddParkingView
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName: @"Main" bundle: nil];
    AddParkingView * sv = [storyboard instantiateViewControllerWithIdentifier:@"AddParking"];
    sv.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self.navigationController pushViewController:sv animated:YES];
    
}
-(void)ShowMyParkingView
{
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName: @"Main" bundle: nil];
    MyParkingView * sv = [storyboard instantiateViewControllerWithIdentifier:@"MyParking"];
    sv.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self.navigationController pushViewController:sv animated:YES];
    
}
-(void)ShowPlanTour
{
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName: @"Main" bundle: nil];
    PlanTourView * sv = [storyboard instantiateViewControllerWithIdentifier:@"PlanTour"];
    sv.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self.navigationController pushViewController:sv animated:YES];
    
}
-(void)ShowMyTour
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName: @"Main" bundle: nil];
    MyTourView * sv = [storyboard instantiateViewControllerWithIdentifier:@"MyTour"];
    sv.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self.navigationController pushViewController:sv animated:YES];
    
}
-(void)ShowTourScreenView
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName: @"Main" bundle: nil];
    TourScreenView * sv = [storyboard instantiateViewControllerWithIdentifier:@"TourScreen"];
    sv.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self.navigationController pushViewController:sv animated:NO];
    
}
-(void)ShowTermsScreenView
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName: @"Main" bundle: nil];
    TermsAndConditionsView * sv = [storyboard instantiateViewControllerWithIdentifier:@"Terms"];
    sv.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self.navigationController pushViewController:sv animated:YES];
    
}
-(void)ShowFindeRoomView
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName: @"Main" bundle: nil];
    FindRoomView * sv = [storyboard instantiateViewControllerWithIdentifier:@"FindRoom"];
    sv.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self.navigationController pushViewController:sv animated:YES];
    
}
-(void)ShowProfile
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName: @"Main" bundle: nil];
    ProfileViewController * sv = [storyboard instantiateViewControllerWithIdentifier:@"ProfileView"];
    sv.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self.navigationController pushViewController:sv animated:YES];
}


-(void)showMenu
{
    MZRSlideInMenu *menu = [[MZRSlideInMenu alloc] init];
    [menu setDelegate:self];//
    [menu addMenuItemWithTitle:kButtonTitle0 textColor:[UIColor whiteColor] backgroundColor:[UIColor blackColor] backgroundImage:[UIImage imageNamed:@"reservation.png"]];
    [menu addMenuItemWithTitle:kButtonTitle1 textColor:[UIColor whiteColor] backgroundColor:[UIColor blackColor] backgroundImage:[UIImage imageNamed:@"reservation.png"]];
    [menu addMenuItemWithTitle:kButtonTitle2 textColor:[UIColor whiteColor] backgroundColor:[UIColor blackColor] backgroundImage:[UIImage imageNamed:@"reservation.png"]];
    [menu addMenuItemWithTitle:kButtonTitle3 textColor:[UIColor whiteColor] backgroundColor:[UIColor blackColor] backgroundImage:[UIImage imageNamed:@"reservation.png"]];
    [menu addMenuItemWithTitle:kButtonTitle4 textColor:[UIColor whiteColor] backgroundColor:[UIColor blackColor] backgroundImage:[UIImage imageNamed:@"reservation.png"]];
    [menu addMenuItemWithTitle:kButtonTitle5 textColor:[UIColor whiteColor] backgroundColor:[UIColor blackColor] backgroundImage:[UIImage imageNamed:@"reservation.png"]];
    [menu addMenuItemWithTitle:kButtonTitle6 textColor:[UIColor whiteColor] backgroundColor:[UIColor blackColor] backgroundImage:[UIImage imageNamed:@"reservation.png"]];
    
    [menu showMenuFromRight];
}
#pragma mark MZRSlideInMenuDelegate

- (void)slideInMenu:(MZRSlideInMenu *)menuView didSelectAtIndex:(NSUInteger)index
{
    
    //    @"Get a Rideshare";
    //    @"Add Parking for Rent";
    //    @"Hire a Tour Guide";
    //    @"Live Tour";
    //    @"Add Room for Rent";
    //    @"Find a Room";
    //    @"Terms and Conditions";
    
    switch (index) {
        case 0:
            // Nothing Implemented for Ride a share. Check with client
            [self clientSourceAndDestination];
            //[self checkDistinationData];
            
            [self viewWillAppear:self];
            
            
            Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
            NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
            if (networkStatus == NotReachable)
            {
                [self showCustomUIAlertViewWithtilet:@"Info" andWithMessage:@"Please check with your internet connection"];
            } else
            {
                [self clientSourceAndDestination];
                //[self checkDistinationData];
                
                [self viewWillAppear:self];
                
            }
            
            break;
        case 1:
        {
            Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
            NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
            if (networkStatus == NotReachable)
            {
                [self showCustomUIAlertViewWithtilet:@"Info" andWithMessage:@"Please check with your internet connection"];
            } else
            {
                [self ShowFindeRoomView];
            }
        }
            break;
        case 2:
        {
            Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
            NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
            if (networkStatus == NotReachable)
            {
                [self showCustomUIAlertViewWithtilet:@"Info" andWithMessage:@"Please check with your internet connection"];
            } else
            {
                [self ShowPlanTour];

            }
        }
            break;
        case 3:
        {
            Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
            NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
            if (networkStatus == NotReachable)
            {
                [self showCustomUIAlertViewWithtilet:@"Info" andWithMessage:@"Please check with your internet connection"];
            } else
            {
                if ([isLiveTour isEqualToString:@"Yes"])
                {
                    [self ShowTourScreenView];
                }else
                {
                    [self showHudWithText:@"No Live Tour Yet"];
                }
                
            }
        }
            
           
            break;
        case 4:
            
        {
            Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
            NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
            if (networkStatus == NotReachable)
            {
                [self showCustomUIAlertViewWithtilet:@"Info" andWithMessage:@"Please check with your internet connection"];
            } else
            {
                [self ShowAddParkingView];
                
            }
        }
            
            break;
        case 5:
            
        {
            Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
            NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
            if (networkStatus == NotReachable)
            {
                [self showCustomUIAlertViewWithtilet:@"Info" andWithMessage:@"Please check with your internet connection"];
            } else
            {
                [self showAddRoomView];
                
            }
        }
            break;
        case 6:
        {
            Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
            NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
            if (networkStatus == NotReachable)
            {
                [self showCustomUIAlertViewWithtilet:@"Info" andWithMessage:@"Please check with your internet connection"];
            } else
            {
                [self ShowTermsScreenView];
                
            }
        }
            break;
        default:
            break;
    }
    
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

#pragma mark - BSForwardGeocoderDelegate methods

- (void)forwardGeocoderConnectionDidFail:(BSForwardGeocoder *)geocoder withErrorMessage:(NSString *)errorMessage
{
    [self showCustomUIAlertViewWithtilet:@"Error" andWithMessage:errorMessage];
}


- (void)forwardGeocodingDidSucceed:(BSForwardGeocoder *)geocoder withResults:(NSArray *)results
{
    // Add placemarks for each result
    for (int i = 0, resultCount = (int)[results count]; i < resultCount; i++) {
        place = [results objectAtIndex:i];
        
        ////NSLog(@"place coordinates are %@",[NSString stringWithFormat:@"%f,%f",place.coordinate.latitude,place.coordinate.longitude]);
    }
    [self.searchBar resignFirstResponder];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    if ([results count] == 1) {
        place = [results objectAtIndex:0];
        
        // Zoom into the location
        GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:place.coordinate.latitude
                                                                longitude:place.coordinate.longitude
                                                                     zoom:15];
        [_mapView animateToCameraPosition:camera];
        if (isSourceAnnotation == NO)
        {
            
            [self showCancelUIAlertViewWithtilet:@"Alert" andWithMessage:@"Is this your pick up location"];
            
        }
        else if (isdestinationAnnotation == NO )
        {
            if (isSourceLock == YES)
            {
                
                [self showCancelUIAlertViewWithtilet:@"Alert" andWithMessage:@"Is this your destination location"];
            }
        }
        
        
    }
    
    // Dismiss the keyboard
    
}

- (void)forwardGeocodingDidFail:(BSForwardGeocoder *)geocoder withErrorCode:(int)errorCode andErrorMessage:(NSString *)errorMessage
{
    NSString *message = @"";
    
    switch (errorCode) {
        case G_GEO_BAD_KEY:
            message = @"The API key is invalid.";
            break;
            
        case G_GEO_UNKNOWN_ADDRESS:
            message = [NSString stringWithFormat:@"Could not find %@", @"searchQuery"];
            break;
            
        case G_GEO_TOO_MANY_QUERIES:
            message = @"Too many queries has been made for this API key.";
            break;
            
        case G_GEO_SERVER_ERROR:
            message = @"Server error, please try again.";
            break;
            
            
        default:
            break;
    }
    
    [self showCustomUIAlertViewWithtilet:@"Information" andWithMessage:message];
    
    
}


#pragma mark - UI Events
- (void)searchBarSearchButtonClicked:(UISearchBar *)theSearchBar
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.animationType = MBProgressHUDModeAnnularDeterminate;
    
    ////NSLog(@"Searching for: %@", self.searchBar.text);
    if (self.forwardGeocoder == nil) {
        self.forwardGeocoder = [[BSForwardGeocoder alloc] initWithDelegate:self];
    }
    
    // If you want to bias on coordinates pass a bounds object. This example is proof that the "Winnetka" example works (see https://developers.google.com/maps/documentation/geocoding/#Viewports)
    CLLocationCoordinate2D southwest, northeast;
    southwest.latitude = 34.172684;
    southwest.longitude = -118.604794;
    northeast.latitude = 34.236144;
    northeast.longitude = -118.500938;
    BSForwardGeocoderCoordinateBounds *bounds = [BSForwardGeocoderCoordinateBounds boundsWithSouthWest:southwest northEast:northeast];
    
    // Forward geocode!
#if NS_BLOCKS_AVAILABLE
    [self.forwardGeocoder forwardGeocodeWithQuery:self.searchBar.text regionBiasing:nil viewportBiasing:bounds success:^(NSArray *results) {
        [self forwardGeocodingDidSucceed:self.forwardGeocoder withResults:results];
    } failure:^(int status, NSString *errorMessage) {
        if (status == G_GEO_NETWORK_ERROR) {
            [self forwardGeocoderConnectionDidFail:self.forwardGeocoder withErrorMessage:errorMessage];
        }
        else {
            [self forwardGeocodingDidFail:self.forwardGeocoder withErrorCode:status andErrorMessage:errorMessage];
        }
    }];
#else
    [self.forwardGeocoder forwardGeocodeWithQuery:self.searchBar.text regionBiasing:nil viewportBiasing:nil];
#endif
    
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if ([searchText length] == 0)
        {
            [searchBar performSelector:@selector(resignFirstResponder)
                     withObject:nil
                     afterDelay:0];
            }
}

-(void)PickupBtnPressed
{
    if (isSourceLock == NO)
    {
        isSourceLock = YES;
        [UIView animateWithDuration:0.0
                              delay:0.0
                            options: UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             [self.locationtitleLabel setText:@"Choose Destination Location"];
                             [self.currentLocationBtn setAlpha:0.0];
                             
                             
                             
                             
                             
                         }
                         completion:^(BOOL finished){
                             ////NSLog(@"Done!");
                         }];
        
        
        delg.sourceLatitude  = [NSString stringWithFormat:@"%f",delg.locationManager.location.coordinate.latitude];
        delg. sourceLongitude =[NSString stringWithFormat:@"%f",delg.locationManager.location.coordinate.longitude];
        longPressedCoordinates = delg.locationManager.location.coordinate;
        [self addGMSmarker:longPressedCoordinates];
        locationMarker.map = nil;
        
    }
    
}
-(void)logout
{
    MBProgressHUD *hue=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hue.labelText=@"Trying to Logout..";
    NSString* Identifier = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    NSLog(@"output is : %@", Identifier);
    
    NSMutableDictionary *params=[[NSMutableDictionary alloc]initWithObjectsAndKeys:@"signout_user",@"command",delg.userId,@"user_id",Identifier,@"uid", nil];
    
    [[NetworkHelper sharedInstance] commandWithParams:params onCompletion:^(NSDictionary *json) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        ////NSLog(@"the json return is %@",json);
        if (![json objectForKey:@"error"]&&json!=nil)
        {
            
            prefs = [NSUserDefaults standardUserDefaults];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [prefs removeObjectForKey:@"user_id"];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"user"];
            UIStoryboard *storyBoard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
            MainViewController*mv =[storyBoard instantiateViewControllerWithIdentifier:@"MainView"];
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:mv];
            [nav.navigationBar setBackgroundImage:[UIImage imageNamed: @"categories_header.png"]
                                    forBarMetrics:UIBarMetricsDefault];
            [self.navigationController pushViewController:mv animated:YES];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }else
        {
            NSString *errorMsg =[json objectForKey:@"error"];
            if ([ErrorFunctions isError:errorMsg])
            {
                [self logout];
            }
            else
            {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [self showCustomUIAlertViewWithtilet:@"Some thing wrong" andWithMessage:[json objectForKey:@"error"]];
            }
            
            ////NSLog(@"Error :%@",[json objectForKey:@"error"]);
            
        }
    }];
    
    
}
#pragma mark -
#pragma mark UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            
            if (alertView == AlertView)
            {
                
                if (isSourceLock == NO)
                {
                    isSourceLock = YES;
                    [UIView animateWithDuration:0.0
                                          delay:0.0
                                        options: UIViewAnimationOptionCurveEaseIn
                                     animations:^{
                                         [self.locationtitleLabel setText:@"Choose Destination Location"];
                                         [self.currentLocationBtn setAlpha:0.0];
                                         
                                         
                                         
                                         
                                     }
                                     completion:^(BOOL finished){
                                         ////NSLog(@"Done!");
                                     }];
                    
                }else
                {
                    
                    [UIView animateWithDuration:0.0
                                          delay:0.0
                                        options: UIViewAnimationOptionCurveEaseIn
                                     animations:^{
                                         [self.locationtitleLabel setText:@"Choose a Car"];
                                         
                                         destinationAnnotation.title =@"Locked";
                                         
                                         
                                         
                                         isdestinationLock = YES;
                                     }
                                     completion:^(BOOL finished){
                                         ////NSLog(@"Done!");
                                     }];
                    
                    
                    
                }
                if (islongPessed)
                {
                    [self addGMSmarker:longPressedCoordinates];
                }
                else
                {
                    [self addGMSmarker:place.coordinate];
                }
                
                
                [alertView dismissWithClickedButtonIndex:buttonIndex animated:YES];
            }
            
            break;
        case 1:
            if (alertView == AlertView)
            {
                [alertView dismissWithClickedButtonIndex:buttonIndex animated:YES];
            }
            break;
        default:
            break;
    }
}
-(void)addGMSmarker:(CLLocationCoordinate2D)coordinate
{
    if (isSourceAnnotation == NO)
    {
        [SVGeocoder reverseGeocode:CLLocationCoordinate2DMake(coordinate.latitude,coordinate.longitude)
                        completion:^(NSArray *placemarks, NSHTTPURLResponse *urlResponse, NSError *error) {
                            SVPlacemark *placemarkN=[[SVPlacemark alloc] init];
                            ////NSLog(@"%@",[placemarks objectAtIndex:0]);
                            placemarkN =[placemarks objectAtIndex:0];
                            
                            // ////NSLog(@"placemark %@",placemarks);
                            NSString *locatedaddress = [NSString stringWithFormat:@"%@,%@,%@",placemarkN.thoroughfare,placemarkN.subLocality,placemarkN.locality];
                            
                            pickUpannotation.position =coordinate;
                            pickUpannotation.title = @"Source Location";
                            pickUpannotation.appearAnimation = kGMSMarkerAnimationPop;
                            pickUpannotation.snippet =locatedaddress;
                            pickUpannotation.icon = [GMSMarker markerImageWithColor:[UIColor greenColor]];
                            pickUpannotation.draggable = YES;
                            pickUpannotation.appearAnimation = kGMSMarkerAnimationPop;
                            pickUpannotation.map = _mapView;
                            self.mapView.selectedMarker = pickUpannotation;
                        }];
        
        
        delg.sourceLatitude =[NSString stringWithFormat:@"%f",coordinate.latitude];
        delg. sourceLongitude =[NSString stringWithFormat:@"%f",coordinate.longitude];
        
        
        [_coordinates addObject:[[CLLocation alloc] initWithLatitude:coordinate.latitude longitude:coordinate.longitude]];
        isSourceAnnotation = YES;
        [self showCustomUIAlertViewWithtilet:@"Info" andWithMessage:@"Do you want to select Drop Location or connect drivers"];
    }
    else if (isdestinationAnnotation == NO )
    {
        if (isSourceLock == YES)
        {
            [SVGeocoder reverseGeocode:CLLocationCoordinate2DMake(coordinate.latitude,coordinate.longitude)                            completion:^(NSArray *placemarks, NSHTTPURLResponse *urlResponse, NSError *error) {
                SVPlacemark *placemarkN=[[SVPlacemark alloc] init];
                ////NSLog(@"%@",[placemarks objectAtIndex:0]);
                placemarkN =[placemarks objectAtIndex:0];
                
                // ////NSLog(@"placemark %@",placemarks);
                NSString *locatedaddress = [NSString stringWithFormat:@"%@,%@,%@",placemarkN.thoroughfare,placemarkN.subLocality,placemarkN.locality];
                
                
                
                destinationAnnotation.position = coordinate;
                destinationAnnotation.title = @"Destination location";
                destinationAnnotation.snippet = locatedaddress;
                destinationAnnotation.icon = [GMSMarker markerImageWithColor:[UIColor redColor]];
                
                delg.destinationLatitude = [NSString stringWithFormat:@"%f",coordinate.latitude];;
                
                destinationAnnotation.draggable = YES;
                delg.destinationLongitude = [NSString stringWithFormat:@"%f",coordinate.longitude];
                destinationAnnotation.map = _mapView;
                self.mapView.selectedMarker = destinationAnnotation;
            }];
            [_coordinates addObject:[[CLLocation alloc] initWithLatitude:coordinate.latitude longitude:coordinate.longitude]];
            
            ////NSLog(@" _coordinates %@",_coordinates);
            //[markers addObject:destinationAnnotation];
            isdestinationAnnotation = YES;
            if ([_coordinates count] > 1)
            {
                delg.isSelectedSourecAndDistination = YES;
                [_routeController getPolylineWithLocations:_coordinates travelMode:TravelModeDriving andCompletitionBlock:^(GMSPolyline *polyline, NSError *error) {
                    if (error)
                    {
                        // NSLog(@"%@", error);
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
                        ////NSLog(@"delg.soureceDestinationDistance =%@",delg.soureceDestinationDistance);
                        
                        if ([delg.soureceDestinationDistance rangeOfString:@"mi"].location != NSNotFound)
                        {
                            isDestanceInMiles = YES;
                            ////NSLog(@"string contain mi");
                            NSArray *components = [delg.soureceDestinationDistance componentsSeparatedByString: @"mi"];
                            delg.soureceDestinationDistance = [components objectAtIndex:0];
                            ////NSLog(@"distance flot value %f",[delg.soureceDestinationDistance floatValue]);
                            distance = [delg.soureceDestinationDistance floatValue];
                            ////NSLog(@"distance in miles %f",distance);
                        }
                        else if ([delg.soureceDestinationDistance rangeOfString:@"km"].location == NSNotFound)
                        {
                            ////NSLog(@"string does not contain km");
                            NSArray *components = [delg.soureceDestinationDistance componentsSeparatedByString: @"m"];
                            delg.soureceDestinationDistance = [components objectAtIndex:0];
                            ////NSLog(@"distance flot value %f",[delg.soureceDestinationDistance floatValue]);
                            distance = [delg.soureceDestinationDistance floatValue]/1000;
                            ////NSLog(@"distance in meater %f",distance);
                        }
                        
                        else {
                            ////NSLog(@"string contains km!");
                            NSArray *components = [delg.soureceDestinationDistance componentsSeparatedByString: @"km"];
                            delg.soureceDestinationDistance = [components objectAtIndex:0];
                            ////NSLog(@"distanse without km or m %@",[components objectAtIndex:0]);
                            distance = [delg.soureceDestinationDistance floatValue];
                            
                            ////NSLog(@"distance in km %f",distance);
                        }
                        
                        ////NSLog(@"distance is %f",distance);
                        
                    }
                }];
            }
        }
        else
        {
            [self showCustomUIAlertViewWithtilet:@"Warning" andWithMessage:@"Please Confirm Source"];
        }
    }
    else
    {
    }
}
#pragma mark All Drivers Web services driverId
-(void)fetch:(NSString *)command of :(NSString *) cartype
{
     [allDrivers removeAllObjects];
    hude=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hude.labelText=@"Searching Drivers...";
    
    
    NSString *currentLatitude =[NSString stringWithFormat:@"%f",delg.locationManager.location.coordinate.latitude];
    NSString *currentLongitude =[NSString stringWithFormat:@"%f",delg.locationManager.location.coordinate.longitude];
    
    NSMutableDictionary *params=[[NSMutableDictionary alloc]initWithObjectsAndKeys:command,@"command",cartype,@"car_id", currentLatitude,@"lat",currentLongitude,@"long", nil];
    [[NetworkHelper sharedInstance] commandWithParams:params onCompletion:^(NSDictionary *json) {
        
        if (![json objectForKey:@"error"]&&json!=nil)
        {
            NSArray *results=[json objectForKey:@"result"];
            NSLog(@"result %@",results);
            for (int i=0; i<[results count]; i++)
            {
                NSDictionary *res=[results objectAtIndex:i];
                //get user location
                NSString *dName =[NSString stringWithFormat:@"%@",[res objectForKey:@"first_name"]];
                NSString *dId =[res objectForKey:@"id"];
                NSString *dphone =[res objectForKey:@"mobile"];
                NSString *dPhoto =[res objectForKey:@"photo"];
                NSString *car_model_Photo =[res objectForKey:@"model_image"];
                NSString *dcarId =[res objectForKey:@"car_type"];
                NSString *driverDistance;
                
                NSString *str_DriverMile = [res objectForKey:@"mile"];
                
                if ([[res objectForKey:@"distance"] isEqual:[NSNull null]])
                {
                    driverDistance = @"N/A";
                }else
                {
                    driverDistance = [res objectForKey:@"distance"];
                    
                }
                
                NSString *availableSeats =[res objectForKey:@"available_seats"];
                NSString *dLocation =[NSString stringWithFormat:@"%@,%@",[res objectForKey:@"latitude"],[res objectForKey:@"longitude"]];
                NSString *carNumber =[res objectForKey:@"car_number"]; ;
                NSString *cImage   =[NSString stringWithFormat:@"%@%@",[res objectForKey:@"doc4_path"],[res objectForKey:@"doc4_name"]];
                // old - gets the value through car type
                //NSString *cBasefare =[res objectForKey:@"base_fare"];
                // NSString *cPermilefare =[res objectForKey:@"per_mile_fare"];
                
                //New - gets the value from driver while add driver
                
                // per_mile,basefare
                
                NSString *cBasefare =[res objectForKey:@"basefare"];
                NSString *cPermilefare =[res objectForKey:@"per_mile"];
                NSString *dRating =[res objectForKey:@"driver_rating"];
                NSString *str_driverGender = [res objectForKey:@"gender"];
                NSString *str_CarModel = [res objectForKey:@"car_model"];
                
                NSString *str_State = [res objectForKey:@"state_name"];
                NSString *str_City = [res objectForKey:@"city_name"];
                NSString *str_OwnerShip = [res objectForKey:@"ownership"];
                
              
                
                
                [allDrivers addObject:[Driver setDriverId:dId driverName:dName driverPhone:dphone driverPhoto:dPhoto driverCarId:dcarId driverLocation:dLocation driverDistance:driverDistance availableSeats:availableSeats carImage:cImage carNumber:carNumber carBasefare:cBasefare carPerMilefare:cPermilefare driverRating:dRating drivermile:str_DriverMile driverGender:str_driverGender driverCarModel:str_CarModel str_model_image:car_model_Photo str_StateName:str_State str_CityName:str_City str_OwnershipType:str_OwnerShip]];
            }
            if (allDrivers.count != 0)
            {
                [self.driverListTable reloadData];
                
                [self showDriversList];
                
            }
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }
        
        else
        {
            //NSLog(@"the error is %@",[json objectForKey:@"error"]);
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            NSString *errorMsg =[json objectForKey:@"error"];
            if ([ErrorFunctions isError:errorMsg])
            {
               // [self fetch:command of:cartype];
                
            }
            else
            {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [self showCustomUIAlertViewWithtilet:@"Info" andWithMessage:@"There is no driver available right now. Please try again later"];
                [self viewWillAppear:YES];
            }
            
        }
        
    }];
    
    //dictionary to be sorted
    
    
    
    //[_locationManager2 stopUpdatingLocation];
}
#pragma mark UITableView Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UIView *view =[[UIView alloc] initWithFrame:CGRectZero];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    
    return 1;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    //CGFloat headerWidth = CGRectGetWidth(self.view.frame);
    UIView *view =[[UIView alloc] initWithFrame:CGRectZero];
    return view;
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    // Return the number of rows in the section.
    return allDrivers.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"DCell";
    DriverCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[DriverCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    Driver *dr = [allDrivers objectAtIndex:indexPath.row];
    cell.driverName.text    = dr.driverName;
    cell.carNumber.text     = dr.carNumber;
    cell.distanceLabel.text = dr.drivermile;
    cell.baseFarelabel.text = [NSString stringWithFormat:@"$%@",dr.carBasefare];
    cell.perMileLabel.text  = [NSString stringWithFormat:@"$%@",dr.carPerMilefare];
    cell.lbl_AvailableSeats.text = [NSString stringWithFormat:@"%@",dr.availableSeats];
    [self addShadowToImageView:cell.BgImageView];
    cell.driverImageView.layer.cornerRadius = cell.driverImageView.frame.size.width/2;
    CGRect frame = CGRectMake(7,65,69,16);
    
    StarRatingView *starviewAnimated = [[StarRatingView alloc]initWithFrame:frame andRating:[dr.driverRating intValue] withLabel:NO animated:YES];
    [cell.contentView addSubview:starviewAnimated];
    
    NSString *imageName = dr.driverPhoto;
    
   
    
    NSString *imageUrl;
    
    if ([imageName isEqualToString:@""]) {
        imageUrl = @"http://192.168.2.176/ridegreen/mappservicesia/upload/image_blank.png";

    }
    else
    {
        if([imageName hasPrefix:@"http://"])
        {
            imageUrl =[NSString stringWithFormat:@"%@",imageName];
        }
        else
        {
            imageUrl =[NSString stringWithFormat:@"%@upload/%@",kAPIHost ,imageName];
        }
    }
    
    
   
    if (imageName!= 0)
    {
        
        
        [cell.driverImageView setImageWithURLRequest:[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:imageUrl]]
                                    placeholderImage:[UIImage imageNamed:@"image_blank.png"]
                                             success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image)
         {
             
             cell.driverImageView.image = image;
             
         }
        failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error)
         
         {
             
             
             
         }];
    }
    
    
    NSString *carName = dr.carImage;
    NSString *carUrl;
    if([carName hasPrefix:@"http://"])
    {
        carUrl =[NSString stringWithFormat:@"%@",carName];
    }
    else
    {
        carUrl =[NSString stringWithFormat:@"%@%@",kAPIHost ,carName];
    }
    if (carName!= 0)
    {
        UIImage *carImage;
        if ([dr.driverCarId intValue] == 1)
        {
            carImage =[UIImage imageNamed:@"car_black.png"];
        }else if ([dr.driverCarId intValue] == 2)
        {
            carImage =[UIImage imageNamed:@"car_suv.png"];
        }
        else if ([dr.driverCarId intValue] == 3)
        {
            carImage =[UIImage imageNamed:@"car-wagon.png"];
        }
        
        [cell.carImageView setImageWithURLRequest:[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:carUrl]]
                                 placeholderImage:carImage
                                          success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image)
         {
             
             cell.carImageView.image = image;
             
         }
        failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error)
         
         {
             
             
             
         }];
        
        
        
        
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Driver *dr =[allDrivers objectAtIndex:indexPath.row];
   // [self ContactDriverWithId:dr.driverId withCarType:dr.driverCarId];
    
    selRow = [[NSNumber alloc] initWithInteger:indexPath.row];
    
    [self alertcheckDirect];
    
   // [customAlertView close];
    
    
    
}
#pragma mark connactDriver
-(void)ContactDriverWithId :(NSString *)driverId withCarType :(NSString *) cartype
{
    
    
    [prefs setObject:delg.selectedDriverId forKey:@"driver_id"];
    NSDate *today = [NSDate date];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    
    // Get the date time in NSString
    NSString *date = [dateFormatter stringFromDate:today];
    //NSLog(@"car type is %@",delg.getCarBtntag);
    if ([delg.destinationLatitude length] == 0 && [delg.destinationLongitude length] == 0)
    {
        delg.destinationLatitude = @"00.000000";
        delg.destinationLongitude = @"00.000000";
    }
    
    MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText=@"wait....";
    
    NSMutableDictionary *params=[[NSMutableDictionary alloc]initWithObjectsAndKeys:@"client_s_d_gps",@"command",delg.sourceLongitude,@"client_source_longitude",delg.sourceLatitude,@"client_source_latitude",delg.destinationLongitude,@"client_d_longitude",delg.destinationLatitude,@"client_d_latitude",delg.userId,@"client_id",driverId,@"driver_id",date,@"date",cartype,@"car_type", nil];
    
    [[NetworkHelper sharedInstance] commandWithParams:params onCompletion:^(NSDictionary *json) {
        
        NSArray *results=[json objectForKey:@"result"];
        NSDictionary *res=[results objectAtIndex:0];
        //////NSLog(@"result is %@",res);
        if (res != nil)
        {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            delg.isConected = YES;
            [self.locationtitleLabel setText:@"Wait For Driver"];
            [self showCustomUIAlertViewWithtilet:@"Info" andWithMessage:@"You are being connected"];
            delg.distinationId =[res objectForKey:@"d_id"];
            if ([delg.checkingTimer isValid] == NO && delg.checkingTimer  == nil)
            {
                [self startcheckingTimer];
            }
        }
        else{
            
            NSString *errorMsg =[json objectForKey:@"error"];
            if ([ErrorFunctions isError:errorMsg])
            {
                [self ContactDriverWithId:driverId withCarType:cartype];
            }
            else if ([errorMsg isEqualToString:@"Driver just hired by other client, Please contact another Driver"])
            {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [self showCustomUIAlertViewWithtilet:@"Some thing wrong" andWithMessage:[json objectForKey:@"error"]];
            }
            else
            {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [self showCustomUIAlertViewWithtilet:@"Some thing wrong" andWithMessage:[json objectForKey:@"error"]];
            }
            
        }
    }];
    
}
-(void) startFlashingbutton
{
    
    CGRect frame = self.locationtitleLabel.frame;
    frame.size.width = 0;
    
    self.locationtitleLabel.frame = frame;
    [UIView animateWithDuration:3.0
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         CGRect frame = self.locationtitleLabel.frame;
                         frame.size.width = 206;
                         self.locationtitleLabel.frame = frame;
                     }
                     completion:^(BOOL finished){
                         // Do nothing
                     }];
}
-(void)startcheckingTimer
{
    UIBackgroundTaskIdentifier bgTask = UIBackgroundTaskInvalid;
    
    UIApplication  *app = [UIApplication sharedApplication];
    bgTask = [app beginBackgroundTaskWithExpirationHandler:^
              {
                  
              }];
    delg.checkingTimer = [NSTimer scheduledTimerWithTimeInterval:5.00
                                                          target:self
                                                        selector:@selector(checkDistinationData)
                                                        userInfo:nil
                                                         repeats:YES];
    [app endBackgroundTask:bgTask];
}



#pragma mark -
#pragma mark CLlocationManager2Delegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    
    currLocation =[locations lastObject];
    lati = [NSString stringWithFormat:@"%f",locationManager.location.coordinate.latitude];
    longi = [NSString stringWithFormat:@"%f",locationManager.location.coordinate.longitude];
    
    
    if (locationMarker!= nil)
    {
        
        
        ////NSLog(@"currLocation.coordinate %f,%f",currLocation.coordinate.latitude,currLocation.coordinate.longitude);
        
        [SVGeocoder reverseGeocode:currLocation.coordinate
                        completion:^(NSArray *placemarks, NSHTTPURLResponse *urlResponse, NSError *error) {
                            SVPlacemark *placemark=[[SVPlacemark alloc] init];
                            placemark =[placemarks objectAtIndex:0];
                            
                            // ////NSLog(@"placemark %@",placemarks);
                            NSString *locatedaddress = [NSString stringWithFormat:@"%@,%@,%@",placemark.thoroughfare,placemark.subLocality,placemark.locality];
                            
                            
                            
                            locationMarker.snippet = locatedaddress;
                            
                            
                            self.mapView.selectedMarker = locationMarker;
                            GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:currLocation.coordinate.latitude
                                                                                    longitude:currLocation.coordinate.longitude
                                                                                         zoom:15.0];
                            [_mapView animateToCameraPosition:camera];
                            [CATransaction begin];
                            [CATransaction setAnimationDuration:1.0];
                            locationMarker.position = locationManager.location.coordinate;
                            [CATransaction commit];
                            [self updateLocationoordinates:currLocation.coordinate];
                            
                            
                        }];
    }
    
    
    
    //  [_locationManager2 stopUpdatingLocation];
}
-(void)updateLocationoordinates :(CLLocationCoordinate2D )coordinates
{
    
//    if (locationMarker != nil) {
//        locationMarker= [GMSMarker markerWithPosition:coordinates];
//        driverMarker.map = _mapView;
//        
//    } else
//        [CATransaction begin];
//    [CATransaction setAnimationDuration:1.0];
//    locationMarker.position = coordinates;
//    [CATransaction commit];
//    locationMarker.position = coordinates;
//    driverMarker.position = coordinates;
//    
//    
    
    //--------------------------
    
    lati = [NSString stringWithFormat:@"%f" ,delg.locationManager.location.coordinate.latitude];
    longi = [NSString stringWithFormat:@"%f",delg.locationManager.location.coordinate.longitude];
    CLLocationCoordinate2D coordinats = CLLocationCoordinate2DMake([lati floatValue], [longi floatValue]);
    
    if (driverMarker == nil) {
        driverMarker = [GMSMarker markerWithPosition:coordinats];
        
        driverMarker.map = _mapView;
    } else
        [CATransaction begin];
    [CATransaction setAnimationDuration:1.0];
    driverMarker.position = coordinats;
    [CATransaction commit];
    driverMarker.position = coordinats;
    
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
    ////////NSLog(@"Error while getting core location : %@",[error localizedFailureReason]);
    if ([error code] == kCLErrorDenied) {
        //you had denied
    }
    [manager stopUpdatingLocation];
}




- (IBAction)backBtnPressed:(id)sender
{
    [self ShowProfile];
}

- (IBAction)currentLocationBtnPressed:(id)sender
{
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:delg.locationManager.location.coordinate.latitude
                                                            longitude:delg.locationManager.location.coordinate.longitude
                                                                 zoom:15];
    [_mapView animateToCameraPosition:camera];
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:YES];
    isdestinationAnnotation = NO;
    isSourceAnnotation = NO;
    isSourceAnnotation = NO;
    isdestinationLock  = NO;
    
    IsConnectViewShown = NO;
    delg.isConected    = NO;
    IsConnectViewShown = NO;
    
    isNotification  = NO;
    isDriverReached = NO;
    isJourneyStart  = NO;
    iswaiting       = NO;
    //isPiad          = NO;
    
    [locationManager stopUpdatingLocation];
    [self.mapView clear];
    
    
    
    
}

- (IBAction)callBtnPressed:(id)sender
{
    
    
    NSString *phoneNumber = [@"telprompt://" stringByAppendingString:COMPANY_NUMBER];
    NSString *cleanedString = [[phoneNumber componentsSeparatedByCharactersInSet:[[NSCharacterSet characterSetWithCharactersInString:@"0123456789-+()"] invertedSet]] componentsJoinedByString:@""];
    NSString *escapedPhoneNumber = [cleanedString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *phoneURLString = [NSString stringWithFormat:@"telprompt:%@", escapedPhoneNumber];
    NSURL *phoneURL = [NSURL URLWithString:phoneURLString];
    
    if ([[UIApplication sharedApplication] canOpenURL:phoneURL]) {
        [[UIApplication sharedApplication] openURL:phoneURL];
    }
    
}

#pragma mark - Cancel Journey
-(void)cancelJourneyBeforeConnacting
{
    MBProgressHUD *hud =[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Please Wait";//delete_destination_data($driver_id)
    NSMutableDictionary *params=[[NSMutableDictionary alloc]initWithObjectsAndKeys:@"client_cancel_b_connact" ,@"command",delg.userId,@"user_id", nil];
    
    
    [[NetworkHelper sharedInstance] commandWithParams:params onCompletion:^(NSDictionary *json) {
        
        //NSLog(@"json %@",json);
        if (json != nil && ![json objectForKey:@"error"])
        {
            
            
            delg.isConected = NO;
            
            
            isLoad = NO;
            isNotification = NO;
            IsConnectViewShown = NO;
            
            [self hideConnectView];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
        }
        else{
            
            NSString *errorMsg =[json objectForKey:@"error"];
            if ([ErrorFunctions isError:errorMsg])
            {
                [self cancelJourneyBeforeConnacting];
            }
            else
            {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                ////NSLog(@"Error is %@",[json objectForKey:@"error"]);
            }
            
        }
        
    }];
    
}
-(void)cancelJourneyClientNotInterested
{
    MBProgressHUD *hud =[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Please Wait";//delete_destination_data($driver_id)
    NSMutableDictionary *params=[[NSMutableDictionary alloc]initWithObjectsAndKeys:@"client_not_Interested" ,@"command",delg.distinationId,@"d_id", nil];
    
    
    [[NetworkHelper sharedInstance] commandWithParams:params onCompletion:^(NSDictionary *json) {
        
        ////NSLog(@"json %@",json);
        if (json != nil && ![json objectForKey:@"error"])
        {
            
            
            delg.isConected = NO;
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self.afterConnectCancelBtn setAlpha:0.0];
            isLoad = NO;
            isNotification = NO;
            IsConnectViewShown = NO;
            [self hideConnectView];
            
        }
        else{
            
            NSString *errorMsg =[json objectForKey:@"error"];
            if ([ErrorFunctions isError:errorMsg])
            {
                [self cancelJourneyClientNotInterested];
            }
            else
            {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                ////NSLog(@"Error is %@",[json objectForKey:@"error"]);
            }
            
        }
        
    }];
}


- (IBAction)clearBtnpressed:(id)sender
{
    isSourceLock            = NO;
    isdestinationLock       = NO;
    isSourceAnnotation      = NO;
    isdestinationAnnotation = NO;
    
    
    //_polyline = [GMSPolyline new];
    pickUpannotation.map       = nil;
    destinationAnnotation .map = nil;
    [self.currentLocationBtn setAlpha:1.0];
    
    [self.locationtitleLabel setText:@"Choose Pickup Location"];
    if(locationMarker.map == nil)
    {
        [self showMarkerOnCoordinates:delg.locationManager.location.coordinate showMarker:locationMarker];
    }
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:delg.locationManager.location.coordinate.latitude
                                                            longitude:delg.locationManager.location.coordinate.longitude
                                                                 zoom:15];
    [_mapView animateToCameraPosition:camera];
    
}
-(void)RemoveAllmarkersFromMap
{
    for (int i = 0; i < allMarkers.count; i++)
    {
        GMSMarker *marker =[GMSMarker new];
        marker =[allMarkers objectAtIndex:i];
        marker.map = nil;
        
    }
    
    allMarkers      = [NSMutableArray new];
    allDriversOnMap = [NSMutableArray new];
}
- (IBAction)afterConnectCancelBtnPressed:(id)sender
{
    
    [self showCancelUIAlertViewWithtilet:@"Are you sure ?" andWithMessage:@"Are you want to cancel this ride ?"];
    
}

- (IBAction)vehicelImgBtnPressed:(id)sender
{
    if (_isCarImage)
    {
        [EXPhotoViewer showImageFrom:self.vehicleImageView];
    }
    
    
}

- (IBAction)driverImgBtnPressed:(id)sender
{
    if (_isDriverImage)
    {
        [EXPhotoViewer showImageFrom:self.driverImageView];
    }
    
}
- (void)showCustomUIAlertViewWithtilet :(NSString *)titel andWithMessage:(NSString *)message {
    
    
    
    
    NYAlertViewController *alertViewController = [[NYAlertViewController alloc] initWithNibName:nil bundle:nil];
    
    
    
    
    alertViewController.backgroundTapDismissalGestureEnabled = YES;
    alertViewController.swipeDismissalGestureEnabled = YES;
    
    alertViewController.title = NSLocalizedString(titel, nil);
    alertViewController.message = NSLocalizedString(message, nil);
    
    
    alertViewController.view.tintColor = self.view.tintColor;
    
    alertViewController.titleFont = [UIFont fontWithName:@"AvenirNext-Bold" size:18.0f];
    alertViewController.messageFont = [UIFont fontWithName:@"AvenirNext-Medium" size:16.0f];
    alertViewController.buttonTitleFont = [UIFont fontWithName:@"AvenirNext-Regular" size:alertViewController.buttonTitleFont.pointSize - 2];
    alertViewController.cancelButtonTitleFont = [UIFont fontWithName:@"AvenirNext-Medium" size:alertViewController.cancelButtonTitleFont.pointSize - 2];
    
    alertViewController.alertViewBackgroundColor = [UIColor colorWithWhite:0.19f alpha:1.0f];
    alertViewController.alertViewCornerRadius = 10.0f;
    
    alertViewController.titleColor = [UIColor colorWithRed:0.42f green:0.78 blue:0.32f alpha:1.0f];
    alertViewController.messageColor = [UIColor colorWithWhite:0.92f alpha:1.0f];
    
    alertViewController.buttonColor = [UIColor colorWithRed:0.42f green:0.78 blue:0.32f alpha:1.0f];
    alertViewController.buttonTitleColor = [UIColor whiteColor];
    
    alertViewController.cancelButtonColor = [UIColor colorWithRed:0.42f green:0.78 blue:0.32f alpha:1.0f];
    alertViewController.cancelButtonTitleColor = [UIColor whiteColor];
    
    
    if ([message isEqualToString:@"Do you want to select Drop Location or connect drivers"])
    {
        alertViewController.buttonCornerRadius = 8.0f;
        [alertViewController addAction:[NYAlertAction actionWithTitle:@"Show Drivers"
                                                                style:UIAlertActionStyleCancel
                                                              handler:^(NYAlertAction *action) {
                                                                  [self dismissViewControllerAnimated:YES completion:^
                                                                   {
                                                                       [self fetch:all_Drivers of:Black_Car];
                                                                   }];
                                                              }]];
        [alertViewController addAction:[NYAlertAction actionWithTitle:@"Drop Location"
                                                                style:UIAlertActionStyleCancel
                                                              handler:^(NYAlertAction *action) {
                                                                  [self dismissViewControllerAnimated:YES completion:nil];
                                                              }]];
        
       // [self presentViewController:alertViewController animated:YES completion:nil];
    }
    else
    {
        alertViewController.buttonCornerRadius = 20.0f;
        [alertViewController addAction:[NYAlertAction actionWithTitle:NSLocalizedString(@"Dismiss", nil)style:UIAlertActionStyleDefault handler:^(NYAlertAction *action)
                                        {
                                           // [self dismissViewControllerAnimated:true completion:nil];
                                            
                                            [self dismissViewControllerAnimated:YES completion:^
                                             {
                                                 if ([message isEqualToString:@"Fare has been paid successfully."])
                                                 {
                                                     //[self dismissViewControllerAnimated:YES completion:nil];
                                                     [self showFareAndRatingView];
                                                 }
                                                 
                                             }];
                                            
                                        }]];
        
    }
    
    [self presentViewController:alertViewController animated:YES completion:nil];
    
    
}
- (void)showCancelUIAlertViewWithtilet :(NSString *)titel andWithMessage:(NSString *)message {
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
    
    [alertViewController addAction:[NYAlertAction actionWithTitle:NSLocalizedString(@"Yes", nil)style:UIAlertActionStyleDefault handler:^(NYAlertAction *action)
                                    {
                                        
                                        [self dismissViewControllerAnimated:YES completion:^
                                         {
                                             if ([message isEqualToString:@"Is this your pick up location"])
                                             {
                                                 
                                                 isSourceLock = YES;
                                                 [UIView animateWithDuration:0.0
                                                                       delay:0.0
                                                                     options: UIViewAnimationOptionCurveEaseIn
                                                                  animations:^{
                                                                      [self.locationtitleLabel setText:@"Choose Destination Location"];
                                                                      [self.currentLocationBtn setAlpha:0.0];
                                                                      
                                                                      
                                                                      
                                                                      
                                                                      
                                                                  }
                                                                  completion:^(BOOL finished){
                                                                      ////NSLog(@"Done!");
                                                                  }];
                                                 [self addGMSmarker:longPressedCoordinates];
                                                 
                                             }
                                             
                                             
                                             
                                             else if ([message isEqualToString:@"Is this your destination location"])
                                             {
                                                 
                                                 
                                                 isdestinationLock = YES;
                                                 [UIView animateWithDuration:0.0
                                                                       delay:0.0
                                                                     options: UIViewAnimationOptionCurveEaseIn
                                                                  animations:^{
                                                                      [self.locationtitleLabel setText:@"Choose a Driver"];
                                                                      [self.currentLocationBtn setAlpha:0.0];
                                                                      
                                                                      
                                                                      
                                                                      
                                                                      [self fetch:all_Drivers of:Black_Car];
                                                                      
                                                                  }
                                                                  completion:^(BOOL finished){
                                                                      ////NSLog(@"Done!");
                                                                  }];
                                                 [self addGMSmarker:longPressedCoordinates];
                                                 
                                                 
                                                 
                                                 
                                             }
                                             
                                             
                                             else if ([message isEqualToString:@"Are you want to cancel this ride request ?"])
                                             {
                                                 
                                                 
                                                 [self cancelJourneyBeforeConnacting];
                                                 
                                             }
                                             else if ([message isEqualToString:@"Are you want to cancel this ride ?"])
                                             {
                                                 
                                                 
                                                 [self cancelJourneyClientNotInterested];
                                                 
                                             }
                                             
                                         }];
                                        
                                        
                                        
                                        
                                    }]];
    
    [alertViewController addAction:[NYAlertAction actionWithTitle:NSLocalizedString(@"NO", nil)
                                                            style:UIAlertActionStyleCancel handler:^(NYAlertAction *action)
                                    {
                                        [self dismissViewControllerAnimated:YES completion:nil];
                                        
                                        if ([message isEqualToString:@"Are you want to cancel this ride request ?"])
                                        {
                                            
                                            
                                            
                                            
                                        }
                                        else if ([message isEqualToString:@"Are you want to cancel this ride ?"])
                                        {
                                            
                                            
                                            [self.afterConnectCancelBtn setEnabled:YES];
                                            
                                        }
                                    }]];
    
    [self presentViewController:alertViewController animated:YES completion:nil];
}
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


#pragma mark-driver Activity

-(void)showNotificationAlertWithBody :(NSString *)alertBody andAlertAction :(NSString *) alertAction sound :(NSString *) sound
{
    
    UILocalNotification* localNotification = [[UILocalNotification alloc] init];
    localNotification.alertBody = alertBody;
    localNotification.alertAction = alertAction;
    localNotification.timeZone = [NSTimeZone defaultTimeZone];
    localNotification.soundName = @"Short Sound Effect.mp3";
    
    localNotification.applicationIconBadgeNumber = [[UIApplication sharedApplication] applicationIconBadgeNumber] + 1;
    
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    
    
}

-(void)showConnectView
{
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:delg.locationManager.location.coordinate.latitude
                                                            longitude:delg.locationManager.location.coordinate.longitude
                                                                 zoom:15];
    
    _afterConnectMapView = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    _afterConnectMapView = [GMSMapView mapWithFrame:CGRectMake(0,0, self.afterConnectMap.frame.size.width,self.afterConnectMap.frame.size.height) camera:camera];
    _afterConnectMapView.delegate = self;
    _afterConnectMapView.myLocationEnabled = YES;
    [self.afterConnectMap addSubview:_afterConnectMapView];
    IsConnectViewShown = YES;
    _markerFinish.map = nil;
    pickUpannotation.map = nil;
    [self driverDetailSetup];
    
    
}
-(void)hideConnectView
{
    [self.connectView setAlpha:0.0];
}

-(void)driverDetailSetup
{
    [self getDriverDestance];
    
    
    
    self.driverImageView.layer.borderWidth = 2.0f;
    self.driverImageView.layer.borderColor =[[UIColor whiteColor] CGColor];
    self.driverImageView.layer.cornerRadius = self.driverImageView.frame.size.width / 2;
    self.driverImageView.layer.masksToBounds = YES;
    NSString *imageUrl;
    
    if ([delg.driverpic isEqualToString:@""])
    {
         imageUrl = @"http://192.168.2.176/ridegreen/mappservicesia/upload/image_blank.png";
    }
    else
    {
        imageUrl =[NSString stringWithFormat:@"%@upload/%@",kAPIHost,delg.driverpic];
 
    }
    
    
    [dSpinner setHidden:NO];
    [dSpinner startAnimating];
    
    [self.driverImageView setImageWithURLRequest:[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:imageUrl]]
                                placeholderImage:[UIImage imageNamed:@"image_blank.png"]
                                         success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image)
     {
         self.driverImageView.image = image;
         self.isDriverImage = YES;
         [dSpinner stopAnimating];
         
         //[cell setNeedsLayout];
         
         
     }
                                         failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error){
                                             self.isDriverImage = NO;
                                             [dSpinner stopAnimating];
                                         }];
    [vSpinner setHidden:NO];
    [vSpinner startAnimating];
    [self.vehicleImageView setImageWithURLRequest:[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:delg.vehicleImg]]
                                 placeholderImage:[UIImage imageNamed:@""]
                                          success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image)
     {
         self.vehicleImageView.image = image;
         self.isCarImage = YES;
         [vSpinner stopAnimating];
         
         
         
         //[cell setNeedsLayout];
         
         
     }
                                          failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error)
     {
         [vSpinner stopAnimating];
         self.isCarImage = NO;
     }];
    
    
    
    [self pickRouteSetup];
    [self.connectView setAlpha:1.0];
    
}

-(void)getDriverDestance
{
    
    NSString *clietnLocation =[NSString stringWithFormat:@"%@,%@",delg.sourceLatitude,delg.sourceLongitude];
    NSString *driverLoction =[NSString stringWithFormat:@"%@,%@",delg.drieverLatitude,delg.driverlongitude];
    
   
    
    NSMutableString *finalUrl =[NSMutableString stringWithFormat:@"%@origins=%@&destinations=%@&mode=driving&sensor=false%@",KBase_MAP_URL,clietnLocation,driverLoction,kgoogleApiTempKey];
    
    
    
    NSURL *url = [NSURL URLWithString:finalUrl];
    
    
    NSError *error = NULL;
    NSString *theJSONString = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:&error];
    
    
    // Parse with TouchJSON
    NSDictionary *replyDict = [NSDictionary dictionaryWithJSONString:theJSONString error:&error];
    
    NSString *distnaceStr = [[[[[[replyDict objectForKey:@"rows"] objectAtIndex:0]
                                objectForKey:@"elements"]
                               objectAtIndex:0]
                              objectForKey:@"distance"]
                             objectForKey:@"text"];
    ////NSLog(@"distnaceStr=%@",distnaceStr);
    
    NSString *str = [distnaceStr stringByReplacingOccurrencesOfString:@"," withString:@"."];
    float DriverDistance ;
    if ([str rangeOfString:@"mi"].location != NSNotFound)
    {
        // in miles
        DriverDistance = [str floatValue];
        ////NSLog(@"distance in miles %f",clientDistance);
    }
    else if ([str rangeOfString:@"km"].location == NSNotFound)
    {
        //convert meters to kilometers
        DriverDistance = [str floatValue]/1000;
        DriverDistance =  DriverDistance  / 1.6;
        ////NSLog(@"distance in miles %f",clientDistance);
    }
    
    else {
        
        DriverDistance = [str floatValue];
        DriverDistance =  DriverDistance  / 1.6;
        ////NSLog(@"distance in km %f",clientDistance);
    }
    //[clientSourceAddress appendString:[NSString stringWithFormat:@" /%.1f",DriverDistance]];
    [self.distanceLabel setText:[NSString stringWithFormat:@"%.01f M",DriverDistance]];
    
    
    
    
}

#pragma mark show driver list
-(UIView *)createRelationListView
{
    UIView *relation = [[UIView alloc] initWithFrame:CGRectMake(0, 0,310, 455)];
    
    relation.backgroundColor =[UIColor whiteColor];
    
    self.driverListTable = [[UITableView alloc]initWithFrame:CGRectMake(5, 5,300, 445) style:UITableViewStyleGrouped];
    self.driverListTable.tag = 2;
    self.driverListTable.rowHeight = 98;
    self.driverListTable.sectionFooterHeight = 1;
    self.driverListTable.sectionHeaderHeight = 21;
    self.driverListTable.scrollEnabled = YES;
    self.driverListTable.showsVerticalScrollIndicator = YES;
    self.driverListTable.userInteractionEnabled = YES;
    self.driverListTable.bounces = YES;
    self.driverListTable.layer.cornerRadius = 12.0f;
    self.driverListTable.delegate = (id)self;
    self.driverListTable.dataSource =(id) self;
    self.driverListTable.separatorColor =[UIColor clearColor];
    self.driverListTable.backgroundColor =[UIColor clearColor];
    [self.driverListTable registerNib:[UINib nibWithNibName:@"DriverCell" bundle:nil] forCellReuseIdentifier:@"DCell"];
    relation.layer.cornerRadius = 12.0f;
    [relation addSubview:self.driverListTable];
    [self.driverListTable reloadData];
    return relation;
}

#pragma mark CustomAlertView

-(void)showDriversList
{
    customAlertView = [[CustomIOSAlertView alloc] init];
    
    [customAlertView setContainerView:[self createRelationListView]];
    customAlertView.tag = 100;
    
    // You may use a Block, rather than a delegate.
    [customAlertView setDelegate:self];
    
    [customAlertView setUseMotionEffects:true];
    [customAlertView setButtonTitles:[NSMutableArray arrayWithObjects:@"Cancel",@"Request driver", nil]];
    // And launch the dialog
    [customAlertView show];
    
}
#pragma mark -
#pragma mark - draw Route
#pragma mark -


-(void)hideAlertView:(CustomIOSAlertView *)alertview
{
    
    
    
    [self customIOS7dialogButtonTouchUpInside:alertview clickedButtonAtIndex:0];
    
    
}
#pragma mark CustomAletrView Delegate

- (void)customIOS7dialogButtonTouchUpInside: (CustomIOSAlertView *)alert clickedButtonAtIndex: (NSInteger)buttonIndex
{
    
    if (alert.tag == 100) {
        switch (buttonIndex) {
            case 0:
                isLoad = NO;
                [self clearBtnpressed:self];
                [alert close];
                [customAlertView close];
                break;
            case 1:
                [self alertcheck];
                break;
            default:
                break;
        }
        
    }
    else if (alert.tag == 1000){
        switch (buttonIndex) {
            case 0:
                break;
            case 1:
                [self ContactDriverWithId:drID withCarType:drCarID];
                [alert close];
                 [customAlertView close];
                break;
            default:
                break;
        }
    }
        
    
    
    
   
   //
}



-(void)alertcheck{
    CustomIOSAlertView *alertView = [[CustomIOSAlertView alloc] init];
    
    // Add some custom content to the alert view
    [alertView setContainerView:[self createDemoView]];
    alertView.tag = 1000;
    
    // Modify the parameters
    [alertView setButtonTitles:[NSMutableArray arrayWithObjects:@"Cancel", @"Request Driver",  nil]];
    [alertView setDelegate:self];
    
    // You may use a Block, rather than a delegate.
    [alertView setOnButtonTouchUpInside:^(CustomIOSAlertView *alertView, int buttonIndex) {
        NSLog(@"Block: Button at position %d is clicked on alertView %d.", buttonIndex, (int)[alertView tag]);
        [alertView close];
    }];
    
    [alertView setUseMotionEffects:true];
    
    // And launch the dialog
    [alertView show];

}



-(void)alertcheckDirect{
    CustomIOSAlertView *alertView = [[CustomIOSAlertView alloc] init];
    
    // Add some custom content to the alert view
    [alertView setContainerView:[self createDemoViewDirect]];
    alertView.tag = 1000;
    
    // Modify the parameters
    [alertView setButtonTitles:[NSMutableArray arrayWithObjects:@"Cancel", @"Request Driver",  nil]];
    [alertView setDelegate:self];
    
    // You may use a Block, rather than a delegate.
    [alertView setOnButtonTouchUpInside:^(CustomIOSAlertView *alertView, int buttonIndex) {
        NSLog(@"Block: Button at position %d is clicked on alertView %d.", buttonIndex, (int)[alertView tag]);
        [alertView close];
    }];
    
    [alertView setUseMotionEffects:true];
    
    // And launch the dialog
    [alertView show];
    
}





- (UIView *)createDemoViewDirect
{
    Driver *dr =[allDrivers objectAtIndex:[selRow integerValue]];
    
    UIView *demoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 290, 450)];
    demoView.backgroundColor = [UIColor whiteColor];
    
    UILabel *lbl_Title = [[UILabel alloc]init];
    lbl_Title.text = @"Requested Driver";
    lbl_Title.frame = CGRectMake(85, 2, 150, 25);
    lbl_Title.font = [UIFont boldSystemFontOfSize:16];
    [demoView addSubview:lbl_Title];
    
    
    NSString *str_Upload = @"http://192.168.2.176/ridegreen/mappservicesia/upload/";
    NSString *str_DriverPhoto = [NSString stringWithFormat:@"%@%@",str_Upload,dr.driverPhoto];
    
    NSURL *url = [NSURL URLWithString:str_DriverPhoto];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 35, 125, 125)];
    imageView.layer.cornerRadius = imageView.frame.size.width / 2;
    imageView.clipsToBounds = YES;
    imageView.image = [UIImage imageWithCIImage:[CIImage imageWithContentsOfURL:url]];
    [demoView addSubview:imageView];
    
    
    UILabel *lbl_DriverName = [[UILabel alloc]init];
    lbl_DriverName.text = [NSString stringWithFormat:@"%@",dr.driverName];
    lbl_DriverName.frame = CGRectMake(140, 40, 150, 25);
    lbl_DriverName.font = [UIFont boldSystemFontOfSize:15];
    [demoView addSubview:lbl_DriverName];
    
    UILabel *lbl_Gender = [[UILabel alloc]init];
    lbl_Gender.text = [NSString stringWithFormat:@"Gender : %@",dr.driverGender];
    lbl_Gender.font = [UIFont systemFontOfSize:15];
    lbl_Gender.frame = CGRectMake(140, 60, 150, 25);
    [demoView addSubview:lbl_Gender];
    
    UILabel *lbl_carNo = [[UILabel alloc]init];
    lbl_carNo.text = [NSString stringWithFormat:@"LIC NO : %@",dr.carNumber];
    lbl_carNo.font = [UIFont systemFontOfSize:15];
    lbl_carNo.frame = CGRectMake(140, 80, 150, 25);
    [demoView addSubview:lbl_carNo];
    
    UILabel *lbl_mil = [[UILabel alloc]init];
    lbl_mil.text = [NSString stringWithFormat:@"Mile : %@",dr.drivermile];
    lbl_mil.font = [UIFont systemFontOfSize:15];
    lbl_mil.frame = CGRectMake(140, 100, 150, 25);
    [demoView addSubview:lbl_mil];
    
    CGRect frame = CGRectMake(140,125,78,20);
    
    StarRatingView *starviewAnimated = [[StarRatingView alloc]initWithFrame:frame andRating:[dr.driverRating intValue] withLabel:NO animated:YES];
    [demoView addSubview:starviewAnimated];
    
    
    UILabel *lbl_mobile = [[UILabel alloc]init];
    lbl_mobile.text = [NSString stringWithFormat:@"Phone : %@",dr.driverPhone];
    lbl_mobile.font = [UIFont systemFontOfSize:15];
    lbl_mobile.frame = CGRectMake(10, 175, 280, 25);
    [demoView addSubview:lbl_mobile];
    
    UILabel *lbl_State = [[UILabel alloc]init];
    lbl_State.text = [NSString stringWithFormat:@"State : %@",dr.str_StateName];
    lbl_State.font = [UIFont systemFontOfSize:15];
    lbl_State.frame = CGRectMake(10, 200, 280, 25);
    [demoView addSubview:lbl_State];
    
    UILabel *lbl_City = [[UILabel alloc]init];
    lbl_City.text = [NSString stringWithFormat:@"City : %@",dr.str_CityName];
    lbl_City.font = [UIFont systemFontOfSize:15];
    lbl_City.frame = CGRectMake(10, 225, 280, 25);
    [demoView addSubview:lbl_City];
    
    UILabel *lbl_carModel = [[UILabel alloc]init];
    lbl_carModel.text = [NSString stringWithFormat:@"Car Model : %@",dr.driverCarModel];
    lbl_carModel.frame = CGRectMake(10, 250, 280, 25);
    lbl_carModel.font = [UIFont systemFontOfSize:15];
    [demoView addSubview:lbl_carModel];
    
    
    UILabel *lbl_seat = [[UILabel alloc]init];
    lbl_seat.text = [NSString stringWithFormat:@"Available Seats : %@",dr.availableSeats];
    lbl_seat.font = [UIFont systemFontOfSize:15];
    lbl_seat.frame = CGRectMake(10, 275, 280, 25);
    [demoView addSubview:lbl_seat];
    
    UILabel *lbl_base = [[UILabel alloc]init];
    lbl_base.text = [NSString stringWithFormat:@"Base Fare : $%@",dr.carBasefare];
    lbl_base.font = [UIFont systemFontOfSize:15];
    lbl_base.frame = CGRectMake(10, 300, 280, 25);
    [demoView addSubview:lbl_base];
    
    UILabel *lbl_permile = [[UILabel alloc]init];
    lbl_permile.text = [NSString stringWithFormat:@"Per Mile Fare : $%@",dr.carPerMilefare];
    lbl_permile.font = [UIFont systemFontOfSize:15];
    lbl_permile.frame = CGRectMake(10, 325, 280, 25);
    [demoView addSubview:lbl_permile];
    
    
    UILabel *lbl_Owner = [[UILabel alloc]init];
    lbl_Owner.text = [NSString stringWithFormat:@"Ownership : %@",dr.str_OwnershipType];
    lbl_Owner.font = [UIFont systemFontOfSize:15];
    lbl_Owner.frame = CGRectMake(10, 350, 280, 25);
    [demoView addSubview:lbl_Owner];
    
    
    
    NSString *str_Upload_carModel = @"http://192.168.2.176/ridegreen/mappservicesia/upload/";
    NSString *str_carmodelimages;
    if ([dr.str_model_image isEqualToString:@""]) {
        str_carmodelimages = @"placeholder_car.png";
     }
    else
    {
        str_carmodelimages = dr.str_model_image;

    }
    
    NSString *str_ModelPhoto = [NSString stringWithFormat:@"%@%@",str_Upload_carModel,str_carmodelimages];
    
    
    NSURL *url_carModel = [NSURL URLWithString:str_ModelPhoto];
    
    
    UIImageView *imageViewcar = [[UIImageView alloc] initWithFrame:CGRectMake(185, 365, 80, 80)];
    imageViewcar.layer.cornerRadius = imageViewcar.frame.size.width / 2;
    imageViewcar.clipsToBounds = YES;
    imageViewcar.image = [UIImage imageWithCIImage:[CIImage imageWithContentsOfURL:url_carModel]];
    [demoView addSubview:imageViewcar];
    

    drID = [NSString stringWithFormat:@"%@",dr.driverId];
    drCarID = [NSString stringWithFormat:@"%@",dr.driverCarId];
    
    
 
    
    return demoView;
}



- (UIView *)createDemoView
{
    
    int randIndex;
    randIndex = arc4random() % [allDrivers count];
    
    Driver *dr =[allDrivers objectAtIndex:randIndex];

    
    UIView *demoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 290, 450)];
    demoView.backgroundColor = [UIColor whiteColor];
    
    UILabel *lbl_Title = [[UILabel alloc]init];
    lbl_Title.text = @"Requested Driver";
    lbl_Title.frame = CGRectMake(85, 2, 150, 25);
    lbl_Title.font = [UIFont boldSystemFontOfSize:16];
    [demoView addSubview:lbl_Title];
    
    
    NSString *str_Upload = @"http://192.168.2.176/ridegreen/mappservicesia/upload/";
    NSString *str_DriverPhoto = [NSString stringWithFormat:@"%@%@",str_Upload,dr.driverPhoto];
    
    NSURL *url = [NSURL URLWithString:str_DriverPhoto];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 35, 125, 125)];
    imageView.layer.cornerRadius = imageView.frame.size.width / 2;
    imageView.clipsToBounds = YES;
    imageView.image = [UIImage imageWithCIImage:[CIImage imageWithContentsOfURL:url]];
    [demoView addSubview:imageView];
    
    
    UILabel *lbl_DriverName = [[UILabel alloc]init];
    lbl_DriverName.text = [NSString stringWithFormat:@"%@",dr.driverName];
    lbl_DriverName.frame = CGRectMake(140, 40, 150, 25);
    lbl_DriverName.font = [UIFont boldSystemFontOfSize:15];
    [demoView addSubview:lbl_DriverName];
    
    UILabel *lbl_Gender = [[UILabel alloc]init];
    lbl_Gender.text = [NSString stringWithFormat:@"Gender : %@",dr.driverGender];
    lbl_Gender.font = [UIFont systemFontOfSize:15];
    lbl_Gender.frame = CGRectMake(140, 60, 150, 25);
    [demoView addSubview:lbl_Gender];
    
    UILabel *lbl_carNo = [[UILabel alloc]init];
    lbl_carNo.text = [NSString stringWithFormat:@"LIC NO : %@",dr.carNumber];
    lbl_carNo.font = [UIFont systemFontOfSize:15];
    lbl_carNo.frame = CGRectMake(140, 80, 150, 25);
    [demoView addSubview:lbl_carNo];
    
    UILabel *lbl_mil = [[UILabel alloc]init];
    lbl_mil.text = [NSString stringWithFormat:@"Mile : %@",dr.drivermile];
    lbl_mil.font = [UIFont systemFontOfSize:15];
    lbl_mil.frame = CGRectMake(140, 100, 150, 25);
    [demoView addSubview:lbl_mil];
    
    CGRect frame = CGRectMake(140,125,78,20);
    
    StarRatingView *starviewAnimated = [[StarRatingView alloc]initWithFrame:frame andRating:[dr.driverRating intValue] withLabel:NO animated:YES];
    [demoView addSubview:starviewAnimated];
    
    
    UILabel *lbl_mobile = [[UILabel alloc]init];
    lbl_mobile.text = [NSString stringWithFormat:@"Phone : %@",dr.driverPhone];
    lbl_mobile.font = [UIFont systemFontOfSize:15];
    lbl_mobile.frame = CGRectMake(10, 175, 280, 25);
    [demoView addSubview:lbl_mobile];
    
    UILabel *lbl_State = [[UILabel alloc]init];
    lbl_State.text = [NSString stringWithFormat:@"State : %@",dr.str_StateName];
    lbl_State.font = [UIFont systemFontOfSize:15];
    lbl_State.frame = CGRectMake(10, 200, 280, 25);
    [demoView addSubview:lbl_State];
    
    UILabel *lbl_City = [[UILabel alloc]init];
    lbl_City.text = [NSString stringWithFormat:@"City : %@",dr.str_CityName];
    lbl_City.font = [UIFont systemFontOfSize:15];
    lbl_City.frame = CGRectMake(10, 225, 280, 25);
    [demoView addSubview:lbl_City];
    
    UILabel *lbl_carModel = [[UILabel alloc]init];
    lbl_carModel.text = [NSString stringWithFormat:@"Car Model : %@",dr.driverCarModel];
    lbl_carModel.frame = CGRectMake(10, 250, 280, 25);
    lbl_carModel.font = [UIFont systemFontOfSize:15];
    [demoView addSubview:lbl_carModel];
    
    
    UILabel *lbl_seat = [[UILabel alloc]init];
    lbl_seat.text = [NSString stringWithFormat:@"Available Seats : %@",dr.availableSeats];
    lbl_seat.font = [UIFont systemFontOfSize:15];
    lbl_seat.frame = CGRectMake(10, 275, 280, 25);
    [demoView addSubview:lbl_seat];
    
    UILabel *lbl_base = [[UILabel alloc]init];
    lbl_base.text = [NSString stringWithFormat:@"Base Fare : $%@",dr.carBasefare];
    lbl_base.font = [UIFont systemFontOfSize:15];
    lbl_base.frame = CGRectMake(10, 300, 280, 25);
    [demoView addSubview:lbl_base];
    
    UILabel *lbl_permile = [[UILabel alloc]init];
    lbl_permile.text = [NSString stringWithFormat:@"Per Mile Fare : $%@",dr.carPerMilefare];
    lbl_permile.font = [UIFont systemFontOfSize:15];
    lbl_permile.frame = CGRectMake(10, 325, 280, 25);
    [demoView addSubview:lbl_permile];
    
    
    UILabel *lbl_Owner = [[UILabel alloc]init];
    lbl_Owner.text = [NSString stringWithFormat:@"Ownership : %@",dr.str_OwnershipType];
    lbl_Owner.font = [UIFont systemFontOfSize:15];
    lbl_Owner.frame = CGRectMake(10, 350, 280, 25);
    [demoView addSubview:lbl_Owner];
    
    
    
    NSString *str_Upload_carModel = @"http://192.168.2.176/ridegreen/mappservicesia/upload/";
    NSString *str_carmodelimages;
    if ([dr.str_model_image isEqualToString:@""]) {
        str_carmodelimages = @"placeholder_car.png";
    }
    else
    {
        str_carmodelimages = dr.str_model_image;
        
    }
    
    NSString *str_ModelPhoto = [NSString stringWithFormat:@"%@%@",str_Upload_carModel,str_carmodelimages];
    
    
    NSURL *url_carModel = [NSURL URLWithString:str_ModelPhoto];
    
    
    UIImageView *imageViewcar = [[UIImageView alloc] initWithFrame:CGRectMake(185, 365, 80, 80)];
    imageViewcar.layer.cornerRadius = imageViewcar.frame.size.width / 2;
    imageViewcar.clipsToBounds = YES;
    imageViewcar.image = [UIImage imageWithCIImage:[CIImage imageWithContentsOfURL:url_carModel]];
    [demoView addSubview:imageViewcar];
    
    
    drID = [NSString stringWithFormat:@"%@",dr.driverId];
    drCarID = [NSString stringWithFormat:@"%@",dr.driverCarId];
    return demoView;
}


@end
