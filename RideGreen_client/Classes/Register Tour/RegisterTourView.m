//
//  RegisterTourView.m
//  ridegreen
//
//  Created by Ridegreen on 31/08/2015.
//  Copyright (c) 2015 Ridegreen. All rights reserved.
//

#import "RegisterTourView.h"

@interface RegisterTourView ()

@end

@implementation RegisterTourView

- (void)viewDidLoad {
    
    
    delg =(AppDelegate *)[[UIApplication sharedApplication]delegate];
    prefs =[NSUserDefaults standardUserDefaults];
    self.userId =[prefs objectForKey:@"user_id"];
    self.commentsTV.placeholder = @"Comments";
    [self setupTextFields];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
-(void)setupTextFields
{
    NSArray *fields = self.view.subviews ; //get all subviews from your scrollview
    
    for (int i=0; i<[fields count]; i++)
    {
        if([[fields objectAtIndex:i] isKindOfClass:[UITextField class]]) //check for UITextField
        {
            UITextField *textField = (UITextField *)[fields objectAtIndex:i];
            UIView* dummyView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,5,45)];
            textField.leftView = dummyView;
            textField.leftViewMode = UITextFieldViewModeAlways;
            [textField setValue:[UIColor lightGrayColor]
                     forKeyPath:@"placeholderLabel.textColor"];
            [textField resignFirstResponder];
            
            
        }
    }
    
    CGPoint position = _tourDateTF.frame.origin;
    
    CGRect sFrame = _startTimeTF.frame;
    CGRect eFrame = _endTimeTf.frame;
    sFrame.origin.x = position.x;
    eFrame.origin.x = position.x +_startTimeTF.frame.size.width +5 ;
    _startTimeTF.frame = sFrame;
    _endTimeTf.frame  = eFrame;
    
    
    
    self.tourDateTF.text = delg.tourSelectedDate;
    self.startTimeTF.text = delg.tourStartUpTime;
    self.numberOfHourTF.text = delg.tourTravelHours;
    
    
    
    _numberOfHourTF.isOptionalDropDown = YES;
    
    [_numberOfHourTF setPlaceholder:@"Number of hours ?"];
    [_numberOfHourTF setOptionalItemText:NSLocalizedString(@"Number of hours ?", nil)];
    
    NSArray *numberArray =[[NSArray alloc] initWithObjects:@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23",@"24", nil];
    
    [_numberOfHourTF setItemList:numberArray];
    
    UIToolbar *toolbar = [[UIToolbar alloc] init];
    [toolbar setBarStyle:UIBarStyleBlackTranslucent];
    [toolbar sizeToFit];
    UIBarButtonItem *buttonflexible = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *buttonDone = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneClicked:)];
    
    [toolbar setItems:[NSArray arrayWithObjects:buttonflexible,buttonDone, nil]];
    _numberOfHourTF.inputAccessoryView = toolbar;
    _startTimeTF.inputAccessoryView = toolbar;
    _endTimeTf.inputAccessoryView = toolbar;
    _meetupTimeTF.inputAccessoryView = toolbar;
    _meetUpLocationTF.inputAccessoryView = toolbar;
    _commentsTV.inputAccessoryView = toolbar;
    [_startTimeTF setDropDownMode:IQDropDownModeTimePicker];
    [_endTimeTf setDropDownMode:IQDropDownModeTimePicker];
    [_meetupTimeTF setDropDownMode:IQDropDownModeTimePicker];
    
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark UITextViewDelegate
-(void)textViewDidBeginEditing:(UITextView *)textView
{
    if (!IsMoveUp)
    {
        [self animatetextViewup:YES];
        IsMoveUp = YES;
    }
    
}
-(void)textViewDidChange:(UITextView *)textView
{
    
}
-(void)textViewDidChangeSelection:(UITextView *)textView
{
    
    /*YOUR CODE HERE*/
}
-(void)textViewDidEndEditing:(UITextView *)textView
{
    
    
    if (IsMoveUp)
    {
        [self animatetextViewup:NO];
        IsMoveUp = NO;
    }
    
    /*YOUR CODE HERE*/
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    
    return YES;
}
-(BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange
{
    
    
    return YES;
}
- (BOOL)textView:(UITextView *)textView shouldInteractWithTextAttachment:(NSTextAttachment *)textAttachment inRange:(NSRange)range
{
    
    return YES;
}
-(BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    if ([textView.text length] != 0)
    {
        //[self submitBtnPressed:self];
    }
    
    return YES;
}
-(void)textField:(IQDropDownTextField*)textField didSelectItem:(NSString*)item
{
    
    
    
    
    
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    
    
    return YES;
}

#pragma mark UITextField delegate methods
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
    if (textField == _meetUpLocationTF && IsMoveUp == NO)
    {
        
        [self animatetextViewup:YES];
        IsMoveUp = YES;
    }
    if (textField == _meetupTimeTF && IsMoveUp == NO) {
        
        [self animatetextViewup:YES];
        IsMoveUp = YES;
    }
    
    
    
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    
    
    
    
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
    
    
    
    
    
}
-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    
    
    if(textField == _numberOfHourTF)
    {
        [_startTimeTF becomeFirstResponder];
    }
    else if(textField == _startTimeTF)
    {
        [_endTimeTf becomeFirstResponder];
    }
    
    else if(textField == _endTimeTf)
    {
        [_meetUpLocationTF becomeFirstResponder];
    }
    else if(textField == _meetUpLocationTF)
    {
        [_meetupTimeTF becomeFirstResponder];
    }
    else if(textField == _meetupTimeTF)
    {
        [_commentsTV becomeFirstResponder];
    }
    
    
    
    return YES;
}
- (void) animatetextViewup: (BOOL) up
{
    int movementDistance =0; // tweak as needed
    const float movementDuration = 0.3f;
    
    movementDistance = 120;
    
    
    
    
    int movement = (up ? -movementDistance : movementDistance);
    
    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField.tag == 222)
    {
        NSUInteger oldLength = [textField.text length];
        NSUInteger replacementLength = [string length];
        NSUInteger rangeLength = range.length;
        
        NSUInteger newLength = oldLength - rangeLength + replacementLength;
        
        BOOL returnKey = [string rangeOfString: @"\n"].location != NSNotFound;
        delg.zipCode = textField.text;
        return newLength <= MAXLENGTH || returnKey;
    }
    
    return YES;
}



