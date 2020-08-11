//
//  MainViewController.m
//  FiveStarLuxury_client
//
//  Created by Ridegreen on 22/06/2014.
//  Copyright (c) 2014 Ridegreen. All rights reserved.
//

#import "AppDelegate.h"

#import "ForgotPasswordViewController.h"
@interface MainViewController ()<AVAudioPlayerDelegate>
{
    BOOL isLoginButtonPressed;
    BOOL isViewup;
    
    AppDelegate *delg;
    // STTimeSlider *_timeSlider;
    NSUserDefaults *prefs;
    
    
}

@property (strong, nonatomic) AVAudioPlayer *audioPlayer;
@end

@implementation MainViewController

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
    [super viewDidLoad];
    
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 20)];
    self.emailTF.leftView = paddingView;
    self.emailTF.leftViewMode = UITextFieldViewModeAlways;
    UIView *paddingView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 20)];
    self.passwordTf.leftView = paddingView1;
    self.passwordTf.leftViewMode = UITextFieldViewModeAlways;
    [[UITextField appearance] setTintColor:[UIColor whiteColor]];
    
    self.navigationController.navigationBarHidden = YES;
    [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
    delg =(AppDelegate *)[[UIApplication sharedApplication]delegate];
    // add background image
    [self.emailTF setValue:[UIColor whiteColor]
                forKeyPath:@"placeholderLabel.textColor"];
    [self.passwordTf setValue:[UIColor whiteColor]
                   forKeyPath:@"placeholderLabel.textColor"];
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
            [textField setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
            textField.font = TextField_font;
            if (textField == _emailTF)
            {
                [_emailTF setPlaceholder:NSLocalizedString(@"Email Address", nil)];
                
            }else if (textField == _passwordTf)
            {
                [_passwordTf setPlaceholder:NSLocalizedString(@"Password", nil)];
            }
        }
    }
}
-(void)viewWillAppear:(BOOL)animated
{
    isLoginButtonPressed = NO;
    
    
    
    //  [self performSelector:@selector(showView) withObject:self afterDelay:1.0 ];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@""style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backButton;
    //   [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    self.navigationController.navigationBarHidden = YES;
    self.title =@"Sign In";
    
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




-(void)showRegesterView
{
    NSString * storyboardName = @"Main";
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle: nil];
    RegisterViewController * vc = [storyboard instantiateViewControllerWithIdentifier:@"RegisterView"];
    
    [self.navigationController pushViewController:vc animated:YES];
    
}
-(void)showRemoteView:(UIView *)view position:(int)y
{
    CGRect searchBarFrame;
    searchBarFrame = view.frame;
    searchBarFrame.origin.y =y;
    [UIView animateWithDuration:0.4 delay:0.0 options:UIViewAnimationOptionTransitionFlipFromLeft
                     animations:^{
        view.frame = searchBarFrame;
    }
                     completion:^(BOOL completion) {
        
        ////NSLog(@"Done!");
    }];
    //    ////////NSLog(@"terms view %@",self.resetView);
}
-(void)hideResetView:(UIView *)view position:(int)y
{// hide terms view with animation
    
    CGRect searchBarFrame;
    searchBarFrame = view.frame;
    searchBarFrame.origin.y =y;
    [UIView animateWithDuration:0.4 delay:0.0 options:UIViewAnimationOptionTransitionFlipFromLeft
                     animations:^{
        view.frame = searchBarFrame;
        
    }
                     completion:^(BOOL completion) {
        
        ////NSLog(@"Done!");
    }];
    
}
- (IBAction)logBtnPressed:(id)sender
{
    
    [self userLogin];
}

