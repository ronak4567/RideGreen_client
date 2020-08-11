//
//  AddRoomForRent.m
//  ridegreen
//
//  Created by Ridegreen on 28/10/2015.
//  Copyright (c) 2015 Ridegreen. All rights reserved.
//

#import "AddRoomForRent.h"

@interface AddRoomForRent ()
{
  NSMutableArray *_imgTitel;
}

@end

@implementation AddRoomForRent

- (void)viewDidLoad 
{
        [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];

    [self setupUITextFileds];
    [self pictureViewSetup];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    delg =(AppDelegate *)[UIApplication sharedApplication].delegate;
    userdefault =[NSUserDefaults standardUserDefaults];
    self.userId =[userdefault objectForKey:@"user_id"];// or 
    paymentOptions =[[NSMutableArray alloc] initWithObjects:@"Paypal",@"Cheque",@"Quick Pay", nil];
    roomTypes      =[[NSMutableArray alloc] initWithObjects:@"House",@"Apartment",@"Hotel", nil];
    stateIds       =[NSMutableArray new];
    stateNames     =[NSMutableArray new];
    cityIds        =[NSMutableArray new];
    cityNames      =[NSMutableArray new];
    _imgTitel       =[NSMutableArray new];
    totalUpLoadedImages = 1;
    [self fetchAllStates];
    


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




-(void)setupUITextFileds
{
    NSArray *fields = [self.formView.subviews arrayByAddingObjectsFromArray:self.pictureView.subviews];  //get all subviews from your scrollview
    UIToolbar *toolbar = [[UIToolbar alloc] init];
    [toolbar setBarStyle:UIBarStyleBlackTranslucent];
    [toolbar sizeToFit];
    UIBarButtonItem *buttonflexible = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *buttonDone = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneClicked:)];
    
    [toolbar setItems:[NSArray arrayWithObjects:buttonflexible,buttonDone, nil]];
    for (int i=0; i<[fields count]; i++)
    {
        if([[fields objectAtIndex:i] isKindOfClass:[UITextField class]]) //check for UITextField
        {
            UITextField *textField = (UITextField *)[fields objectAtIndex:i];
            UIView* dummyView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,5,45)];
            textField.leftView = dummyView;
            textField.leftViewMode = UITextFieldViewModeAlways;
            [textField setValue:[UIColor lightGrayColor]
                     forKeyPath:@"_placeholderLabel.textColor"];
            textField.delegate = self;
           
            textField .inputAccessoryView = dummyView;
            textField.inputAccessoryView = toolbar;
            
            
            
        }
        if([[fields objectAtIndex:i] isKindOfClass:[UIImageView class]])
        {
            UIImageView *imgView = (UIImageView *)[fields objectAtIndex:i];
            imgView.layer.borderColor = White_ColorCG;
            imgView.layer.borderWidth = 2.0f;
            imgView.layer.cornerRadius = 12.0f;
            imgView.layer.masksToBounds = YES;
        }
    }
    
    
    

    
}
-(void)pictureViewSetup
{
    [self.nextBtn setHidden:YES];
    [self.formBackbtn setHidden:YES];
    [self.pictureView setHidden:NO];
    [self.formView setHidden:YES];
    
    [self.submitBtn setTitle:@"Next" forState:UIControlStateNormal];
}
-(void)doneClicked:(UIBarButtonItem*)button
{
    if (isViewUp) 
    {
        [self animatetexfieldup:NO withView:self.pictureView];
        isViewUp = NO;
    }
    [self.view endEditing:YES];
    
    
}
-(void)showFormView
{
    [self.pictureView setHidden:YES];
    [self.formView setHidden:NO];
    [self.viewBackBtn setHidden:YES];
    [self.formBackbtn setHidden:NO];
    [self.nextBtn setHidden:YES];
    [self.submitBtn setTitle:@"Add Room" forState:UIControlStateNormal];
   
    CATransition *transition = [CATransition animation];
    transition.duration = 0.5;
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromRight;
    [transition setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [self.view.layer addAnimation:transition forKey:nil];
    
    [self.view addSubview:self.formView];
    
    [self.submitBtn bringSubviewToFront:self.formView];
    
}
-(void)hideFormView
{
    [self.pictureView setHidden:NO];
    [self.formView setHidden:YES];
    
    [self.viewBackBtn setHidden:NO];
    [self.formBackbtn setHidden:YES];
    [self.nextBtn setHidden:NO];
    [self.submitBtn setTitle:@"Next" forState:UIControlStateNormal];
    CATransition *transition = [CATransition animation];
    transition.duration = 0.5;
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromLeft;
    [transition setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [self.view.layer addAnimation:transition forKey:nil];
    
    [self.view addSubview:self.pictureView];
   
}
#pragma mrak UITextField Delegate Methods
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if(isDes)
    {
        NSInteger length = [textField.text length];
        if (length>599&& ![string isEqualToString:@""]) {
            return NO;
        }
    }
    
    if (isphone)
    {
        NSUInteger newLength = [textField.text length] + [string length] - range.length;
        
        if([string hasPrefix:@"+1"])
        {
            return (newLength > 10) ? NO : YES;
        }else 
        {
            return (newLength > 10) ? NO : YES;
        }
    }
    if (isPrice) 
    {
        NSUInteger newLength = [textField.text length] + [string length] - range.length;
        return (newLength > 5) ? NO : YES; 
    }

   
    return YES;
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField == _stateTF )
    {
        [self.view endEditing:YES];
        
        if(!isState)
        {
            Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
            NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
            if (networkStatus == NotReachable)
            {
                [self showCustomUIAlertViewWithtilet:@"Info" andWithMessage:@"Please check with your internet connection"];
            } else
            {
                isState = YES;
                [self showslectionView];
            }
            
        }
       
        return NO;
    }
    
    else if (textField == _cityTF && [_stateTF.text length] != 0) 
    {
        [self.view endEditing:YES];
        
        if (!isCity)
        {
            isCity = YES;
            
            [self showslectionView];
        }
        
        return NO;
    }
    else if (textField == _cityTF && [_stateTF.text length] == 0) 
    {
        [self.view endEditing:YES];       
        [self showCustomUIAlertViewWithtilet:@"Info" andWithMessage:@"Please select state first"];
        return NO;
    } 
    if (textField == _roomsTF )
    {
        [self.view endEditing:YES];
        if (!isRooms)
        {
            isRooms = YES;
            [self showslectionView];
        }
        return NO;
    }
    else if (textField == _bedsTF)
    {
        [self.view endEditing:YES];
        
        if (!isBeds)
        {
            isBeds = YES;
            [self showslectionView];
        }
        return NO;
        
    }
    else if (textField == _paymentOptionTF) 
    {
        [self.view endEditing:YES];
        
        if (!isPayMentOptions)
        {
            isPayMentOptions = YES;
            [self showslectionView];
        }
        return NO;
    }
    if (textField == _roomAddressTF) 
    {
        [self.view endEditing:YES];
        
        if (!isRoomAddress)
        {
            isRoomAddress = YES;
            [self showTextviewWithPlcaholder:@"Enter Room Address" text:_roomAddressTF.text];
        }
       
        return NO;
        
    }
    if (textField == _clientAddressTF) 
    {
        [self.view endEditing:YES];
        if (!isClientAddress )
        {
            isClientAddress = YES;
            
            if (_selectedOptions.length != 0) 
            {
                if ([_selectedOptions isEqualToString:@"Paypal"]) 
                {
                    [self showTextviewWithPlcaholder:@"Enter Paypal Id" text:_clientAddressTF.text];
                    isQuickPay = NO;

                }
                else  if ([_selectedOptions isEqualToString:@"Cheque"])
                {
                    [self showTextviewWithPlcaholder:@"Address to Receive Paycheck" text:_clientAddressTF.text];
                    isQuickPay = NO;
                }
                else  if ([_selectedOptions isEqualToString:@"Quick Pay"])
                {
                    [self showTextviewWithPlcaholder:@"Enter your Email Id" text:_clientAddressTF.text];
                    isQuickPay = YES;
                }
                
            }else 
            {
             [self showHudWithText:@"Please select payment option first"]; 
            }
        }
        else 
        {
           
        }
    return NO;
    }
    
    if (textField == _priceTF) 
    {
        [self.view endEditing:YES];
        if (!isPrice)
        {
            isPrice = YES;
            [self showTextviewWithPlcaholder:@"Enter Price per night" text:_priceTF.text];
        }
    return NO;
    }
    if (textField == _nameTF) 
    {
        if (!isname)
        {
            isname = YES;
            [self showTextviewWithPlcaholder:@"Enter owner's name" text:_priceTF.text];
        }
        return NO;
    }
    if (textField == _phoneTF) 
    {
        if (!isphone)
        {
            isphone = YES;
            [self showTextviewWithPlcaholder:@"Enter Contact phone no" text:_priceTF.text];
        }
        return NO;
    }
    if (textField == _txt_SecurityDeposit)
    {
        if (!isSecurityDeposit)
        {
            isSecurityDeposit = YES;
            [self showTextviewWithPlcaholder:@"Enter Security Deposit Amount" text:_priceTF.text];
        }
        return NO;
    }
    
    
    if (textField == _txt_Description)
    {
        if (!isDes )
        {
            isDes = YES;
            [self showTextviewWithPlcaholder:@"Description" text:_txt_Description.text];
        }
        return NO;
    }
   if (textField == _roomTypeTF )
    {
        [self.view endEditing:YES];
        if (!isRoomType)
        {
            isRoomType = YES;
            [self showslectionView];
        }
         return NO;
        
    }
//    if (textField == _nameTF || textField == _phoneTF ) 
//    {
//        if (!isViewUp) 
//        {
//         [self animatetexfieldup:YES withView:self.pictureView];
//            isViewUp = YES;
//        }
//        
//        
//         return YES;
//    }
    
    
    return YES;
}


