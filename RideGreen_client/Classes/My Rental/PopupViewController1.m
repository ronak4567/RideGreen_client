//
//  PopupViewController1.m
//  STPopup
//
//  Created by Kevin Lin on 11/9/15.
//  Copyright (c) 2015 Sth4Me. All rights reserved.
//

#import "PopupViewController1.h"


@implementation PopupViewController1
{
    UILabel     *_label;
    UIImageView *_driverImage;
    UIImageView *_buttonBgImage;
    UILabel     *_carNumberLabel;
    UIImageView *_carImage;
    UIButton    *_callButton;
    UIButton    *_fixedButton;
    UIButton    *_connectButton;
    //StarRatingView *starviewAnimated;
    PopupView *mainView;
}

- (instancetype)init
{
    if (self = [super init]) {
        //self.title = NSLocalizedString(@"Client Info",nil);
        self.contentSizeInPopup = CGSizeMake(270,100);
        self.landscapeContentSizeInPopup = CGSizeMake(400, 200);
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    delg = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    
   
    
    NSArray *subviewArray = [[NSBundle mainBundle] loadNibNamed:@"PopupView" owner:self options:nil];
    mainView = [subviewArray objectAtIndex:0];
    mainView.nameLabel.text = self.request.clientName;
    //mainView.lbl_ClientRating.text = [NSString stringWithFormat:@"Rating : %@",self.request.roomrating];
    if (_isMyRented) 
    {
        mainView.phoneLabel.text = self.request.clientphone;
    }else 
    {
     mainView.phoneLabel.text = self.request.clientphone;
    }
   
    
    CGRect frame = CGRectMake(0, 0,70,15);
    
    StarRatingView *starviewAnimated = [[StarRatingView alloc]initWithFrame:frame andRating:[self.request.clientrating intValue] withLabel:NO animated:YES];
    [mainView.bgView addSubview:starviewAnimated];
    
  
      mainView.clientImageView.layer.borderColor = [UIColor whiteColor].CGColor;
     mainView.clientImageView.layer.borderWidth = 2;
    mainView.clientImageView.layer.cornerRadius = mainView.clientImageView.frame.size.width/2 ;
     mainView.clientImageView.layer.masksToBounds = YES;
    [mainView.clientImageView setImage:[UIImage imageNamed:@"image_blank.png"]];
    
    CGFloat imgviewHight = CGRectGetHeight(mainView.clientImageView.frame);
    CGFloat imgviewWidth = CGRectGetWidth (mainView.clientImageView.frame);
    cSpinner = [[TJSpinner alloc] initWithSpinnerType:kTJSpinnerTypeCircular];
    cSpinner.center = CGPointMake(imgviewWidth / 2, imgviewHight / 2);
    cSpinner.hidesWhenStopped = YES;
    [cSpinner setHidden:YES];
    [mainView.clientImageView addSubview:cSpinner];
    
    
    
    
    [mainView.callBtn addTarget:self action:@selector(callBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:mainView];
    
        [self displayClientImage];
}

-(void)displayClientImage
{
 
      
    if (![_request.clientphoto isEqualToString:@"0"]) 
    {   [cSpinner setHidden:NO];
        [cSpinner startAnimating];
        NSString *imageUrl =[NSString stringWithFormat:@"%@upload/%@",kAPIHost,_request.clientphoto];
        [mainView.clientImageView setImageWithURLRequest:[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:imageUrl]]placeholderImage:[UIImage imageNamed:@"image_blank.png"]
            success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image)
         {
             
             mainView.clientImageView.image = image;
             [cSpinner stopAnimating];
             mainView.isImage = YES;
             
         }  failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error){
             [cSpinner stopAnimating];
             mainView.isImage = NO;
         }];
  
    }else 
    {
        mainView.isImage = NO;
    }
    
   

}

-(IBAction)connectBtnPressed:(id)sender
{

    isFixed = NO;
    //[self ContactDriverWithId:_driver.driverId];

}
-(IBAction)fixedBtnPressed:(id)sender
{
    isFixed = YES;
   // [self ContactDriverWithId:_driver.driverId];
    
}

