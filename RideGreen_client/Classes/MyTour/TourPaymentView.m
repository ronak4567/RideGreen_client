//
//  TourPaymentView.m
//  ridegreendriver
//
//  Created by Ridegreen on 02/09/2015.
//  Copyright (c) 2015 Ridegreen. All rights reserved.
//

#import "TourPaymentView.h"

@interface TourPaymentView ()

@end

@implementation TourPaymentView

- (void)viewDidLoad {
    [super viewDidLoad];
    delg =(AppDelegate *)[[UIApplication sharedApplication]delegate];
    prefs =[NSUserDefaults standardUserDefaults];
    self.userId = [prefs stringForKey:@"user_id"];
    delg.custromId = [prefs stringForKey:@"custrom_id"];

    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
       
        if (screenSize.height > 480.0f)
        {
            _starRatingView = [[TQStarRatingView alloc] initWithFrame:CGRectMake(30,405, 250, 50)
                                                         numberOfStar:5];
            _reatingStarsImageview. frame = _starRatingView.frame;
            [self.starRatingView setScore:0.0f withAnimation:YES];
        }
        else
        {
            _starRatingView = [[TQStarRatingView alloc] initWithFrame:CGRectMake(30,320, 250, 50)
                                                         numberOfStar:5];
            _reatingStarsImageview. frame = _starRatingView.frame;
            [self.starRatingView setScore:0.0f withAnimation:YES];
        }
    }
    else
    {
        /*Do iPad stuff here.*/
    }
    
    //    _starRatingView = [[TQStarRatingView alloc] initWithFrame:CGRectMake(30,415, 250, 50)
    //                                                 numberOfStar:5];
    //     [self.starRatingView setScore:0.0f withAnimation:YES];
    _starRatingView.delegate = self;
    [self.view addSubview:_starRatingView];
    [self.starRatingView setAlpha:0.0];
    [self.rateyourClientImage setAlpha:0.0];
    [self.scoreLabel setAlpha:0.0];
    [self.reatingStarsImageview setAlpha:0.0];
    [self.donBtnBg setAlpha:0.0];
    [self.doneBtn setAlpha:0.0];
    
      NSString *totalBill =[NSString stringWithFormat:@"Total bill: %@",self.totalbil];
     NSString *totalHours =[NSString stringWithFormat:@"Total Hours: %@",self.totalHours];
    [UIView animateWithDuration:0.3
                          delay:0.0
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         [self.totalHoursLabel setText:totalHours];
                         [self.totalBillLabel setText:totalBill];
                         [self.starRatingView setAlpha:1.0];
                         [self.rateyourClientImage setAlpha:1.0];
                         [self.scoreLabel setAlpha:1.0];
                         [self.reatingStarsImageview setAlpha:1.0];
                         [self.donBtnBg setAlpha:1.0];
                         [self.doneBtn setAlpha:1.0];
                         
                         
                     }
                     completion:^(BOOL finished){
                         ////NSLog(@"Done!");
                     }];
    [self postStripeToken:delg.custromId whitAmount:_totalbil];