-(void)textEditing:(id)sender
{
    
    if (isQuickPay) {
        
    
    if (_clientAddressTF.text.length > 0)
    {
        if ([self validEmailAddress:_clientAddressTF.text])
        {
        }
        else
        {
            [self showCustomUIAlertViewWithtilet:@"Warning" andWithMessage:@"Please enter valid email address" ];
        }
    }
    }
}


-(BOOL)validEmailAddress:(NSString*)emailStr{
    NSString *emailRegex =
    @"(?:[a-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[a-z0-9!#$%\\&'*+/=?\\^_`{|}"
    @"~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\"
    @"x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-"
    @"z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5"
    @"]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-"
    @"9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21"
    @"-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES[c] %@", emailRegex];
    
    if(![emailTest evaluateWithObject:emailStr])
    {
        return false;
    }
    else
    return TRUE;
}


- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
    
    
    
    
}

-(void)hidekeybord
{
    [self.view endEditing:YES];
    if([_phoneTF becomeFirstResponder])
    {
        [_phoneTF resignFirstResponder];
    }
    
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    
//    if (isViewUp && textField == _phoneTF) 
//    {
//        [self animatetexfieldup:NO withView:self.pictureView];
//        isViewUp = NO;
//    }

    
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
   if (isname) 
    {
        _nameTF.text = _alertextField.text;
        isname = NO;
    }
    else if (isphone) 
    {
        _phoneTF.text = _alertextField.text;
        isphone = NO;
    }
    else if (isClientAddress) 
    {
        _clientAddressTF.text = _alertextField.text;
        isClientAddress = NO;
    }
    else if (isDes)
    {
        _txt_Description.text = _descrip.text;
        isDes = NO;
    }
    else if (isSecurityDeposit)
    {
        _txt_SecurityDeposit.text = _alertextField.text;
        isSecurityDeposit = NO;
    }
    
    [self.alertextField resignFirstResponder];
    [alertView close];    
    [self.view endEditing:YES];
       
    return YES;
}
- (void) animatetexfieldup: (BOOL) up withView:(UIView *) view
{
    
    const int movementDistance = 200; // tweak as needed
    const float movementDuration = 0.3f; // tweak as needed
   
    int movement = (up ? -movementDistance : movementDistance);
    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    view.frame = CGRectOffset(view.frame, 0, movement);
    [UIView commitAnimations];
}


#pragma mark Button IBActions
- (IBAction)currentLocationBtnPressed:(id)sender 
{
    [self useCrrentLocation];
}