- (IBAction)regsBtnPressed:(id)sender
{
    // [self showView];
    
    
    NSString * storyboardName = @"Main";
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle: nil];
    RegisterViewController * vc = [storyboard instantiateViewControllerWithIdentifier:@"RegisterView"];
    
    [self.navigationController pushViewController:vc animated:YES];
    
}
#pragma mark UITextField delegate methods
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
    
    if (isiPhone4)
    {
        if (!isViewup)
        {
            [self animatetexfield:textField up:YES];
            isViewup = YES;
        }
        
    }else
    {
        
        
    }
    
    
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    
    if (textField == self.emailTF)
    {
        [self textEditing:self.emailTF];
    }
    
    
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
    
    
    if (textField == _passwordTf)
    {
        if (isiPhone4)
        {
            if (isViewup)
            {
                [self animatetexfield:textField up:NO];
                isViewup = NO;
            }
            
        }else
        {
            
            
        }
        
    }
    
    
}
-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    
    
    if (textField == self.emailTF)
    {
        [self.passwordTf becomeFirstResponder];
    }
    if (textField == self.passwordTf)
    {
        [self logBtnPressed:self];
    }
    
    [textField resignFirstResponder];
    return YES;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    return YES;
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
    return TRUE;
}

-(void)textEditing:(id)sender
{
    if (_emailTF.text.length > 0)
    {
        if ([self validEmailAddress:_emailTF.text])
        {
        }
        else
        {
            // emailtext = @"NO";
            [self showCustomUIAlertViewWithtilet:@"Warning" andWithMessage:@"Please enter valid email address" ];
        }
    }
}

#pragma mark Web Services

