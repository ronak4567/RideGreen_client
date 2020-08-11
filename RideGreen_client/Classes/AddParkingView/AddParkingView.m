//
//  AddParkingView.m
//  ridegreen
//
//  Created by Ridegreen on 30/08/2015.
//  Copyright (c) 2015 Ridegreen. All rights reserved.
//

#import "AddParkingView.h"

@interface AddParkingView ()
{
    CustomIOSAlertView *alertView ;
    NSUserDefaults *prefs;
    AppDelegate *delg;
    MapView *mapView;
    GMSMapView *mView;
     BSKmlResult *place;
    __block NSString *locatedaddress;
    __block NSString *currentCoordinats;
    NSString *str_amount;
}
@property (strong ,nonatomic) NSString *str_amount;

@property (strong, nonatomic) AFJSONRequestOperation* httpOperation;
@property (nonatomic,retain) NSString *postingPricewithTax;
@property (nonatomic,retain) NSString *taxPrice;

@property (nonatomic,retain) NSString *tokanId;
@property (nonatomic,retain) NSString *postingPrice;
@property (nonatomic, retain) NSString *userId;
@end

@implementation AddParkingView

- (void)viewDidLoad {
    
    delg =(AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    
   // marry_parkingSpace =[[NSMutableArray alloc] initWithObjects:@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20", nil];
    
    marry_parkingSpace =[[NSMutableArray alloc] initWithObjects:@"1 to 5",@"6 to 10",@"11 to 15",@"16 to 20",@"20+", nil];

    
    
     prefs =[NSUserDefaults standardUserDefaults];
    _tokanId =[prefs objectForKey:@"custrom_id"];
    self.userId =[prefs objectForKey:@"user_id"];
    _selectedCityId =[prefs objectForKey:@"city_id"];
    cityIds =[NSMutableArray new];
    cityNames =[NSMutableArray new];
    // added by zia 
    _parkingNameTF.autocapitalizationType = UITextAutocapitalizationTypeSentences;
     _parkingLocationTF.autocapitalizationType = UITextAutocapitalizationTypeSentences;
    [self setupUITextFileds];
        
    [super viewDidLoad];
    if (_disableEnableSwitch.on) 
    {
        [self.disableParkingLb setText:@"Disable Parking"];
    }else
    {
        [self.disableParkingLb setText:@"Enable Parking"];
    }
        if (delg.isEidtParking) 
    {
        [self.useCurrentLocationBtn setHidden:YES];
        [self.selectFromMapBtn setHidden:YES];
        [self.disableEnableSwitch setHidden:NO];
        [self.disableParkingLb setHidden:NO];
    }
    else 
    {
        [self.useCurrentLocationBtn setHidden:NO];
        [self.selectFromMapBtn setHidden:NO];
        [self.disableEnableSwitch setHidden:YES];
        [self.disableParkingLb setHidden:YES];
    }
 
    [self fetchPostingPrice];
     [super viewDidLoad];
    // Do any additional setup after loading the view.
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    // Return the number of sections.
    // on select cities
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    // Return the number of rows in the section.
     if (isParkingSpace)
    {
        return [marry_parkingSpace count];
        
    }
    return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *sectionName;
    if (isParkingSpace)
    {
        sectionName = @"Select Parking Space";
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
     if (isParkingSpace)
    {
        // for blood groups
        cell.textLabel.text= [marry_parkingSpace objectAtIndex:indexPath.row];
        if ([cell.textLabel.text isEqualToString:self.selectedParkingSpace])
        {
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
    if (isParkingSpace)
    {
        self.selectedParkingSpace = cell.textLabel.text;
        NSInteger intspace = indexPath.row + 1;
        self.Spaceparking = [NSString stringWithFormat:@"%ld",(long)intspace];
        
        [self.txt_Spaces setText:self.selectedParkingSpace];
        [self.txt_Spaces resignFirstResponder];
    }
    
    [self hideAlertView:alertView];
}




-(void)hideAlertView:(CustomIOSAlertView *)alertview
{
    
    
    
    [self customIOS7dialogButtonTouchUpInside:alertview clickedButtonAtIndex:0];
    
    
}



- (void)customIOS7dialogButtonTouchUpInside: (CustomIOSAlertView *)alert clickedButtonAtIndex: (NSInteger)buttonIndex
{
   
    
    if (buttonIndex == 0)
    {
        [alert close];
        if (isParkingSpace)
        {
            isParkingSpace = NO;
        }
        
    }else
    {
       
        
        
    }
    
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    
    if (textField == self.txt_Spaces )
    {
        [self.view endEditing:YES];
        if (!isParkingSpace)
        {
            isParkingSpace = YES;
            [self showslectionView];
        }
        return NO;
        
    }
  
    
    return YES;
}


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
    
    
    
    
    
    
    CALayer *fieldLayer = _alertextField.layer;
    [fieldLayer setCornerRadius:10];
    [fieldLayer setBorderWidth:2];
    fieldLayer.borderColor=[[UIColor lightGrayColor] CGColor];
    CGRect frame = view.frame;
    
    
    if (isParkingSpace)
    {
        [_alertextField becomeFirstResponder];
        [view addSubview:_alertextField];
        frame.size.height = 80;
        view.frame = frame;
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


-(void)setupUITextFileds
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
                     forKeyPath:@"_placeholderLabel.textColor"];
            [textField resignFirstResponder];
        }
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mrak UITextField Delegate Methods
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
       return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
       
    
}


- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    
   
    
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
       
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    
        
    if (textField == _parkingNameTF) 
    {
        
        [_perHourRateTF becomeFirstResponder];
    }
    else if (textField == _perHourRateTF) 
    {
        
        [_parkingLocationTF becomeFirstResponder];
    }
    else if (textField == _parkingLocationTF) 
    {
        
        [_parkingLocationTF resignFirstResponder];
        [self submitBtnPressed:self];
    }

    return YES;
}


#pragma mark Button IBActions
- (IBAction)currentLocationBtnPressed:(id)sender 
{
    [self useCrrentLocation];
}

- (IBAction)selectFromMapBtnPressed:(id)sender 
{
    
    [self.parkingNameTF resignFirstResponder];
    [self.parkingLocationTF resignFirstResponder];
    [self showCustomAlertViewWithMessage:@"Tab and hold to Select Location"];

}

- (IBAction)backBtnPressed:(id)sender 
{

    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)submitBtnPressed:(id)sender
{
    
    if ([self.parkingNameTF.text length] != 0 && [self.perHourRateTF.text length] !=0 && [self.parkingLocationTF.text length] !=0  && [self.txt_Spaces.text length] !=0)
    {
        float taxPercentage = [_taxPrice floatValue]/100;
        float spaceAmount;
        if ([self.txt_Spaces.text isEqualToString:@"1 to 5"])
        {
            spaceAmount = [_postingPrice floatValue] * 1;
        }
        else if ([self.txt_Spaces.text isEqualToString:@"6 to 10"])
        {
            spaceAmount = [_postingPrice floatValue] * 2;
        }
        else if([self.txt_Spaces.text isEqualToString:@"11 to 15"])
        {
            spaceAmount = [_postingPrice floatValue] * 3;
        }
        else if([self.txt_Spaces.text isEqualToString:@"16 to 20"])
        {
            spaceAmount = [_postingPrice floatValue] * 4;
        }
        else if([self.txt_Spaces.text isEqualToString:@"20+"])
        {
            spaceAmount = [_postingPrice floatValue] * 5;
        }
        
        NSString *totalAmount = [NSString stringWithFormat:@"%.02f",spaceAmount];
        
        
        float postingCostWithTax = ([totalAmount floatValue] + ([totalAmount floatValue] * (taxPercentage)));
        
        _postingPricewithTax = [NSString stringWithFormat:@"%.02f",postingCostWithTax];
        
        self.str_amount = [NSString stringWithFormat:@"%.02f",postingCostWithTax];
        
        NSString *msg =[NSString stringWithFormat:@"Posting Cost : $%@\nTax Rate : %@%@\n\nAdding parking will cost you $%@, Tap continue .. ",totalAmount,_taxPrice,@"%",_postingPricewithTax];
        
        [self showCancelUIAlertViewWithtilet:@"Info" andWithMessage:msg];
        //        if ([currentCoordinats length] != 0 && [locatedaddress length] != 0)
        //        {
        //
        //
        //        }else
        //        {
        //            NSString *msg =[NSString stringWithFormat:@"Some thing want worng,try again later"];
        //            [self showCustomUIAlertViewWithtilet:@"info" andWithMessage:msg];
        //
        //
        //        }
        
    }
    else
    {
        // Alert if entered user name or   password wrong
        [self showCustomUIAlertViewWithtilet:@"Info" andWithMessage:@"Please provide correct informatiom"];
        
        
        
    }
    
}


- (IBAction)disableEnableSwitchChanged:(id)sender 
{
    if (_disableEnableSwitch.on) 
    {
        
        [self.disableParkingLb setText:@"Disable Parking"];
    }else
    {
     [self.disableParkingLb setText:@"Enable Parking"];
    
    }


}


#pragma mark Web Services

-(void)addPaking
{
    [self.parkingNameTF resignFirstResponder];
    [self.parkingLocationTF resignFirstResponder];
    NSString *parkingName = _parkingNameTF.text;
    NSString *parkingLocation =_parkingLocationTF.text;
    NSString *perHourRate = _perHourRateTF.text;
  
        
        MBProgressHUD *hue=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hue.labelText=@"Adding...";
        NSMutableDictionary *params=[[NSMutableDictionary alloc]initWithObjectsAndKeys:@"add_parking",@"command",parkingName,@"parking_name",parkingLocation,@"parking_location",self.userId,@"client_id",currentCoordinats,@"coordinate",@"iPhone",@"from",perHourRate,@"per_hour_rate",_selectedCityId,@"city_id",self.Spaceparking,@"space",nil];
        
        [[NetworkHelper sharedInstance] commandWithParams:params onCompletion:^(NSDictionary *json) {
            //[MBProgressHUD hideHUDForView:self.view animated:YES];
            //NSLog(@"the json return is %@",json);
            if (![json objectForKey:@"error"]&& json!=nil)
            {
                
                NSArray *results=[json objectForKey:@"result"];
                NSDictionary *res=[results objectAtIndex:0];
                NSString *amount = [res objectForKey:@"cost_per_posting"];
                NSString *str_parkid = [res objectForKey:@"park_id"];
                NSLog(@"amount %@",amount);
                
//                [self postStripeToken:_tokanId whitAmount:_postingPricewithTax];
                [self postStripeToken:_tokanId whitAmount:_postingPricewithTax parkingID:str_parkid];
                
                //[MBProgressHUD hideHUDForView:self.view animated:YES];
                
                
                
            }else
            {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                NSString *errorMsg =[json objectForKey:@"error"];
                if ([ErrorFunctions isError:errorMsg])
                {
                    [self addPaking];
                }else
                {
                    [self showCustomUIAlertViewWithtilet:@"Warning" andWithMessage:[json objectForKey:@"error"]  ];
                    
                }

                
                
                ////NSLog(@"Error :%@",[json objectForKey:@"error"]);
            }
        }];
        
        
        
}
-(void)fetchPostingPrice
{
    
    NSMutableDictionary *params=[[NSMutableDictionary alloc]initWithObjectsAndKeys:@"posting_price",@"command",_selectedCityId,@"city_id", nil];
    
    [[NetworkHelper sharedInstance] commandWithParams:params onCompletion:^(NSDictionary *json) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSLog(@"the json return is %@",json);
        
        if (![json objectForKey:@"error"]&& json!=nil)
        {
            
            NSArray *results=[json objectForKey:@"result"];
            NSDictionary *res=[results objectAtIndex:0];
            _postingPrice = [res objectForKey:@"cost_per_posting"];
            NSLog(@"res %@",res);
            
            _taxPrice = [res objectForKey:@"taxrate"];
        }else
        {
            NSString *errorMsg =[json objectForKey:@"error"];
            if ([ErrorFunctions isError:errorMsg])
            {
                [self fetchPostingPrice];
            }else
            {
                
                
            }
            
        }
    }];
    
    
    
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
                            locatedaddress = [NSString stringWithFormat:@"%@,%@,%@,%@",placemarkN.subThoroughfare,placemarkN.thoroughfare,placemarkN.subLocality,placemarkN.locality];
                            GMSMarker *marker= [[GMSMarker alloc] init];
                            marker=[GMSMarker markerWithPosition:coordinate];
                            marker.position = coordinate;
                            // CLLocationCoordinate2DMake([latitude doubleValue], [longitude doubleValue]);
                            marker.title =@"Parking Location";
                            marker.snippet = locatedaddress;
                            marker.appearAnimation = YES;
                            marker.map = mView;
                            mView.selectedMarker = marker;

                            [self.parkingLocationTF setText:locatedaddress];
                            
                            
                            
                            
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
                            
                            [self.parkingLocationTF setText:locatedaddress];
                            
                            
                            
                            
                        }
                        
                        
                        
                    }];

}