- (IBAction)selectFromMapBtnPressed:(id)sender 
{
    
    [self.roomAddressTF resignFirstResponder];
    [self showCustomAlertViewWithMessage:@"Tab and hold to Select Location"];
    
}

- (IBAction)backBtnPressed:(id)sender 
{
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)submitBtnPressed:(id)sender 
{
    
    if ([self.submitBtn.currentTitle isEqualToString:@"Next"]) 
    {
        if ([self toNextViewRequirment]) 
        {
            if ([self numberOfRequiredImages]) 
            {
                [self showFormView];
            }
            else
            {
            [self showCustomUIAlertViewWithtilet:@"Info" andWithMessage:@"Two images required"];
            }
            
        } else 
        {
        [self showCustomUIAlertViewWithtilet:@"Info" andWithMessage:@"Some fields are empty "];
        }  
    }
    else
    {
        if ([self submitRequirment]) 
        {
            [self checkImageViewWithTag];  
        }else 
        {
         [self showCustomUIAlertViewWithtilet:@"Info" andWithMessage:@"Some fields are empty "];
        }
    
    }

}
-(BOOL)toNextViewRequirment
{
    if ([_roomTypeTF.text length] != 0 && [_nameTF.text length] != 0 && [_phoneTF.text length] != 0  && [_txt_Description.text length] != 0 && [_txt_SecurityDeposit.text length] != 0)
    {
        return YES;       
    }else 
    {
        return NO;
    }
    
    
}
-(BOOL)submitRequirment
{
    if ([self.nameTF.text length] != 0 && [self.phoneTF.text length] !=0 && [self.roomAddressTF.text length] !=0 && [self.stateTF.text length] !=0 && [self.cityTF.text length] !=0 && [self.roomsTF.text length] !=0 && [self.bedsTF.text length] !=0 && [self.roomAddressTF.text length] !=0 && [self.paymentOptionTF.text length] !=0 && [self.priceTF.text length] !=0 &&[self.clientAddressTF.text length] !=0 && [self.txt_Description.text length] !=0  && [self.txt_SecurityDeposit.text length] !=0 )
    {
        return YES;
    }
    else
    {
        return NO;
    }
     
}

-(BOOL )numberOfRequiredImages
{
    NSInteger numberOfImages = 0;
    for (int i = 1; i < 4; i++)
    {
        UIImageView *imgView = (UIImageView *) [self.pictureView viewWithTag:i];
        
        if (imgView.image != nil)
        {
            numberOfImages++;
        }
    }
    
    if (numberOfImages >= 2) 
    {
        return YES;
    }else 
    {
        return  NO;
    }
   
    
}
- (IBAction)fromBackBtnPressed:(id)sender 
{
    [self hideFormView];
}

- (IBAction)nextBtnPressed:(id)sender 
{
    [self showFormView];
}

#pragma mark Web Services

-(void)addRoom 
{
    if (isQuickPay)
    {
        if (_clientAddressTF.text.length > 0)
        {
            if ([self validEmailAddress:_clientAddressTF.text])
            {
            }
            else
            {
                [self showCustomUIAlertViewWithtilet:@"Warning" andWithMessage:@"Please enter valid email address" ];
            }
        }
    }
        

    [self.view endEditing:YES];
    NSString *name          = _nameTF.text;
    NSString *phone         = _phoneTF.text;
    NSString *roomAddress   = _roomAddressTF.text;
    NSString *clientAddress ;
    NSString *rentalPrice   = _priceTF.text;
    NSString *numberOfRooms = _selectedRooms;
    NSString *numberOfBeds  = _selectedBeds; 
    NSString *paymentOption = _paymentOptionTF.text;
    NSString *stateId       = _selectedStateId;
    NSString *cityId        =  _selectedCityId;
    NSString *roomtype      =_roomTypeTF.text;
    NSString *des = _txt_Description.text;
    NSString *str_SecurityDeposit = _txt_SecurityDeposit.text;

    if (!_clientAddressTF.hidden)
    {
       clientAddress = _clientAddressTF.text;
    }else
    {
        clientAddress = @"";
    }
    
    NSString *imageName  =[_imgTitel componentsJoinedByString:@","];
    /*
    command=add_room_for_rent&name=zeeshan&state_id=1&city_id=2&no_of_rooms=2&no_of_beds=4&room_address=E-11/4%20Islamabad&client_address=E-11/4%20Islamabad&phone=+13347671894&rate_per_month=11.00&payment_option=paypall&user_id=11//$imag_name     
     */
    
    MBProgressHUD *hue=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hue.labelText=@"Adding...";
    NSMutableDictionary *params=[[NSMutableDictionary alloc]initWithObjectsAndKeys:@"add_room_for_rent",@"command",name,@"name",phone,@"phone",stateId,@"state_id",cityId,@"city_id",numberOfRooms,@"no_of_rooms",numberOfBeds,@"no_of_beds",imageName,@"imag_name",roomAddress,@"room_address",clientAddress,@"client_address",rentalPrice,@"rate_per_month",paymentOption,@"payment_option",self.userId,@"user_id",roomtype,@"room_type",des,@"description",str_SecurityDeposit,@"security_deposit", nil];
    
    [[NetworkHelper sharedInstance] commandWithParams:params onCompletion:^(NSDictionary *json) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        //NSLog(@"the json return is %@",json);
        if (![json objectForKey:@"error"]&& json!=nil)
        {
            totalUpLoadedImages = 1;
            _imgTitel = nil;
            [self showCustomUIAlertViewWithtilet:@"Successful" andWithMessage:@"Room would be reviewed by Ridegreen for acceptance."];
         [MBProgressHUD hideHUDForView:self.view animated:YES];
        }else
        {
            NSString *errorMsg =[json objectForKey:@"error"];
            if ([ErrorFunctions isError:errorMsg])
            {
                [self addRoom];
            }else
            {
              [self showCustomUIAlertViewWithtilet:@"Warning" andWithMessage:[json objectForKey:@"error"]  ];  
                
            }
            totalUpLoadedImages = 1;
            ////NSLog(@"Error :%@",[json objectForKey:@"error"]);
        }
    }];
   // }
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
    mView = mapView;
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:delg.locationManager.location.coordinate.latitude
                                                            longitude:delg.locationManager.location.coordinate.longitude
                                                                 zoom:11];
    mView = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    mView = [GMSMapView mapWithFrame:CGRectMake(0,0, mapView.frame.size.width,mapView.frame.size.height) camera:camera];
    mView.delegate = self;
    mView.myLocationEnabled = YES;
    
   
    return mView;
    
}