-(void)userLogin
{
    [self.emailTF resignFirstResponder];
    [self.passwordTf resignFirstResponder];
    if ([self.emailTF.text length]>0 && [self.passwordTf.text length]>0) {
        
        
        NSString* Identifier = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
        NSLog(@"output is : %@", Identifier);
        
        
        MBProgressHUD *hue=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hue.labelText=@"Trying to Login..";
        NSMutableDictionary *params=[[NSMutableDictionary alloc]initWithObjectsAndKeys:@"login",@"command",self.emailTF.text,@"username",_passwordTf.text,@"password",Identifier,@"uid", nil];
        //Identifier,@"UUID",
        
        [[NetworkHelper sharedInstance] commandWithParams:params onCompletion:^(NSDictionary *json) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            //NSLog(@"the json return is %@",json);
            if (![json objectForKey:@"error"]&& json!=nil)
            {
                
                NSArray *results=[json objectForKey:@"result"];
                NSDictionary *res=[results objectAtIndex:0];
                
                NSString *str_Expiration_Month = [res objectForKey:@"expiration_month"];
                NSString *str_ExpirationYear = [res objectForKey:@"expiration_year"];
                
                
                NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
                
                NSInteger month = [components month];
                NSString *str_Month = [NSString stringWithFormat: @"%ld", (long)month];
                NSInteger year = [components year];
                NSString *str_Year = [NSString stringWithFormat: @"%ld", (long)year];
                
                
                if ([str_ExpirationYear intValue] > [str_Year intValue])
                {
                    
                    delg.userId=[res objectForKey:@"id"];
                    
                    NSString *str_user = [res objectForKey:@"id"];
                    [[NSUserDefaults standardUserDefaults] setObject:str_user forKey:@"user"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    
                    
                    NSString *city_id =[res objectForKey:@"city_id"];
                    NSString *name =[NSString stringWithFormat:@"%@",[res objectForKey:@"first_name"]];
                    NSString *mobile =[res objectForKey:@"mobile"];
                    prefs = [NSUserDefaults standardUserDefaults];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    [prefs setObject:[res objectForKey:@"id"] forKey:@"user_id"];
                    [prefs setObject:name forKey:@"name"];
                    [prefs setObject:mobile forKey:@"mobile"];
                    [prefs setObject:[res objectForKey:@"discount"] forKey:@"discount"];
                    delg.userImageName =[res objectForKey:@"photo"];
                    [prefs setObject:[res objectForKey:@"customerid"] forKey:@"custrom_id"];
                    delg.custromId =[prefs stringForKey:@"custrom_id"];
                    [prefs setObject:city_id forKey:@"city_id"];
                    [prefs setObject:[res objectForKey:@"taxrate"] forKey:@"taxrate"];
                    //NSLog(@"delg.custromId %@",delg.custromId);
                    ////NSLog(@"discount %@",[prefs stringForKey:@"discount"]);
                    
                    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
                    CurrentLocatioView * vc = [storyboard instantiateViewControllerWithIdentifier:@"CurrentLocation"];
                    
                    [self.navigationController setViewControllers:[NSArray arrayWithObject:vc] animated:YES];
                    [self.navigationController pushViewController:vc animated:YES];
                    
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                }
                
                
                else if ([str_ExpirationYear intValue] == [str_Year intValue])
                {
                    if ([str_Expiration_Month intValue] >= [str_Month intValue]) {
                        
                        
                        NSString *str_user = [res objectForKey:@"id"];
                        [[NSUserDefaults standardUserDefaults] setObject:str_user forKey:@"user"];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                        
                        delg.userId=[res objectForKey:@"id"];
                        NSString *city_id =[res objectForKey:@"city_id"];
                        NSString *name =[NSString stringWithFormat:@"%@",[res objectForKey:@"first_name"]];
                        NSString *mobile =[res objectForKey:@"mobile"];
                        prefs = [NSUserDefaults standardUserDefaults];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                        [prefs setObject:[res objectForKey:@"id"] forKey:@"user_id"];
                        [prefs setObject:name forKey:@"name"];
                        [prefs setObject:mobile forKey:@"mobile"];
                        [prefs setObject:[res objectForKey:@"discount"] forKey:@"discount"];
                        delg.userImageName =[res objectForKey:@"photo"];
                        [prefs setObject:[res objectForKey:@"customerid"] forKey:@"custrom_id"];
                        delg.custromId =[prefs stringForKey:@"custrom_id"];
                        [prefs setObject:city_id forKey:@"city_id"];
                        [prefs setObject:[res objectForKey:@"taxrate"] forKey:@"taxrate"];
                        //NSLog(@"delg.custromId %@",delg.custromId);
                        ////NSLog(@"discount %@",[prefs stringForKey:@"discount"]);
                        
                        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
                        CurrentLocatioView * vc = [storyboard instantiateViewControllerWithIdentifier:@"CurrentLocation"];
                        
                        [self.navigationController setViewControllers:[NSArray arrayWithObject:vc] animated:YES];
                        [self.navigationController pushViewController:vc animated:YES];
                        
                        [MBProgressHUD hideHUDForView:self.view animated:YES];
                    }
                    else
                    {
                        [self showCustomUIAlertViewWithtilet:@"Warning" andWithMessage:@"Your card has expired. Please contact Ridegreen admin to update your credit card information."];
                    }
                }
                else
                {
                    [self showCustomUIAlertViewWithtilet:@"Warning" andWithMessage:@"Your card has expired. Please contact Ridegreen admin to update your credit card information."];
                }
                
                
                
            }else
            {
                NSString *errorMsg =[json objectForKey:@"error"];
                if ([ErrorFunctions isError:errorMsg])
                {
                    //[self userLogin];
                }
                else
                {
                    if ([[json objectForKey:@"error"] isEqualToString:@"Please Provide Correct Username or Password?"]) {
                        [self showCustomUIAlertViewWithtilet:@"Warning" andWithMessage:[json objectForKey:@"error"]  ];
                    }
                    else if ([[json objectForKey:@"error"] isEqualToString:@"Your Account has been Temporarily Disabled, Contact to Admin Please!"]) {
                        [self showCustomUIAlertViewWithtilet:@"Warning" andWithMessage:[json objectForKey:@"error"]  ];
                    }
                    else
                    {
                        [self showCancelUIAlertViewWithtiletReset:@"Warning" andWithMessage:[json objectForKey:@"error"]  ];
                        //  [self showCustomUIAlertViewWithtilet:@"Warning" andWithMessage:[json objectForKey:@"error"]  ];
                    }
                }
                NSLog(@"Error :%@",[json objectForKey:@"error"]);
            }
        }];
        
        
    }
    else{
        // Alert if entered user name or   password wrong
        [self showCustomUIAlertViewWithtilet:@"Info" andWithMessage:@"Enter UserName and Password"];
    }
    
}
-(void)playSound
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"button_1" ofType:@"mp3"]; /// set .mp3 name which you have in project
    _audioPlayer=[[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:path] error:NULL];
    _audioPlayer.delegate=self;
    [_audioPlayer play];
}

