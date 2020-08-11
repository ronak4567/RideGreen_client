//
//  MyParkingView.m
//  ridegreen
//
//  Created by Ridegreen on 30/08/2015.
//  Copyright (c) 2015 Ridegreen. All rights reserved.
//

#import "MyParkingView.h"

@interface MyParkingView ()
{
    NSInteger deleteSelectedIndex;
    NSString *tokanId;
    NSString *renewalPost;
    NSString *tax;
    
}
@property (strong, nonatomic) AFJSONRequestOperation* httpOperation;

@end

@implementation MyParkingView

- (void)viewDidLoad {
    
    allprakings =[NSMutableArray new];
    tax = [[NSUserDefaults standardUserDefaults]objectForKey:@"taxrate"];
    //renewalPost = @"0.99";
    
    userdefault =[NSUserDefaults standardUserDefaults];
    tokanId =[userdefault objectForKey:@"custrom_id"];
    self.userId =[userdefault objectForKey:@"user_id"];
    [self fetchMyParking];
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark web services 
-(void)fetchMyParking
{
    MBProgressHUD *hue=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hue.labelText=@"";
    NSMutableDictionary *params=[[NSMutableDictionary alloc]initWithObjectsAndKeys:@"my_parking",@"command",self.userId,@"client_id", nil];
    
    [[NetworkHelper sharedInstance] commandWithParams:params onCompletion:^(NSDictionary *json) {
        
        //NSLog(@"the json return is %@",json);
        if (![json objectForKey:@"error"]&& json!=nil)
        {
            NSArray *results=[json objectForKey:@"result"];
            
            renewalPost =  [[results objectAtIndex:0] objectForKey:@"parking_cost_renewal"];//
            
            
            [[CMyParking alloc] updateClientPark:json];
             [self updateParkingUI];
        }else
        {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            NSLog(@"Error :%@",[json objectForKey:@"error"]);
            NSString *errorMsg =[json objectForKey:@"error"];
            if ([ErrorFunctions isError:errorMsg])
                [self fetchMyParking];
            else
                 //[self showHudWithText:[json objectForKey:@"error"]];
            
            [self showCustomUIAlertViewWithtilets:@"My Parkings" andWithMessage:@"You have no parkings."];
            
            //[self showCustomUIAlertViewWithtilet:@"Info" andWithMessage:[json objectForKey:@"error"]];
        }
        
       
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




-(void)updateParkingUI
{
    NSMutableArray *results = [[CMyParking alloc] fetchClientPark];
    
    [allprakings removeAllObjects];
    
    //NSArray *results=[json objectForKey:@"result"];
    for (int i=0; i<[results count]; i++)
    {
        NSDictionary *res = [results objectAtIndex:i];
        NSLog(@"my parking result:%@",res);
        CMyParking *obj_cl = (CMyParking *)res;
        
        NSString *pid = obj_cl.idField;
        NSString *pName = obj_cl.name;
        NSString *pAddress = obj_cl.location;
        NSString *pLocation = obj_cl.coordinate;
        NSString *phRent =obj_cl.pricePerHour;
        NSString *disabled =obj_cl.isAvailable;
        NSString *usedDays = obj_cl.usedDays;
        [allprakings addObject:[Parking setParkingId:pid parkingName:pName parkingaddress:pAddress parkingLocation:pLocation perHourRent:phRent disableEnable:disabled noOfDays:usedDays]];
    }
    [self.tableView reloadData];
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

-(void)renewParking:(NSString *)parkingid
{
    MBProgressHUD *hue=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hue.labelText=@"";
    NSMutableDictionary *params=[[NSMutableDictionary alloc]initWithObjectsAndKeys:@"renew_parking",@"command",parkingid,@"park_id", nil];
    
    [[NetworkHelper sharedInstance] commandWithParams:params onCompletion:^(NSDictionary *json) {
        
        //NSLog(@"the json return is %@",json);
        if (![json objectForKey:@"error"]&& json!=nil)
            {
                [self postStripeToken:tokanId whitAmount:self.renewalPostWithTax parkingID:parkingid];
                }else
                    {
                        [MBProgressHUD hideHUDForView:self.view animated:YES];
                        NSLog(@"Error :%@",[json objectForKey:@"error"]);
                        NSString *errorMsg =[json objectForKey:@"error"];
                        if ([ErrorFunctions isError:errorMsg])
                            [self fetchMyParking];
                        else
                            [self showHudWithText:[json objectForKey:@"error"]];
                        
                        //[self showCustomUIAlertViewWithtilet:@"Info" andWithMessage:[json objectForKey:@"error"]];
                        }
        
        }];
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
    
    [alertViewController addAction:[NYAlertAction actionWithTitle:NSLocalizedString(@"Dismiss", nil)style:UIAlertActionStyleDefault handler:^(NYAlertAction *action) 
                                    {
                                        [self dismissViewControllerAnimated:YES completion:nil];
                                        [self fetchMyParking];
                                    }]];
    
    //    [alertViewController addAction:[NYAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil)
    //                                                            style:UIAlertActionStyleCancel
    //                                                          handler:^(NYAlertAction *action) {
    //                                                              [self dismissViewControllerAnimated:YES completion:nil];
    //                                                          }]];
    
    [self presentViewController:alertViewController animated:YES completion:nil];
}

#pragma mark - Table view data source
#pragma mark UITableView Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    return 103;
}
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
    return allprakings.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString* cellIdentifier1 = @"PakCell";
    
    MyParkingCell* cell1 = [tableView dequeueReusableCellWithIdentifier:cellIdentifier1];
    if (!cell1)
    {
        cell1 = [[MyParkingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier1];
        
    }
    
  //  cell1.backgroundColor = [UIColor clearColor];
//    cell1.contentView.backgroundColor = Cell_Bg_color
    Parking *park = [allprakings objectAtIndex:indexPath.row];
    
    [cell1 setSelectionStyle:UITableViewCellSelectionStyleNone];
    cell1.parkingNameLb.text = park.parkingName;
    cell1.pakringLocationLb.text = park.parkingaddress;
    cell1.rateLb.text = [NSString stringWithFormat:@"$%@/hr",park.perHourRent];
    if ([park.disableEnable intValue] == 1)
        cell1.disableSwitch.on = YES; 
    else
        cell1.disableSwitch.on = NO;
    
    if ([park.usedDays intValue] > 0)
    {
        cell1.renewBtn.hidden = YES;
        cell1.renewBtnBG.hidden = YES;
    }
    else
    {
        cell1.renewBtn.hidden = NO;
        cell1.renewBtnBG.hidden = NO;
    }
    
    cell1.deletBtn.tag = indexPath.row;
    cell1.disableSwitch.tag = indexPath.row;
    [cell1.deletBtn addTarget:self action:@selector(deleteBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [cell1.disableSwitch addTarget:self action:@selector(disableSwitchChanged:) forControlEvents:UIControlEventValueChanged];
    
    cell1.renewBtn.tag = indexPath.row;
    [cell1.renewBtn addTarget:self action:@selector(renewBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell1;
}

-(IBAction)renewBtnPressed:(id)sender
{
    Parking *park = [allprakings objectAtIndex:[sender tag]];
    float parkinfCost = ([renewalPost floatValue] + [renewalPost floatValue] * ([tax floatValue]/100));
     self.str_amount = [NSString stringWithFormat:@"%.02f",parkinfCost];
    self.renewalPostWithTax = [NSString stringWithFormat:@"%.02f",parkinfCost];
    NSString *alertMessage = [NSString stringWithFormat:@"Renewal Cost : $%@\nTax Rate : %@%@\n\nRenew parking will cost you $%@, Tap continue",renewalPost,tax,@"%",self.renewalPostWithTax];
    [self showCancelUIAlertViewWithtilet:@"Info" andWithMessage:alertMessage selected:park.parkingId selectedParkingName:park.parkingName];
}

-(IBAction)deleteBtnPressed:(id)sender
{
      Parking *park = [allprakings objectAtIndex:[sender tag]];
    deleteSelectedIndex = [sender tag];
    [self showCancelUIAlertViewWithtilet:@"Are you sure?" andWithMessage:@"Do you realy want to delete this Parking" selected:park.parkingId selectedParkingName:park.parkingName];
}
-(IBAction)disableSwitchChanged:(id)sender
{
   UISwitch *disableSwitch = (UISwitch *)sender;
     Parking *park = [allprakings objectAtIndex:[sender tag]];
    NSString *disabled ;
    if (disableSwitch.on) 
    {
     disabled = @"1";   
    }else 
    {
    disabled = @"0";
    }
    [self updateEnableDisableStatusOfIndex:park.parkingId withName:park.parkingName withStatus:disabled];
}

- (IBAction)backBtnPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];

}


#pragma mark Web Services
-(void)updateEnableDisableStatusOfIndex :(NSString *) selectedIndex withName:(NSString *)parkingName withStatus :(NSString *) status
{
   
    //&id=2&st=0
    MBProgressHUD *hud =[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"wait"; 
    NSMutableDictionary *params=[[NSMutableDictionary alloc]initWithObjectsAndKeys:@"parking_available",@"command",selectedIndex,@"id",status ,@"status", nil];
    
    [[NetworkHelper sharedInstance] commandWithParams:params onCompletion:^(NSDictionary *json) {
                //NSLog(@"the json return is %@",json);
        if (![json objectForKey:@"error"]&& json!=nil)
        {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            
            NSDictionary *res=[json objectForKey:@"result"];
            NSString *msg=[NSString stringWithFormat:@"%@",[res objectForKey:@"successful"]];

           
            if ([msg isEqualToString:@"1"] )
            {
                
                if ([status intValue] == 1) 
                {
                 // added by zia   
                  [self showCustomUIAlertViewWithtilet:@"Successful" andWithMessage:[NSString stringWithFormat:@"%@ is Available Now",parkingName]];  
                    
                }else 
                {
                    //added by zia
                [self showCustomUIAlertViewWithtilet:@"Successful" andWithMessage:[NSString stringWithFormat:@"%@ is Unavailable Now",parkingName]];  
                }
                
                
            }                  
            
            
        }else
        {
            NSString *errorMsg =[json objectForKey:@"error"];
            if ([ErrorFunctions isError:errorMsg])
            {
                [self updateEnableDisableStatusOfIndex:selectedIndex withName:parkingName withStatus:status];    
            }
            else
            {
                
                [self showHudWithText:errorMsg];
                
            }
            

        }
    }];


}
-(void)deleteParkingFromIndex :(NSString *)selectedIndex selectedParkingName:(NSString *)parkingName
{
    NSString *isDelete = @"1" ;
  
    MBProgressHUD *hud =[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Deleting..";
    NSMutableDictionary *params=[[NSMutableDictionary alloc]initWithObjectsAndKeys:@"parking_delete",@"command",selectedIndex,@"id",isDelete,@"status", nil];
    
    [[NetworkHelper sharedInstance] commandWithParams:params onCompletion:^(NSDictionary *json) {
       
        //NSLog(@"the json return is %@",json);
        if (![json objectForKey:@"error"]&& json!=nil)
        {
             [MBProgressHUD hideHUDForView:self.view animated:YES];
            NSDictionary *res=[json objectForKey:@"result"];
            NSString *status=[NSString stringWithFormat:@"%@",[res objectForKey:@"successful"]];
            if ([status isEqualToString:@"1"])
            {
                //added by zia
                [self showCustomUIAlertViewWithtilet:@"Successful" andWithMessage:[NSString stringWithFormat:@"%@ deleted",parkingName]];
                [[CMyParking alloc]deleteObjectAtIndex:deleteSelectedIndex];
            } 
           
            
            [self fetchMyParking];
            
            
            
        }else
        {
            NSString *errorMsg =[json objectForKey:@"error"];
            if ([ErrorFunctions isError:errorMsg])
            {
                [self deleteParkingFromIndex:selectedIndex selectedParkingName:parkingName];    
            }
            else
            {
                
                [self showHudWithText:errorMsg];
                
            }
        }
    }];


}
- (void)showCancelUIAlertViewWithtilet :(NSString *)titel andWithMessage:(NSString *)message selected :(NSString *) selectedIndex selectedParkingName:(NSString *)parkingName {
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
                                        [self dismissViewControllerAnimated:YES completion:^
                                         {
                                             if (![titel isEqualToString:@"Info"])
                                                 [self deleteParkingFromIndex:selectedIndex selectedParkingName:parkingName];
                                             else
                                                 [self renewActionFromIndex:selectedIndex selectedParkingName:parkingName];
                                             
                                         }];
                                        

                                        
                                        
                                        
                                    }]];
    
    [self presentViewController:alertViewController animated:YES completion:nil];
}


-(void)renewActionFromIndex :(NSString *)selectedIndex selectedParkingName:(NSString *)parkingName
{
    //[self postStripeToken:tokanId whitAmount:@"0.99"];
    [self renewParking:selectedIndex];
}



#pragma mark
#pragma mark - Stripe
#pragma mark
- (void)postStripeToken:(NSString* )token whitAmount :(NSString *) amount parkingID:(NSString*)parkID{
    //1
    
    //NSLog(@"delg.custromId %@",delg.custromId);
    NSString *finalAmount =[NSString stringWithFormat:@"%.0f",[amount floatValue]*100];
    
    NSURL *postURL = [NSURL URLWithString:STRIPE_TEST_POST_URL];
    AFHTTPClient* httpClient = [AFHTTPClient clientWithBaseURL:postURL];
    httpClient.parameterEncoding = AFJSONParameterEncoding;
    [httpClient registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [httpClient setDefaultHeader:@"Content-Type" value:@"application/json"];
    
    //4
    NSMutableString *stripUrl =[[NSMutableString alloc] init];
    
    [stripUrl appendString:KStripUrl];
    
    [stripUrl appendString:[NSString stringWithFormat:@"stripeCustomer=%@&stripeAmount=%@&sourceId=%@&type=parking",token,finalAmount,parkID]];
    
    //[stripUrl appendString:[NSString stringWithFormat:@"stripeCustomer=%@&stripeAmount=%@",token,finalAmount]];
    NSLog(@"stripUrl %@",stripUrl);
    NSMutableURLRequest* request = [httpClient requestWithMethod:@"GET" path:stripUrl parameters:nil];
    
    self.httpOperation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON)
                          
                          {
                              [MBProgressHUD hideHUDForView:self.view animated:YES];
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
    
    //Add Transaction Details - rejo18042016
    
    MBProgressHUD *hud =[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"wait";
    NSString *str_transactionType = @"2";
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
              [self showCustomUIAlertViewWithtilet:@"Renew Parking" andWithMessage:@"Your Parking has been successfully renewed."];
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
    [self showCustomUIAlertViewWithtilet:@"Payment Not successful" andWithMessage:@"Please try again later."];
}

@end