-(void)doneClicked:(UIBarButtonItem*)button
{
    if (IsMoveUp)
    {
        
        [self animatetextViewup:NO];
        IsMoveUp = NO;
    }
    
    [self.view endEditing:YES];
}
#pragma mark
#pragma mark UIButton Actions
- (IBAction)backBtnPressed:(id)sender
{
    
    if (delg.isRigesterTour == NO)
    {
        [self.navigationController popToRootViewControllerAnimated:NO];
        
    }else
    {
        
        [self.navigationController popViewControllerAnimated:NO];
    }
}

- (IBAction)checkFarebtnPressed:(id)sender
{
    if ([_numberOfHourTF.text length] !=0)
    {
        float totalHr =[_numberOfHourTF.text floatValue];
        float perHrRate =[self.perHourRate floatValue];
        float fare = totalHr * perHrRate;
        float taxVal = (fare*[delg.tourTaxRate floatValue] ) / 100;
        float Rate = taxVal + fare ;
        NSLog(@"Rate : %f",Rate);
        
        NSString *msg = [NSString stringWithFormat:@"Price per hour:$%@\nno.of Hours:  %@\n\nTotal fare:  $%.02f\nTax Rate:  %@%@\n\n $%.02f would be charged to your credit card",_perHourRate,_numberOfHourTF.text,fare,delg.tourTaxRate,@"%",Rate];
        [self showCustomUIAlertViewWithtilet:@"Estimated fare" andWithMessage:msg];
    }else
    {
        [self showCustomUIAlertViewWithtilet:@"Info" andWithMessage:@"Please select Number of hours"];
    }
}

- (IBAction)fromMapBtnPressed:(id)sender
{
    [self.view endEditing:YES];
    if (IsMoveUp)
    {
        [self animatetextViewup:NO];
        IsMoveUp = NO;
    }
    [self showCustomAlertViewWithMessage:@"Tab and hold to Select Location"];
}

- (IBAction)myLocationBtnPressed:(id)sender
{
    
    [self useCrrentLocation];
}