- (void) animatetexfield: (UITextField*) texfield up: (BOOL) up
{
    const int movementDistance = 50; // tweak as needed
    const float movementDuration = 0.3f; // tweak as needed
    
    int movement = (up ? -movementDistance : movementDistance);
    
    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
}



- (IBAction)howToUseBtnPressed:(id)sender 
{
    [self showHowTouseView];
    
}
-(void)showHowTouseView
{
    NSString * storyboardName = @"Main";
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle: nil];
    HowToUseView * vc = [storyboard instantiateViewControllerWithIdentifier:@"HowToUse"];
    
    [self presentViewController:vc animated:YES completion:nil];
    
}





- (void)showCancelUIAlertViewWithtiletReset :(NSString *)titel andWithMessage:(NSString *)message {
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
            NSLog(@"Cancel Option Clicked");
        }];
    }]];
    
    
    
    
    [alertViewController addAction:[NYAlertAction actionWithTitle:NSLocalizedString(@"Reset", nil)style:UIAlertActionStyleDefault handler:^(NYAlertAction *action)
                                    {
        [self dismissViewControllerAnimated:YES completion:^
         {
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            if ([titel isEqualToString:@"Warning"])
            {
                [self resetLogin];
            }
            
            
        }];
    }]];
    
    
    
    
    [self presentViewController:alertViewController animated:YES completion:nil];
}





-(void)resetLogin{
    MBProgressHUD *hue=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hue.labelText=@"Trying to Reset..";
    NSMutableDictionary *params=[[NSMutableDictionary alloc]initWithObjectsAndKeys:@"reset_login",@"command",self.emailTF.text,@"username", nil];
    
    [[NetworkHelper sharedInstance] commandWithParams:params onCompletion:^(NSDictionary *json) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (![json objectForKey:@"error"]&& json!=nil)
        {
            
            NSArray *results=[json objectForKey:@"result"];
            NSDictionary *res=[results objectAtIndex:0];
            NSString *str_Status =[res objectForKey:@"status"];
            
            if ([str_Status isEqualToString:@"Reset login"])
            {
                [self showCustomUIAlertViewWithtilet_check:@"Info" andWithMessage:@"Reset Succesfully please click login to proceed"];
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                
            }
            
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            
            
        }else
        {
            NSString *errorMsg =[json objectForKey:@"error"];
            if ([ErrorFunctions isError:errorMsg])
            {
            }
            else
            {
                
            }
        }
    }];
}









- (void)showCustomUIAlertViewWithtilet_check :(NSString *)titel andWithMessage:(NSString *)message {
    NYAlertViewController *alertViewController = [[NYAlertViewController alloc] initWithNibName:nil bundle:nil];
    
    alertViewController.backgroundTapDismissalGestureEnabled = YES;
    alertViewController.swipeDismissalGestureEnabled = YES;
    
    alertViewController.title = NSLocalizedString(titel, nil);
    alertViewController.message = NSLocalizedString(message, nil);
    
    alertViewController.buttonCornerRadius = 12.0f;
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







- (void)showCustomUIAlertViewWithtilet :(NSString *)titel andWithMessage:(NSString *)message {
    NYAlertViewController *alertViewController = [[NYAlertViewController alloc] initWithNibName:nil bundle:nil];
    
    alertViewController.backgroundTapDismissalGestureEnabled = YES;
    alertViewController.swipeDismissalGestureEnabled = YES;
    
    alertViewController.title = NSLocalizedString(titel, nil);
    alertViewController.message = NSLocalizedString(message, nil);
    
    alertViewController.buttonCornerRadius = 12.0f;
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




- (IBAction)action_ForgotPassword:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName: @"Main" bundle: nil];
    ForgotPasswordViewController * vc = [storyboard instantiateViewControllerWithIdentifier:@"ForgotPassword"];
    [self.navigationController pushViewController:vc animated:YES];
}





@end