#pragma mark GoogleMapDelegate

- (void)mapView:(GMSMapView *)mapView didLongPressAtCoordinate:(CLLocationCoordinate2D)coordinate
{
    
    currentCoordinats =[NSString stringWithFormat:@"%f,%f",coordinate.latitude,coordinate.longitude];
    
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
                            marker.title =@"Parking Location";
                            marker.snippet = locatedaddress;
                            marker.appearAnimation = YES;
                            marker.map = mView;
                            mView.selectedMarker = marker;
                            
                            [self.clientAddressTF setText:locatedaddress];
                            
                            
                            
                            
                        }
                        
                        
                        
                    }];
    
    
}
-(void)useCrrentLocation
{
    currentCoordinats = [NSString stringWithFormat:@"%f,%f",delg.locationManager.location.coordinate.latitude,delg.locationManager.location.coordinate.longitude];
    [SVGeocoder reverseGeocode:CLLocationCoordinate2DMake(delg.locationManager.location.coordinate.latitude,delg.locationManager.location.coordinate.longitude)
                    completion:^(NSArray *placemarks, NSHTTPURLResponse *urlResponse, NSError *error) {
                        SVPlacemark *placemarkN=[[SVPlacemark alloc] init];
                        // ////NSLog(@"%@",[placemarks objectAtIndex:0]);
                        
                        if (placemarks.count !=0)
                        {
                            placemarkN =[placemarks objectAtIndex:0];
                            
                            // ////NSLog(@"placemark %@",placemarks);
                            locatedaddress = [NSString stringWithFormat:@"%@,%@,%@",placemarkN.thoroughfare,placemarkN.subLocality,placemarkN.locality];
                            
                            [self.clientAddressTF setText:locatedaddress];
                            
                            
                            
                            
                        }
                        
                        
                        
                    }];
    
}
#pragma mark UITextViewDelegate

