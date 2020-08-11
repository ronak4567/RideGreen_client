//
//  MyRentalView.m
//  ridegreen
//
//  Created by Ridegreen on 28/10/2015.
//  Copyright (c) 2015 Ridegreen. All rights reserved.
//

#import "MyRentalView.h"
const NSString *changingFee = @"1";
@interface MyRentalView (){
    NSString *totalPayment;
    RenterRequest *commenRequest;
    NSString *totalEditpayment;
}

@end

@implementation MyRentalView

- (void)viewDidLoad {
    
    myRentalrooms  =[NSMutableArray new];
    allRentedrooms =[NSMutableArray new];
    allRequestes   =[NSMutableArray new];
    userdefault =[NSUserDefaults standardUserDefaults];
    CGRect tableFrame = self.tableView.frame;
    tableFrame.origin.y = _isMyRented ? 67 : 126;
    selectedSegment = _isMyRented ? 3 : 0;
    self.tableView.frame = tableFrame;
    self.userId =[userdefault objectForKey:@"user_id"];
    
    if (!_isMyRented)
    {
        [self drawSegmentedController];
        if ([_str_MyRequest isEqualToString:@"MyRequest"]) {
            [self fetchAllRequest];
            selectedSegment = _isMyRented ? 3 : 1;
        }
        else
        {
        [self fetchMyRentel];
            
        }
        // UIImage *titelImg =[UIImage imageNamed:@"myrental.png"];
        //[_screentitelImageView setImage:titelImg];
        self.screentitelImageView.hidden = NO;
        self.img_ReserveRoom.hidden = YES;
        
    }else
    {
        // UIImage *titelImg =[UIImage imageNamed:@"hired.png"];
        //[_screentitelImageView setImage:titelImg];
        self.screentitelImageView.hidden = YES;
        self.img_ReserveRoom.hidden = NO;
        
        [self fetchMyRented];
    }
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)drawSegmentedController
{
    CGFloat viewWidth = CGRectGetWidth(self.view.frame);
    
    _segmentedControl = [[HMSegmentedControl alloc] initWithSectionTitles:@[@"My Rental",@"Requested",@"Rented"]];
    [_segmentedControl setFrame:CGRectMake(0, 67, viewWidth , 60)];
    _segmentedControl.backgroundColor = White_Color ;
    _segmentedControl.type = HMSegmentedControlTypeText;
    _segmentedControl.verticalDividerColor = kSegmentedIndicatorColor;
    _segmentedControl.verticalDividerEnabled = YES;
    _segmentedControl.verticalDividerWidth = 1.0f;
    _segmentedControl.selectionIndicatorHeight = 6.0f;
    _segmentedControl.titleTextAttributes = @{NSForegroundColorAttributeName : kSegmentedIndicatorColor };
    _segmentedControl.selectionIndicatorColor = kSegmentedIndicatorColor;
    _segmentedControl.segmentWidthStyle = HMSegmentedControlSegmentWidthStyleFixed;
    _segmentedControl.selectionStyle = HMSegmentedControlSelectionStyleFullWidthStripe;
    _segmentedControl.selectedSegmentIndex = HMSegmentedControlNoSegment;
    _segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    _segmentedControl.shouldAnimateUserSelection = YES;
    
    
    if ([_str_MyRequest isEqualToString:@"MyRequest"])
        _segmentedControl.selectedSegmentIndex = 1;
    else
    _segmentedControl.selectedSegmentIndex = 0;
    
    
    
    _segmentedControl.tag = 2;
    
    _segmentedControl.layer.cornerRadius = 8.0f;
    _segmentedControl.layer.masksToBounds = NO;
    _segmentedControl.layer.shadowOpacity = 0.8;
    _segmentedControl.layer.shadowRadius = 5;
    _segmentedControl.layer.shadowOffset = CGSizeMake(2.0f, 2.0f);
    
    [_segmentedControl setIndexChangeBlock:^(NSInteger index) 
     {
         
         
         selectedSegment = index;
         
         
         switch (selectedSegment) {
             case 0:
                 [self fetchMyRentel];
                 break;
             case 1:
                 [self fetchAllRequest];
                 break;
             case 2:
                 [self fetchAllRented];
                 break;
             case 3:
                 [self fetchMyRented];
                 break;
             default:
                 break;
         }
     }];
    
    [self.view addSubview:_segmentedControl];
    
    
}

#pragma mark web services 
-(void)fetchMyRentel
{
    MBProgressHUD *hue=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hue.labelText=@"";
    NSMutableDictionary *params=[[NSMutableDictionary alloc]initWithObjectsAndKeys:@"my_rental",@"command",self.userId,@"user_id", nil];
    
    [[NetworkHelper sharedInstance] commandWithParams:params onCompletion:^(NSDictionary *json) {
          [myRentalrooms removeAllObjects];
        //NSLog(@"the json return is %@",json);
        if (![json objectForKey:@"error"]&& json!=nil)
        {
            //NSArray *results=[json objectForKey:@"result"];
            [[CMyRental alloc] updateClientRental:json];
            //VGS
            [MBProgressHUD hideHUDForView:self.view animated:YES];

            
        }else
        {
            [self reloadTable];
            NSString *errorMsg =[json objectForKey:@"error"];
            if ([ErrorFunctions isError:errorMsg])
                [self fetchMyRentel];
            else
                [self showHudWithText:errorMsg];
            
            if ([errorMsg isEqualToString:@"No Record Found."])
                [[CMyRental alloc] deleteAllDataRental];
        }
        [self updateRentalUI];
    }];
    
}