#pragma mark Create Custom View

#pragma mark CustomAletrView Delegate

/*
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
*/

-(void)getCoordinatesFromAddressString :(NSString *)addrssString
{
    if (self.forwardGeocoder == nil) {
        self.forwardGeocoder = [[BSForwardGeocoder alloc] initWithDelegate:self];
    }
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
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
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self addPaking];
        
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
            message = [NSString stringWithFormat:@"Could not find your location"];//[NSString stringWithFormat:@"Could not find %@", @"searchQuery"];
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
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [self showCustomUIAlertViewWithtilet:@"Information" andWithMessage:message];
    
    
}
#pragma mark
#pragma mark - Stripe
#pragma mark
- (void)postStripeToken:(NSString* )token whitAmount :(NSString *) amount parkingID:(NSString*)parkID{
    //1
  
    NSLog(@"delg.custromId %@",delg.custromId);
    NSString *finalAmount =[NSString stringWithFormat:@"%.0f",[amount floatValue]*100];
    
    NSURL *postURL = [NSURL URLWithString:STRIPE_TEST_POST_URL];
    AFHTTPClient* httpClient = [AFHTTPClient clientWithBaseURL:postURL];
    httpClient.parameterEncoding = AFJSONParameterEncoding;
    [httpClient registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [httpClient setDefaultHeader:@"Content-Type" value:@"application/json"];
    
    //4
    NSMutableString *stripUrl =[[NSMutableString alloc] init];

    [stripUrl appendString:KStripUrl];
    
    [stripUrl appendString:[NSString stringWithFormat:@"stripeCustomer=%@&stripeAmount=%@&sourceId=%@&type=parking",token,finalAmount,parkID]];//
    NSLog(@"stripUrl %@",stripUrl);
    NSMutableURLRequest* request = [httpClient requestWithMethod:@"GET" path:stripUrl parameters:nil];
    
    self.httpOperation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON)
                          
                          {
                             // [MBProgressHUD hideHUDForView:self.view animated:YES];
                              [self chargeDidSucceed];
                              
                          }
                        failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON)
                          {
                              [MBProgressHUD hideHUDForView:self.view animated:YES];
                              NSLog(@"%@",JSON);
                              NSLog(@"error %@",error);
                              [self chargeDidNotSuceed];
                          }];
    
    [self.httpOperation start];
    
    
    
}
- (void)chargeDidSucceed {
    //rejo18042016
    
    MBProgressHUD *hud =[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"wait";
    NSString *str_transactionType = @"1";
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
           [self showCustomUIAlertViewWithtilet:@"New Parking" andWithMessage:@"Your parking has been listed for a duration of  1 month.  Renewal is required after listing expiration date."];
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


- (void)chargeDidNotSuceed {
    //2
    [self showCustomUIAlertViewWithtilet:@"Payment Not successful" andWithMessage:@"Please try again later."];
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
                                         // added by zia
                                            if ([message isEqualToString:@"Your parking has been listed for a duration of  1 month.  Renewal is required after listing expiration date."])
                                            {
                                                [self.navigationController popViewControllerAnimated:NO];
                                            }
                                        }];
                                        
                                    }]];
    
    
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
    
    [alertViewController addAction:[NYAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil)style:UIAlertActionStyleDefault handler:^(NYAlertAction *action) 
                                    {
                                        
                                        [self dismissViewControllerAnimated:YES completion:^
                                         {
                                                                                         
                                         }];
                                        
                                        
                                        
                                        
                                    }]];
    
    [alertViewController addAction:[NYAlertAction actionWithTitle:NSLocalizedString(@"continue", nil)
                                                            style:UIAlertActionStyleCancel handler:^(NYAlertAction *action)
                                    { 
                                        
                                if ([self isCurrentCoodinatesAndAddress]) 
                                    {
                                    [self dismissViewControllerAnimated:YES completion:^
                                        {
                                        [self addPaking];
                                        }];
                                    }else 
                                    {
                                        [self dismissViewControllerAnimated:YES completion:^
                                         {
                                        [self getCoordinatesFromAddressString:_parkingLocationTF.text];
                                         }];
                                        
                                    }
                                        
                                        
                                        
                                        
                                        
                                       
                                                                           
                                    
                                    }]];
    
    [self presentViewController:alertViewController animated:YES completion:nil];
}
-(BOOL)isCurrentCoodinatesAndAddress
{
    if ([currentCoordinats length] != 0 && [locatedaddress length] != 0) 
    {
        return YES;
    
    }else 
    
    {
    return NO;
    }



}


@end