-(void)textViewDidBeginEditing:(UITextView *)textView
{
       
    
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
    [self.forwardGeocoder forwardGeocodeWithQuery:self.searchBar.text regionBiasing:nil viewportBiasing:nil];
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
    if ([results count] == 1) {
        place = [results objectAtIndex:0];
        
        // Zoom into the location
        currentCoordinats =[NSString stringWithFormat:@"%f,%f",place.coordinate.latitude,place.coordinate.longitude] ;
        [self addRoom];
        
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
#pragma mark Web Services
-(void)fetchAllStates
{
    
    
    
    NSMutableDictionary *params=[[NSMutableDictionary alloc]initWithObjectsAndKeys:@"get_states",@"command", nil];
    
    [[NetworkHelper sharedInstance] commandWithParams:params onCompletion:^(NSDictionary *json) {
        
        NSLog(@"the json return is %@",json);
        
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        
        
        if (![json objectForKey:@"error"]) 
        {
            NSArray *results=[json objectForKey:@"result"];
            //NSLog(@"result %@",results);
            for (int i=0; i<results.count; i++) 
            {
                NSDictionary *res =[results objectAtIndex:i];
                
                // adding user adis in array
                [stateNames addObject:[[res objectForKey:@"name"] capitalizedString]];
                [stateIds addObject:[res objectForKey:@"id"]];
            }
        }
        
        else
        {
            // if reques error call again
            NSString *errorMsg =[json objectForKey:@"error"];
            if ([ErrorFunctions isError:errorMsg])
            {
                [self fetchAllStates];
            }else
            {
               NSLog(@"Error is %@",[json objectForKey:@"error"]);
                
            }
    }
}];
    
}
-(void)fetchAllCitiesFromStateId :(NSString *)stateId
{
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    
    NSMutableDictionary *params=[[NSMutableDictionary alloc]initWithObjectsAndKeys:@"get_state_cities",@"command",stateId,@"state_id", nil];
    
    [[NetworkHelper sharedInstance] commandWithParams:params onCompletion:^(NSDictionary *json) {
        NSLog(@"the json return is %@",json);
        [cityNames removeAllObjects];
        [cityIds removeAllObjects];
        if (![json objectForKey:@"error"] && json != nil)
        {
                       
            NSArray *results=[json objectForKey:@"result"];
            //NSLog(@"result %@",results);
            for (int i=0; i<results.count; i++) {
                NSDictionary *res =[results objectAtIndex:i];
                
                // adding user adis in array
                [cityNames addObject:[[res objectForKey:@"name"] capitalizedString]];
                [cityIds addObject:[res objectForKey:@"id"]];
            }
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }
        else
        {
            // if reques error call again
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            NSString *errorMsg =[json objectForKey:@"error"];
            
            if ([ErrorFunctions isError:errorMsg])
            {
                [self fetchAllCitiesFromStateId:stateId];
            }
            else
            {
                NSLog(@"Error is %@",[json objectForKey:@"error"]);
            }
        }
    }];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    // Return the number of sections.
    // on select cities
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    // Return the number of rows in the section.
    if (isState) 
    {
        return [stateIds count];
    }
    // on blood groub selection
    else if (isCity)
    {
        return [cityIds count];
        
    }
    else if (isRooms || isBeds)
    {
        return 50;
        
    }
    else if (isPayMentOptions)
    {
        return [paymentOptions count];
        
    }
    else if (isRoomType)
    {
        return [roomTypes count];
        
    }
    return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *sectionName;
    // for cities
    if (isState)
    {
        sectionName = @"Select State";
        
    }else if (isCity)
    {
        // for blood groups
        sectionName = @"Select City";
    }
    else if (isRooms)
    {
        // for blood groups
        sectionName = @"Select Number or Rooms";
    }
    else if (isBeds)
    {
        // for blood groups
        sectionName = @"Select Number of beds";
    }
    else if (isPayMentOptions)
    {
        // for blood groups
        sectionName = @"Select PayMent Option";
    }
    else if (isRoomType)
    {
        // for blood groups
        sectionName = @"Select Room Type";
    }
    return sectionName;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString* cellIdentifier = @"cell";
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    }
    // for cities
    if (isState)
    {
        cell.textLabel.text= [stateNames objectAtIndex:indexPath.row];
        if ([cell.textLabel.text isEqualToString:_selectedStateName]) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            
        }else
        {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        
    }else if (isCity)
    {
        // for blood groups
        cell.textLabel.text= [cityNames objectAtIndex:indexPath.row];
        if ([cell.textLabel.text isEqualToString:_selectedCityName]) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            
        }else
        {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
    else if (isRooms)
    {
        // for blood groups
        cell.textLabel.text= [NSString stringWithFormat:@"%zd",indexPath.row+1];
        if ([cell.textLabel.text isEqualToString:_selectedRooms]) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            
        }else
        {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
    else if (isBeds)
    {
        // for blood groups
        cell.textLabel.text= [NSString stringWithFormat:@"%zd",indexPath.row+1];
        if ([cell.textLabel.text isEqualToString:_selectedBeds]) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            
        }else
        {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
    else if (isPayMentOptions)
    {
        // for blood groups
        cell.textLabel.text= [paymentOptions objectAtIndex:indexPath.row];
        if ([cell.textLabel.text isEqualToString:_selectedOptions]) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            
        }else
        {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
    else if (isRoomType)
    {
        // for blood groups
        cell.textLabel.text= [roomTypes objectAtIndex:indexPath.row];
        if ([cell.textLabel.text isEqualToString:_selectedRoomtype]) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            
        }else
        {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
    return cell;
}




-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSString *tfText;
    if (isState)
    {
        //zia
        _selectedStateId  =[stateIds objectAtIndex:indexPath.row];
        _selectedStateName =[stateNames objectAtIndex:indexPath.row];
        [self.stateTF setText:_selectedStateName];
        [self.cityTF setText:@""];
        [self fetchAllCitiesFromStateId:_selectedStateId];
        [self.stateTF resignFirstResponder];
        isState = NO;
    }else if (isCity)
    {
        _selectedCityId  =[cityIds objectAtIndex:indexPath.row];
        _selectedCityName =[cityNames objectAtIndex:indexPath.row];
        [self.cityTF setText:_selectedCityName]; 
        [self.cityTF resignFirstResponder];
        
        isCity = NO;
    }
    else if (isRooms)
    {
        _selectedRooms = cell.textLabel.text;
        
        if ([_selectedRooms intValue] == 1) 
        {
            tfText = [NSString stringWithFormat:@"%@ Room",_selectedRooms];
        }else 
        {
          tfText = [NSString stringWithFormat:@"%@ Rooms",_selectedRooms];
        }
         
        [self.roomsTF setText:tfText]; 
        [self.roomsTF resignFirstResponder];
        isRooms = NO;
    }
    else if (isBeds)
    {
        _selectedBeds = cell.textLabel.text;
        if ([_selectedBeds intValue] == 1) 
        {
            tfText = [NSString stringWithFormat:@"%@ Bed",_selectedBeds];
        }else 
        {
            tfText = [NSString stringWithFormat:@"%@ Beds",_selectedBeds];
        }
        [self.bedsTF setText:tfText]; 
        [self.bedsTF resignFirstResponder];
        isBeds = NO;
    }
    else if (isPayMentOptions)
    {
        _selectedOptions = cell.textLabel.text;
        [self.paymentOptionTF setText:_selectedOptions]; 
        [self.paymentOptionTF resignFirstResponder];
        isPayMentOptions = NO;
        
        if ([_selectedOptions isEqualToString:@"Paypal"]) 
        {
            [self.clientAddressTF setPlaceholder:@"Paypal id"];
            isQuickPay = NO;
        }
        else if ([_selectedOptions isEqualToString:@"Cheque"])
        {
            [self.clientAddressTF setPlaceholder:@"Address to Receive Paycheck"];
            isQuickPay = NO;
        }
        else if ([_selectedOptions isEqualToString:@"Quick Pay"])
        {
            [self.clientAddressTF setPlaceholder:@"Email id"];
            isQuickPay = YES;//jose
        }
        
        else
        {
//            CGRect pOFrame = self.paymentOptionTF.frame;
//            pOFrame.size.width =70; 
//            self.paymentOptionTF.frame = pOFrame;  
//            
//            CGRect cAFrame = self.clientAddressTF.frame;
//            cAFrame.origin.x = pOFrame.origin.x + pOFrame.size.width+5;
//            cAFrame.size.width = 262 - pOFrame.size.width; 
//            self.clientAddressTF.frame = cAFrame;  
//            [self.clientAddressTF setHidden:NO];

        }
    }
    else if (isRoomType)
    {
        _selectedRoomtype = cell.textLabel.text;
        [self.roomTypeTF setText:_selectedRoomtype]; 
        [self.roomTypeTF resignFirstResponder];
    }

    [self hideAlertView:alertView];
}
- (IBAction)imageBtnPressed:(id)sender
{
    
    _imgBtntag =[sender tag];
    
    [self showActionSheet];
}

#pragma mark take pic
#pragma mark take pic
- (void)showActionSheet
{
    UIAlertController * view=   [UIAlertController
                                 alertControllerWithTitle:@"Add Photo"
                                 message:@""
                                 preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction* SelectFormGallery = [UIAlertAction
                                        actionWithTitle:@"Take Photo"
                                        
                                        style:UIAlertActionStyleDefault
                                        handler:^(UIAlertAction * action)
                                        {
                                            [self TakePic];
                                            [view dismissViewControllerAnimated:YES completion:nil];
                                            
                                        }];
    UIAlertAction* TakePhoto = [UIAlertAction
                                actionWithTitle:@"Choose Existing Photo"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action)
                                {
                                    [self selectPic];
                                    [view dismissViewControllerAnimated:YES completion:nil];
                                    
                                }];
    
    UIAlertAction* cancel = [UIAlertAction
                             actionWithTitle:@"Cancel"
                             style:UIAlertActionStyleCancel
                             handler:^(UIAlertAction * action)
                             {
                                 [view dismissViewControllerAnimated:YES completion:nil];
                                 
                             }];
    
    [view addAction:SelectFormGallery];
    [view addAction:TakePhoto];
    [view addAction:cancel];
    [self presentViewController:view animated:YES completion:nil];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex: (NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        [self selectPic];
    }
    else if (buttonIndex == 1)
    {
        [self TakePic];
    }
    
}
-(void)TakePic
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    [self presentViewController:picker animated:YES completion:NULL];
}
-(void)selectPic
{
    imagePickerController = [[UIImagePickerController alloc]init];
    imagePickerController.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    imagePickerController.sourceType=UIImagePickerControllerCameraCaptureModePhoto;
    imagePickerController.delegate = self;
    [self presentViewController:imagePickerController animated:YES completion:nil];
}

#pragma mark VPImageCropperDelegate

- (void)imageCropper:(VPImageCropperViewController *)cropperViewController didFinished:(UIImage *)editedImage {
    
    UIImageView *imageView = (UIImageView *)[self.pictureView viewWithTag:_imgBtntag];
    imageView.image = editedImage;
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
        // TO DO
    }];
}

- (void)imageCropperDidCancel:(VPImageCropperViewController *)cropperViewController {
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
    }];
}
#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:^() {
        UIImage *portraitImg = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        portraitImg = [self imageByScalingToMaxSize:portraitImg];
        // present the cropper view controller
        VPImageCropperViewController *imgCropperVC = [[VPImageCropperViewController alloc] initWithImage:portraitImg cropFrame:CGRectMake(0, 100.0f, self.view.frame.size.width, self.view.frame.size.width) limitScaleRatio:3.0];
        imgCropperVC.delegate = self;
        [self presentViewController:imgCropperVC animated:YES completion:^{
            // TO DO
        }];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:^(){
    }];
}

