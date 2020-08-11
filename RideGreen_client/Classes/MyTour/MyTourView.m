//
//  MyTourView.m
//  ridegreen
//
//  Created by Ridegreen on 01/09/2015.
//  Copyright (c) 2015 Ridegreen. All rights reserved.
//

#import "MyTourView.h"

@interface MyTourView ()
{
    NSString *str_TotalPayment;
    MyTour *commonTourRequest;
}



@end

@implementation MyTourView

- (void)viewDidLoad {
    prefs =[NSUserDefaults standardUserDefaults];
    self.userId =[prefs objectForKey:@"user_id"];
    allTours =[NSMutableArray new];
   
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated
{
    [self fetchAllTour];
    [super viewWillAppear:YES];
     
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)fetchAllTour
{
    
    MBProgressHUD *hud =[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"";
    NSMutableDictionary *params=[[NSMutableDictionary alloc]initWithObjectsAndKeys:@"my_tours",@"command",self.userId,@"client_id", nil];
    
    [[NetworkHelper sharedInstance] commandWithParams:params onCompletion:^(NSDictionary *json) {
        
        NSLog(@"the json return is %@",json);
        
        //
        //
        
        
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        if (![json objectForKey:@"error"]) 
        {
            [[CMyTours alloc] updateClientMyTours:json];
        }
        else
        {
            // if reques error call again
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            NSString *errorMsg =[json objectForKey:@"error"];
            if ([ErrorFunctions isError:errorMsg])
            {
                [self fetchAllTour];
            }
            else 
            {
                [self showHudWithText:errorMsg];
                NSLog(@"Error is %@",[json objectForKey:@"error"]);
                [self showCustomUIAlertViewWithtilet:@"Info" andWithMessage:[json objectForKey:@"error"]];
                if ([[json objectForKey:@"error"] isEqualToString:@" You have no planned Tours!"]) {
                    [[CMyTours alloc] deleteAllDataMyTours];
                }
            }
        }
        
        [self updatedMytourUI];
    }];
}


-(void)updatedMytourUI
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
//    NSArray *results=[json objectForKey:@"result"];
    
    NSMutableArray *results = [[CMyTours alloc] fetchClientMyTours];
    [allTours removeAllObjects];
    for (int i=0; i<results.count; i++) {
        NSDictionary *res =[results objectAtIndex:i];
        
        CMyTours *obj_cl = (CMyTours *)res;
        
        NSString *tid =obj_cl.tourId;
        NSString *clientId =obj_cl.clientId;
        NSString *driverId =obj_cl.driverId;
        NSString *tDate =obj_cl.tourDate;
        NSString *dname =[NSString stringWithFormat:@"%@",obj_cl.firstName];
        NSString *dImage  =obj_cl.photo;
        NSString *dPhone  =obj_cl.mobile;
        NSString *dRate = @"";//[res objectForKey:@"rate_per_hour"];
        NSString *meetupLocation =obj_cl.meetupLocation;
        NSString *meetupAddress =obj_cl.meetupAddress;
        NSString *meetupTime =obj_cl.meetupTime;
        NSString *expectedHours =obj_cl.tourHourExpected;
        NSString *status =obj_cl.status;
        NSString *driverStatus = obj_cl.driverStatus;
        NSString *clientStatus = obj_cl.clientStatus;
        NSString *canceltour = obj_cl.canceltour;
        NSString *customerId = obj_cl.customerId;
        NSString *tourprice = obj_cl.tourprice;
        NSString *admin_phone =obj_cl.adminphone;
        NSString *driver_name = obj_cl.drivernam;
        NSString *driver_phone = obj_cl.driverphon;
        NSString *str_refundpercentage = obj_cl.refundpercentage;
        
        [allTours  addObject:[MyTour setTourId:tid tourDate:tDate driverId:driverId driverName:dname driverImage:dImage driverRate:dRate driverPhone:dPhone clientId:clientId meetupAddress:meetupAddress meetupLocation:meetupLocation meetupTime:meetupTime expectedHours:expectedHours status:status driverStatus:driverStatus clientStatus:clientStatus cancelstatus:canceltour customerId:customerId tourprice:tourprice adminphone:admin_phone drivernam:driver_name driverphon:driver_phone refundpercentage:str_refundpercentage]];
    }
    
    [self.tableView reloadData];
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
#pragma mark - Table view data source
#pragma mark UITableView Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    
    return 143;
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
    return allTours.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString* cellIdentifier = @"TCell";
    
    
    TourCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell)
    {
        cell = [[TourCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        
    }
    //cell.backgroundColor = Cell_Bg_color;
    TJSpinner *spinner = [[TJSpinner alloc] initWithSpinnerType:kTJSpinnerTypeCircular];
    spinner.hidesWhenStopped = YES;
    [spinner setHidden:YES];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    spinner.center = CGPointMake(cell.driverImageView.frame.size.width/2, cell.driverImageView.frame.size.height/2);

    tour =[allTours objectAtIndex:indexPath.row];
    cell.driverNameLabel.text = tour.driverName;
    [cell.driverNameLabel sizeToFit];
    cell.driverRateLabel.text =[NSString stringWithFormat:@"%@ %@  (Expected duration %@ hrs)",tour.tDate,tour.meetupTime,tour.expectedHours];
    cell.meetupAddress.text = tour.meetupAddress;
    //[cell.meetupAddress sizeToFit];
    cell.meetupTimeLabel.text = tour.meetupTime;
    
    cell.driverImageView.layer.borderWidth = 2.0f;
    cell.driverImageView.layer.borderColor =[UIColor lightGrayColor].CGColor;
    cell.driverImageView.layer.masksToBounds = YES;
    cell.phonebtn.tag = indexPath.row;
    cell.mapBtn.tag = indexPath.row;
    cell.goToMeetupLocationBtn.tag = indexPath.row;
    NSString *tourDateTime =[NSString stringWithFormat:@"%@ %@",tour.tDate,tour.meetupTime];
    NSDate *tourDate =[self getDateFromString:tourDateTime];

   
    NSInteger hoursBetweenDates =[self getTimeDifrance:tourDateTime];

    [cell.phonebtn addTarget:self action:@selector(phoneBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
     [cell.mapBtn addTarget:self action:@selector(mapBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
     [cell.goToMeetupLocationBtn addTarget:self action:@selector(goToMeetupLocationBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
   
    
    if ([tour.canceltour integerValue] >= 3 )
    {
        [cell.img_CancelTour setHidden:NO];
        [cell.btn_CancelTour setHidden:NO];
        cell.btn_CancelTour.tag = indexPath.row;
        deleteIndex = indexPath.row;
        [cell.btn_CancelTour addTarget:self action:@selector(action_CancelTour:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    else
    {
        [cell.img_CancelTour setHidden:YES];
        [cell.btn_CancelTour setHidden:YES];
            }

    
    [cell.btn_DriverInfo addTarget:self action:@selector(action_DriverInfo:) forControlEvents:UIControlEventTouchUpInside];
    cell.btn_DriverInfo.tag = indexPath.row;
    
    
    
    if (hoursBetweenDates <= 4 && ![self isNagtiveNumber:hoursBetweenDates] && [tour.driverStatus isEqualToString:@"accepted"])
    {
        [cell.goToMeetupLocationBtn setTitle:@"Go meetup location" forState:UIControlStateNormal];
        [cell.goToMeetupLocationBtn setEnabled:YES];  
    }
    else if (hoursBetweenDates <= 4 && [self isNagtiveNumber:hoursBetweenDates] && [tour.driverStatus isEqualToString:@"accepted"]) 
    {
        [cell.goToMeetupLocationBtn setTitle:@"Missed" forState:UIControlStateNormal];
        [cell.goToMeetupLocationBtn setEnabled:NO];  
    }
    else if (hoursBetweenDates > 4 && [tour.driverStatus isEqualToString:@"accepted"])
    {
        if (![tourDate  isToday]) 
        {
            
            [cell.goToMeetupLocationBtn setTitle:@"Not Today" forState:UIControlStateNormal];
            [cell.goToMeetupLocationBtn setEnabled:NO];
            
        }else if ([tourDate  isToday]) 
        {
            [cell.goToMeetupLocationBtn setTitle:@"Not Now" forState:UIControlStateNormal];
            [cell.goToMeetupLocationBtn setEnabled:NO];
            
        }
        
    }

    cell.driverImageView.layer.cornerRadius = cell.driverImageView.frame.size.width/2;
    [cell.driverImageView addSubview:spinner];
    NSString *imageName = tour.driverImage;
    
    NSString *imageUrl;
    if([imageName hasPrefix:@"http://"])
    {
        imageUrl =[NSString stringWithFormat:@"%@",imageName];
    }
    else
    {
        imageUrl =[NSString stringWithFormat:@"%@upload/%@",kAPIHost ,imageName];
    }
    if (imageName!= 0)
    {
        [spinner setHidden:NO];
        [spinner startAnimating];
        
        [cell.driverImageView setImageWithURLRequest:[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:imageUrl]]
            placeholderImage:[UIImage imageNamed:@"image_blank.png"]
            success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image)
         {
             
             cell.driverImageView.image = image;
             cell.isImage = YES;
             [spinner stopAnimating];
             [[NSUserDefaults standardUserDefaults] setObject:UIImagePNGRepresentation(image) forKey:[NSString stringWithFormat:@"CTourImage%ld",(long)indexPath.row]];
         }
        failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error)
         
         {
             cell.isImage = NO;
            [spinner stopAnimating];
             
             NSData *imageData = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"CTourImage%ld",(long)indexPath.row]];
             if (imageData != nil){
                 UIImage* image = [UIImage imageWithData:imageData];
                 cell.driverImageView.image = image;
             }
             
         }];
    }
    
    
    return cell;    
}






-(IBAction)action_CancelTour:(id)sender
{
    commonTourRequest = [allTours objectAtIndex:[sender tag]];
    [self showCustomUIAlertViewWithtilet:@"Cancel Tour" andWithMessage:@"Are you sure want to cancel this Tour?"];
}


-(IBAction)action_DriverInfo:(id)sender
{
    MyTour *tour = [allTours objectAtIndex:[sender tag]];
    NSString *str_DriverName = tour.drivernam;
    NSString *str_DriverPhone = tour.driverphon;
    
    NSString *msg = [NSString stringWithFormat:@"Driver Name : %@ \n\n Driver Phone : %@",str_DriverName,str_DriverPhone];
    
    
    
    [self showCustomUIAlertViewWithtitle:@"Driver Info" andWithMessage:msg];
    

}

- (void)showCustomUIAlertViewWithtitle :(NSString *)titel andWithMessage:(NSString *)message {
    
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
    [alertViewController addAction:[NYAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil)style:UIAlertActionStyleDefault handler:^(NYAlertAction *action)
                                    {
                                        [self dismissViewControllerAnimated:YES completion:^
                                         {
                                         }];
                                        
                                    }]];
       [self presentViewController:alertViewController animated:YES completion:nil];
}

    

-(NSDate *)getDateFromString:(NSString *)dateString
{
    
    
    // Convert string to date object
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    [dateFormat setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    NSDate *date = [dateFormat dateFromString:dateString];  
    
    
    
    return date; 
    
}
-(NSInteger)getTimeDifrance :(NSString *)tourDateStr
{
    NSDateFormatter* dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    [dateFormatter setLocale:[[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"] autorelease]];
    [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm a"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    NSDate* tourdate = [dateFormatter dateFromString:tourDateStr];
    NSString *localDate =[self GetCurrentDateString];
    
    NSDate   *currentDate     =[self getCurrentDateFromString:localDate];
    NSTimeInterval distanceBetweenDates = [tourdate timeIntervalSinceDate:currentDate];
    double secondsInAnHour = 3600;
    NSInteger hoursBetweenDates = distanceBetweenDates / secondsInAnHour;
    return hoursBetweenDates;
}
-(NSString *)GetCurrentDateString
{
    NSDate *today = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    // display in 12HR/24HR (i.e. 11:25PM or 23:25) format according to User Settings
    [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm a"];
    NSString *currentTime = [dateFormatter stringFromDate:today];
    
    return currentTime;
}
-(BOOL)isNagtiveNumber:(NSInteger) num
{
    if (num >= 0)
    {
        // do positive stuff
        return NO;
    }
    else
    {
        return YES;
        // do negative stuff
    }
}
-(NSDate *)getCurrentDateFromString:(NSString *)dateString
{
    
    
    // Convert string to date object
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd hh:mm a"];
    [dateFormat setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    NSDate *date =[[NSDate alloc] init];
    date =  [dateFormat dateFromString:dateString];
    
    
    
    return date; 
    
}
#pragma mark UIButton Actions
- (IBAction)phoneBtnPressed:(id)sender 
{
    MyTour *tour =[allTours objectAtIndex:[sender tag]];
    [self makeCallonNumber:tour.adminphone];
    
}

- (IBAction)mapBtnPressed:(id)sender 
{
  MyTour *tour =[allTours objectAtIndex:[sender tag]];
    
  [self showMapViewWithCoordinats:tour.meetupLocation withAddress:tour.meetupAddress];

}
- (IBAction)goToMeetupLocationBtnPressed:(id)sender 
{
   MyTour *tour =[allTours objectAtIndex:[sender tag]];
    [prefs setObject:tour.tId forKey:@"tourId"];
    [prefs setObject:tour.driverId forKey:@"driverId"];
      [self updateTourStatusWithId:tour.tId withdriverId:tour.driverId status:@"Going to meetup location" WithTour:tour];
}
#pragma mark Web Services
-(void)updateTourStatusWithId :(NSString *) tId withdriverId:(NSString *)driverId status :(NSString *) status  WithTour:(MyTour *) tour
{
    
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
                [prefs setObject:@"Yes" forKey:@"IsTourLive"];
                [self ShowTourScreenViewWithTour:tour];  
                
                
            }

           
            
        }
        else{
            ////NSLog(@"Error : %@",[json objectForKey:@"error"]);
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            NSString *errorMsg =[json objectForKey:@"error"];
            if ([ErrorFunctions isError:errorMsg])
            {
                [self updateTourStatusWithId:tId withdriverId:driverId status:status WithTour:tour];
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
-(void)ShowTourScreenViewWithTour:(MyTour *) tour
{
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName: @"Main" bundle: nil];
    TourScreenView * sv = [storyboard instantiateViewControllerWithIdentifier:@"TourScreen"];
    sv.tour = tour;
    sv.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self.navigationController pushViewController:sv animated:YES];
    
}
-(void)makeCallonNumber:(NSString *) phNumber
{
    NSString *phoneNumber = [@"telprompt://" stringByAppendingString:phNumber];
    NSString *cleanedString = [[phoneNumber componentsSeparatedByCharactersInSet:[[NSCharacterSet characterSetWithCharactersInString:@"0123456789-+()"] invertedSet]] componentsJoinedByString:@""];
    NSString *escapedPhoneNumber = [cleanedString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *phoneURLString = [NSString stringWithFormat:@"telprompt:%@", escapedPhoneNumber];
    NSURL *phoneURL = [NSURL URLWithString:phoneURLString];
    
    if ([[UIApplication sharedApplication] canOpenURL:phoneURL]) {
        [[UIApplication sharedApplication] openURL:phoneURL];
    }
    


}
-(UIView *)showMapViewWithCoordinats:(NSString *) coordinats withAddress :(NSString *) address
{
    NSArray *cord =[coordinats componentsSeparatedByString:@","];
    
    NSString *lati = [cord objectAtIndex:0];
    NSString *lngi = [cord objectAtIndex:1];
    
    CLLocationCoordinate2D loction =CLLocationCoordinate2DMake([lati floatValue], [lngi floatValue]);
    mapView =  [[[NSBundle mainBundle] loadNibNamed:@"MapView" owner:self options:nil] objectAtIndex:0];
    mView = mapView;
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:[lati floatValue]
                                                            longitude:[lngi floatValue]
                                                                 zoom:11];
    
    mView = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    mView = [GMSMapView mapWithFrame:CGRectMake(0,0, mapView.frame.size.width,mapView.frame.size.height) camera:camera];
    mView.delegate = self;
    mView.myLocationEnabled = YES;
    
    GMSMarker *marker= [[GMSMarker alloc] init];
    marker=[GMSMarker markerWithPosition:loction];
    marker.position = loction;
    // CLLocationCoordinate2DMake([latitude doubleValue], [longitude doubleValue]);
    marker.title =@"Meetup Location";
    marker.snippet = address;
    marker.appearAnimation = YES;
    marker.map = mView;
    mView.selectedMarker = marker;

    alertView = [[CustomIOSAlertView alloc] init];
    alertView.tag = 1;
    // Add some custom content to the alert view
    [alertView setContainerView:mView];
    
    // Modify the parameters
    [alertView setButtonTitles:[NSMutableArray arrayWithObjects:@"Done", nil]];
    [alertView setDelegate:self];
    
    // You may use a Block, rather than a delegate.
    [alertView setOnButtonTouchUpInside:^(CustomIOSAlertView *aView, int buttonIndex) {
        NSLog(@"Block: Button at position %d is clicked on alertView %d.", buttonIndex, (int)[aView tag]);
        //[aView close];
    }];
    
    [alertView setUseMotionEffects:true];
    
    // And launch the dialog
    [alertView show];
    return mView;
    
}

#pragma mark GoogleMapDelegate

- (void)mapView:(GMSMapView *)mapView didLongPressAtCoordinate:(CLLocationCoordinate2D)coordinate
{
    
       
    
}
#pragma mark CustomAletrView Delegate
- (void)customIOS7dialogButtonTouchUpInside: (CustomIOSAlertView *)alert clickedButtonAtIndex: (NSInteger)buttonIndex
{
    
    
    if (buttonIndex == 0) 
    {
        [alert close];  
        
        
    }else //DropOff
    {
        
        [alert close];
    }
    
}
- (IBAction)backBtnPressed:(id)sender 
{
    [self.navigationController popViewControllerAnimated:YES];
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
    
    [alertViewController addAction:[NYAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil)style:UIAlertActionStyleDefault handler:^(NYAlertAction *action)
                                    {
                                        [self dismissViewControllerAnimated:YES completion:nil];
                                        
                                    }]];
    [alertViewController addAction:[NYAlertAction actionWithTitle:NSLocalizedString(@"Continue", nil)style:UIAlertActionStyleDefault handler:^(NYAlertAction *action)
                                    {
                                        [self dismissViewControllerAnimated:YES completion:^
                                         {
                                             if ([titel isEqualToString:@"Cancel Tour"])
                                             {
                                                 
                                                 //Rejo 02032016
                                                
                                                 [self action_CancelApi:commonTourRequest.tourprice cusid:commonTourRequest.customerId bookingId:commonTourRequest.tId type:@"tourCancel"];
                                                 
                                                 
                                                 
                                             }
                                             
                                         }];
                                        
                                    }]];
    [self presentViewController:alertViewController animated:YES completion:nil];
}



-(void)action_CancelApi:(NSString*)amount cusid:(NSString*)token bookingId:(NSString *)sourceId type:(NSString *)type
{
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSString *finalAmount =[NSString stringWithFormat:@"%.0f",[amount floatValue]*100];
    
    float refundamount = [tour.refundpercentage integerValue]/100.0*[finalAmount floatValue];
    
    finalAmount = [NSString stringWithFormat:@"%.0f",refundamount];
    NSLog(@"refundamount  :%f",refundamount);
    
    
    NSURL *postURL = [NSURL URLWithString:STRIPE_TEST_POST_URL];
    AFHTTPClient* httpClient = [AFHTTPClient clientWithBaseURL:postURL];
    httpClient.parameterEncoding = AFJSONParameterEncoding;
    [httpClient registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [httpClient setDefaultHeader:@"Content-Type" value:@"application/json"];
    
    //4
    NSMutableString *stripUrl =[[NSMutableString alloc] init];
    
    [stripUrl appendString:KRefundUrl];
    
    [stripUrl appendString:[NSString stringWithFormat:@"stripeCustomerId=%@&refundAmount=%@&tour_id=%@&type=%@",token,finalAmount,sourceId,type]];
    
    
    NSLog(@"stripUrl %@",stripUrl);
    NSMutableURLRequest* request = [httpClient requestWithMethod:@"GET" path:stripUrl parameters:nil];
    
    self.httpOperation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON)
                          {
                              [MBProgressHUD hideHUDForView:self.view animated:YES];
                              
                              
                              
                              NSString *str_M = @"% of room rent shortly";
                              NSString *str_Message = [NSString stringWithFormat:@"You will get %@%@",tour.refundpercentage,str_M];
                              
                              [self showHudWithText:str_Message];
                              
                            //  [self showCustomUIAlertViewWithtilets:@"Cancel Tour" andWithMessage:@"Tour cancelled succusfully"];

                              
                              
                              //[[CMyTours alloc]deleteObjectAtIndex:deleteIndex];
                             // [self.tableView reloadData];
                              [self fetchAllTour];
                          }
                             failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON)
                          {
                              [MBProgressHUD hideHUDForView:self.view animated:YES];
                              NSLog(@"%@",JSON);
                              NSLog(@"error %@",error);
                              //[self chargeDidNotSuceed];
                          }];
    
    [self.httpOperation start];
}


- (void)showCustomUIAlertViewWithtilets :(NSString *)titel andWithMessage:(NSString *)message {
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
    [self presentViewController:alertViewController animated:YES completion:nil];
}


@end