// Do any additional setup after loading the view.
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
#pragma mark
#pragma mark - Stripe 
#pragma mark
- (void)postStripeToken:(NSString* )token whitAmount :(NSString *) amount{
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
    
    [stripUrl appendString:[NSString stringWithFormat:@"stripeCustomer=%@&stripeAmount=%@",token,finalAmount]];
    NSLog(@"stripUrl %@",stripUrl);
    NSMutableURLRequest* request = [httpClient requestWithMethod:@"GET" path:stripUrl parameters:nil];
    
    self.httpOperation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON)
                          
                          {
                              [MBProgressHUD hideHUDForView:self.view animated:YES];
                              NSString *tourId =[prefs objectForKey:@"tourId"];
                              
                              [self updateTourStatustourId:tourId];
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

-(void)updateTourStatustourId:(NSString *)tId 
{
    
    //     NSDate *today = [NSDate date];
    NSDate *today = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm a"];
    NSString *date = [dateFormatter stringFromDate:today];
    
    NSString *status =@"Paid";


    NSMutableDictionary *params=[[NSMutableDictionary alloc]initWithObjectsAndKeys:@"driver_live_tour_status_update",@"command",tId,@"tour_id",status,@"status",date,@"end_time",nil];
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
                [prefs removeObjectForKey:@"tourId"];
                [prefs removeObjectForKey:@"driverId"]; 
                [prefs removeObjectForKey:@"IsTourLive"];
                
                [self chargeDidSucceed];
            }
            
        }
        else{
            ////NSLog(@"Error : %@",[json objectForKey:@"error"]);
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            NSString *errorMsg =[json objectForKey:@"error"];
            if ([ErrorFunctions isError:errorMsg])
            {
                [self updateTourStatustourId:tId];
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

- (void)chargeDidSucceed {
    NSString * msg =[NSString stringWithFormat:@"$%@ has been Paid Successfully",_totalbil];
    [self showCustomUIAlertViewWithtilet:@"Done" andWithMessage:msg];
}

- (void)chargeDidNotSuceed {
    [self showCustomUIAlertViewWithtilet:@"Not successful" andWithMessage:@"Please try again later."];
}

-(void)updateRating:(NSString *)rating withClientId :(NSString *)clientId
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSMutableDictionary *params=[[NSMutableDictionary alloc]initWithObjectsAndKeys:@"update_client_reting",@"command",clientId,@"d_id",rating,@"rating", nil];
    [[NetworkHelper sharedInstance] commandWithParams:params onCompletion:^(NSDictionary *json) {
     
        if (![json objectForKey:@"error"]&&json!=nil)
        {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            ////NSLog(@"result is %@",json);
            [prefs setObject:@"No" forKey:@"IsTourLive"];
            [self showCurrentLocationViewController];
        }
        else{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            NSString *errorMsg =[json objectForKey:@"error"];
            if ([ErrorFunctions isError:errorMsg])
            {
                [self updateRating:rating withClientId:clientId];
            }
            else
            {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                NSLog(@"Error :%@",[json objectForKey:@"error"]);
                [self showCustomUIAlertViewWithtilet:@"Info" andWithMessage:[json objectForKey:@"error"]];
            }
        }
    }];
}



- (IBAction)doneBtnPressed:(id)sender 
{
    NSString *clientId =[prefs objectForKey:@"clientId"];
    
    [self updateRating:self.scoreLabel.text withClientId:clientId];

}
-(void)starRatingView:(TQStarRatingView *)view score:(float)score
{
    self.scoreLabel.text = [NSString stringWithFormat:@"%0.2f",score * 10 ];
    ////NSLog(@" self.scoreLabel.text %@", self.scoreLabel.text);
}

- (IBAction)scoreButtonTouchUpInside:(id)sender
{
    //设置分数。参数需要在0-1之间。
    [self.starRatingView setScore:0.5f withAnimation:YES];
    
    //or
    /*
     z
     [self.starRatingView setScore:0.5f withAnimation:YES completion:^(BOOL finished)
     {
     ////NSLog(@"%@",@"starOver");
     }];
     
     */
}
-(void)showCurrentLocationViewController
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    CurrentLocatioView * vc = [storyboard instantiateViewControllerWithIdentifier:@"CurrentLocation"];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:vc];
    
    [self presentViewController:navigationController animated:YES completion:nil]; 
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
                                             if ([message isEqualToString:@"Reservation successfully completed"])
                                             {
                                                 [self.navigationController popViewControllerAnimated:YES];
                                                 
                                             }
                                         }];                                        
                                    }]];
    
    //    [alertViewController addAction:[NYAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil)
    //                                                            style:UIAlertActionStyleCancel
    //                                                          handler:^(NYAlertAction *action) {
    //                                                              [self dismissViewControllerAnimated:YES completion:nil];
    //                                                          }]];
    
    [self presentViewController:alertViewController animated:YES completion:nil];
}

@end