#pragma mark image scale utility
- (UIImage *)imageByScalingToMaxSize:(UIImage *)sourceImage {
    if (sourceImage.size.width < ORIGINAL_MAX_WIDTH) return sourceImage;
    CGFloat btWidth = 0.0f;
    CGFloat btHeight = 0.0f;
    if (sourceImage.size.width > sourceImage.size.height) {
        btHeight = ORIGINAL_MAX_WIDTH;
        btWidth = sourceImage.size.width * (ORIGINAL_MAX_WIDTH / sourceImage.size.height);
    } else {
        btWidth = ORIGINAL_MAX_WIDTH;
        btHeight = sourceImage.size.height * (ORIGINAL_MAX_WIDTH / sourceImage.size.width);
    }
    CGSize targetSize = CGSizeMake(btWidth, btHeight);
    return [self imageByScalingAndCroppingForSourceImage:sourceImage targetSize:targetSize];
}

- (UIImage *)imageByScalingAndCroppingForSourceImage:(UIImage *)sourceImage targetSize:(CGSize)targetSize {
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor)
            scaleFactor = widthFactor; // scale to fit height
        else
            scaleFactor = heightFactor; // scale to fit width
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else
            if (widthFactor < heightFactor)
            {
                thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
            }
    }
    UIGraphicsBeginImageContext(targetSize); // this will crop
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil) //NSLog(@"could not scale image");
        
        //pop the context to get back to the default
        UIGraphicsEndImageContext();
    return newImage;
}

#pragma mark - UINavigationControllerDelegate


- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
}

#pragma mark camera utility
- (BOOL) isCameraAvailable{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}

- (BOOL) isRearCameraAvailable{
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
}

- (BOOL) isFrontCameraAvailable {
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront];
}

