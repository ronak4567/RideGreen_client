//
//  PlanTourView.m
//  ridegreen
//
//  Created by Ridegreen on 31/08/2015.
//  Copyright (c) 2015 Ridegreen. All rights reserved.
//


#import "PlanTourView.h"

@interface PlanTourView ()

@end

@implementation PlanTourView

- (void)viewDidLoad {
    
    isTableViewShown = NO ;
    stateIds   =[NSMutableArray new];
    stateNames =[NSMutableArray new];
    cityNames  =[NSMutableArray new];
    cityIds    =[NSMutableArray new];
    allDrivers =[NSMutableArray new];
     marray_CityTax = [NSMutableArray new];
    delg =(AppDelegate *)[[UIApplication sharedApplication]delegate];
    [self setupUITextFileds];
    
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated
{
    [self screenStup];
    
     
    
    [super viewWillAppear:YES];
}

-(void)screenStup
{
    
    
  [self fetchAllStates];
        
 
    
    if (delg.isRigesterTour) 
    {
        
        [self showAvailableDriverTabel];
    }else 
    {
        [self hideAvailableDriverTabel];
    }
    

}

-(void)setupUITextFileds
{
    NSArray *fields = [NSArray arrayWithObjects:self.stateTF,self.cityTf,self.tourDateTf,self.tour_numberOfHourTF,self.tour_startTimeTF, nil]; //get all subviews from your scrollview
    
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
    
    
    self.tour_numberOfHourTF.isOptionalDropDown = YES;
    
    [self.tour_numberOfHourTF setPlaceholder:@"Number of hours ?"];
    [self.tour_numberOfHourTF setOptionalItemText:NSLocalizedString(@"Number of hours ?", nil)];
    
    NSArray *numberArray =[[NSArray alloc] initWithObjects:@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23",@"24", nil];
    
    [self.tour_numberOfHourTF setItemList:numberArray];
    
    CGPoint position = self.tourDateTf.frame.origin;
    
    CGRect sFrame = self.tour_startTimeTF.frame;
    CGRect eFrame = self.tour_endTimeTf.frame;
    sFrame.origin.x = position.x;
    eFrame.origin.x = position.x +self.tour_startTimeTF.frame.size.width +5 ;
    self.tour_startTimeTF.frame = sFrame;
    self.tour_endTimeTf.frame  = eFrame;
    
    UIToolbar *toolbar = [[UIToolbar alloc] init];
    [toolbar setBarStyle:UIBarStyleBlackTranslucent];
    [toolbar sizeToFit];
    UIBarButtonItem *buttonflexible = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *buttonDone = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneClicked:)];
    
    [toolbar setItems:[NSArray arrayWithObjects:buttonflexible,buttonDone, nil]];
    _tourDateTf.inputAccessoryView = toolbar;
     self.tour_startTimeTF.inputAccessoryView = toolbar;
    [_tourDateTf setDropDownMode:IQDropDownModeDatePicker];
    [self.tour_startTimeTF setDropDownMode:IQDropDownModeTimePicker];

    
    
    self.tour_numberOfHourTF.inputAccessoryView = toolbar;

    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    [_tourDateTf setDateFormatter:dateFormatter];
    [self.view insertSubview:_tourDateTf belowSubview:_availableView];
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
        
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [stateIds removeAllObjects];
        [stateNames removeAllObjects];
        
        if (![json objectForKey:@"error"]) 
        {
            NSArray *results=[json objectForKey:@"result"];
            //NSLog(@"result %@",results);
            for (int i=0; i<results.count; i++) {
                NSDictionary *res =[results objectAtIndex:i];
                
                // adding user adis in array
                [stateNames addObject:[[res objectForKey:@"name"] capitalizedString]];
                [stateIds addObject:[res objectForKey:@"id"]];
                
                
                
            }
            
            
            [self.selectionTable reloadData];
            
        }
        
        else
        {
            [self.selectionTable reloadData];
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
        
        [[NSUserDefaults standardUserDefaults] synchronize];
        [cityNames removeAllObjects];
        [cityIds removeAllObjects];
        [marray_CityTax removeAllObjects];
        
        
        if (![json objectForKey:@"error"] && json != nil) 
        {
                       
            NSArray *results=[json objectForKey:@"result"];
            //NSLog(@"result %@",results);
            for (int i=0; i<results.count; i++) {
                NSDictionary *res =[results objectAtIndex:i];
                
                // adding user adis in array
                [cityNames addObject:[[res objectForKey:@"name"] capitalizedString]];
                [cityIds addObject:[res objectForKey:@"id"]];
                [marray_CityTax addObject:[res objectForKey:@"taxrate"]];
            }
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
           [self.selectionTable reloadData];
            
        }
        
        else
        {
            // if reques error call again
            [self.selectionTable reloadData];
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


-(void)fetchAvailableDriversOfCity :(NSString *)cityId withTourDate :(NSString *) toureDate tourStartUpTime:(NSString *)StartTime tourTravelHours:(NSString *)travelHours
{
    
    MBProgressHUD *hud =[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Checking availability";
    NSMutableDictionary *params=[[NSMutableDictionary alloc]initWithObjectsAndKeys:@"get_available_driver",@"command",cityId,@"city_id",toureDate ,@"tour_date" ,StartTime,@"start_time",travelHours,@"number_hours",  nil];
    
    
    //",startTime,@"
    
    
    [[NetworkHelper sharedInstance] commandWithParams:params onCompletion:^(NSDictionary *json) {
        
        NSLog(@"the json return is %@",json);
        
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        
        
        if (![json objectForKey:@"error"]) 
        {
             [MBProgressHUD hideHUDForView:self.view animated:YES];
            [allDrivers removeAllObjects];
            NSArray *results=[json objectForKey:@"result"];
            //NSLog(@"result %@",results);
            for (int i=0; i<results.count; i++) {
                NSDictionary *res =[results objectAtIndex:i];
                
                // adding user adis in array
                NSString *did =[res objectForKey:@"id"]; 
                NSString *dname =[NSString stringWithFormat:@"%@",[res objectForKey:@"first_name"]];
                NSString *dImage  =[res objectForKey:@"photo"];
                NSString *dRate = [res objectForKey:@"rate_per_hour"];
                NSString *dCity = [res objectForKey:@"city_name"];
                #warning change with guide rating
                NSString *dRating =[res objectForKey:@"driver_rating"];
                [allDrivers addObject:[AvailableDriver setDriverId:did DriverName:dname DriverImage:dImage PerHourRate:dRate driverCity:dCity dRating:dRating]];

                
                
                
            }
            [self showAvailableDriverTabel];
            
            [self.tableView reloadData];
        }
        else
        {
            // if reques error call again
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            NSString *errorMsg =[json objectForKey:@"error"];
            if ([ErrorFunctions isError:errorMsg])
            {
               //[self fetchAvailableDriversOfCity:cityId withTourDate:toureDate];
                
                [self fetchAvailableDriversOfCity:cityId withTourDate:toureDate tourStartUpTime:StartTime tourTravelHours:travelHours];
            }
            else if ([errorMsg isEqualToString:@"No record Found"])
            {
                [self showCustomUIAlertViewWithtilet:@"Info" andWithMessage:@"No driver Available!\nPlease try again later"];
                NSLog(@"Error is %@",[json objectForKey:@"error"]);
            }else 
            {
            
                NSLog(@"Error is %@",[json objectForKey:@"error"]);

            }
        }
    }];
    
    
    
    
}
-(void)showAvailableDriverTabel
{
    
    isTableViewShown = YES ;
    [UIView animateWithDuration:0.5
                          delay:0.0
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         [self.StateDropDownMenu setAlpha:0.0];
                         [self.citiesDropDownMenu setAlpha:0.0];
                         [self.availableView setAlpha:1.0];
                         
                     }
                     completion:^(BOOL finished){
                         ////NSLog(@"Done!");
                     }];

}
-(void)hideAvailableDriverTabel
{
    isTableViewShown = NO;
    [UIView animateWithDuration:0.5
                          delay:0.0
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         [self.StateDropDownMenu setAlpha:1.0];
                         [self.citiesDropDownMenu setAlpha:1.0];
                         [self.availableView setAlpha:0.0];
                     }
                     completion:^(BOOL finished){
                         ////NSLog(@"Done!");
                     }];
    
}

-(NSDate *)getDateFromString:(NSString *)dateString
{
    
    
    // Convert string to date object
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [dateFormat dateFromString:dateString];  
    
   
      
    return date; 

}
#pragma mark UIButton IBActions 


- (IBAction)availableDriversBtnPressed:(id)sender 
{
    delg.tourSelectedDate = _tourDateTf.text;
    delg.tourStartUpTime = self.tour_startTimeTF.text;
    delg.tourTravelHours = self.tour_numberOfHourTF.text;
    
    [_tourDateTf resignFirstResponder];
    //[selectedDate];
    NSDate *selectedDate = [self getDateFromString:_tourDateTf.text];
    if ([selectedDate isToday] || [selectedDate isLaterThanDate:[NSDate date]]) 
    {
        if ([_tourDateTf.text length] != 0 && [_selectedCityId length] != 0 && [self.tour_numberOfHourTF.text length] != 0 && [self.tour_startTimeTF.text length] != 0)
        {
            //[self fetchAvailableDriversOfCity:_selectedCityId withTourDate:_tourDateTf.text];
            
            
            
            [self fetchAvailableDriversOfCity:_selectedCityId withTourDate:self.tourDateTf.text tourStartUpTime:self.tour_startTimeTF.text tourTravelHours:self.tour_numberOfHourTF.text];
            
            
            
            
        }else 
        {
            
            [self showCustomUIAlertViewWithtilet:@"Info" andWithMessage:@"Please Provide correct information"];
        }
   
        
    }else 
    {
     [self showCustomUIAlertViewWithtilet:@"Info" andWithMessage:@"Invalid date"];
    
    }
    
}
-(IBAction)changeDateBtnPressed:(id)sender
{
    [self hideAvailableDriverTabel];

}
- (IBAction)backBtnPressed:(id)sender 
{

    if (isTableViewShown) 
    {
        [self hideAvailableDriverTabel];
    }else 
    {
        delg.isRigesterTour = NO;
        [cityNames removeAllObjects];
        [cityIds removeAllObjects];
        [marray_CityTax removeAllObjects];
     [self.navigationController popViewControllerAnimated:NO];
    }
   
}

-(void)doneClicked:(UIBarButtonItem*)button
{
    [self.view endEditing:YES];
}
#pragma mark - Table view data source
#pragma mark UITableView Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UIView *view =[[UIView alloc] initWithFrame:CGRectZero];
   // x,y,width,height
    
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    if (tableView == _tableView) 
    {
        return 86;
    }else 
    {
    return 40;
    }
    
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
        
        
    }
    return sectionName;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
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
    }
    else 
    {
        return allDrivers.count;
    }
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString* cellIdentifier = @"ADCell";
 
    static NSString* cellIdentifier2 = @"cell";
    UITableViewCell* cell2 = [tableView dequeueReusableCellWithIdentifier:cellIdentifier2];

    AvailableDriverCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (tableView == self.selectionTable)
    {
        if (!cell2)
        {
            cell2 = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
        }
        // for cities
        if (isState)
        {
            cell2.textLabel.text= [stateNames objectAtIndex:indexPath.row];
            if ([cell2.textLabel.text isEqualToString:_selectedStateName]) {
                cell2.accessoryType = UITableViewCellAccessoryCheckmark;
                
            }else
            {
                cell2.accessoryType = UITableViewCellAccessoryNone;
            }
            
        }else if (isCity)
        {
            // for blood groups
            cell2.textLabel.text= [cityNames objectAtIndex:indexPath.row];
            if ([cell2.textLabel.text isEqualToString:_selectedCityName]) {
                cell2.accessoryType = UITableViewCellAccessoryCheckmark;
                
            }else
            {
                cell2.accessoryType = UITableViewCellAccessoryNone;
            }
            
        }
                
        
        return cell2;
        
        
    }else 
    {
        if (!cell)
        {
            cell = [[AvailableDriverCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            
        }
        TJSpinner *spinner = [[TJSpinner alloc] initWithSpinnerType:kTJSpinnerTypeCircular];
        spinner.center = CGPointMake(cell.driverImageView.frame.size.width / 2, cell.driverImageView.frame.size.height / 2);
        spinner.hidesWhenStopped = YES;
        [spinner setHidden:YES];

        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        AvailableDriver *driver =[allDrivers objectAtIndex:indexPath.row];
        cell.driverName.text = driver.dName;
        cell.perHourRate.text =[NSString stringWithFormat:@"$%@/hr", driver.dPerHourRate];
        cell.cityName.text = driver.dCity;
        
        cell.driverImageView.layer.borderWidth = 2.0f;
        cell.driverImageView.layer.borderColor =[UIColor lightGrayColor].CGColor;
        cell.driverImageView.layer.masksToBounds = YES;
        cell.regidterTourBtn.tag = indexPath.row;
        [cell.regidterTourBtn addTarget:self action:@selector(regidterTourBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
        CGPoint origin = cell.driverImageView.frame.origin;
        
        cell.driverImageView.layer.cornerRadius = cell.driverImageView.frame.size.width/2;
        CGRect frame = CGRectMake(origin.x, 48,70,15);
        
        StarRatingView *starviewAnimated = [[StarRatingView alloc]initWithFrame:frame andRating:[driver.dRating intValue] withLabel:NO animated:YES];
        [cell.bgView addSubview:starviewAnimated];
        
        
        
        [cell.driverImageView addSubview:spinner];
        NSString *imageName = driver.dIamge;
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
            
            [spinner setHidden:YES];
            [spinner startAnimating];
            [cell.driverImageView setImageWithURLRequest:[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:imageUrl]]
            placeholderImage:[UIImage imageNamed:@"image_blank.png"]
            success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image)
             {
                 
                 cell.driverImageView.image = image;
                 cell.isImage = YES;
                 [spinner stopAnimating];
                 
             }
            failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error)
             
             {
                 
                 [spinner stopAnimating]; 
                 cell.isImage = NO; 
                 
             }];
        }
        
    }
   
    
    return cell;    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   // UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
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
        _str_CityTaxRate = [marray_CityTax objectAtIndex:indexPath.row];
        
        delg.tourTaxRate = _str_CityTaxRate;
        [self.cityTf setText:_selectedCityName]; 
        [self.cityTf resignFirstResponder];
        
        isCity = NO;
        
       
    }
        
    
    [self hideAlertView:alertView];
}


-(IBAction)regidterTourBtnPressed:(id)sender
{
    
    AvailableDriver *driver =[allDrivers objectAtIndex:[sender tag]];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName: @"Main" bundle: nil];
    RegisterTourView * sv = [storyboard instantiateViewControllerWithIdentifier:@"RegisterTour"];
    sv.selectedDriverId = driver.dId;
    sv.tourDateTF.text = self.tourDateTf.text;
    sv.selectedCityId = _selectedCityId;
    sv.perHourRate = driver.dPerHourRate;
    sv.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self.navigationController pushViewController:sv animated:NO];
    delg.isRigesterTour = YES;

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
    
    
    [self presentViewController:alertViewController animated:YES completion:nil];
}




/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