-(void)updateRentalUI
{
    NSMutableArray *results = [[CMyRental alloc] fetchClientRental];
    for (int i=0; i<[results count]; i++)
    {
        NSDictionary *res = [results objectAtIndex:i];
        NSLog(@"result:%@",res);
        CMyRental *obj_cl = (CMyRental *)res;
        NSString *roomId = obj_cl.idField;
        NSString *roomAddress = obj_cl.roomAddress;
        NSString *roomRentalPrice = obj_cl.ratePerMonth;
        NSString *requestedDate =obj_cl.requestedDate;
        NSString *roomhRentalDate =obj_cl.rentedDate;
        NSString *disabled =obj_cl.status;
        NSString *roomStatus =obj_cl.rentedStatus;
        NSString *numberofRooms =obj_cl.rooms;
        NSString *numberofBeds =obj_cl.beds;
        NSString *roomImage  = obj_cl.roomImage;
        NSString *roomType  = obj_cl.roomType;
        
        [myRentalrooms addObject:[RentalRooms setRoomId:roomId roomAddress:roomAddress nubmerOfRooms:numberofRooms nubmerOfBeds:numberofBeds roomRentalPrice:roomRentalPrice roomRentaldate:roomhRentalDate isEnable:disabled roomStatus:roomStatus requestedDate:requestedDate roomImage:roomImage roomType:roomType]];
    }
    [self reloadTable];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
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
-(void)fetchAllRequest
{
    //command=get_room_by_status&rented_status=requested&user_id=170
    MBProgressHUD *hue=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hue.labelText=@"";
    NSMutableDictionary *params=[[NSMutableDictionary alloc]initWithObjectsAndKeys:@"get_room_by_status",@"command",@"requested",@"rented_status",self.userId,@"user_id", nil];
    
    [[NetworkHelper sharedInstance] commandWithParams:params onCompletion:^(NSDictionary *json) {
        
        //NSLog(@"the json return is %@",json);
         [allRequestes removeAllObjects];
        if (![json objectForKey:@"error"]&& json!=nil)
        {
            [[CMyRequested alloc] updateClientRequested:json];
            
        }else
        {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            NSString *errorMsg =[json objectForKey:@"error"];
            if ([ErrorFunctions isError:errorMsg])
            {
                [self fetchAllRequest];    
            }
            else
            {
                [self showHudWithText:errorMsg];
            }
            
            if ([errorMsg isEqualToString:@"No Record Found."])
                [[CMyRequested alloc] deleteAllDataRequested];

            [self reloadTable];
            
            [self showHudWithText:[json objectForKey:@"error"]];
            
        }
        
        [self updateRequestedUi];
    }];
}


-(void)updateRequestedUi
{
    //NSArray *results=[json objectForKey:@"result"];
    NSMutableArray *results = [[CMyRequested alloc] fetchClientRequested];
    
    for (int i=0; i<[results count]; i++)
    {
        NSDictionary *res = [results objectAtIndex:i];
        NSLog(@"result:%@",res);
        CMyRequested *obj_cl = (CMyRequested *)res;
        NSString *roomId = obj_cl.idField;
        NSString *roomAddress = obj_cl.roomAddress;
        NSString *roomRentalPrice = obj_cl.ratePerMonth;
        NSString *roomhRentalDate =obj_cl.createdon;
        NSString *roomStatus =obj_cl.status;
        NSString *numberofRooms =obj_cl.rooms;
        NSString *numberofBeds =obj_cl.beds;
        NSString *cId =obj_cl.renterId;
        NSString *requestedDate =obj_cl.requestedDate;
        NSString *cName      =obj_cl.firstName;
        NSString *cphone     =obj_cl.mobile;
        NSString *cphoto     =obj_cl.photo;
        NSString *cusId      =obj_cl.customerid;
        NSString *rent       =obj_cl.totalPayment;
        NSString *roomImage  = obj_cl.roomImage;
        NSString *roomType  = obj_cl.roomType;
        NSString *noOfDays  = obj_cl.noOfDays;
        NSString *isCheckIn =obj_cl.isCheckIn;
        NSString *checkInDate =obj_cl.checkinDate;
        NSString *roomrating =obj_cl.roomrating;
        NSString *client_rating = obj_cl.clientrating;
        NSString *str_refundedPercentage = obj_cl.refundpercentage;
  
        
        [allRequestes addObject:[RenterRequest setRequestedRoomId:roomId roomAddress:roomAddress nubmerOfRooms:numberofRooms nubmerOfBeds:numberofBeds roomRentalPrice:roomRentalPrice roomRentaldate:roomhRentalDate isEnable:roomStatus clientId:cId clientName:cName clientphone:cphone clientadress:@"" clientphoto:cphoto customerId:cusId totelRent:rent roomImage:roomImage roomType:roomType numberOfDays:noOfDays requestedDate:requestedDate isCheckIn:isCheckIn checkInDate:checkInDate bookid:obj_cl.bookingId cancelRoom:obj_cl.cancelRoom temp_checkin_date:obj_cl.tempCheckinDate taxrate:obj_cl.taxRate requestStatus:obj_cl.rentedStatus roomrating:roomrating descrip:@"" adminphone:@"" clientrating:client_rating securitydeposit:@"" refundpercentage:str_refundedPercentage]];
        
    }
    [self reloadTable];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

-(void)fetchAllRented
{
    MBProgressHUD *hue=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hue.labelText=@"";
    NSMutableDictionary *params=[[NSMutableDictionary alloc]initWithObjectsAndKeys:@"get_room_by_status",@"command",@"rented",@"rented_status",self.userId,@"user_id", nil];
    
    [[NetworkHelper sharedInstance] commandWithParams:params onCompletion:^(NSDictionary *json) {
        
        NSLog(@"the json return is %@",json);
        [allRequestes removeAllObjects];
        if (![json objectForKey:@"error"]&& json!=nil)
        {
            [[CMyRented alloc] updateClientRented:json];
        }else
        {
            [self reloadTable];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            NSString *errorMsg =[json objectForKey:@"error"];
            if ([ErrorFunctions isError:errorMsg])
                [self fetchAllRented];    
            else
                [self showHudWithText:errorMsg];
            
            if ([errorMsg isEqualToString:@"No Record Found."])
                [[CMyRented alloc] deleteAllDataRented];
            
            [self reloadTable];
        }
        [self updateRentedUI];
    }];
}

-(void)updateRentedUI
{
    //NSArray *results=[json objectForKey:@"result"];
    NSMutableArray *results = [[CMyRented alloc] fetchClientRented];
    for (int i=0; i<[results count]; i++)
    {
        NSDictionary *res = [results objectAtIndex:i];
        //NSLog(@"result:%@",res);
        CMyRented *obj_cl = (CMyRented *)res;
        NSString *roomId = obj_cl.idField;
        NSString *roomAddress = obj_cl.roomAddress;
        NSString *roomRentalPrice = obj_cl.ratePerMonth;
        NSString *roomhRentalDate =obj_cl.createdon;
        NSString *roomStatus =obj_cl.status;
        NSString *numberofRooms =obj_cl.rooms;
        NSString *numberofBeds =obj_cl.beds;
        NSString *cId =obj_cl.renterId;
        NSString *cName      =obj_cl.firstName;
        NSString *cphone     =obj_cl.mobile;
        NSString *cphoto     =obj_cl.photo;
        NSString *cusId      =obj_cl.customerid;
        NSString *rent       =obj_cl.totalPayment;
        NSString *roomImage  = obj_cl.roomImage;
        NSString *roomType  = obj_cl.roomType;
        NSString *noOfDays  = obj_cl.noOfDays;
        NSString *rentedDate =obj_cl.rentedDate;
        NSString *isCheckIn =obj_cl.isCheckIn;
        NSString *checkInDate =obj_cl.checkinDate;
        NSString *roomrating =obj_cl.roomrating;
        NSString *admin_phone = obj_cl.adminphone;
        NSString *str_clientRating = obj_cl.clientrating;
        
        
        [allRequestes addObject:[RenterRequest setRequestedRoomId:roomId roomAddress:roomAddress nubmerOfRooms:numberofRooms nubmerOfBeds:numberofBeds roomRentalPrice:roomRentalPrice roomRentaldate:roomhRentalDate isEnable:roomStatus clientId:cId clientName:cName clientphone:cphone clientadress:@"" clientphoto:cphoto customerId:cusId totelRent:rent roomImage:roomImage roomType:roomType numberOfDays:noOfDays requestedDate:rentedDate isCheckIn:isCheckIn checkInDate:checkInDate bookid:obj_cl.bookingId cancelRoom:obj_cl.cancelRoom temp_checkin_date:obj_cl.tempCheckinDate taxrate:obj_cl.taxRate requestStatus:obj_cl.rentedStatus roomrating:roomrating descrip:@"" adminphone:admin_phone clientrating:str_clientRating securitydeposit:@"" refundpercentage:@""]];
        
    }
    [self reloadTable];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

//
-(void)fetchMyRented
{
    //command=get_room_by_status&rented_status=requested&user_id=170
    MBProgressHUD *hue=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hue.labelText=@"";
    NSMutableDictionary *params=[[NSMutableDictionary alloc]initWithObjectsAndKeys:@"my_rented_rooms",@"command",self.userId,@"renter_id", nil];
    
    [[NetworkHelper sharedInstance] commandWithParams:params onCompletion:^(NSDictionary *json) {
        
        //NSLog(@"the json return is %@",json);
        [allRentedrooms removeAllObjects];
        if (![json objectForKey:@"error"]&& json!=nil)
        {
            [[CMyRequested alloc] updateClientRequested:json];
        }else
        {
            [self reloadTable];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            NSString *errorMsg =[json objectForKey:@"error"];
            if ([ErrorFunctions isError:errorMsg])
                [self fetchMyRented];
            else
                [self showHudWithText:errorMsg];
           
            
            if ([errorMsg isEqualToString:@"No Record Found."]){
                [[CMyRequested alloc] deleteAllDataRequested];
                [self showCustomUIAlertViewWithtilets:@"My Reservation" andWithMessage:@"You have no Reservations"];
            }
        }
        
        [self updateReservationUi];
    }];
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








-(void)updateReservationUi
{
    //NSArray *results=[json objectForKey:@"result"];
    NSMutableArray *results = [[CMyRequested alloc] fetchClientRequested];
    for (int i=0; i<[results count]; i++)
    {
        NSDictionary *res = [results objectAtIndex:i];
        NSLog(@"result:%@",res);
        CMyRequested *obj_cl = (CMyRequested *)res;
        NSString *roomId = obj_cl.idField;
        NSString *roomAddress = obj_cl.roomAddress;
        NSString *roomRentalPrice = obj_cl.ratePerMonth;
        NSString *roomhRentalDate =obj_cl.createdon;
        NSString *roomStatus =obj_cl.status;
        
        NSString *numberofRooms =obj_cl.rooms;
        NSString *numberofBeds =obj_cl.beds;
        NSString *cId =obj_cl.renterId;
        NSString *cName      =obj_cl.firstName;
        NSString *cphone     =obj_cl.mobile;
        NSString *cphoto     =obj_cl.photo;
        NSString *cusId      =obj_cl.customerid;
        NSString *rent       =obj_cl.totalPayment;
        NSString *roomImage  = obj_cl.roomImage;
        NSString *roomType  = obj_cl.roomType;
        NSString *noOfDays  = obj_cl.noOfDays;
        NSString *rentedDate =obj_cl.rentedDate;
        NSString *isCheckIn =obj_cl.isCheckIn;
        NSString *checkInDate =obj_cl.checkinDate;
        NSString *admin_phone = obj_cl.adminphone;
        NSString *str_clientRating =obj_cl.clientrating;
        NSString *str_refundPercentage = obj_cl.refundpercentage;
        
        [allRentedrooms addObject:[RenterRequest setRequestedRoomId:roomId roomAddress:roomAddress nubmerOfRooms:numberofRooms nubmerOfBeds:numberofBeds roomRentalPrice:roomRentalPrice roomRentaldate:roomhRentalDate isEnable:roomStatus clientId:cId clientName:cName clientphone:cphone clientadress:@"" clientphoto:cphoto customerId:cusId totelRent:rent roomImage:roomImage roomType:roomType numberOfDays:noOfDays requestedDate:rentedDate isCheckIn:isCheckIn checkInDate:checkInDate bookid:obj_cl.bookingId cancelRoom:obj_cl.cancelRoom temp_checkin_date:obj_cl.tempCheckinDate taxrate:obj_cl.taxRate requestStatus:obj_cl.rentedStatus roomrating:obj_cl.roomrating descrip:@"" adminphone:admin_phone clientrating:str_clientRating securitydeposit:@"" refundpercentage:str_refundPercentage]];
        
    }
    [self reloadTable];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

#pragma mark - Table view data source
#pragma mark UITableView Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView != self.selectionTable){
        
        if (selectedSegment == 0)
        {
            return  220;
        }else
        {
            return 206;
        }
    }
    return 44;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(tableView != self.selectionTable){
        return 1;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(tableView != self.selectionTable){
        UIView *view =[[UIView alloc] initWithFrame:CGRectZero];
        return view;
    }
    return  nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if(tableView != self.selectionTable){
        return 1;
    }
    return 0;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if(tableView != self.selectionTable){
        //CGFloat headerWidth = CGRectGetWidth(self.view.frame);
        UIView *view =[[UIView alloc] initWithFrame:CGRectZero];
        return view;
    }
    return nil;
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if(tableView == self.selectionTable)
    {
        return 30;
    }
    else{
        switch (selectedSegment) {
            case 0:
                return myRentalrooms.count;
                break;
            case 1:
                return allRequestes.count;
                break;
            case 2:
                return allRequestes.count;
                break;
            case 3:
                return allRentedrooms.count;
                break;
                
            default:
                break;
        }
    }
    return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if(tableView == self.selectionTable)
    {
        return  @"Select Days";
    }
    return nil;
    
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(tableView == self.selectionTable)
    {
        static NSString* cellIdentifier = @"cell";
        
        
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
        }
        cell.textLabel.text= [NSString stringWithFormat:@"%zd",indexPath.row+1];
        if ([cell.textLabel.text isEqualToString:_selectedNumberofDays]) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            
        }else
        {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        return cell;
    }
    else{
        static NSString* cellIdentifier = @"RCell";
        static NSString* cellIdentifier2 = @"ReqCell";
        MyRentalCell *cell  = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        RequestCell  *cell2 = [tableView dequeueReusableCellWithIdentifier:cellIdentifier2];
        
        TJSpinner *spinner1 = [[TJSpinner alloc] initWithSpinnerType:kTJSpinnerTypeCircular];
        spinner1.hidesWhenStopped = YES;
        [spinner1 setHidden:YES];
        NSArray *imgArray;
        NSString *imageName;
        NSString *imageUrl;
        NSString *requestedFor;
        RenterRequest *request;
        
        [cell2.cilentInfoBtn setTitle:@"Client info" forState:UIControlStateNormal];
        
        cell2.lbl_RoomStatus.hidden = YES;
        
        switch (selectedSegment) {
            case 0:
                if (!cell)
                {
                    cell = [[MyRentalCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
                }
                RentalRooms *room = [myRentalrooms objectAtIndex:indexPath.row];
                cell.roomsAndBedslabel.text = [NSString stringWithFormat:@"%@ Rooms %@ Beds",room.nubmerOfRooms,room.nubmerOfBeds];
                cell.roomType.text = [NSString stringWithFormat:@"%@ Room",room.roomType];;
                cell.roomAdressLabel.text = room.roomAddress;
                cell.pricePerMonth.text   = [NSString stringWithFormat:@"$%@/night",room.roomRentalPrice];;
                cell.rentedDate.text      = room.roomRentaldate;
              
                
                if ([room.isEnable intValue] == 0)
                {
                    [cell.rentedDate setText:@"Enable"];
                    cell.enableSwitch.on = YES;
                }else
                {
                    [cell.rentedDate setText:@"Disable"];
                    cell.enableSwitch.on = NO;
                }
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                
                cell.enableSwitch.tag = indexPath.row;
                [cell.enableSwitch addTarget:self action:@selector(disableSwitchChanged:) forControlEvents:UIControlEventValueChanged];
                if ([room.roomStatus isEqualToString:@"requested"])
                {
                    [cell.rentedDate setText:[NSString stringWithFormat:@"Requested at: %@",room.requestedDate]];
                    //[cell.enableSwitch setHidden:YES]; VGS 0405
                    
                }
                else if ([room.roomStatus isEqualToString:@"rented"])
                {
                    [cell.rentedDate setText:[NSString stringWithFormat:@"Rented at: %@",room.roomRentaldate]];
                    //[cell.enableSwitch setHidden:YES]; VGS 0405
                }
                else
                {
                   // [cell.enableSwitch setHidden:NO]; VGS 0405
                }
                
                cell.imgBtn.tag = indexPath.row;
                [cell.imgBtn addTarget:self action:@selector(rooImgBtnpressed:) forControlEvents:UIControlEventTouchUpInside];
                
                spinner1.center = CGPointMake(cell2.roomImgView.frame.size.width / 2, cell2.roomImgView.frame.size.height / 2);
                [cell.roomImgView addSubview:spinner1];
                imageName = room.roomImage;
                imgArray =[imageName componentsSeparatedByString:@","];
                imageName =[imgArray objectAtIndex:0];
                
                if([imageName hasPrefix:@"http://"])
                    imageUrl =[NSString stringWithFormat:@"%@",imageName];
                else
                    imageUrl =[NSString stringWithFormat:@"%@upload/roomImages/%@",kAPIHost ,imageName];
                
                if (imageName!= 0)
                {
                    [spinner1 setHidden:NO];
                    [spinner1 startAnimating];
                    [cell.roomImgView setImageWithURLRequest:[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:imageUrl]]
                                            placeholderImage:[UIImage imageNamed:@"room_Placeholde.png"]
                                                     success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image)
                     {
                         cell.roomImgView.image = image;
                         cell.isImage = YES ;
                         [spinner1 stopAnimating];
                         [[NSUserDefaults standardUserDefaults] setObject:UIImagePNGRepresentation(image) forKey:[NSString stringWithFormat:@"rendalImage%ld",(long)indexPath.row]];
                     }
                                                     failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error){ [spinner1 stopAnimating];
                                                         cell.isImage = NO ;
                                                         NSData *imageData = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"rendalImage%ld",(long)indexPath.row]];
                                                         if (imageData != nil){
                                                             UIImage* image = [UIImage imageWithData:imageData];
                                                             cell.roomImgView.image = image;
                                                         }
                                                     }];
                }
                else
                {
                    cell.isImage = NO;
                }
                
                return cell;
                break;
            case 1:
                if (!cell2)
                {
                    cell2 = [[RequestCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
                }
                request = [allRequestes objectAtIndex:indexPath.row];
                
                requestedFor = [NSString stringWithFormat:@"Requested at %@",request.requestedDate];
                if ([request.numberOfDays intValue] == 1)
                {
                    cell2.lbl_CheckInDate.text = [NSString stringWithFormat:@"Chekin at %@ for %@ day",[self changetheDateFormatwithDate:request.temp_checkin_date],request.numberOfDays];
                    
                }else
                {
                    cell2.lbl_CheckInDate.text = [NSString stringWithFormat:@"Chekin at %@ for %@ days",[self changetheDateFormatwithDate:request.temp_checkin_date],request.numberOfDays];
                }
                                
                cell2.statusLabel.text = requestedFor;
                cell2.roomsAndBedslabel.text = [NSString stringWithFormat:@"%@ Rooms %@ Beds",request.nubmerOfRooms,request.nubmerOfBeds];
                cell2.roomAdressLabel.text = request.roomAddress;
                cell2.roomType.text = [NSString stringWithFormat:@"%@ Room",request.roomType];
                cell2.pricePerMonth.text   = [NSString stringWithFormat:@"$%@/night",request.roomRentalPrice]; ;
                [cell2 setSelectionStyle:UITableViewCellSelectionStyleNone];
                cell2.cilentInfoBtn.tag = indexPath.row;
                cell2.acceptBtn.tag = indexPath.row;
                cell2.rejectBtn.tag = indexPath.row;
                [cell2.acceptBtn setHidden:NO];
                [cell2.rejectBtn setHidden:NO];
                [cell2.checkInOutBtn setHidden:YES];
                [cell2.checkInOutBg setHidden:YES];
//                [cell2.editDateBg setHidden:YES];
//                [cell2.editDateBtn setHidden:YES];
                [cell2.checkinDateLabel setHidden:YES];
                [self addShadowToButton:cell2.rejectBtn];
                [self addShadowToButton:cell2.acceptBtn];
                
                cell2.imgBtn.tag = indexPath.row;
                [cell2.imgBtn addTarget:self action:@selector(rooImgBtnpressed:) forControlEvents:UIControlEventTouchUpInside];
                [cell2.cilentInfoBtn addTarget:self action:@selector(renterInfoBtnpressed:) forControlEvents:UIControlEventTouchUpInside];
                [cell2.acceptBtn addTarget:self action:@selector(accepteBtnpressed:) forControlEvents:UIControlEventTouchUpInside];
                [cell2.rejectBtn addTarget:self action:@selector(rejectBtnpressed:) forControlEvents:UIControlEventTouchUpInside];
                spinner1.center = CGPointMake(cell2.roomImgView.frame.size.width / 2, cell2.roomImgView.frame.size.height / 2);
                
                [cell2.roomImgView addSubview:spinner1];
                
                imageName = request.roomImage;
                imgArray =[imageName componentsSeparatedByString:@","];
                imageName =[imgArray objectAtIndex:0];
                if([imageName hasPrefix:@"http://"])
                {
                    imageUrl =[NSString stringWithFormat:@"%@",imageName];
                }
                else
                {
                    imageUrl =[NSString stringWithFormat:@"%@upload/roomImages/%@",kAPIHost ,imageName];
                }
                if (imageName!= 0)
                {
                    [spinner1 setHidden:NO];
                    [spinner1 startAnimating];
                    [cell2.roomImgView setImageWithURLRequest:[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:imageUrl]] placeholderImage:[UIImage imageNamed:@"room_Placeholde.png"] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image)
                     {
                         cell2.roomImgView.image = image;
                         cell2.isImage = YES;
                         [spinner1 stopAnimating];
                         
                         [[NSUserDefaults standardUserDefaults] setObject:UIImagePNGRepresentation(image) forKey:[NSString stringWithFormat:@"requested%ld",(long)indexPath.row]];
                         
                     }
                                                      failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error)
                     { [spinner1 stopAnimating];
                         cell2.isImage = NO;
                         NSData *imagedata = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"requested%ld",(long)indexPath.row]];
                         if (imagedata != nil) {
                             cell2.roomImgView.image = [UIImage imageWithData:imagedata];
                         }
                     }];
                }
                else
                {
                    cell2.isImage = NO;
                }
                
                return cell2;
                break;
            case 2:
                if (!cell2)
                {
                    cell2 = [[RequestCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
                }
                
                request = [allRequestes objectAtIndex:indexPath.row];
                requestedFor = [NSString stringWithFormat:@"Rented on %@",request.requestedDate];
                if ([request.numberOfDays intValue] == 1)
                {
                    cell2.lbl_CheckInDate.text = [NSString stringWithFormat:@"Chekin on %@ for %@ day",[self changetheDateFormatwithDate:request.temp_checkin_date],request.numberOfDays];
                    
                }else
                {
                    cell2.lbl_CheckInDate.text = [NSString stringWithFormat:@"Chekin on %@ for %@ days",[self changetheDateFormatwithDate:request.temp_checkin_date],request.numberOfDays];
                    
                }
                cell2.statusLabel.text = requestedFor;
                cell2.roomType.text =[NSString stringWithFormat:@"%@ Room",request.roomType];
                cell2.roomsAndBedslabel.text = [NSString stringWithFormat:@"%@ Rooms %@ Beds",request.nubmerOfRooms,request.nubmerOfBeds];
                cell2.checkinDateLabel.text = [NSString stringWithFormat:@"Check-in %@",request.checkInDate];
                cell2.roomAdressLabel.text = request.roomAddress;
                
                cell2.pricePerMonth.text   = [NSString stringWithFormat:@"$%@/night",request.roomRentalPrice]; ;
                [cell2 setSelectionStyle:UITableViewCellSelectionStyleNone];
                cell2.cilentInfoBtn.tag = indexPath.row;
                cell2.acceptBtn.tag = indexPath.row;
                cell2.rejectBtn.tag = indexPath.row;
                cell2.imgBtn.tag = indexPath.row;
                cell2.checkInOutBtn.tag = indexPath.row;
                [cell2.acceptBtn setHidden:YES];
                [cell2.rejectBtn setHidden:YES];
//                [cell2.editDateBg setHidden:YES];
//                [cell2.editDateBtn setHidden:YES];
                /*if ([request.isCheckIn isEqualToString:@"1"])
                 {
                 [cell2.checkinDateLabel setHidden:NO];
                 [cell2.checkInOutBtn setHidden:YES];
                 [cell2.checkInOutBg setHidden:YES];
                 
                 }else
                 {
                 [cell2.checkinDateLabel setHidden:YES];
                 [cell2.checkInOutBtn setHidden:NO];
                 [cell2.checkInOutBg setHidden:NO];
                 }*/
                
                if ([request.isCheckIn isEqualToString:@"1"])
                {
                    [cell2.checkinDateLabel setHidden:NO];
                    [cell2.checkInOutBtn setHidden:NO];
                    cell2.checkInOutBtn.userInteractionEnabled = NO;
                    [cell2.checkInOutBtn setTitle:@"IN-USE" forState:UIControlStateNormal];
                    [cell2.checkInOutBtn setBackgroundImage:nil forState:UIControlStateNormal];
                    cell2.checkInOutBtn.backgroundColor = [UIColor clearColor];
                    [cell2.checkInOutBtn setTitleColor:[UIColor colorWithRed:8.0/255.0 green:63.0/255.0 blue:19.0/255.0 alpha:1] forState:UIControlStateNormal];
                    
                    [cell2.checkInOutBg setHidden:YES];
                    
                }else
                {
                    [cell2.checkinDateLabel setHidden:YES];
                    [cell2.checkInOutBtn setHidden:NO];
                    cell2.checkInOutBtn.userInteractionEnabled = YES;
                    [cell2.checkInOutBtn setBackgroundImage:[UIImage imageNamed:@"reservation.png"] forState:UIControlStateNormal];
                    [cell2.checkInOutBtn setTitleColor :[UIColor whiteColor] forState:UIControlStateNormal];
                    [cell2.checkInOutBtn setTitle:@"Check-in" forState:UIControlStateNormal];
                    [cell2.checkInOutBg setHidden:NO];
                }
                
                [self addShadowToButton:cell2.rejectBtn];
                [self addShadowToButton:cell2.acceptBtn];
                //[cell2.checkInOutBtn setTitle:@"Check-in" forState:UIControlStateNormal];
                [cell2.checkInOutBtn addTarget:self action:@selector(checkInOutBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
                [cell2.imgBtn addTarget:self action:@selector(rooImgBtnpressed:) forControlEvents:UIControlEventTouchUpInside];
                [cell2.cilentInfoBtn addTarget:self action:@selector(renterInfoBtnpressed:) forControlEvents:UIControlEventTouchUpInside];
                [cell2.acceptBtn addTarget:self action:@selector(accepteBtnpressed:) forControlEvents:UIControlEventTouchUpInside];
                [cell2.rejectBtn addTarget:self action:@selector(rejectBtnpressed:) forControlEvents:UIControlEventTouchUpInside];
                spinner1.center = CGPointMake(cell2.roomImgView.frame.size.width / 2, cell2.roomImgView.frame.size.height / 2);
                
                [cell2.roomImgView addSubview:spinner1];
                
                imageName = request.roomImage;
                imgArray =[imageName componentsSeparatedByString:@","];
                imageName =[imgArray objectAtIndex:0];
                if([imageName hasPrefix:@"http://"])
                {
                    imageUrl =[NSString stringWithFormat:@"%@",imageName];
                }
                else
                {
                    imageUrl =[NSString stringWithFormat:@"%@upload/roomImages/%@",kAPIHost ,imageName];
                }
                if (imageName!= 0)
                {
                    
                    [spinner1 setHidden:NO];
                    [spinner1 startAnimating];
                    [cell2.roomImgView setImageWithURLRequest:[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:imageUrl]] placeholderImage:[UIImage imageNamed:@"room_Placeholde.png"]
                                                      success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image)
                     {
                         
                         cell2.roomImgView.image = image;
                         cell2.isImage = YES;
                         [spinner1 stopAnimating];
                         
                         [[NSUserDefaults standardUserDefaults] setObject:UIImagePNGRepresentation(image) forKey:[NSString stringWithFormat:@"rended%ld",(long)indexPath.row]];
                         NSLog(@"indexpath :%@",[NSString stringWithFormat:@"rended%ld",(long)indexPath.row]);
                         
                     }
                                                      failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error)
                     { [spinner1 stopAnimating];
                         cell2.isImage = NO;
                         NSData *imagedata = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"rended%ld",(long)indexPath.row]];
                         NSLog(@"indexpath222 :%@",[NSString stringWithFormat:@"rended%ld",(long)indexPath.row]);
                         if (imagedata != nil) {
                             cell2.roomImgView.image = [UIImage imageWithData:imagedata];
                         }
                     }];
                }
                else
                {
                    cell2.isImage = NO;
                }
                
                return cell2;
                break;
                
            case 3:
                if (!cell2)
                {
                    cell2 = [[RequestCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
                    
                }
                
                RenterRequest *rented = [allRentedrooms objectAtIndex:indexPath.row];
                
                if ([rented.requestStatus isEqualToString:@"requested"])
                {
                    cell2.lbl_RoomStatus.hidden = NO;
                }
                else{
                    cell2.lbl_RoomStatus.hidden = YES;
                }
                
                if ([rented.cancelRoom integerValue] >= 3 && [rented.requestStatus isEqualToString:@"rented"] )
                {
                    [cell2.img_CancelRoom setHidden:NO];
                    [cell2.btn_CancelRoom setHidden:NO];
//                    [cell2.editDateBg setHidden:NO];
//                    [cell2.editDateBtn setHidden:NO];
                    cell2.btn_CancelRoom.tag = indexPath.row;
                    [cell2.btn_CancelRoom addTarget:self action:@selector(action_CancelRoom:) forControlEvents:UIControlEventTouchUpInside];

                }
                else
                {
                    [cell2.img_CancelRoom setHidden:YES];
                    [cell2.btn_CancelRoom setHidden:YES];
//                    [cell2.editDateBg setHidden:YES];
//                    [cell2.editDateBtn setHidden:YES];
                }
                
                
                cell2.roomsAndBedslabel.text = [NSString stringWithFormat:@"%@ Rooms %@ Beds",rented.nubmerOfRooms,rented.nubmerOfBeds];
                requestedFor = [NSString stringWithFormat:@"Rented on %@",rented.requestedDate];
                if ([rented.numberOfDays intValue] == 1)
                {
                    cell2.lbl_CheckInDate.text = [NSString stringWithFormat:@"Chekin on %@ for %@ day",[self changetheDateFormatwithDate:rented.temp_checkin_date],rented.numberOfDays];
                    
                }else
                {
                    cell2.lbl_CheckInDate.text = [NSString stringWithFormat:@"Chekin on %@ for %@ days",[self changetheDateFormatwithDate:rented.temp_checkin_date],rented.numberOfDays];
                    
                }
                
                
                cell2.statusLabel.text = requestedFor;
                cell2.roomType.text = [NSString stringWithFormat:@"%@ Room",rented.roomType];
                cell2.roomAdressLabel.text = rented.roomAddress;
                cell2.pricePerMonth.text   = [NSString stringWithFormat:@"$%@/night",rented.roomRentalPrice];
                [cell2 setSelectionStyle:UITableViewCellSelectionStyleNone];
                cell2.cilentInfoBtn.tag = indexPath.row;
                cell2.acceptBtn.tag = indexPath.row;
                cell2.rejectBtn.tag = indexPath.row;
                cell2.imgBtn.tag = indexPath.row;
                cell2.checkInOutBtn.tag = indexPath.row;
                [cell2.acceptBtn setHidden:YES];
                [cell2.rejectBtn setHidden:YES];
                NSString *isIn = (NSString *)rented.isCheckIn;//request
                if ([isIn isEqualToString:@"1"])
                {
                    [cell2.checkinDateLabel setHidden:NO];
                    [cell2.checkInOutBtn setHidden:NO];
                    [cell2.checkInOutBg setHidden:NO];
                    
                }else
                {
                    [cell2.checkinDateLabel setHidden:YES];
                    [cell2.checkInOutBtn setHidden:YES];
                    [cell2.checkInOutBg setHidden:YES];
                }
                
//                cell2.editDateBtn.tag = indexPath.row;
//                [cell2.editDateBtn addTarget:self action:@selector(editbuttonPressed:) forControlEvents:UIControlEventTouchUpInside];
                [cell2.cilentInfoBtn setTitle:@"Owner info" forState:UIControlStateNormal];
                [cell2.checkInOutBtn setTitle:@"Check-out" forState:UIControlStateNormal];
                [cell2.checkInOutBtn addTarget:self action:@selector(checkInOutBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
                [cell2.cilentInfoBtn addTarget:self action:@selector(renterInfoBtnpressed:) forControlEvents:UIControlEventTouchUpInside];
                [cell2.acceptBtn addTarget:self action:@selector(accepteBtnpressed:) forControlEvents:UIControlEventTouchUpInside];
                [cell2.rejectBtn addTarget:self action:@selector(rejectBtnpressed:) forControlEvents:UIControlEventTouchUpInside];
                
                [cell2.imgBtn addTarget:self action:@selector(rooImgBtnpressed:) forControlEvents:UIControlEventTouchUpInside];
                spinner1.center = CGPointMake(cell2.roomImgView.frame.size.width / 2, cell2.roomImgView.frame.size.height / 2);
                [cell2.roomImgView addSubview:spinner1];
                
                imageName = rented.roomImage;
                
                imgArray =[imageName componentsSeparatedByString:@","];
                imageName =[imgArray objectAtIndex:0];
                
                if([imageName hasPrefix:@"http://"])
                {
                    imageUrl =[NSString stringWithFormat:@"%@",imageName];
                }
                else
                {
                    imageUrl =[NSString stringWithFormat:@"%@upload/roomImages/%@",kAPIHost ,imageName];
                }
                if (imageName!= 0)
                {
                    
                    [spinner1 setHidden:NO];
                    [spinner1 startAnimating];
                    [cell2.roomImgView setImageWithURLRequest:[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:imageUrl]] placeholderImage:[UIImage imageNamed:@"room_Placeholde.png"] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image)
                     {
                         cell2.roomImgView.image = image;
                         cell2.isImage = YES;
                         [spinner1 stopAnimating];
                         
                         [[NSUserDefaults standardUserDefaults] setObject:UIImagePNGRepresentation(image) forKey:[NSString stringWithFormat:@"reserve%ld",(long)indexPath.row]];
                     }
                                                      failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error){
                                                          [spinner1 stopAnimating];
                                                          cell2.isImage = NO;
                                                          NSData *imagedata = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"reserve%ld",(long)indexPath.row]];
                                                          if (imagedata != nil) {
                                                              cell2.roomImgView.image = [UIImage imageWithData:imagedata];
                                                          }
                                                      }];
                }
                else 
                {
                    cell2.isImage = NO;
                }
                
                return cell2;
                break;
                
                
                
            default:
                break;
        }
    }
    
    return nil;
}