- (BOOL) doesCameraSupportTakingPhotos {
    return [self cameraSupportsMedia:(__bridge NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypeCamera];
}

- (BOOL) isPhotoLibraryAvailable{
    return [UIImagePickerController isSourceTypeAvailable:
            UIImagePickerControllerSourceTypePhotoLibrary];
}
- (BOOL) canUserPickVideosFromPhotoLibrary{
    return [self
            cameraSupportsMedia:(__bridge NSString *)kUTTypeMovie sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}
- (BOOL) canUserPickPhotosFromPhotoLibrary{
    return [self
            cameraSupportsMedia:(__bridge NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}

- (BOOL) cameraSupportsMedia:(NSString *)paramMediaType sourceType:(UIImagePickerControllerSourceType)paramSourceType{
    __block BOOL result = NO;
    if ([paramMediaType length] == 0) {
        return NO;
    }
    NSArray *availableMediaTypes = [UIImagePickerController availableMediaTypesForSourceType:paramSourceType];
    [availableMediaTypes enumerateObjectsUsingBlock: ^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *mediaType = (NSString *)obj;
        if ([mediaType isEqualToString:paramMediaType]){
            result = YES;
            *stop= YES;
        }
    }];
    return result;
}

-(void)checkImageViewWithTag
{
    
    
    UIImageView *imgView = (UIImageView *) [self.pictureView viewWithTag:totalUpLoadedImages];
    
    if (imgView.image != nil && totalUpLoadedImages <= 4)
    {
        [self uploadRoomImage:imgView.image]; 
        
        
    }else
    {
        if (totalUpLoadedImages < 4) 
        {
            totalUpLoadedImages++;
            [self checkImageViewWithTag];    
        }else 
        {
            [self addRoom];
        }

    }
        
     
    
   
    
}
-(void)uploadRoomImage:(UIImage *) image
{
    
    NSString *imgStr =[self randomStringWithLength:6];
    NSString *titel =[NSString stringWithFormat:@"%@.jpg",imgStr];
    [_imgTitel addObject:titel
     ];
    


    MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText=[NSString stringWithFormat:@"Uploding Image %d",totalUpLoadedImages];
    [[API sharedInstance] commandWithParams:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"upload_room_image", @"command", UIImageJPEGRepresentation(image,0.6), @"file",imgStr, @"title", nil] onCompletion:^(NSDictionary *json)
     {
         ////NSLog(@"result is %@",[json objectForKey:@"result"]);
         //completion
         if (![json objectForKey:@"error"]&&[json objectForKey:@"result"]!=nil)
         {
             [MBProgressHUD hideHUDForView:self.view animated:YES];
             totalUpLoadedImages++;
             [self checkImageViewWithTag];
             
             
         } else
         {
             [MBProgressHUD hideHUDForView:self.view animated:YES];
             NSString* errorMsg = [json objectForKey:@"error"];
             //////NSLog(@"error :%@",errorMsg);
             [self uploadRoomImage:image];
             
             
             if ([@"Authorization required" compare:errorMsg]==NSOrderedSame)
             {
             }
         }
     }];
}
#pragma mark CustomAlertView

-(void)showslectionView
{
    //[self hidekeybord];
    alertView = [[CustomIOSAlertView alloc] init];
    
    [alertView setContainerView:[self createSelectionListView]];
    
    // You may use a Block, rather than a delegate.
    [alertView setDelegate:self];
    [alertView setOnButtonTouchUpInside:^(CustomIOSAlertView *aView, int buttonIndex) {
        NSLog(@"Block: Button at position %d is clicked on alertView %d.", buttonIndex, (int)[aView tag]);
        [aView close];
    }];
    
    [alertView setUseMotionEffects:true];
    
    // And launch the dialog
    [alertView show];
    
}
-(UIView *)createSelectionListView
{
    UIView *relation = [[UIView alloc] initWithFrame:CGRectMake(0, 0,200,250)];
    
    self.selectionTable = [[UITableView alloc]initWithFrame:CGRectMake(5, 5,190, 240) style:UITableViewStyleGrouped];
    self.selectionTable.tag = 2;
    self.selectionTable.rowHeight = 42;
    self.selectionTable.sectionFooterHeight = 10;
    self.selectionTable.sectionHeaderHeight = 1;
    self.selectionTable.scrollEnabled = YES;
    self.selectionTable.showsVerticalScrollIndicator = YES;
    self.selectionTable.userInteractionEnabled = YES;
    self.selectionTable.bounces = YES;
    self.selectionTable.layer.cornerRadius = 12.0f;
    self.selectionTable.delegate = (id)self;
    self.selectionTable.dataSource =(id) self;
    [self.selectionTable registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    relation.layer.cornerRadius = 12.0f;
    [relation addSubview:self.selectionTable];
    
    return relation;
}
-(void)showTextviewWithPlcaholder:(NSString *)placeholder text:(NSString *) text
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0,300,120)];
        
    UILabel *titellabel = [[UILabel alloc]initWithFrame:CGRectMake(0,5, view.frame.size.width,20)];
    
    titellabel.text            = placeholder;
    titellabel.numberOfLines   = 1;
    titellabel.clipsToBounds   = YES;
    titellabel.backgroundColor = [UIColor clearColor];
    titellabel.textColor       = [UIColor blackColor];
    titellabel.textAlignment   = NSTextAlignmentCenter;
    [view addSubview:titellabel];
    _alertextField = [[UITextField alloc] initWithFrame:CGRectMake(10,25,280, 40)];
    _alertextField.borderStyle = UITextBorderStyleRoundedRect;
    _alertextField.font = [UIFont systemFontOfSize:15];
    _alertextField.placeholder = placeholder;
    _alertextField.autocorrectionType = UITextAutocorrectionTypeNo;
    _alertextField.keyboardAppearance = UIKeyboardAppearanceDark;
    _alertextField.keyboardType = UIKeyboardTypeDefault;
    _alertextField.returnKeyType = UIReturnKeyDone;
    _alertextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _alertextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;    
    _alertextField.delegate = self;
    
    _addressTextView = [[GCPlaceholderTextView alloc] initWithFrame:CGRectMake(5,30,290,80)];
    _addressTextView .text = text; 
    _addressTextView.placeholder = placeholder;
    _addressTextView.font = [UIFont systemFontOfSize:14.0];
    _addressTextView.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.93 alpha:1];
    _addressTextView.editable = YES;
    _addressTextView.delegate = self;
    _addressTextView.keyboardAppearance = UIKeyboardAppearanceDark;
    _addressTextView.userInteractionEnabled = YES; // superview may blocks touches
    _addressTextView.clipsToBounds = YES; // superview may clips your textfield, you will see it
    
    
    _descrip = [[GCPlaceholderTextView alloc] initWithFrame:CGRectMake(5,30,290,80)];
    _descrip .text = text;
    _descrip.placeholder = placeholder;
    _descrip.font = [UIFont systemFontOfSize:14.0];
    _descrip.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.93 alpha:1];
    _descrip.editable = YES;
    _descrip.delegate = self;
    _descrip.keyboardAppearance = UIKeyboardAppearanceDark;
    _descrip.userInteractionEnabled = YES; // superview may blocks touches
    _descrip.clipsToBounds = YES; // su
       

    
    
    BOOL isPaypal =[_selectedOptions isEqualToString:@"Paypal"];
    if (isPrice || isphone || isSecurityDeposit)
    {
        _addressTextView.keyboardType = UIKeyboardTypeNumberPad;
        _alertextField.keyboardType = UIKeyboardTypeNumberPad;
       
    
    }else if (isPaypal)
    {
      _alertextField.keyboardType = UIKeyboardTypeEmailAddress;
    }
    else 
    {
         
        _addressTextView.keyboardType = UIKeyboardTypeDefault;
        _alertextField.keyboardType   = UIKeyboardTypeDefault;
    }
   
    
    CALayer *imageLayer = _addressTextView.layer;
    [imageLayer setCornerRadius:10];
    [imageLayer setBorderWidth:2];
    imageLayer.borderColor=[[UIColor lightGrayColor] CGColor];
    
    CALayer *fieldLayer = _alertextField.layer;
    [fieldLayer setCornerRadius:10];
    [fieldLayer setBorderWidth:2];
    fieldLayer.borderColor=[[UIColor lightGrayColor] CGColor];
    CGRect frame = view.frame;
    
    
    if (isPaypal|| isPrice || isname || isphone || isSecurityDeposit)
    { 
        [_alertextField becomeFirstResponder];
        [view addSubview:_alertextField];   
        frame.size.height = 80;
        view.frame = frame;
    }
    else if (isDes) {
        [_descrip becomeFirstResponder];
        [view addSubview:_descrip];
    }
    else 
    {  
        [_addressTextView becomeFirstResponder];
        [view addSubview:_addressTextView];
    }

    
    alertView = [[CustomIOSAlertView alloc] init];
    
    [alertView setContainerView:view];
    [alertView setButtonTitles:[NSMutableArray arrayWithObjects:@"Cancel",@"Done", nil]];
    // You may use a Block, rather than a delegate.
    [alertView setDelegate:self];
   
    
    [alertView setUseMotionEffects:true];
    
    // And launch the dialog
    [alertView show];
    

}