#pragma mark connactDriver
-(void)ContactDriverWithId :(NSString *)driverId
{
    
    
    NSDate *today = [NSDate date];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    
    // Get the date time in NSString
    NSString *date = [dateFormatter stringFromDate:today];
    //NSLog(@"car type is %@",delg.getCarBtntag);
    NSString *fixed;
    NSString *clientFixedFare;
      
    NSString *currentActivity;
   
    if ([delg.destinationLatitude length] == 0 && [delg.destinationLongitude length] == 0) 
    {
        delg.destinationLatitude = @"00.000000";
        delg.destinationLongitude= @"00.000000";
        fixed = @"0";
        clientFixedFare = @"0";  
       
         currentActivity =@"Waiting for driver";
    }else 
    {
        if (isFixed) 
        {
            fixed = @"1";
            clientFixedFare = @"1";  
            currentActivity =@"Client requested fixed fare";
        }else 
        {
            fixed = @"0";
            clientFixedFare = @"0";  
           currentActivity =@"Client Requseted";
        }
    
    }
    MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText=@"wait....";
    
    NSMutableDictionary *params=[[NSMutableDictionary alloc]initWithObjectsAndKeys:@"client_s_d_gps",@"command",delg.sourceLongitude,@"client_source_longitude",delg.sourceLatitude,@"client_source_latitude",delg.destinationLongitude,@"client_d_longitude",delg.destinationLatitude,@"client_d_latitude",delg.userId,@"client_id",driverId,@"driver_id",date,@"date",fixed,@"is_fixed",clientFixedFare,@"client_fixed_fare",currentActivity,@" current_activity", nil];
    
    
    [[NetworkHelper sharedInstance] commandWithParams:params onCompletion:^(NSDictionary *json) 
    {
        
        NSArray *results=[json objectForKey:@"result"];
        NSDictionary *res=[results objectAtIndex:0];
        //////NSLog(@"result is %@",res);
        if (res != nil) {
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            delg.isConected = YES;
            
            [self showCustomUIAlertViewWithtilet:@"Info" andWithMessage:@"You are being connected"];
            delg.distinationId =[res objectForKey:@"d_id"];
           
            
            
            
        }
        else{
            
            NSString *errorMsg =[json objectForKey:@"error"];
            if ([ErrorFunctions isError:errorMsg])
            {
                [self ContactDriverWithId:driverId];
            }
            else if ([errorMsg isEqualToString:@"Driver just hired by other client, Please contact another Driver"])
            {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [self showCustomUIAlertViewWithtilet:@"Oops" andWithMessage:[json objectForKey:@"error"]];
                
                
                
            }
            else
            {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                
                [self showCustomUIAlertViewWithtilet:@"Oops" andWithMessage:[json objectForKey:@"error"]];
                
                
                
                
                
            }
            
        }
    }];
    
}
-(void)drawRatingStarViewWith:(NSString *)rating
{
    
  
    
    
    
}

- (IBAction)callBtnPressed:(id)sender
{
    [self makePhoneCallWithNumber:_request.clientphone];
}
-(void)makePhoneCallWithNumber:(NSString *)pNumber
{
    if (_isMyRented) 
    {
        pNumber = self.request.adminphone;
    }
    
    NSString *phoneNumber = [@"telprompt://" stringByAppendingString:pNumber];
    NSString *cleanedString = [[phoneNumber componentsSeparatedByCharactersInSet:[[NSCharacterSet characterSetWithCharactersInString:@"0123456789-+()"] invertedSet]] componentsJoinedByString:@""];
    NSString *escapedPhoneNumber = [cleanedString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *phoneURLString = [NSString stringWithFormat:@"telprompt:%@", escapedPhoneNumber];
    NSURL *phoneURL = [NSURL URLWithString:phoneURLString];
    
    if ([[UIApplication sharedApplication] canOpenURL:phoneURL]) {
        [[UIApplication sharedApplication] openURL:phoneURL];
    }
    
    
}



- (void)showCustomUIAlertViewWithtilet :(NSString *)titel andWithMessage:(NSString *)message {
    
    
    NYAlertViewController *alertViewController = [[NYAlertViewController alloc] initWithNibName:nil bundle:nil];
    
    alertViewController.backgroundTapDismissalGestureEnabled = YES;
    alertViewController.swipeDismissalGestureEnabled = YES;
    
    alertViewController.title = NSLocalizedString(titel, nil);
    alertViewController.message = NSLocalizedString(message, nil);
    
     //alertViewController.buttonCornerRadius = kRadiuseCorner;
    
    alertViewController.view.tintColor = self.view.tintColor;
    
    alertViewController.titleFont = [UIFont fontWithName:@"AvenirNext-Bold" size:18.0f];
    
    alertViewController.messageFont = [UIFont fontWithName:@"AvenirNext-Medium" size:16.0f];
    
    alertViewController.buttonTitleFont = [UIFont fontWithName:@"AvenirNext-Regular" size:alertViewController.buttonTitleFont.pointSize];
    
    alertViewController.cancelButtonTitleFont = [UIFont fontWithName:@"AvenirNext-Medium" size:alertViewController.cancelButtonTitleFont.pointSize];
    
    
    //alertViewController.alertViewBackgroundColor = Bar_color;
    
    alertViewController.alertViewCornerRadius = 10.0f;
    
    alertViewController.titleColor = [UIColor whiteColor];
    
    alertViewController.messageColor = [UIColor colorWithWhite:0.92f alpha:1.0f];
    
    alertViewController.buttonColor = Black_Color;
    
    alertViewController.buttonTitleColor = White_Color;
    
    alertViewController.cancelButtonColor = Black_Color;
    
    alertViewController.cancelButtonTitleColor = White_Color;
    
    [alertViewController addAction:[NYAlertAction actionWithTitle:NSLocalizedString(@"OK", nil)style:UIAlertActionStyleDefault handler:^(NYAlertAction *action) 
                                    {
                                        [self dismissViewControllerAnimated:YES completion:^
                                        {
                                            if ([NSLocalizedString(message, nil) isEqualToString:NSLocalizedString(@"You are being connected", nil)]) 
                                            {
                                                [self.popupController dismiss];  
                                                
                                            }
                                        }];
  
                                    }]];
    
    
    [self presentViewController:alertViewController animated:YES completion:nil];
}

@end