-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == self.selectionTable){
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        _selectedNumberofDays = cell.textLabel.text;
        noofDaysTF.text = _selectedNumberofDays;
        [daysAlertView close];
    }
    
}


-(IBAction)action_CancelRoom:(id)sender
{
    commenRequest = [allRentedrooms objectAtIndex:[sender tag]];
    
    [self showCustomUIAlertViewWithtilet:@"Cancel Room" andWithMessage:@"Are you sure want to cancel this reservation?"];
}

-(IBAction)disableSwitchChanged:(id)sender
{
    UISwitch *disableSwitch = (UISwitch *)sender;
    RentalRooms *room = [myRentalrooms objectAtIndex:[sender tag]];
    NSIndexPath * indexPath = [NSIndexPath indexPathForRow:[sender tag] inSection:0];
    MyRentalCell *cell = (MyRentalCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    
    
    NSString *disabled ;
    if (disableSwitch.on) 
    {
        [cell.rentedDate setText:@"Enabled"];
        disabled = @"0";   
    }else 
    {
        [cell.rentedDate setText:@"Disabled"];
        disabled = @"1";
    }
    [self updateEnableDisableStatusOfIndex:room.roomId withStatus:disabled];
}
-(IBAction)renterInfoBtnpressed:(id)sender
{
    UIButton *infoBtn = (UIButton *)sender;
    RenterRequest *request;
    
    switch (selectedSegment)
    {
        case 1:
             request = [allRequestes objectAtIndex:infoBtn.tag];
            [self ShowPopupWithRequest:request title:@"Client info"];
            break;
        case 2:
            request = [allRequestes objectAtIndex:infoBtn.tag];
            [self ShowPopupWithRequest:request title:@"Client info"];
            break;
        case 3:
            request = [allRentedrooms objectAtIndex:infoBtn.tag];
            [self ShowPopupWithRequest:request title:@"Owner info"];
            break;

        default:
            break;
    }
    
    
}
-(IBAction)accepteBtnpressed:(id)sender
{
    UIButton *infoBtn = (UIButton *)sender;
    RenterRequest *request = [allRequestes objectAtIndex:infoBtn.tag];
    self.tokenId   = request.customerId;
    self.totalRent = request.totelRent;
    [self updateStatusWthitId:request.roomId renterId:request.clientId withStatus:@"accepted" index:infoBtn.tag bookingid:request.bookingId];
    
}

-(IBAction)rejectBtnpressed:(id)sender
{
    UIButton *infoBtn = (UIButton *)sender;
    RenterRequest *request = [allRequestes objectAtIndex:infoBtn.tag];
    [self updateStatusWthitId:request.roomId renterId:request.clientId  withStatus:@"rejected" index:infoBtn.tag bookingid:request.bookingId];
    
}
-(IBAction)rooImgBtnpressed:(id)sender
{
    NSInteger btnTag = [sender tag];
    RentalRooms *room;
    RenterRequest *request;
    RenterRequest *rented ;
    switch (selectedSegment) 
    {
        case 0:
            room = [myRentalrooms objectAtIndex:btnTag];
            [self fetchAllPhotos:room.roomImage];
            break;
        case 1:
            request = [allRequestes objectAtIndex:btnTag];
            [self fetchAllPhotos:request.roomImage];
            break;
        case 2:
            request = [allRequestes objectAtIndex:btnTag];
            [self fetchAllPhotos:request.roomImage];
            break;
        case 3:
            rented = [allRentedrooms objectAtIndex:btnTag];
            [self fetchAllPhotos:rented.roomImage];
            break;

        default:
            break;
    }
}
-(IBAction)checkInOutBtnPressed:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    if ([btn.currentTitle isEqualToString:@"Check-in"]) 
    {
       
        RenterRequest *request = [allRequestes objectAtIndex:btn.tag];
        NSString *tempcheckinDate = [self changetheDateFormatwithDate:request.temp_checkin_date];
        
        if ([tempcheckinDate isEqualToString:[self DateToString]]){
            [self updateStatusWthitId:request.roomId renterId:request.clientId withStatus:@"check-in" index:btn.tag bookingid:request.bookingId];
        }
        else
        {
            [self showCustomUIAlertViewWithtilets:@"info" andWithMessage:@"Check-in date is different"];
        }
        
    }else 
    {
        RenterRequest *request = [allRentedrooms objectAtIndex:btn.tag];
        totalPayment = request.totelRent;
        [self updateStatusWthitId:request.roomId renterId:request.clientId withStatus:@"check-out" index:btn.tag bookingid:request.bookingId];
    }
}
/*-(IBAction)editbuttonPressed:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    //RenterRequest *rented = [allRentedrooms objectAtIndex:btn.tag];
    commenRequest = [allRentedrooms objectAtIndex:btn.tag];
    lastRented = [allRentedrooms objectAtIndex:btn.tag];
    NSString *modifiedDate = [self changetheDateFormatwithDate:commenRequest.temp_checkin_date];
    
    [self showCustomUIAlertViewWithDate:modifiedDate andWithdays:commenRequest.numberOfDays];
}*/

