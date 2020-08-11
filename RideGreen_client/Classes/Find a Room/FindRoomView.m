//
//  FindRoomView.m
//  ridegreen
//
//  Created by Ridegreen on 30/10/2015.
//  Copyright (c) 2015 Ridegreen. All rights reserved.
//

#import "FindRoomView.h"
#import "FindRoomCell.h"

@interface FindRoomView ()

@end

@implementation FindRoomView

- (void)viewDidLoad 
{
 
    [super viewDidLoad];
    
    
    stateIds       =[NSMutableArray new];
    stateNames     =[NSMutableArray new];
    cityIds        =[NSMutableArray new];
    cityNames      =[NSMutableArray new];
    allRentedrooms =[NSMutableArray new];
    
    taxRates       =[NSMutableArray new];
    userdefault =[NSUserDefaults standardUserDefaults];
    self.userId =[userdefault objectForKey:@"user_id"];
    
    [self fetchAllStates];
    [self setupUITextFileds];
    
    // Do any additional setup after loading the view.
}
- (id)initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super initWithCoder:aDecoder])) {
        self.title = @"MWPhotoBrowser";
        
        // Clear cache for testing
        [[SDImageCache sharedImageCache] clearDisk];
        [[SDImageCache sharedImageCache] clearMemory];
        
            
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];
        
        [self loadAssets];
        
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    delg = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    [self.detailView setHidden:YES];
 }
-(void)setupUITextFileds
{
    NSArray *fields = [NSArray arrayWithObjects:self.stateTF,self.cityTf,self.dateTf, nil]; //get all subviews from your scrollview//
    
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
    
    UIToolbar *toolbar = [[UIToolbar alloc] init];
    [toolbar setBarStyle:UIBarStyleBlackTranslucent];
    [toolbar sizeToFit];
    UIBarButtonItem *buttonflexible = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *buttonDone = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneClicked:)];
    
    [toolbar setItems:[NSArray arrayWithObjects:buttonflexible,buttonDone, nil]];
    _dateTf.inputAccessoryView = toolbar;
    [_dateTf setDropDownMode:IQDropDownModeDatePicker];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    [_dateTf setDateFormatter:dateFormatter];
    
    
    
    
    [self.view insertSubview:_dateTf belowSubview:self.view];
    //[self.view inse];
}

-(void)doneClicked:(UIBarButtonItem*)button
{
    [self.view endEditing:YES];
    if (([_dateTf.text length] != 0) && ([_stateTF.text length] != 0) && ([_cityTf.text length] != 0))
    {
        [self fetchAllRoomsForRentFromState:_selectedStateId city:_selectedCityId];
        
    }
    else
    {
        [self hidekeybord];
        [self showCustomUIAlertViewWithtilet:@"Info" andWithMessage:@"Please select All fields"];
    }
    
}


