//
//  ForgotPasswordViewController.m
//  ridegreendriver
//
//  Created by VGS_036 on 19/01/16.
//  Copyright © 2016 Ridegreen. All rights reserved.
//

#import "ForgotPasswordViewController.h"

@interface ForgotPasswordViewController ()

@end

@implementation ForgotPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.txt_Email.delegate = self;
    
    [self.txt_Email becomeFirstResponder];
    [self.txt_Email setValue:[UIColor whiteColor] forKeyPath:@"placeholderLabel.textColor"];
    
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (IBAction)action_Back:(id)sender {
    [self.navigationController popViewControllerAnimated:NO];
}

- (IBAction)action_Submit:(id)sender {
    
    if ([self.txt_Email.text length]>0){
        if ([self validEmailAddress:self.txt_Email.text])
        {
            NSMutableDictionary *params=[[NSMutableDictionary alloc]initWithObjectsAndKeys:@"forogotpassword_client",@"command",self.txt_Email.text,@"forgotemail", nil];
            
            [[NetworkHelper sharedInstance] commandWithParams:params onCompletion:^(NSDictionary *json) {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                NSLog(@"the json return is %@",json);
                if (![json objectForKey:@"error"]&& json!=nil)
                {
                    NSArray *results=[json objectForKey:@"result"];
                    BOOL str = [results valueForKey:@"successful"];
                    
                    if (str)
                    {
                        self.txt_Email.text = @"";
                        [self.navigationController popViewControllerAnimated:NO];
                        [self showCustomUIAlertViewWithtilet:@"Info" andWithMessage:@"New Password has been sent to your Email Id given"];
                    }
                }
                else
                {
                    NSLog(@"Error :%@",[json objectForKey:@"error"]);
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    NSString *errorMsg =[json objectForKey:@"error"];
                    if ([ErrorFunctions isError:errorMsg])
                    {
                    }
                    else
                    {
                        [self showCustomUIAlertViewWithtilet:@"Info" andWithMessage:[json objectForKey:@"error"]];
                    }
                }
            }];
        }
        else
        {
            [self showCustomUIAlertViewWithtilet:@"Info" andWithMessage:@"Please enter valid email address"];
            [self.txt_Email becomeFirstResponder];
        }
    }
    else{
        [self showCustomUIAlertViewWithtilet:@"Info" andWithMessage:@"Enter your Email Address"];
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
    return TRUE;
}

- (void)showCustomUIAlertViewWithtilet :(NSString *)titel andWithMessage:(NSString *)message {
    
    
    NSInteger actionCount = 1;
    NYAlertViewController *alertViewController = [[NYAlertViewController alloc] initWithNibName:nil bundle:nil];
    [alertViewController setTransitioningDelegate:self];
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
    
    for (int i = 0; i < actionCount; i++) {
        NSString *actionTitle = [NSString stringWithFormat:NSLocalizedString(@"Action %d", nil), i + 1];
        UIAlertActionStyle actionStyle = UIAlertActionStyleDefault;
        
        // Set up the final action as a cancel button
        if (i == actionCount - 1) {
            actionTitle = NSLocalizedString(@"Cancel", nil);
            actionStyle = UIAlertActionStyleCancel;
        }
        
        [alertViewController addAction:[NYAlertAction actionWithTitle:actionTitle style:actionStyle handler:^(NYAlertAction *action)
                                        {
                                            [self dismissViewControllerAnimated:YES completion:nil];
                                            
                                            
                                        }]];
    }
    [self presentViewController:alertViewController animated:YES completion:nil];
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


- (void)dealloc {
    [_txt_Email release];
    [super dealloc];
}
@end