-(NSString *)DateToString
{
    NSDateFormatter *displayingFormatter = [NSDateFormatter new];
    [displayingFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *display = [displayingFormatter stringFromDate:[NSDate date]];
    return display;
}

-(NSString *)changetheDateFormatwithDate:(NSString *)dateString
{
    NSDateFormatter *parsingFormatter = [NSDateFormatter new];
    [parsingFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    
    NSDate *date = [parsingFormatter dateFromString:dateString];
    NSLog(@"date: %@", date);
    
    NSDateFormatter *displayingFormatter = [NSDateFormatter new];
    [displayingFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *display = [displayingFormatter stringFromDate:date];
    return display;
}

- (IBAction)backBtnPressed:(id)sender
{
    _isMyRented = NO;
    [self.navigationController popViewControllerAnimated:YES];
    
}
-(void)reloadTable
{
    NSRange range = NSMakeRange(0, [self numberOfSectionsInTableView:self.tableView]);
    NSIndexSet *sections = [NSIndexSet indexSetWithIndexesInRange:range];
    [self.tableView reloadSections:sections withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark Web Services
-(void)updateStatusWthitId:(NSString *)selectedroomId renterId:(NSString *) renterId withStatus :(NSString *) status index:(NSInteger)tag bookingid:(NSString *)bookingid
{
    
    NSDate *today = [NSDate date];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm a"];
    
    // Get the date time in NSString
    NSString *date = [dateFormatter stringFromDate:today];

    
    MBProgressHUD *hud =[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"wait"; 
    NSMutableDictionary *params=[[NSMutableDictionary alloc]initWithObjectsAndKeys:@"accepted_requested_room",@"command", renterId,@"renter_id",selectedroomId,@"room_id",status ,@"states",selectedroomId,@"requested_id",date,@"c_date",bookingid,@"booking_id", nil];
    
    [[NetworkHelper sharedInstance] commandWithParams:params onCompletion:^(NSDictionary *json) {
        //NSLog(@"the json return is %@",json);
        if (![json objectForKey:@"error"]&& json!=nil)
        {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            if ([status isEqualToString:@"accepted"])
            {
                [self fetchAllRequest];  
                [self postStripeToken:_tokenId whitAmount:_totalRent sourceid:bookingid statustype:@"roomAccept"];
            }else if ([status isEqualToString:@"check-in"])
            {
                [self fetchAllRented];
            }
            else if ([status isEqualToString:@"check-out"])
            {
                [self fetchMyRented];
                
                NSString * storyboardName = @"Main";
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle: nil];
                FareRatingViewController * Dvc = [storyboard instantiateViewControllerWithIdentifier:@"FareRating"];
                Dvc.isMyRental = @"isMyRental";
                Dvc.roomid = selectedroomId;
                Dvc.roomfare = totalPayment;
                [self.navigationController pushViewController:Dvc animated:YES];
            }
            else{
                [[CMyRequested alloc] deleteDataAtIndex:tag];
                [self fetchAllRequest];
            }
        }else
        {
            //[self showCustomUIAlertViewWithtilet:@"Warning" andWithMessage:[json objectForKey:@"error"]  ];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            NSString *errorMsg =[json objectForKey:@"error"];
            if ([ErrorFunctions isError:errorMsg])
            {
                [self updateStatusWthitId:selectedroomId renterId:renterId withStatus:status index:tag bookingid:bookingid];
            }
            else
            {
                [self showHudWithText:errorMsg];
            }

            NSLog(@"Error :%@",[json objectForKey:@"error"]);
        }
    }];
    
    
}
#pragma mark
#pragma mark - Stripe
#pragma mark
- (void)postStripeToken:(NSString* )token whitAmount :(NSString *) amount sourceid:(NSString *)sourceId statustype:(NSString *)type {
    //1
    
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
    
    [stripUrl appendString:[NSString stringWithFormat:@"stripeCustomer=%@&stripeAmount=%@&sourceId=%@&type=%@",token,finalAmount,sourceId,type]];
    NSLog(@"stripUrl %@",stripUrl);
    NSMutableURLRequest* request = [httpClient requestWithMethod:@"GET" path:stripUrl parameters:nil];
    
    self.httpOperation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON)
                          {
                              [self chargeDidSucceed];                          }
                        failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON)
                          {
                              [MBProgressHUD hideHUDForView:self.view animated:YES];
                              NSLog(@"%@",JSON);
                              NSLog(@"error %@",error);
                              [self postStripeToken:_tokenId whitAmount:_totalRent sourceid:sourceId statustype:@"roomAccept"];
                          }];
    
    [self.httpOperation start];
}



- (void)chargeDidSucceed {
    //rejo18042016
    
     MBProgressHUD *hud =[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"wait";
    NSString *str_transactionType = @"3"; //guide_reservation
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



-(void)updateEnableDisableStatusOfIndex :(NSString *) selectedIndex withStatus :(NSString *) status
{
//command=enable_disable_room&name=zeeshan&states=1&room_id=1
    MBProgressHUD *hud =[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"wait"; 
    NSMutableDictionary *params=[[NSMutableDictionary alloc]initWithObjectsAndKeys:@"enable_disable_room",@"command",selectedIndex,@"room_id",status ,@"states", nil];
    
    [[NetworkHelper sharedInstance] commandWithParams:params onCompletion:^(NSDictionary *json) {
        //NSLog(@"the json return is %@",json);
        if (![json objectForKey:@"error"]&& json!=nil)
        {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            if ([status intValue] == 0) 
            {
                // added by zia
                [self showHudWithText:@"This Room is available now"];
            }else 
            {
                //added by zia
                [self showHudWithText:@"This Room is unavailable now"];
            }
        }else
        {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            NSString *errorMsg =[json objectForKey:@"error"];
            if ([ErrorFunctions isError:errorMsg])
            {
                [self updateEnableDisableStatusOfIndex:selectedIndex withStatus:status];    
            }
            else
            {
                [self showHudWithText:errorMsg];
            }
            NSLog(@"Error :%@",[json objectForKey:@"error"]);
        }
    }];
}

-(void)addShadowToButton:(UIButton *)button
{
    button.layer.cornerRadius = 8.0f;
    button.layer.masksToBounds = NO;
    button.layer.shadowOpacity = 0.8;
    button.layer.shadowRadius = 12;
    button.layer.shadowOffset = CGSizeMake(2.0f, 2.0f);
    
}


#pragma mark CustomAlertView
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
                                             [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                                             if ([titel isEqualToString:@"Cancel Room"])
                                             {
                                                 
                                                 int Total_Amounts =   (int)[commenRequest.roomRentalPrice integerValue] * (int)[commenRequest.numberOfDays integerValue];
                                                 
                                                self.str_TotalAmoun = [NSString stringWithFormat:@"%d",Total_Amounts];
                                                 
                                               
                                                 
                                                 [self action_CancelApi:self.str_TotalAmoun  cusid:commenRequest.customerId bookingId:commenRequest.bookingId type:@"roomCancel"];//roomId:(NSString *)commenRequest.roomId
                                             }
                                            
//                                             else if ([titel isEqualToString:@"Payment"]){
//                                                 [self action_editApi];
//                                             }
                                         }];
                                    }]];
    
    //    [alertViewController addAction:[NYAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil)
    //                                                            style:UIAlertActionStyleCancel
    //                                                          handler:^(NYAlertAction *action) {
    //                                                              [self dismissViewControllerAnimated:YES completion:nil];
    //                                                          }]];
    [self presentViewController:alertViewController animated:YES completion:nil];
}