- (IBAction)submitBtnPressed:(id)sender
{
    if ([_startTimeTF.text length] != 0 && [_numberOfHourTF.text length] != 0 && [_meetUpLocationTF.text length] != 0) {
        // NSDate *selectedDate =[self getDateFromString:_tourDateTF.text];
        NSDate *startTime = [self getTimeFromString:_startTimeTF.text];
        NSDate *endTime = [self getTimeFromString:_endTimeTf.text];
        NSDate *meetUptime =[self getTimeFromString:_meetupTimeTF.text];
        
        
        if (delg.currentCoordinats.length != 0)
        {
            
            if ([endTime isEarlierThanDate:startTime])
            {
                
                [self showCustomUIAlertViewWithtilet:@"Info" andWithMessage:@"End time is earlier then Start Time"];
            }
            else if ([meetUptime isLaterThanDate:endTime])
            {
                
                [self showCustomUIAlertViewWithtilet:@"Info" andWithMessage:@"Meetup time is Later then End Time"];
            }
            else
            {
                
                [self action_Register];
                
                //[self submitTourFrom];
                
            }
            
        }else
        {
            
            if ([endTime isEarlierThanDate:startTime])
            {
                
                [self showCustomUIAlertViewWithtilet:@"Info" andWithMessage:@"End time is earlier then Start Time"];
            }
            else if ([meetUptime isLaterThanDate:endTime])
            {
                
                [self showCustomUIAlertViewWithtilet:@"Info" andWithMessage:@"Meetup time is Later then End Time"];
            }else
            {
                
                [self getCoordinatesFromAddressString:_meetUpLocationTF.text];
            }
            
            
            
        }
        
    }else
    {
        [self showCustomUIAlertViewWithtilet:@"Info" andWithMessage:@"Some fields are empty"];
        
    }
    
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
-(NSDate *)getTimeFromString:(NSString *)dateString
{
    // Convert string to date object
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"hh:mm a"];
    [dateFormat setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    NSDate *date = [dateFormat dateFromString:dateString];
    return date;
}


-(void)action_Register{
    if ([_numberOfHourTF.text length] !=0)
    {
        float totalHr =[_numberOfHourTF.text floatValue];
        float perHrRate =[self.perHourRate floatValue];
        float fare = totalHr * perHrRate;
        float taxVal = (fare*[delg.tourTaxRate floatValue] ) / 100;
        float Rate = taxVal + fare ;
        NSLog(@"Rate : %f",Rate);
        self.str_amount = [NSString stringWithFormat:@"%.02f", Rate];
        self.str_TotalPayment = [NSString stringWithFormat:@"%.02f", Rate];
        NSString *msg = [NSString stringWithFormat:@"Price per hour:$%@\nno.of Hours:  %@\n\nTotal fare:  $%.02f\nTax Rate:  %@%@\n\n $%.02f would be charged to your credit card",_perHourRate,_numberOfHourTF.text,fare,delg.tourTaxRate,@"%",Rate];
        [self showCustomUIAlertViewWithtitle:@"Estimated fare" andWithMessage:msg];
    }
}


-(void)SubmitSuccess{
    NSString *tourDate      = self.tourDateTF.text;
    NSString *numberOfHours = self.numberOfHourTF.text;
    NSString *startTime     = self.startTimeTF.text;
   // NSString *endTime       = @"";
    NSString *meetupAddress = self.meetUpLocationTF.text;
    NSString *meetupTime    = self.startTimeTF.text;
    NSString *comments      = self.commentsTV.text;
    NSString *total_payment = self.str_TotalPayment;
    MBProgressHUD *hude=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hude.labelText = @"";
    //driver_id,client_id,city_id,tour_date,number_of_hours,start_time,end_time,meetup_location,meetup_time,comment
    
    NSMutableDictionary *params=[[NSMutableDictionary alloc]initWithObjectsAndKeys:@"register_tour",@"command",_selectedDriverId,@"driver_id",_userId,@"client_id",_selectedCityId,@"city_id",tourDate,@"tour_date",numberOfHours,@"number_hours",startTime,@"start_time",meetupAddress,@"meetup_address",delg.currentCoordinats,@"meetup_location",meetupTime,@"meetup_time",comments,@"comment",total_payment,@"total_payment",nil];
    
    NSLog(@"params %@",params);
    
    [[NetworkHelper sharedInstance] commandWithParams:params onCompletion:^(NSDictionary *json) {
        
        if (![json objectForKey:@"error"]&&json!=nil)
        {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            NSDictionary *res=[json objectForKey:@"result"];
            NSString *msg =[res objectForKey:@"successful"];
            self.successMsg = [NSString stringWithFormat:@"%@",msg];
            delg.isRigesterTour = NO;
            
            str_CusId = [res objectForKey:@"customerid"];
            str_TourId = [res objectForKey:@"tour_id"];
            [self postStripeToken:str_CusId whitAmount:self.str_TotalPayment sourceid:str_TourId statustype:@"tourAccept"];
        }
        else{
            ////NSLog(@"Error : %@",[json objectForKey:@"error"]);
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            NSString *errorMsg =[json objectForKey:@"error"];
            if ([ErrorFunctions isError:errorMsg])
            {
                //[self submitTourFrom];
                [self action_Register];
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

#pragma mark
#pragma mark - Stripe
#pragma mark
- (void)postStripeToken:(NSString* )token whitAmount :(NSString *) amount sourceid:(NSString *)sourceId statustype:(NSString *)type {
    //1
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSString *finalAmount =[NSString stringWithFormat:@"%.0f",[amount floatValue]*100];
    
    NSURL *postURL = [NSURL URLWithString:STRIPE_TEST_POST_URL];
    AFHTTPClient* httpClient = [AFHTTPClient clientWithBaseURL:postURL];
    httpClient.parameterEncoding = AFJSONParameterEncoding;
    [httpClient registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [httpClient setDefaultHeader:@"Content-Type" value:@"application/json"];
    
    //4
    NSMutableString *stripUrl =[[NSMutableString alloc] init];
    
    [stripUrl appendString:KStripUrl];
    
    [stripUrl appendString:[NSString stringWithFormat:@"stripeCustomer=%@&stripeAmount=%@&sourceId=%@&type=%@",token,finalAmount,sourceId,type]];
    NSLog(@"stripUrl %@",stripUrl);
    NSMutableURLRequest* request = [httpClient requestWithMethod:@"GET" path:stripUrl parameters:nil];
    
    self.httpOperation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON)
                          {
                              [self chargeDidSucceed];
                              
                          }
                                                                         failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON)
                          {
                              [MBProgressHUD hideHUDForView:self.view animated:YES];
                              NSLog(@"%@",JSON);
                              NSLog(@"error %@",error);
                             // [self postStripeToken:str_CusId whitAmount:str_TotalPayment sourceid:str_TourId statustype:@"tourAccept"];
                          }];
    
    [self.httpOperation start];
}

- (void)chargeDidSucceed {
    //rejo18042016
    
   // MBProgressHUD *hud =[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //hud.labelText = @"wait";
    NSString *str_transactionType = @"5"; //guide_reservation
    NSMutableDictionary *params=[[NSMutableDictionary alloc]initWithObjectsAndKeys:@"payment_transaction",@"command",str_transactionType,@"transaction_type",self.str_amount,@"amount_paid",self.userId,@"client_id", nil];
    
    [[NetworkHelper sharedInstance] commandWithParams:params onCompletion:^(NSDictionary *json) {
        //NSLog(@"the json return is %@",json);
        if (![json objectForKey:@"error"]&& json!=nil)
        {
            NSDictionary *res=[json objectForKey:@"result"];
            NSString *status=[NSString stringWithFormat:@"%@",[res objectForKey:@"successful"]];
            if ([status isEqualToString:@"1"])
            {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [self showCustomUIAlertViewWithtitles:@"Done" andWithMessage:self.successMsg];
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


#pragma mark Web Services
-(void)submitTourFrom
{
    [self action_Register];
}

-(void)showCustomAlertViewWithMessage :(NSString *) message
{
    alertView = [[CustomIOSAlertView alloc] init];
    alertView.tag = 1;
    // Add some custom content to the alert view
    [alertView setContainerView:[self showMapView]];
    
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
    
}
-(UIView *)showMapView
{
    mapView =  [[[NSBundle mainBundle] loadNibNamed:@"MapView" owner:self options:nil] objectAtIndex:0];
    [mapView addSubview:[self titelLabe]];
    mView = mapView;
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:delg.locationManager.location.coordinate.latitude
                                                            longitude:delg.locationManager.location.coordinate.longitude
                                                                 zoom:11];
    mView = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    mView = [GMSMapView mapWithFrame:CGRectMake(0,30, mapView.frame.size.width,mapView.frame.size.height-30) camera:camera];
    mView.delegate = self;
    mView.myLocationEnabled = YES;
    return mView;
    
}
-(UILabel *)titelLabe
{
    UILabel *lbl1 = [[UILabel alloc] init];
    lbl1.textColor = [UIColor blackColor];
    CGRect frame = CGRectMake(0, 0,250,30);
    [lbl1 setFrame:frame];
    lbl1.backgroundColor=[UIColor clearColor];
    lbl1.textColor=[UIColor darkGrayColor];
    lbl1.textAlignment = NSTextAlignmentCenter;
    lbl1.userInteractionEnabled=NO;
    lbl1.text= @"Tab and hold to Select";
    return lbl1;
}
#pragma mark GoogleMapDelegate

- (void)mapView:(GMSMapView *)mapView didLongPressAtCoordinate:(CLLocationCoordinate2D)coordinate
{
    [mView clear];
    delg.currentCoordinats =[NSString stringWithFormat:@"%f,%f",coordinate.latitude,coordinate.longitude];
    [SVGeocoder reverseGeocode:coordinate
                    completion:^(NSArray *placemarks, NSHTTPURLResponse *urlResponse, NSError *error) {
                        SVPlacemark *placemarkN=[[SVPlacemark alloc] init];
                        NSLog(@"%@",[placemarks objectAtIndex:0]);
                        
                        if (placemarks.count !=0)
                        {
                            placemarkN =[placemarks objectAtIndex:0];
                            
                            // ////NSLog(@"placemark %@",placemarks);
                            locatedaddress = [NSString stringWithFormat:@"%@,%@,%@",placemarkN.thoroughfare,placemarkN.subLocality,placemarkN.locality];
                            GMSMarker *marker= [[GMSMarker alloc] init];
                            marker=[GMSMarker markerWithPosition:coordinate];
                            marker.position = coordinate;
                            // CLLocationCoordinate2DMake([latitude doubleValue], [longitude doubleValue]);
                            marker.title =@"Meetup Location";
                            marker.snippet = locatedaddress;
                            marker.appearAnimation = YES;
                            marker.map = mView;
                            mView.selectedMarker = marker;
                            
                            [self.meetUpLocationTF setText:locatedaddress];
                            
                        }
                    }];
    
    
}
-(void)useCrrentLocation
{
    [SVGeocoder reverseGeocode:CLLocationCoordinate2DMake(delg.locationManager.location.coordinate.latitude,delg.locationManager.location.coordinate.longitude)
                    completion:^(NSArray *placemarks, NSHTTPURLResponse *urlResponse, NSError *error) {
                        SVPlacemark *placemarkN=[[SVPlacemark alloc] init];
                        if (placemarks.count !=0)
                        {
                            placemarkN =[placemarks objectAtIndex:0];
                            // ////NSLog(@"placemark %@",placemarks);
                            locatedaddress = [NSString stringWithFormat:@"%@,%@,%@",placemarkN.thoroughfare,placemarkN.subLocality,placemarkN.locality];
                            [self.meetUpLocationTF setText:locatedaddress];
                        }
                    }];
}

#pragma mark Create Custom View

#pragma mark CustomAletrView Delegate
- (void)customIOS7dialogButtonTouchUpInside: (CustomIOSAlertView *)alert clickedButtonAtIndex: (NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        [alert close];
    }
    else //DropOff
    {
        [alert close];
    }
}

-(void)getCoordinatesFromAddressString :(NSString *)addrssString
{
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
    [self.forwardGeocoder forwardGeocodeWithQuery:addrssString regionBiasing:nil viewportBiasing:bounds success:^(NSArray *results) {
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
    [self.forwardGeocoder forwardGeocodeWithQuery:addrssString regionBiasing:nil viewportBiasing:nil];
#endif
    
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
    //[self.searchBar resignFirstResponder];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    if ([results count] > 0) {
        place = [results objectAtIndex:0];
        
        // Zoom into the location
        delg.currentCoordinats =[NSString stringWithFormat:@"%f,%f",place.coordinate.latitude,place.coordinate.longitude] ;
        //[self submitTourFrom];
        [self action_Register];
        
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
    [alertViewController addAction:[NYAlertAction actionWithTitle:NSLocalizedString(@"Register", self)style:UIAlertActionStyleDefault handler:^(NYAlertAction *action)
                                    {
                                        [self dismissViewControllerAnimated:YES completion:^
                                         {
                                             [self SubmitSuccess];
                                         }];
                                    }]];
    [self presentViewController:alertViewController animated:YES completion:nil];
}

- (void)showCustomUIAlertViewWithtitles :(NSString *)titel andWithMessage:(NSString *)message {
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
                                        [self dismissViewControllerAnimated:YES completion:^
                                         {
                                             if ([message isEqualToString:self.successMsg])
                                             {
                                                 [self.navigationController popToRootViewControllerAnimated:NO];
                                             }
                                             
                                             
                                         }];
                                        
                                    }]];
    
    
    [self presentViewController:alertViewController animated:YES completion:nil];
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
                                        [self dismissViewControllerAnimated:YES completion:^
                                         {
                                             if ([message isEqualToString:self.successMsg])
                                             {
                                                 [self.navigationController popToRootViewControllerAnimated:NO];
                                             }
                                         }];
                                    }]];
    [self presentViewController:alertViewController animated:YES completion:nil];
}

- (void)dealloc {
    [_myLocationBtn release];
    [_fromMapBtn release];
    [super dealloc];
}
@end