-(void)hideAlertView:(CustomIOSAlertView *)alertview
{
    
    
    
    [self customIOS7dialogButtonTouchUpInside:alertview clickedButtonAtIndex:0];
    
    
}
#pragma mark Create Custom View

#pragma mark CustomAletrView Delegate
- (void)customIOS7dialogButtonTouchUpInside: (CustomIOSAlertView *)alert clickedButtonAtIndex: (NSInteger)buttonIndex
{
    BOOL isPaypal =[_selectedOptions isEqualToString:@"Paypal"];
    BOOL isVaildEmail =[self validEmailAddress:_alertextField.text];

   
    
    if (buttonIndex == 0)
    {
        [alert close];
        if (isState)
        {
            isState = NO;
        }
        
       
        else if (isCity)
        {
            isCity = NO;
        }
        else if (isname)
        {
            isname = NO;
        }
        else if (isphone)
        {
            isphone = NO;
        }
        else if (isSecurityDeposit)
        {
            isSecurityDeposit = NO;
        }
        else if (isDes)
        {
            isDes = NO;
        }
        
        else if (isRooms)
        {
            isRooms = NO;
        }
        else if (isBeds)
        {
            isBeds = NO;
        }
        else if (isRoomAddress)
        {
            isRoomAddress = NO;
        }
        else if (isClientAddress)
        {
            isClientAddress = NO;
        }
        else if (isPrice)
        {
            isPrice = NO;
        }
        else  if (isPayMentOptions)
        {
            isPayMentOptions = NO;
        }
        else  if (isRoomType)
        {
            isRoomType = NO;
        }
        
    }else 
    {
        if (isRoomAddress) 
        {
            _roomAddressTF.text = _addressTextView.text;
            isRoomAddress = NO;
        }
        else if (isClientAddress) 
        {
            if (isPaypal)
            {
             _clientAddressTF.text = _alertextField.text;
            }else 
            {
             _clientAddressTF.text = _addressTextView.text;
            }
       
            isClientAddress = NO;
        }
        else if (isPrice) 
        {
            _priceTF.text = _alertextField.text;
            isPrice = NO;
        }
        else if (isname) 
        {
            _nameTF.text = _alertextField.text;
            isname = NO;
        }
        else if (isphone) 
        {
            _phoneTF.text = _alertextField.text;
            isphone = NO;
        }
        
        else if (isSecurityDeposit)
        {
            _txt_SecurityDeposit.text = _alertextField.text;
            isSecurityDeposit = NO;
        }
        
        
        else if (isDes) {
            _txt_Description.text = _descrip.text;
            isDes = NO;
        }
        
        
        
        if (isClientAddress && isPaypal)
        {
            
            if (isVaildEmail)
            {
                
                [self.alertextField resignFirstResponder];
                [self.addressTextView resignFirstResponder];
                [alert close];
                
            }else
            {
                [self showAlertHudWithText:@"Invaild Email Address"];
            }
            
        }else
        {
            [self.alertextField resignFirstResponder];
            [self.addressTextView resignFirstResponder];
            
            [alert close];
        }
        
            [self.alertextField resignFirstResponder];
            [self.addressTextView resignFirstResponder];

        [alert close];
        }
}






//checkrejo
//-(void)textEditing:(id)sender
//{
//    if (self.clientAddressTF.text.length > 0)
//    {
//        if ([self validEmailAddress:self.clientAddressTF.text])
//            
//        {
//            
//        }
//        else
//        {
//            // emailtext = @"NO";
//            [self showCustomUIAlertViewWithtilet:@"Warning" andWithMessage:@"Please enter valid email address" ];
//            
//            
//            
//        }
//    }
//    
//    
//    
//}



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
                                             // added by zia
                                             if ([message isEqualToString:@"Room would be reviewed by Ridegreen for acceptance."])
                                             {
                                                 [self.navigationController popViewControllerAnimated:NO];
                                             }
                                         }];
                                        
                                    }]];
    
    
    [self presentViewController:alertViewController animated:YES completion:nil];
}
- (void)keyboardWasShown:(NSNotification *)notification
{
    
    // Get the size of the keyboard.
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    //Given size may not account for screen rotation
    keybordHigt = MIN(keyboardSize.height,keyboardSize.width);
   
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
-(void)showAlertHudWithText:(NSString *)text
{
    [MBProgressHUD hideHUDForView:alertView animated:YES];
    MBProgressHUD *hud =[MBProgressHUD showHUDAddedTo:alertView animated:YES];
    
    hud.animationType = MBProgressHUDAnimationZoomIn;
    hud.mode = MBProgressHUDModeText;
    hud.minSize = CGSizeMake(100, 50);
    //hud.yOffset = 220.0; 
    hud.labelText = text;
    [hud hide:YES afterDelay:3];
    
}
//Users/us14/Documents/Desktop/RideGreen PakringAnd tour/RideGreen_client/RideGreen_client/Classes/Add Room/AddRoomForRent.m:1940:90: Implicit conversion loses integer precision: 'NSUInteger' (aka 'unsigned long') to 'u_int32_t' (aka 'unsigned int')
-(NSString *) randomStringWithLength: (int) len {
    
    NSMutableString *randomString = [NSMutableString stringWithCapacity: len];
    
    for (int i=0; i<len; i++) {
        [randomString appendFormat: @"%C", [LETTERS characterAtIndex: arc4random_uniform((uint32_t)[LETTERS length])]];
    }
   
    return randomString;
}
- (void)dealloc {
    [_roomImageView release];
    [_formView release];
    [_roomTypeTF release];
    [_pictureView release];
    [_formBackbtn release];
    [_nextBtn release];
    [_viewBackBtn release];
    [_submitBtn release];
    [_nameView release];
    [_txt_Description release];
    [_txt_SecurityDeposit release];
    [super dealloc];
}
@end