//roomId:(NSString *)roomid
-(void)action_CancelApi:(NSString*)amount cusid:(NSString*)token bookingId:(NSString *)sourceId type:(NSString *)type
{
    NSString *finalAmount =[NSString stringWithFormat:@"%.0f",[amount floatValue]*100];
    float refundamount = [commenRequest.refundpercentage integerValue]/100.0*[finalAmount floatValue];
    finalAmount = [NSString stringWithFormat:@"%.0f",refundamount];
    NSLog(@"refundamount  :%f",refundamount);
    float refu = ([amount floatValue] * [commenRequest.refundpercentage integerValue]) / 100;
    
    self.str_RefundAmount = [NSString stringWithFormat:@"%.2f",refu];
    
    
    NSURL *postURL = [NSURL URLWithString:STRIPE_TEST_POST_URL];
    AFHTTPClient* httpClient = [AFHTTPClient clientWithBaseURL:postURL];
    httpClient.parameterEncoding = AFJSONParameterEncoding;
    [httpClient registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [httpClient setDefaultHeader:@"Content-Type" value:@"application/json"];
    
    //4
    NSMutableString *stripUrl =[[NSMutableString alloc] init];
    
    [stripUrl appendString:KRefundUrl];
    
    [stripUrl appendString:[NSString stringWithFormat:@"stripeCustomerId=%@&refundAmount=%@&booking_id=%@&type=%@",token,finalAmount,sourceId,type]];
    NSLog(@"stripUrl %@",stripUrl);
    NSMutableURLRequest* request = [httpClient requestWithMethod:@"GET" path:stripUrl parameters:nil];
    
    self.httpOperation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON)
                          {
                             // [MBProgressHUD hideHUDForView:self.view animated:YES];
                                                           // [self successRefundRoom];
                              
                              [MBProgressHUD hideHUDForView:self.view animated:YES];
                              NSString *str_M = @"% of room rent shortly";
                              NSString *str_Message = [NSString stringWithFormat:@"You will get %@%@",commenRequest.refundpercentage,str_M];
                              
                              [self showHudWithText:str_Message];
                              [self fetchMyRented];
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

-(void)successRefundRoom{
    NSString *str_transactionType = @"6"; //guide_reservation
    NSMutableDictionary *params=[[NSMutableDictionary alloc]initWithObjectsAndKeys:@"payment_transaction",@"command",str_transactionType,@"transaction_type",self.str_RefundAmount,@"amount_paid",self.userId,@"client_id", nil];
    
    [[NetworkHelper sharedInstance] commandWithParams:params onCompletion:^(NSDictionary *json) {
        //NSLog(@"the json return is %@",json);
        if (![json objectForKey:@"error"]&& json!=nil)
        {
            NSDictionary *res=[json objectForKey:@"result"];
            NSString *status=[NSString stringWithFormat:@"%@",[res objectForKey:@"successful"]];
            if ([status isEqualToString:@"1"])
            {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                NSString *str_M = @"% of room rent shortly";
                NSString *str_Message = [NSString stringWithFormat:@"You will get %@%@",commenRequest.refundpercentage,str_M];
                
                [self showHudWithText:str_Message];
                [self fetchMyRented];
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


/*- (void)showCustomUIAlertViewWithDate :(NSString *)date andWithdays:(NSString *)days {
    
    UIView *textFieldView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 250, 100)];
    textFieldView.backgroundColor = [UIColor colorWithWhite:0.19f alpha:1.0f];
    UILabel *dateLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 50, 30)];
    dateLabel.text = @"Date :";
    dateLabel.textColor = [UIColor colorWithWhite:0.92f alpha:1.0f];
    
    
    _dateTf = [[IQDropDownTextField alloc]initWithFrame:CGRectMake(70, 10, 170, 30)];
    
    _dateTf.backgroundColor = [UIColor colorWithWhite:0.92f alpha:1.0f];
    _dateTf.layer.cornerRadius = 5;
    
    
    UIToolbar *toolbar = [[UIToolbar alloc] init];
    [toolbar setBarStyle:UIBarStyleBlackTranslucent];
    [toolbar sizeToFit];
    UIBarButtonItem *buttonflexible = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *buttonDone = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneClicked:)];
    [buttonDone setTintColor:[UIColor whiteColor]];
    
    [toolbar setItems:[NSArray arrayWithObjects:buttonflexible,buttonDone, nil]];
    _dateTf.inputAccessoryView = toolbar;
    [_dateTf setDropDownMode:IQDropDownModeDatePicker];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    [_dateTf setDateFormatter:dateFormatter];
    [self.view insertSubview:_dateTf belowSubview:self.view];
    
    UILabel *noofDaysLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 50, 50, 30)];
    noofDaysLabel.text = @"Days :";
    noofDaysLabel.textColor = [UIColor colorWithWhite:0.92f alpha:1.0f];
    noofDaysTF = [[UITextField alloc]initWithFrame:CGRectMake(70, 50, 170, 30)];
    noofDaysTF.backgroundColor = [UIColor colorWithWhite:0.92f alpha:1.0f];
    noofDaysTF.layer.cornerRadius = 5;
    noofDaysTF.delegate =self;
    _dateTf.text = date;
    noofDaysTF.text = days;
    [textFieldView addSubview:dateLabel];
    [textFieldView addSubview:noofDaysLabel];
    [textFieldView addSubview:_dateTf];
    [textFieldView addSubview:noofDaysTF];
    
    
    NSDate *date1 = [dateFormatter dateFromString:_dateTf.text];
    _dateTf.date = date1;
    
    alertView = [[CustomIOSAlertView alloc] init];
    alertView.tag = 1;
    alertView.backgroundColor = [UIColor colorWithWhite:0.19f alpha:1.0f];
    [alertView setContainerView:textFieldView];
    [alertView setButtonTitles:[NSMutableArray arrayWithObjects:@"Cancel",@"Done", nil]];
    [alertView setDelegate:self];
    [alertView setOnButtonTouchUpInside:^(CustomIOSAlertView *aView, int buttonIndex) {
        NSLog(@"Block: Button at position %d is clicked on alertView %d.", buttonIndex, (int)[aView tag]);
        //[aView close];
    }];
    
    [alertView setUseMotionEffects:true];
    
    // And launch the dialog
    [alertView show];
    
    
}*/




-(void)doneClicked:(UIBarButtonItem*)button
{
//    [self.view endEditing:YES];
    [_dateTf resignFirstResponder];
    
}
/*- (void)customIOS7dialogButtonTouchUpInside: (CustomIOSAlertView *)alert clickedButtonAtIndex: (NSInteger)buttonIndex
{
    if(alert == daysAlertView)
    {
        [daysAlertView close];
    }
    else
    {
        if(buttonIndex==1)
        {
//            [self action_editPress];
            [self CalculateDifferenceofDays];
        }
        [alertView close];
    }
    NSLog(@"Done Pressed");
    
}*/

/*-(void)action_editApi
{
    MBProgressHUD *hud =[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"wait";
    NSMutableDictionary *params=[[NSMutableDictionary alloc]initWithObjectsAndKeys:@"my_rooms_booked_edit",@"command",commenRequest.bookingId,@"booking_id",_dateTf.text ,@"edit_date",noofDaysTF.text ,@"edit_days", totalEditpayment, @"edit_fare", nil];
    
    [[NetworkHelper sharedInstance] commandWithParams:params onCompletion:^(NSDictionary *json) {
        //NSLog(@"the json return is %@",json);
        if (![json objectForKey:@"error"]&& json!=nil)
        {
            //[MBProgressHUD hideHUDForView:self.view animated:YES];
            [self showHudWithText:@"your request sent to room's owner"];
            [self fetchMyRented];
        }else
        {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            NSString *errorMsg =[json objectForKey:@"error"];
            [self showHudWithText:errorMsg];
            NSLog(@"Error :%@",[json objectForKey:@"error"]);
        }
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
    }];
}*/







/*-(void)CalculateDifferenceofDays
{
    int lastDays = lastRented.numberOfDays.intValue;
    int newDays = noofDaysTF.text.intValue;
    if(lastDays == newDays)
    {
        NSString *finalAmount =[NSString stringWithFormat:@"%.0f",[changingFee floatValue]*100];
        totalEditpayment = finalAmount;
        
        [self showCustomUIAlertViewWithtilet:@"Payment" andWithMessage:[NSString stringWithFormat:@"$%@ will be charge from your account",changingFee]];
        
        
        NSLog(@"dateDifference %i",0);
    }
    else if(lastDays < newDays)
    {
        int dateDifference = newDays - lastDays;
        float totalAmount = dateDifference  * lastRented.roomRentalPrice.floatValue;
        float taxforPayment = (totalAmount * lastRented.taxRate.floatValue)/100;
//        NSString *changeFee = @"5";
        float totalPaymentWithtax = totalAmount + taxforPayment +[changingFee floatValue];
        NSString *totalFee = [NSString stringWithFormat:@"%.02f",totalAmount];
        NSString *totalpaymentTax = [NSString stringWithFormat:@"%.02f",totalPaymentWithtax];
        [self showCustomUIAlertViewWithtilet:@"Payment" andWithMessage:[NSString stringWithFormat:@"Price per day: $%@\nno of days: %i\n\nTotal Rent: $%@\nTax Rate: %@\nDate Change Fee: $%@\n\n $%@ will be charge from your account",lastRented.roomRentalPrice,dateDifference,totalFee,lastRented.taxRate,changingFee,totalpaymentTax]];
        NSLog(@"dateDifference %i",dateDifference);
        NSString *finalAmount =[NSString stringWithFormat:@"%.0f",[totalpaymentTax floatValue]*100];
        totalEditpayment = finalAmount;
        
    }
    else
    {
        int dateDifference = lastDays - newDays;
        NSLog(@"dateDifference %i",dateDifference);
        float totalAmount = dateDifference  * lastRented.roomRentalPrice.floatValue;
        float amountwithAdditionalPayment = totalAmount - [changingFee floatValue];
        NSString *finalAmount =[NSString stringWithFormat:@"%.0f",amountwithAdditionalPayment*100];
        totalEditpayment = finalAmount;
        [self action_editApi];
    }
}*/

-(void)ShowPopupWithRequest:(RenterRequest *)request title:(NSString *)title
{
    PopupViewController1 *popView = [PopupViewController1 new];
    popView.title = NSLocalizedString(title, nil);
    [popView setRequest:request];
    [popView setIsMyRented:_isMyRented];
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
-(void)fetchAllPhotos :(NSString*)imageNames
{
    NSMutableArray *photos = [[NSMutableArray alloc] init];
    NSString *imageName ; 
    NSArray *imgArray =[imageNames componentsSeparatedByString:@","];
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
    [self showPhotos]; 
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

- (void)dealloc {
    [_screentitelImageView release];
    [_img_ReserveRoom release];
    [super dealloc];
}

-(void)showslectionView
{
    //[self hidekeybord];
    daysAlertView = [[CustomIOSAlertView alloc] init];
    
    [daysAlertView setContainerView:[self createSelectionListView]];
    
    // You may use a Block, rather than a delegate.
    [daysAlertView setDelegate:self];
    [daysAlertView setOnButtonTouchUpInside:^(CustomIOSAlertView *aView, int buttonIndex) {
        NSLog(@"Block: Button at position %d is clicked on alertView %d.", buttonIndex, (int)[aView tag]);
        [aView close];
    }];
    
    [daysAlertView setUseMotionEffects:true];
    
    // And launch the dialog
    [daysAlertView show];
    
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
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    noofDaysTF.inputAccessoryView = nil;
    
    if (textField == noofDaysTF) {
        [_dateTf resignFirstResponder];
    }
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self showslectionView];
    [noofDaysTF resignFirstResponder];
    
}
@end
