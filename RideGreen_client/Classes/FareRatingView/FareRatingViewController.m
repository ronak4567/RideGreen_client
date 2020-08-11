//
//  FareRatingViewController.m
//  fivestar
//
//  Created by Ridegreen on 15/09/2014.
//  Copyright (c) 2014 Ridegreen. All rights reserved.
//
#import "AppDelegate.h"
#import "NetworkHelper.h"
#import "MBProgressHUD.h"
#import "FareRatingViewController.h"
#import "CurrentLocatioView.h"
#import "NYAlertViewController.h"

@interface FareRatingViewController ()
{
    AppDelegate *dleg;
    NSString *ratingIs;
    NSString *isCash;
    NSString *isCC;
}
@property (nonatomic,strong) NSTimer *updatingTimer;

@property (nonatomic,retain)  NSString *ratingIs;
@end

@implementation FareRatingViewController
@synthesize ratingIs;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    if([self.isMyRental isEqualToString:@"isMyRental"])
    {
        self.rateTitleImageView.image = [UIImage imageNamed:@"rate_room_text.png"];
        }
    else
        {
            self.rateTitleImageView.image = [UIImage imageNamed:@"rate_driver_text.png"];
            }
     [self rating];
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
   
    dleg =(AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if ([self.isMyRental isEqualToString:@"isMyRental"])
        [self.fareLabel setText:[NSString stringWithFormat:@"$%@",self.roomfare]];
    else
      [self.fareLabel setText:[NSString stringWithFormat:@"$%@",dleg.finalFare]];
    
    [self.totalPaidTF setValue:[UIColor whiteColor]
                forKeyPath:@"_placeholderLabel.textColor"];
    isCash = @"0";
    isCC = @"0";
    [self.waitingLabel setHidden:YES];
   
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)rating
{
    //38,437,242,36
    
    CGRect frame ; 
    CGRect scorLabelFrame = _scoreLabel.frame;
    if (isiPhone6)
    {
        frame =  CGRectMake(63,478, 250, 50);
    }
    else if (isiPhone5)
    {
        frame =  CGRectMake(35,401, 250, 50);
        
    }else if (isiPhone4)
    {
        frame = CGRectMake(35,320, 250, 50);
        
    }
    
    scorLabelFrame.origin.y = frame.origin.y - _scoreLabel.frame.size.height - 10;
    _scoreLabel.frame = scorLabelFrame;
    _starRatingView = [[TQStarRatingView alloc] initWithFrame:frame numberOfStar:5];
    _reatingStarsImageview. frame = _starRatingView.frame;
    [self.starRatingView setScore:0.0f withAnimation:YES];    
    _starRatingView.delegate = self;
    [self.view addSubview:_starRatingView];
    
    
}
-(void)starRatingView:(TQStarRatingView *)view score:(float)score
{
   self.ratingIs = [NSString stringWithFormat:@"%0.2f",score * 100 ];
    ////NSLog(@" ratingIs %@",self.ratingIs);
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

-(void)updateRating
{

    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSMutableDictionary *params;
    if([self.isMyRental isEqualToString:@"isMyRental"])
        {
            
            params=[[NSMutableDictionary alloc]initWithObjectsAndKeys:@"update_room_rating",@"command",[[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"],@"user_id",ratingIs,@"rating",self.roomid,@"room_id", nil];
            //[self.navigationController popViewControllerAnimated:YES];
            
            }
    else{
        params=[[NSMutableDictionary alloc]initWithObjectsAndKeys:@"update_driver_reting",@"command",dleg.selectedDriverId,@"user_id",ratingIs,@"rating", nil];
        }
    //update_driver_reting ($user_id,$rating)
    ////NSLog(@"ratingIs %@",self.ratingIs);
    //NSMutableDictionary *params=[[NSMutableDictionary alloc]initWithObjectsAndKeys:@"update_driver_reting",@"command",dleg.selectedDriverId,@"user_id",ratingIs,@"rating", nil];
    
    
    [[NetworkHelper sharedInstance] commandWithParams:params onCompletion:^(NSDictionary *json) {
        // NSArray *results=[json objectForKey:@"result"];
        if (![json objectForKey:@"error"]&&json!=nil)
            {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                ////NSLog(@"result is %@",json);
                if ([self.isMyRental isEqualToString:@"isMyRental"]) {
                    [self.navigationController popViewControllerAnimated:YES];
                    }
                else{
                    dleg.isConected = NO;
                    /*UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
                    CurrentLocatioView * vc = [storyboard instantiateViewControllerWithIdentifier:@"CurrentLocation"];
                    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:vc];
                    
                    [self presentViewController:navigationController animated:YES completion:nil];*/
                    [self.navigationController popViewControllerAnimated:YES];
                    
                    }
                }
        else{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            NSString *errorMsg =[json objectForKey:@"error"];
            if ([ErrorFunctions isError:errorMsg])
                {
                    [self updateRating];
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

- (IBAction)proceedBtnPressed:(id)sender
{
    [self updateRating];
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
@end