-(void)showDetailView
{
    [self.detailView setHidden:NO];
    CATransition *transition = [CATransition animation];
    transition.duration = 0.5;
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromRight;
    [transition setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [self.view.layer addAnimation:transition forKey:nil];
    
    [self.view addSubview:self.detailView];
}
-(void)hideDetailView
{   [self.detailView setHidden:NO];
    CATransition *transition = [CATransition animation];
    transition.duration = 0.5;
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromLeft;
    [transition setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [self.view.layer addAnimation:transition forKey:nil];
    [self.detailView removeFromSuperview];    
  
}
#pragma mrak UITextField Delegate Methods
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return YES;
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    
    _cityTf .inputAccessoryView = nil;
    _stateTF.inputAccessoryView = nil;
    //_dateTf.inputAccessoryView = nil;
       return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
    
    if (textField == _stateTF )
    {
        
        isState = YES;
        
        Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
        NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
        if (networkStatus == NotReachable)
        {
             [self showCustomUIAlertViewWithtilet:@"Info" andWithMessage:@"Please check with your internet connection"];
        } else
        {
            [self showslectionView];
            [self hidekeybord];
        }
        
        
    }
    
    else if (textField == _cityTf && [_stateTF.text length] != 0) 
    {
        isCity = YES;
        
        [self showslectionView];
        [self hidekeybord];  
    }
    else if (textField == _cityTf && [_stateTF.text length] == 0) 
    {
        [self hidekeybord];        
        [self showCustomUIAlertViewWithtilet:@"Info" andWithMessage:@"Please select state first"];
        
    }
    else if ((textField == _dateTf) && ([_stateTF.text length] != 0) && ([_cityTf.text length] != 0))
    {
        
    }
    else if ((textField == _dateTf) && ([_stateTF.text length] == 0) && ([_cityTf.text length] == 0))
    {
        [self hidekeybord];
        [self showCustomUIAlertViewWithtilet:@"Info" andWithMessage:@"Please select state and city first"];
    }
        
    
    
}

-(void)hidekeybord
{
    [self.view endEditing:YES];
    
    [self.cityTf   resignFirstResponder];
    [self.stateTF  resignFirstResponder];
   
    
    
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    
    
    
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
    
    [self.view endEditing:YES];
    
  
    return YES;
}
#pragma mark CustomAletrView Delegate
- (void)customIOS7dialogButtonTouchUpInside: (CustomIOSAlertView *)alert clickedButtonAtIndex: (NSInteger)buttonIndex
{
    
    
    if (buttonIndex == 0) 
    {
        [alert close];  
        
        
    }else 
    {    }
    
}
#pragma mark Web Services
-(void)fetchAllStates
{
    NSMutableDictionary *params=[[NSMutableDictionary alloc]initWithObjectsAndKeys:@"get_states",@"command", nil];
    
    [[NetworkHelper sharedInstance] commandWithParams:params onCompletion:^(NSDictionary *json) {
        
        NSLog(@"the json return is %@",json);
    
        if (![json objectForKey:@"error"]) 
        {
            NSArray *results=[json objectForKey:@"result"];
            //NSLog(@"result %@",results);
            for (int i=0; i<results.count; i++) 
            {
                NSDictionary *res =[results objectAtIndex:i];
                
                // adding user adis in array
                [stateNames addObject:(NSString *)[[res objectForKey:@"name"] capitalizedString]];
                [stateIds addObject:(NSString *)[res objectForKey:@"id"]];
            }
        }
        
        else
        {
            // if reques error call again
            NSString *errorMsg =[json objectForKey:@"error"];
            if ([ErrorFunctions isError:errorMsg])
            {
                [self fetchAllStates];     
            }
            else
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
        [taxRates removeAllObjects];
        if (![json objectForKey:@"error"] && json != nil) 
        {
            
            
            NSArray *results=[json objectForKey:@"result"];
            //NSLog(@"result %@",results);
            for (int i=0; i<results.count; i++) {
                NSDictionary *res =[results objectAtIndex:i];
                
                // adding user adis in array
                [cityNames addObject:(NSString *)[[res objectForKey:@"name"] capitalizedString]];
                [cityIds addObject:(NSString *)[res objectForKey:@"id"]];
                 [taxRates addObject:(NSString *)[res objectForKey:@"taxrate"]];
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

#pragma mark - UITableView Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    // Return the number of sections.
    // on select cities
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
    
    // Return the number of rows in the section.
    if (tableView == self.selectionTable)
    {
        if (isState) 
        {
            return [stateIds count];
        }
        // on blood groub selection
        else if (isCity)
        {
            return [cityIds count];
            
        }
        else if (isRequest)
        {
            return 30;
            
        }
        
    }
    else 
    {
        return allRentedrooms.count;
    
    }
   return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *sectionName = @"";
    if (tableView == self.selectionTable)
    {
        
        // for cities
        if (isState)
        {
            sectionName = @"Select State";
        }else if (isCity)
        {
            // for blood groups
            sectionName = @"Select City";
        }
        else if (isRequest)
        {
            // for blood groups
            sectionName = @"Select Days";
        }

        
    }
    return sectionName;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString* cellIdentifier = @"cell";
    static NSString* cellIdentifier2 = @"FCell";
    NSString *imageName;
    NSString *imageUrl;
    FindRoomCell  *cell2 = [tableView dequeueReusableCellWithIdentifier:cellIdentifier2];
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (tableView == self.selectionTable)
    {
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
        else if (isRequest)
        {
            // for blood groups
            cell.textLabel.text= [NSString stringWithFormat:@"%zd",indexPath.row+1];
            if ([cell.textLabel.text isEqualToString:_selectedNumberofDays]) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
                
            }else
            {
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
            
        }
        
        
        return cell;
        

    }else
    {
        if (!cell2)
        {
            cell2 = [[FindRoomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            
        }
              
        RenterRequest *request = [allRentedrooms objectAtIndex:indexPath.row];
        cell2.roomsAndBedslabel.text = [NSString stringWithFormat:@"%@ Rooms %@ Beds",request.nubmerOfRooms,request.nubmerOfBeds];
        cell2.roomAdressLabel.text = request.roomAddress;
        cell2.pricePerMonth.text   = [NSString stringWithFormat:@"$%@/night",request.roomRentalPrice];
        cell2.roomTypeLabel.text   = [NSString stringWithFormat:@"%@ Room",request.roomType]; 
        [cell2 setSelectionStyle:UITableViewCellSelectionStyleNone];
        [self roundRectView:cell2.bgView];
        [self roundRectView:cell2.priceView];
        [self roundRectView:cell2.roomTypeView];
        
        imageName = request.roomImage;
        NSArray *imgArray =[imageName componentsSeparatedByString:@","];
        imageName =[imgArray objectAtIndex:0];
        if([imageName hasPrefix:@"http://"])
        {
            imageUrl =[NSString stringWithFormat:@"%@",imageName];
        }
        else
        {
            imageUrl =[NSString stringWithFormat:@"%@%@",kBASE_ROOM_IMG_URL ,imageName];
        }
        if (imageName!= 0)
        {
            TJSpinner *spinner1 = [[TJSpinner alloc] initWithSpinnerType:kTJSpinnerTypeCircular];
            [spinner1 setColor:[UIColor orangeColor]];
            //[UIColor colorWithRed:17/255.00 green:181/255.00 blue:255.00/255.00 alpha:1.0]
            [spinner1 setStrokeWidth:20];
            [spinner1 setInnerRadius:8];
            [spinner1 setOuterRadius:30];
            [spinner1 setNumberOfStrokes:8];
            
            spinner1.hidesWhenStopped = YES;
            [spinner1 setPatternStyle:TJActivityIndicatorPatternStylePetal];
            
            [spinner1 setHidden:YES];
            
            spinner1.center = CGPointMake(cell2.roomImgView.frame.size.width / 2, cell2.roomImgView.frame.size.height / 2);
            [cell2.roomImgView addSubview:spinner1];
            [spinner1 setHidden:NO];
            [spinner1 startAnimating];
            
            
            [cell2.roomImgView setImageWithURLRequest:[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:imageUrl]]
                                    placeholderImage:[UIImage imageNamed:@"room_Placeholde.png"]
                                             success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image)
             {
                [spinner1 stopAnimating];
                [spinner1 setHidden:YES];
                 cell2.roomImgView.image = image;
                 cell2.isImage = YES;
                
                 
             }
    failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error){
        [spinner1 stopAnimating];
         [spinner1 setHidden:YES];
        cell2.isImage = NO;
        }];
        
        
        }else 
        {
        
         cell2.isImage = NO;
        }

        return cell2;
    }
   


}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    FindRoomCell *cell2 = (FindRoomCell *)[tableView cellForRowAtIndexPath:indexPath];
    
    if (tableView == self.selectionTable)
    {
// for cities
    if (isState)
    {
        //zia
        _selectedStateId  =[stateIds objectAtIndex:indexPath.row];
        _selectedStateName =[stateNames objectAtIndex:indexPath.row];
        [self.stateTF setText:_selectedStateName];
        [self.cityTf setText:@""];
        _selectedCityName = @"";
        [self fetchAllCitiesFromStateId:_selectedStateId];
        [self.stateTF resignFirstResponder];
        isState = NO;
    }else if (isCity)
    {
        _selectedCityId  =[cityIds objectAtIndex:indexPath.row];
        _selectedCityName =[cityNames objectAtIndex:indexPath.row];
        _selectedTaxRate = [taxRates objectAtIndex:indexPath.row];

        [self.cityTf setText:_selectedCityName]; 
        [self.cityTf resignFirstResponder];
        
        isCity = NO;
        
        //[self fetchAllRoomsForRentFromState:_selectedStateId city:_selectedCityId];
    }
    else if (isRequest)
    {
        _selectedNumberofDays = cell.textLabel.text;
        
        isRequest= NO;
        self.renRequest = [allRentedrooms objectAtIndex:_selectedIndex];
        
        [self checkRoomAvailable:_selectedNumberofDays room:self.renRequest black:^(BOOL status) {
            if (status)
                [self requestSetup:self.renRequest];
        }];
}
    
    }        
    else
    {
        _selectedNumberofDays = cell.textLabel.text;
        
        isRequest= NO;
        self.renRequest = [RenterRequest new];
        self.renRequest = [allRentedrooms objectAtIndex:indexPath.row
                    ];
        
        [self detailViewSetupwith:self.renRequest roomImage: cell2.roomImgView.image];
        _selectedIndex = indexPath.row;
        [self showDetailView];
    }
    
    [self hideAlertView:alertView];
}



-(BOOL)checkRoomAvailable:(NSString *)noofdays room:(RenterRequest *)request black:(roomResponseBlock)completionBlock
{
    __block BOOL status;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSMutableDictionary *params=[[NSMutableDictionary alloc]initWithObjectsAndKeys:@"room_check_request",@"command",request.roomId,@"room_id",noofdays,@"num_days",self.dateTf.text,@"date",nil];
    
    [[NetworkHelper sharedInstance] commandWithParams:params onCompletion:^(NSDictionary *json) {
        if (![json objectForKey:@"error"]&& json!=nil)
        {
            NSDictionary *results=[[json objectForKey:@"result"] objectAtIndex:0];
            
            if ([[results objectForKey:@"status"] isEqualToString:@"Available"])
            {
                status = YES;
            }
            else
            {
                [self showCustomUIAlertViewWithtilet:@"info" andWithMessage:@"Sorry! Not avilable for your duration."];
                status = NO;
            }
            
            completionBlock(status);
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
        }
    }];
    
    return status;
}

/*-(void)requestSetup:(RenterRequest *)request
{
    
    float rent = [request.roomRentalPrice floatValue] * [_selectedNumberofDays intValue];
    NSString *tRent = [NSString stringWithFormat:@"%.02f",rent];
    totalRent = [NSString stringWithFormat:@"%.02f",rent];;
    [delg setTotalRent:tRent];
    NSString *msg = [NSString stringWithFormat:@"Price Per day:$%@\nno.of days:  %@\n\nTotal Rent:  $%@\n\n $%@ will be charger from your account",request.roomRentalPrice,_selectedNumberofDays,tRent,tRent];
    
    [self showCustomUIAlertViewWithtilet:@"Rent Payment" andWithMessage:msg];

}*/

-(void)requestSetup:(RenterRequest *)request
{
    float rent = [request.roomRentalPrice floatValue] * [_selectedNumberofDays intValue];
    NSString *tRent = [NSString stringWithFormat:@"%.02f",rent];
    
    totalRent = [NSString stringWithFormat:@"%.02f",rent];;
    
    float totalCharges = rent *([_selectedTaxRate floatValue]/100);
    totalCharges = rent + totalCharges;
    NSString *totalCharge = [NSString stringWithFormat:@"%.02f",totalCharges];
    [delg setTotalRent:totalCharge];
    NSString *msg = [NSString stringWithFormat:@"Price Per night:$%@\nno.of days:  %@\n\nTotal Rent:  $%@\nTax Rate:  %@%@\n\n $%@ would be charged to your credit card",request.roomRentalPrice,_selectedNumberofDays,tRent,_selectedTaxRate,@"%",totalCharge];
    
    [self showCustomUIAlertViewWithtilet:@"Rent Payment" andWithMessage:msg];
    
}


-(IBAction)clientInfoBtnpressed:(id)sender
{
    UIButton *infoBtn = (UIButton *)sender;
    RenterRequest *request = [allRentedrooms objectAtIndex:infoBtn.tag];
    
    [self ShowPopupWithRequest:request];
}

-(NSDate *)getDateFromString:(NSString *)dateString
{
    // Convert string to date object
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [dateFormat dateFromString:dateString];

    return date;
}

#pragma mark Web Services
-(void)updateStatusWthitId:(NSString *)selectedroomId renterId:(NSString *) renterId withStatus :(NSString *) status 
{
    
   RenterRequest *request = [allRentedrooms objectAtIndex:_selectedIndex];
    selectedroomId = request.roomId;
    renterId = self.userId;
    NSDate *today = [NSDate date];
    NSDate *selected_day = [self getDateFromString:_dateTf.text];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    
    // Get the date time in NSString
    
    NSString *date = [dateFormatter stringFromDate:today];//today
    NSString *selecteddate = [dateFormatter stringFromDate:selected_day];
    
    MBProgressHUD *hud =[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"wait";
    
    NSMutableDictionary *params=[[NSMutableDictionary alloc]initWithObjectsAndKeys:@"accepted_requested_room",@"command",
                                 renterId,@"renter_id",
                                 selectedroomId,@"room_id",
                                 status ,@"states",
                                 selectedroomId,@"requested_id",
                                 _selectedNumberofDays,@"no_of_days",
                                  delg.totalRent,@"total_rent",
                                 date,@"c_date",
                                 selecteddate, @"temp_checkin_date",
                                 nil];
    
    [[NetworkHelper sharedInstance] commandWithParams:params onCompletion:^(NSDictionary *json) {
        //NSLog(@"the json return is %@",json);
        if (![json objectForKey:@"error"]&& json!=nil)
        {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
           // [self fetchAllRoomsForRentFromState:_selectedStateId city:_selectedCityId];
            //[self.navigationController popViewControllerAnimated:YES];
            
            [self showCustomUIAlertViewWithtilet:@"Info" andWithMessage:@"Your reservation request has been sent to the room's owner"];
            
        }else
        {
            NSString *errorMsg =[json objectForKey:@"error"];
            if ([ErrorFunctions isError:errorMsg])
            {
                [self updateStatusWthitId:selectedroomId renterId:renterId withStatus:status];    
            }
            else
            {
                
                NSLog(@"Error is %@",[json objectForKey:@"error"]);
            }
           
        }
    }];
    
    
}
-(void)ShowPopupWithRequest:(RenterRequest *)request
{
    PopupViewController1 *popView = [PopupViewController1 new];
    [popView setRequest:request];
    
    popupController = [[STPopupController alloc] initWithRootViewController:popView];
    popupController.cornerRadius = 4;
    popupController.transitionStyle = _transitionStyle;
    [popupController presentInViewController:self];
    
    [STPopupNavigationBar appearance].barTintColor = kSegmentedBgColor;
    [STPopupNavigationBar appearance].tintColor = [UIColor whiteColor];
    [STPopupNavigationBar appearance].barStyle = UIBarStyleDefault;
    
    [STPopupNavigationBar appearance].titleTextAttributes = @{ NSFontAttributeName:[UIFont fontWithName:@"Cochin" size:18], NSForegroundColorAttributeName: [UIColor whiteColor] };
    [[UIBarButtonItem appearanceWhenContainedIn:[STPopupNavigationBar class], nil] setTitleTextAttributes:@{ NSFontAttributeName:[UIFont fontWithName:@"Cochin" size:18] } forState:UIControlStateNormal];
    
}
#pragma mark CustomAlertView

-(void)showslectionView
{
    //[self hidekeybord];
    alertView = [[CustomIOSAlertView alloc] init];
    
    [alertView setContainerView:[self createSelectionListView]];
    
    // You may use a Block, rather than a delegate.
    [alertView setDelegate:self];
    [alertView setOnButtonTouchUpInside:^(CustomIOSAlertView *aView, int buttonIndex)
    {
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
    self.selectionTable.sectionFooterHeight = 22;
    self.selectionTable.sectionHeaderHeight = 22;
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
-(void)hideAlertView:(CustomIOSAlertView *)alertview
{
    [self customIOS7dialogButtonTouchUpInside:alertview clickedButtonAtIndex:0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)fetchAllRoomsForRentFromState:(NSString *)stateId city:(NSString *)cityId
{
    MBProgressHUD *hue=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hue.labelText=@"";
    NSMutableDictionary *params=[[NSMutableDictionary alloc]initWithObjectsAndKeys:@"rental_request",@"command",stateId,@"state_id",cityId,@"city_id",self.userId,@"user_id",self.dateTf.text,@"selected_date",nil];
    
    [[NetworkHelper sharedInstance] commandWithParams:params onCompletion:^(NSDictionary *json) {
        
        //NSLog(@"the json return is %@",json);
        [allRentedrooms removeAllObjects];
        if (![json objectForKey:@"error"]&& json!=nil)
        {
            NSArray *results=[json objectForKey:@"result"];
            for (int i=0; i<[results count]; i++)
            {
                NSDictionary *res = [results objectAtIndex:i];
                NSLog(@"result:%@",res);
                NSString *adminphone = [res objectForKey:@"admin_phone"];
                NSString *roomId = [res objectForKey:@"id"];
                NSString *roomAddress = [res objectForKey:@"room_address"];
                NSString *roomRentalPrice = [res objectForKey:@"rate_per_month"];
                NSString *roomhRentalDate =[res objectForKey:@"createdon"];
                NSString *roomStatus =[res objectForKey:@"status"];
                
                NSString *numberofRooms =[res objectForKey:@"rooms"];
                NSString *numberofBeds =[res objectForKey:@"beds"];
                NSString *cId =[res objectForKey:@"first_name"];
                NSString *cName     =[res objectForKey:@"name"];
                NSString *cphone    =[res objectForKey:@"mobile"];
                NSString *cphoto    =[res objectForKey:@"photo"];
                NSString *caddress  = [res objectForKey:@"client_address"];
                NSString *roomImage = [res objectForKey:@"room_image"];
                NSString *roomType  = [res objectForKey:@"room_type"];
                NSString *description = [res objectForKey:@"description"];
                NSString *str_RoomRating = [res objectForKey:@"room_rating"];
                NSString *str_Security = [res objectForKey:@"security_deposit"];
                
                [allRentedrooms addObject:[RenterRequest setRequestedRoomId:roomId roomAddress:roomAddress nubmerOfRooms:numberofRooms nubmerOfBeds:numberofBeds roomRentalPrice:roomRentalPrice roomRentaldate:roomhRentalDate isEnable:roomStatus clientId:cId clientName:cName clientphone:cphone clientadress:caddress clientphoto:cphoto customerId:@"" totelRent:@"" roomImage:roomImage roomType:roomType numberOfDays:@"" requestedDate:@"" isCheckIn:@"" checkInDate:@"" bookid:@"" cancelRoom:@"" temp_checkin_date:@"" taxrate:@"" requestStatus:@"" roomrating:str_RoomRating descrip:description adminphone:adminphone clientrating:@"" securitydeposit:str_Security refundpercentage:@""]];
            }
            [self.tableView reloadData];
        }
        else
        {
            NSString *errorMsg =[json objectForKey:@"error"];
            if ([ErrorFunctions isError:errorMsg])
            {
                [self fetchAllRoomsForRentFromState:stateId city:cityId];    
            }
            else
            {
                NSLog(@"Error is %@",[json objectForKey:@"error"]);
                [self showCustomUIAlertViewWithtilet:@"info" andWithMessage:@"There are no room available for rent in this city or date.Please try another date"];
                [self.tableView reloadData];
            }
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
    
}

- (void)dealloc {
    [_stateTF release];
    [_cityTf release];
    [_roomImageView release];
    [_roomAddressLabel release];
    [_bedsRoomsLabel release];
    [_addressView release];
    [_ownerNameLabel release];
    [_ownerPhoneLabel release];
    [_ownerImageView release];
    [_detailView release];
    //[_roomDescrip release];
    [_lbl_priceperRate release];
    [_txtview_Description release];
    [_img_StarRating release];
    [_lbl_SecurityDeposit release];
    [super dealloc];
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
    if ([titel isEqualToString:@"Rent Payment"]) 
    {
        [alertViewController addAction:[NYAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil)style:UIAlertActionStyleDefault handler:^(NYAlertAction *action) 
                                        {
                                            [self dismissViewControllerAnimated:YES completion:nil];
                                            
                                        }]];
        [alertViewController addAction:[NYAlertAction actionWithTitle:NSLocalizedString(@"Continue", nil)style:UIAlertActionStyleDefault handler:^(NYAlertAction *action) 
                                        {
                                            [self dismissViewControllerAnimated:YES completion:^
                                            {
                                         
            [self updateStatusWthitId:@"" renterId:self.userId withStatus:@"requested"];
                                            }];
                                            
                                        }]];
  
        
    }else 
    {
        [alertViewController addAction:[NYAlertAction actionWithTitle:NSLocalizedString(@"Dismiss", nil)style:UIAlertActionStyleDefault handler:^(NYAlertAction *action) 
                                        {
                                            [self dismissViewControllerAnimated:YES completion:^
                                             {
                                                 // added by zia
                                                 if ([message isEqualToString:@"Your reservation request has been sent to the room's owner"]) 
                                                 {
                                                     [self.navigationController popViewControllerAnimated:NO];
                                                 }
                                             }];
                                            
                                        }]];

    }
       
    
    [self presentViewController:alertViewController animated:YES completion:nil];
}
#pragma mark- Detail view
-(void)detailViewSetupwith:(RenterRequest *)request1 roomImage:(UIImage *)roomimg
{
    //    CGFloat imgHight = CGRectGetHeight(self.roomImageView.frame);
    self.roomImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *pgr = [[UITapGestureRecognizer alloc] 
                                     initWithTarget:self action:@selector(handlePinch:)];
    pgr.delegate = self;
    [self.roomImageView addGestureRecognizer:pgr];
    [self roundRectView:self.addressView];
    CGFloat imgWidht = CGRectGetWidth(self.ownerImageView.frame);
    self.ownerImageView.layer.borderColor = White_ColorCG;
    self.ownerImageView.layer.borderWidth = 2.0f;
    self.ownerImageView.layer.cornerRadius = imgWidht/2; 
    self.ownerImageView.layer.masksToBounds = YES;
    
    self.roomImageView.image = roomimg;
    NSLog(@"address :%@",request1.roomAddress);
    
    //rejo29122016
    self.lbl_priceperRate.text = [NSString stringWithFormat:@"$%@/night",request1.roomRentalPrice];
    self.roomAddressLabel.text = [NSString stringWithFormat:@"%@",request1.roomAddress];
    self.bedsRoomsLabel.text = [NSString stringWithFormat:@"%@ Rooms %@ Beds",request1.nubmerOfRooms,request1.nubmerOfBeds];
    self.ownerNameLabel.text = request1.clientName;
    self.ownerPhoneLabel.text = request1.clientphone;
    
    self.lbl_SecurityDeposit.text = [NSString stringWithFormat:@"$%@",request1.securitydeposit];//request1.securitydeposit;
    
    //self.ownerPhoneLabel.text = request1.adminphone;
    
    CGRect frame = CGRectMake(0,0,80,16);
    
    StarRatingView *starviewAnimated1 = [[StarRatingView alloc]initWithFrame:frame andRating:[request1.roomrating intValue] withLabel:NO animated:YES];
    [_img_StarRating addSubview:starviewAnimated1];
    
    //self.roomDescrip.text = [NSString stringWithFormat:@"%@",request1.descript];
    
    self.txtview_Description.text = [NSString stringWithFormat:@"%@",request1.descript];
    //self.txtview_Description.textColor = [UIColor whiteColor];

    //[self.roomDescrip sizeToFit];
    
    [self displayClientImage:request1.clientphoto];
    [self fetchAllPhotos];
}


- (void)handlePinch:(UIPinchGestureRecognizer *)pinchGestureRecognizer
{
    [self showPhotos];
}
- (IBAction)backBtnPressed:(id)sender 
{
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)callBtnPressed:(id)sender 
{
    [self makePhoneCallWithNumber:self.renRequest.clientphone];

}

- (IBAction)detailBackBtnPressed:(id)sender 
{
    [self hideDetailView];
}

- (IBAction)requestBtnPressed:(id)sender 
{
    //_selectedIndex = [sender tag];
    isRequest = YES;
    [self showslectionView];

}
-(void)roundRectView:(UIView *)view
{
   // view.layer.borderColor = White_ColorCG;
    view.layer.borderWidth = 0.0f;
    view.layer.cornerRadius = 8.f; 
    view.layer.masksToBounds = YES;
}
-(void)makePhoneCallWithNumber:(NSString *)pNumber
{
    //NSString *phoneNumber = [@"telprompt://" stringByAppendingString:COMPANY_NUMBER];
    NSString *phoneNumber = [@"telprompt://" stringByAppendingString:pNumber];
    NSString *cleanedString = [[phoneNumber componentsSeparatedByCharactersInSet:[[NSCharacterSet characterSetWithCharactersInString:@"0123456789-+()"] invertedSet]] componentsJoinedByString:@""];
    NSString *escapedPhoneNumber = [cleanedString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *phoneURLString = [NSString stringWithFormat:@"telprompt:%@", escapedPhoneNumber];
    NSURL *phoneURL = [NSURL URLWithString:phoneURLString];
    
    if ([[UIApplication sharedApplication] canOpenURL:phoneURL]) {
        [[UIApplication sharedApplication] openURL:phoneURL];
    }
    
    
}
-(void)displayClientImage:(NSString *)imageName
{
   
    CGFloat imgviewHight = CGRectGetHeight(self.ownerImageView.frame);
    CGFloat imgviewWidth = CGRectGetWidth (self.ownerImageView.frame);
    cSpinner = [[TJSpinner alloc] initWithSpinnerType:kTJSpinnerTypeCircular];
    cSpinner.center = CGPointMake(imgviewWidth / 2, imgviewHight / 2);
    
    cSpinner.hidesWhenStopped = YES;
    [cSpinner setHidden:YES];
    [self.ownerImageView addSubview:cSpinner];
    NSString *imageUrl =[NSString stringWithFormat:@"%@upload/%@",kAPIHost,imageName];
       
    if (![imageName isEqualToString:@"0"]) 
    {   [cSpinner setHidden:NO];
        [cSpinner startAnimating];
       
        [self.ownerImageView setImageWithURLRequest:[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:imageUrl]]placeholderImage:[UIImage imageNamed:@"image_blank.png"]
                                                 success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image)
         {
             
             self.ownerImageView.image = image;
             [cSpinner stopAnimating];
           
             
         }  failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error){
             [cSpinner stopAnimating];
            
         }];
        
    }else 
    {
        
    }
    
    
    
}
#pragma mark

-(void)showPhotos
{
  
    displayActionButton = NO;
    displaySelectionButtons = NO;
    displayNavArrows = YES;
    enableGrid = YES;
    startOnGrid = NO;
    autoPlayOnAppear = NO;
   
    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    browser.displayActionButton = displayActionButton;
    browser.displayNavArrows = displayNavArrows;
    browser.displaySelectionButtons = displaySelectionButtons;
    browser.alwaysShowControls = displaySelectionButtons;
    browser.zoomPhotosToFill = YES;
    browser.enableGrid = enableGrid;
    browser.startOnGrid = startOnGrid;
    browser.enableSwipeToDismiss = YES;
    browser.autoPlayOnAppear = autoPlayOnAppear;
    [browser setCurrentPhotoIndex:0];
    
    [self.navigationController pushViewController:browser animated:YES];
}
-(void)fetchAllPhotos
{
     NSMutableArray *photos = [[NSMutableArray alloc] init];
    NSString *imageName = self.renRequest.roomImage;
    NSArray *imgArray =[imageName componentsSeparatedByString:@","];
   
    for (int i = 0; i < imgArray.count; i++) 
    {
        imageName =[imgArray objectAtIndex:i];
        NSString *imageUrl =[NSString stringWithFormat:@"%@%@",kBASE_ROOM_IMG_URL ,imageName];
        
    [photos addObject:[MWPhoto photoWithURL:[NSURL URLWithString:imageUrl]]];
    }
    
    self.photos = photos;
    if (displaySelectionButtons) {
        _selections = [NSMutableArray new];
        for (int i = 0; i < photos.count; i++) {
            [_selections addObject:[NSNumber numberWithBool:NO]];
        }
    }

}
#pragma mark - MWPhotoBrowserDelegate

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return _photos.count;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index < _photos.count)
        return [_photos objectAtIndex:index];
    return nil;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser thumbPhotoAtIndex:(NSUInteger)index {
    if (index < _thumbs.count)
        return [_thumbs objectAtIndex:index];
    return nil;
}

//- (MWCaptionView *)photoBrowser:(MWPhotoBrowser *)photoBrowser captionViewForPhotoAtIndex:(NSUInteger)index {
//    MWPhoto *photo = [self.photos objectAtIndex:index];
//    MWCaptionView *captionView = [[MWCaptionView alloc] initWithPhoto:photo];
//    return [captionView autorelease];
//}

//- (void)photoBrowser:(MWPhotoBrowser *)photoBrowser actionButtonPressedForPhotoAtIndex:(NSUInteger)index {
//    NSLog(@"ACTION!");
//}

- (void)photoBrowser:(MWPhotoBrowser *)photoBrowser didDisplayPhotoAtIndex:(NSUInteger)index {
    NSLog(@"Did start viewing photo at index %lu", (unsigned long)index);
}

- (BOOL)photoBrowser:(MWPhotoBrowser *)photoBrowser isPhotoSelectedAtIndex:(NSUInteger)index {
    return [[_selections objectAtIndex:index] boolValue];
}

//- (NSString *)photoBrowser:(MWPhotoBrowser *)photoBrowser titleForPhotoAtIndex:(NSUInteger)index {
//    return [NSString stringWithFormat:@"Photo %lu", (unsigned long)index+1];
//}

- (void)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index selectedChanged:(BOOL)selected {
    [_selections replaceObjectAtIndex:index withObject:[NSNumber numberWithBool:selected]];
    NSLog(@"Photo at index %lu selected %@", (unsigned long)index, selected ? @"YES" : @"NO");
}

- (void)photoBrowserDidFinishModalPresentation:(MWPhotoBrowser *)photoBrowser {
    // If we subscribe to this method we must dismiss the view controller ourselves
    NSLog(@"Did finish modal presentation");
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Load Assets

- (void)loadAssets {
    if (NSClassFromString(@"PHAsset")) {
        
        // Check library permissions
        PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
        if (status == PHAuthorizationStatusNotDetermined) {
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                if (status == PHAuthorizationStatusAuthorized) {
                    [self performLoadAssets];
                }
            }];
        } else if (status == PHAuthorizationStatusAuthorized) {
            [self performLoadAssets];
        }
        
    } else {
        
        // Assets library
        [self performLoadAssets];
        
    }
}

- (IBAction)action_Email:(id)sender {
    if([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *mailCont = [[MFMailComposeViewController alloc] init];
        mailCont.mailComposeDelegate = self;        // Required to invoke mailComposeController when send
        
        [mailCont setSubject:@"RideGreen"];
        [mailCont setToRecipients:[NSArray arrayWithObject:@""]];
        [mailCont setMessageBody:@"subject" isHTML:NO];
        
        [self presentViewController:mailCont animated:YES completion:nil];
    }
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    [controller dismissViewControllerAnimated:YES completion:nil];
}

- (void)performLoadAssets {
    
    // Initialise
    _assets = [NSMutableArray new];
    
    // Load
    if (NSClassFromString(@"PHAsset")) {
        
        // Photos library iOS >= 8
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            PHFetchOptions *options = [PHFetchOptions new];
            options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
            PHFetchResult *fetchResults = [PHAsset fetchAssetsWithOptions:options];
            [fetchResults enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                [_assets addObject:obj];
            }];
            if (fetchResults.count > 0) {
                [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
            }
        });
        
    } else {
        
        // Assets Library iOS < 8
        _ALAssetsLibrary = [[ALAssetsLibrary alloc] init];
        
        // Run in the background as it takes a while to get all assets from the library
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            NSMutableArray *assetGroups = [[NSMutableArray alloc] init];
            NSMutableArray *assetURLDictionaries = [[NSMutableArray alloc] init];
            
            // Process assets
            void (^assetEnumerator)(ALAsset *, NSUInteger, BOOL *) = ^(ALAsset *result, NSUInteger index, BOOL *stop) {
                if (result != nil) {
                    NSString *assetType = [result valueForProperty:ALAssetPropertyType];
                    if ([assetType isEqualToString:ALAssetTypePhoto] || [assetType isEqualToString:ALAssetTypeVideo]) {
                        [assetURLDictionaries addObject:[result valueForProperty:ALAssetPropertyURLs]];
                        NSURL *url = result.defaultRepresentation.url;
                        [_ALAssetsLibrary assetForURL:url
                                          resultBlock:^(ALAsset *asset) {
                                              if (asset) {
                                                  @synchronized(_assets) {
                                                      [_assets addObject:asset];
                                                      if (_assets.count == 1) {
                                                          // Added first asset so reload data
                                                          [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
                                                      }
                                                  }
                                              }
                                          }
                                         failureBlock:^(NSError *error){
                                             NSLog(@"operation was not successfull!");
                                         }];
                        
                    }
                }
            };
            
            // Process groups
            void (^ assetGroupEnumerator) (ALAssetsGroup *, BOOL *) = ^(ALAssetsGroup *group, BOOL *stop) {
                if (group != nil) {
                    [group enumerateAssetsWithOptions:NSEnumerationReverse usingBlock:assetEnumerator];
                    [assetGroups addObject:group];
                }
            };
            
            // Process!
            [_ALAssetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll
                                            usingBlock:assetGroupEnumerator
                                          failureBlock:^(NSError *error) {
                                              NSLog(@"There is an error");
                                          }];
            
        });
        
    }
    
}



@end
