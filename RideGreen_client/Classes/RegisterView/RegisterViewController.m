//
//  RegisterViewController.m
//  fiveStarLuxuryCars
//
//  Created by Ridegreen on 06/05/2014.
//  Copyright (c) 2014 Ridegreen. All rights reserved.
//



#import "AppDelegate.h"



#define ORIGINAL_MAX_WIDTH 640.0f
#define kPayPalEnvironment  PayPalEnvironmentSandbox
@interface RegisterViewController ()<VPImageCropperDelegate,SampleProtocolDelegate>
{
    AppDelegate *delg;
    UIBarButtonItem *anotherButton;
    UIBarButtonItem *anotherButton2;
    NSURL *referenceURL;
    NSString * refUrl;
    NSString * thumbrefUrl;
    NSString *advId;
    NSString *countryName;
    int selectedIndex;
    int aid ;
    int page;
}
@property (strong, nonatomic) AFJSONRequestOperation* httpOperation;
@property (strong,nonatomic)UIPageControl *pageControl;
@property (nonatomic ,retain) UIImage *image;

@end
bool isShown ;
bool iscountryBtnPressed = false;
@implementation RegisterViewController
{
    //STTimeSlider *_timeSlider;
}

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
    [self.nextBtn setHidden:YES];
    [self.submitBtn setHidden:YES];
    [self.registerBtn setSelected:YES];
    [self setTitle:@"Register"];
    
    isTermsCondition = NO;
    
    stateIds   =[NSMutableArray new];
    stateNames =[NSMutableArray new];
    cityIds    =[NSMutableArray new];
    cityNames  =[NSMutableArray new];
    isViewUp = NO;
    [[UITextField appearance] setTintColor:[UIColor whiteColor]];
    countryName = @"USA";
    isShown = false;
    self.stateTF.inputView = [UIView new];
    self.cityTF.inputView = [UIView new];
    [self fetchAllStates];
    
    [self textFieldSetup];
}

- (void) expirationDate :(NSString *)str_date CardNumber :(NSString *)str_CardNo
{
    self.str_ExpirationDate = str_date;
    NSString *trimmedString=[str_CardNo substringFromIndex:MAX((int)[str_CardNo length]-4, 0)];
    self.str_CardNumber = trimmedString;
}

-(void)textFieldSetup
{
    NSArray *fields = self.nextView.subviews ; //get all subviews from your scrollview
    UIToolbar *toolbar = [[UIToolbar alloc] init];
    [toolbar setBarStyle:UIBarStyleBlackTranslucent];
    [toolbar sizeToFit];
    UIBarButtonItem *buttonflexible = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *buttonDone = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneClicked:)];
    
    [toolbar setItems:[NSArray arrayWithObjects:buttonflexible,buttonDone, nil]];
    for (int i=0; i<[fields count]; i++)
    {
        if([[fields objectAtIndex:i] isKindOfClass:[UITextField class]]) //check for UITextField
        {
            UITextField *textField = (UITextField *)[fields objectAtIndex:i];
            UIView* dummyView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,5,45)];
            textField.leftView = dummyView;
            textField.leftViewMode = UITextFieldViewModeAlways;
            textField.autocorrectionType = UITextAutocorrectionTypeNo;
            [textField setValue:[UIColor lightGrayColor]
                     forKeyPath:@"placeholderLabel.textColor"];
            [textField resignFirstResponder];
            textField.inputAccessoryView = toolbar;
        }
    }
    _cityTF.inputAccessoryView = nil;
    _stateTF.inputAccessoryView = nil;
    _imageView.layer.borderColor   = White_ColorCG;
    _imageView.layer.borderWidth   = 2.0f;
    _imageView.layer.cornerRadius  = _imageView.frame.size.width/2;
    _imageView.layer.masksToBounds = YES;
}
-(void)doneClicked:(UIBarButtonItem*)button
{
    if (isViewUp)
    {
        [self animatetexfieldup:NO];
        isViewUp = NO;
    }
    [self.view endEditing:YES];
    
    
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    delg =(AppDelegate *)[[UIApplication sharedApplication]delegate];
    if (delg.isgotToken)
    {
        if (self.imageView.image != nil)
        {
            [self upLoadImageNew];
        }else
        {
            [self submitFrom];
        }
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@""style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backButton;
    
    
    //[self.registerBtn setSelected:YES];
    //[self.signBtn setSelected:NO];
    
    
    //     [PayPalMobile preconnectWithEnvironment:self.environment];
    //
    //    [self pay];
}
- (IBAction)signBtnPressed:(id)sender
{
    [self.pageControl removeFromSuperview];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == self.mobileTf)
    {
        NSUInteger newLength = [textField.text length] + [string length] - range.length;
        return (newLength > 10) ? NO : YES;
    }
    if (textField == self.passwordTf)
    {
        [self.nextBtn setHidden:NO];
        //[self.submitBtn setHidden:YES];
    }
    if (textField == self.lastNameTf)
    {
        
        //[self.submitBtn setHidden:NO];
        [self.nextBtn setHidden:YES];
    }
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    //selectedTextField
    
    if (isiPhone5)
    {
        if ((textField == self.passwordTf && !isViewUp) || (textField == self.confirmPasswordTF && !isViewUp))
        {
            [self animatetexfieldup:YES];
            isViewUp = YES;
        }
        else
        {
            
        }
    }
    
    if (textField == _stateTF )
    {
        [self.firstNameTf resignFirstResponder];
        [self.lastNameTf resignFirstResponder];
        [self.emailTf resignFirstResponder];
        [self.mobileTf resignFirstResponder];
        [self.passwordTf resignFirstResponder];
        [self.confirmPasswordTF resignFirstResponder];
        [self showslectionView];
    }
    
    else if (textField == _cityTF && [_stateTF.text length] != 0)
    {
        [self.firstNameTf resignFirstResponder];
        [self.lastNameTf resignFirstResponder];
        [self.emailTf resignFirstResponder];
        [self.mobileTf resignFirstResponder];
        [self.passwordTf resignFirstResponder];
        [self.confirmPasswordTF resignFirstResponder];
        [self showslectionView];
    }
    else if (textField == _cityTF && [_stateTF.text length] == 0)
    {
        [self.firstNameTf resignFirstResponder];
        [self.lastNameTf resignFirstResponder];
        [self.emailTf resignFirstResponder];
        [self.mobileTf resignFirstResponder];
        [self.passwordTf resignFirstResponder];
        [self.confirmPasswordTF resignFirstResponder];
        [self showCustomUIAlertViewWithtilet:@"Info" andWithMessage:@"Please select state first"];
    }
}


- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    if (textField == self.emailTf)
    {
        [self textEditing:self.emailTf];
    }
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (isiPhone5)
    {
        if (textField == self.confirmPasswordTF &&  isViewUp) {
            
            [self animatetexfieldup:NO];
            isViewUp = NO;
        }
        [self setEditing:NO animated:YES];
        
    }
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    
    if ([self.firstNameTf.text length] != 0 && [self.firstNameTf.text length] != 0 && [self.emailTf.text length] != 0 && [self.passwordTf.text length] != 0 && [self.confirmPasswordTF.text length] != 0 &&[self.mobileTf.text length] != 0)
        
    {
        if ([self.passwordTf.text isEqualToString:self.confirmPasswordTF.text])
        {
            [self EmailValidationFromDb];
            
        }
        else
        {
            [self showCustomUIAlertViewWithtilet:@"Info" andWithMessage:@"Password do not match"];
            
        }
    }
    else
    {
        [self showCustomUIAlertViewWithtilet:@"Info" andWithMessage:@"Some Fields are empty"];
    }
    [textField resignFirstResponder];
    
    return YES;
}
- (void) animatetexfieldup: (BOOL) up
{
    const int movementDistance = 50; // tweak as needed
    const float movementDuration = 0.3f; // tweak as needed
    
    int movement = (up ? -movementDistance : movementDistance);
    
    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.nextView.frame = CGRectOffset(self.nextView.frame, 0, movement);
    [UIView commitAnimations];
}
- (IBAction)exitBtnclicked:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
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
    if (_emailTf.text.length > 0)
    {
        if ([self validEmailAddress:_emailTf.text])
            
        {
            
        }
        else
        {
            // emailtext = @"NO";
            if ([self.emailTf becomeFirstResponder])
            {
                [self.emailTf resignFirstResponder];
            }
            if ([self.mobileTf becomeFirstResponder])
            {
                [self.mobileTf resignFirstResponder];
            }
            if ([self.passwordTf becomeFirstResponder])
            {
                [self.passwordTf resignFirstResponder];
            }
            
            [self showCustomUIAlertViewWithtilet:@"Info" andWithMessage:@"Please enter valid email address"];
            
            
            
        }
    }
    
    
    
}

-(void)EmailValidationFromDb
{
    NSString *email = self.emailTf.text;
    NSMutableDictionary *params=[[NSMutableDictionary alloc]initWithObjectsAndKeys:@"email_validation",@"command",email,@"email", nil];
    MBProgressHUD *hude=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hude.labelText=@"Validating Email ";
    [[NetworkHelper sharedInstance] commandWithParams:params onCompletion:^(NSDictionary *json) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (![json objectForKey:@"error"]&&json!=nil) {
            //NSLog(@"json result is %@",json);
            NSDictionary *res=[json objectForKey:@"result"];
            NSString *status=[NSString stringWithFormat:@"%@",[res objectForKey:@"successful"]];
            if ([status isEqualToString:@"1"])
            {
                delg.clientName  = self.firstNameTf.text;
                delg.ClientEmail = self.emailTf.text;
                ////NSLog(@"delg.clientName %@ ,delg.ClientEmail %@",delg.clientName ,delg.ClientEmail );
                NSString * storyboardName = @"Main";
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle: nil];
                RWStripeViewController * Dvc = [storyboard instantiateViewControllerWithIdentifier:@"RWStripeView"];
                Dvc.delegate = self;
                [self.navigationController pushViewController:Dvc animated:YES];
                
            }
            else
            {
                //NSLog(@"result is %@",json);
                [self showCustomUIAlertViewWithtilet:@"Some thing wrong" andWithMessage:@"Account Not Created"];
                
            }
        }
        else{
            //NSLog(@"Error : %@",[json objectForKey:@"error"]);
            NSString *errorMsg =[json objectForKey:@"error"];
            if ([ErrorFunctions isError:errorMsg])
            {
                [self EmailValidationFromDb];
            }
            else
            {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [self showCustomUIAlertViewWithtilet:@"Some thing wrong" andWithMessage:[json objectForKey:@"error"]];
            }
        }
    }];
    
}
#pragma mark upload image

-(void)upLoadImageNew
{
    // [self hideNextView];
    aid = arc4random() % 10000;
    advId =[NSString stringWithFormat:@"adv%d",aid];
    
    //NSLog(@"advId %@",advId);
    
    MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText=@"Uploding Image";
    [[API sharedInstance] commandWithParams:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"uploadNew", @"command", UIImageJPEGRepresentation(self.imageView.image,0.6), @"file",advId, @"title", nil] onCompletion:^(NSDictionary *json)
     {
         ////NSLog(@"result is %@",[json objectForKey:@"result"]);
         //completion
         if (![json objectForKey:@"error"]&&[json objectForKey:@"result"]!=nil)
         {
             [MBProgressHUD hideHUDForView:self.view animated:YES];
             //success
             
             [self submitFrom];
         } else
         {
             [MBProgressHUD hideHUDForView:self.view animated:YES];
             NSString* errorMsg = [json objectForKey:@"error"];
             //////NSLog(@"error :%@",errorMsg);
             [self upLoadImageNew];
             if ([@"Authorization required" compare:errorMsg]==NSOrderedSame)
             {
             }
         }
     }];
    
}
- (IBAction)imageBtnPressed:(id)sender
{
    [self showActionSheet];
}

- (IBAction)backBtnPressed:(id)sender
{
    [self.mobileTf resignFirstResponder];
    [self.emailTf resignFirstResponder];
    [self.passwordTf resignFirstResponder];
    if (isShown == true)
    {
        // [self hideNextView];
    }else
    {
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (IBAction)nextBtnPressed:(id)sender
{
    [self submitBtnPressed:self];
}

- (IBAction)submitBtnPressed:(id)sender
{
    //  aid = arc4random() % 10000;
    
    [self.emailTf resignFirstResponder];
    [self.passwordTf resignFirstResponder];
    [self.mobileTf resignFirstResponder];
    [self.firstNameTf resignFirstResponder];
    [self.lastNameTf resignFirstResponder];
    NSString *fname=self.firstNameTf.text;
    NSString *lname=self.lastNameTf.text;
    NSString *password = self.passwordTf.text;
    NSString *confirmPassword = self.confirmPasswordTF.text;
    NSString *email = self.emailTf.text;
    NSString *phone = self.mobileTf.text;
    NSString *state = self.stateTF.text;
    NSString *city = self.cityTF.text;
    
    if ([email length] != 0 && [password length] != 0 && [email length]!=0 && [fname length]!=0 && [lname length]!=0 && [phone length]!=0 && ![countryName isEqualToString:@""] && [state length]!= 0 && [city length]!= 0)
    {
        if (self.imageView.image == nil){
            [self showCustomUIAlertViewWithtilet:@"Warning" andWithMessage:@"Please upload your profile Image. "];
        }
        else if([self.passwordTf.text length] < 6)
        {
            [self showCustomUIAlertViewWithtilet:@"Warning" andWithMessage:@"password should be at least 6 character "];
        }
        else if (!isTermsCondition)
        {
            [self showCustomUIAlertViewWithtilet:@"Warning" andWithMessage:@"Please agree with the Terms and Conditions."];
        }
        else if (![self.passwordTf.text isEqualToString:self.confirmPasswordTF.text])
        {
            [self showCustomUIAlertViewWithtilet:@"Warning" andWithMessage:@"Password not match"];
        }
        else if ([password isEqualToString:confirmPassword])
        {
            [self EmailValidationFromDb];
        }
    }
    else
    {
        [self showCustomUIAlertViewWithtilet:@"Warning" andWithMessage:@"Please fill all fields"];
    }
}

-(void)submitFrom
{
    // [self hideNextView];
    
    advId =[NSString stringWithFormat:@"adv%d",aid];
    //NSLog(@"advid %@",advId);
    NSString *fname=self.firstNameTf.text;
    NSString *lname=self.lastNameTf.text;
    NSString *email = self.emailTf.text;
    NSString *pasword = self.passwordTf.text;
    NSString *userType = @"client";
    NSString *mobile = [NSString stringWithFormat:@"+1%@",self.mobileTf.text];
    if (self.imageView.image != nil)
    {
        refUrl=[NSString stringWithFormat:@"%@%@",advId,@".jpg"];
    }else
    {
        refUrl=@"0";
    }
    
    
    [self textEditing:email];
    ////NSLog(@"refUrl %@",refUrl);
    NSMutableDictionary *params=[[NSMutableDictionary alloc]initWithObjectsAndKeys:@"create_new_account",@"command",pasword,@"password",self.stateTF.text,@"country",email,@"email",mobile,@"mobile",fname,@"first_name",lname,@"last_name",refUrl,@"photo",userType,@"user_type",_selectedCityId,@"city_id",self.str_ExpirationDate,@"expiration_date",self.str_CardNumber,@"card_no", nil];
    //NSLog(@"params %@",params);//,[[NSUserDefaults standardUserDefaults] valueForKey:@"token_id"],@"customer_id"
    MBProgressHUD *hude=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hude.labelText=@"Creating New User";
    [[NetworkHelper sharedInstance] commandWithParams:params onCompletion:^(NSDictionary *json) {
        
        if (![json objectForKey:@"error"]&&json!=nil)
        {
            NSDictionary *res=[json objectForKey:@"result"];
            NSString *status=[NSString stringWithFormat:@"%@",[res objectForKey:@"successful"]];
            if ([status isEqualToString:@"5"])
            {
                //[self chargeDidSucceed];
                
                [self postStripeToken:delg.cardTokenId];
                //NSLog(@"json %@",json);
            }
            else{
                //NSLog(@"error : %@",[json objectForKey:@"error"]);
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                
                [self showCustomUIAlertViewWithtilet:@"Not successful"  andWithMessage:@"Please try again later"];
            }
        }
        else{
            ////NSLog(@"Error : %@",[json objectForKey:@"error"]);
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            NSString *errorMsg =[json objectForKey:@"error"];
            if ([ErrorFunctions isError:errorMsg])
            {
                [self submitFrom];
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

#pragma mark take pic
#pragma mark take pic
- (void)showActionSheet
{
    UIAlertController * view=   [UIAlertController
                                 alertControllerWithTitle:@"Add Photo"
                                 message:@""
                                 preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction* SelectFormGallery = [UIAlertAction
                                        actionWithTitle:@"Take Photo"
                                        
                                        style:UIAlertActionStyleDefault
                                        handler:^(UIAlertAction * action)
                                        {
                                            [self TakePic];
                                            [view dismissViewControllerAnimated:YES completion:nil];
                                            
                                        }];
    UIAlertAction* TakePhoto = [UIAlertAction
                                actionWithTitle:@"Choose Existing Photo"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action)
                                {
                                    [self selectPic];
                                    [view dismissViewControllerAnimated:YES completion:nil];
                                    
                                }];
    
    UIAlertAction* cancel = [UIAlertAction
                             actionWithTitle:@"Cancel"
                             style:UIAlertActionStyleCancel
                             handler:^(UIAlertAction * action)
                             {
                                 [view dismissViewControllerAnimated:YES completion:nil];
                                 
                             }];
    
    
    [view addAction:SelectFormGallery];
    [view addAction:TakePhoto];
    [view addAction:cancel];
    [self presentViewController:view animated:YES completion:nil];
    
    
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex: (NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        [self selectPic];
    }
    else if (buttonIndex == 1)
    {
        [self TakePic];
    }
    
}
-(void)TakePic
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    [self presentViewController:picker animated:YES completion:NULL];
}
-(void)selectPic
{
    imagePickerController = [[UIImagePickerController alloc]init];
    imagePickerController.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    imagePickerController.sourceType=UIImagePickerControllerCameraCaptureModePhoto;
    imagePickerController.delegate = self;
    [self presentViewController:imagePickerController animated:YES completion:nil];
}


#pragma mark VPImageCropperDelegate

- (void)imageCropper:(VPImageCropperViewController *)cropperViewController didFinished:(UIImage *)editedImage {
    self.portraitImageView.image = editedImage;
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
        // TO DO
    }];
}

- (void)imageCropperDidCancel:(VPImageCropperViewController *)cropperViewController {
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
    }];
}
#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:^() {
        UIImage *portraitImg = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        portraitImg = [self imageByScalingToMaxSize:portraitImg];
        // present the cropper view controller
        VPImageCropperViewController *imgCropperVC = [[VPImageCropperViewController alloc] initWithImage:portraitImg cropFrame:CGRectMake(0, 100.0f, self.view.frame.size.width, self.view.frame.size.width) limitScaleRatio:3.0];
        imgCropperVC.delegate = self;
        [self presentViewController:imgCropperVC animated:YES completion:^{
            // TO DO
        }];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:^(){
    }];
}

#pragma mark image scale utility
- (UIImage *)imageByScalingToMaxSize:(UIImage *)sourceImage {
    if (sourceImage.size.width < ORIGINAL_MAX_WIDTH) return sourceImage;
    CGFloat btWidth = 0.0f;
    CGFloat btHeight = 0.0f;
    if (sourceImage.size.width > sourceImage.size.height) {
        btHeight = ORIGINAL_MAX_WIDTH;
        btWidth = sourceImage.size.width * (ORIGINAL_MAX_WIDTH / sourceImage.size.height);
    } else {
        btWidth = ORIGINAL_MAX_WIDTH;
        btHeight = sourceImage.size.height * (ORIGINAL_MAX_WIDTH / sourceImage.size.width);
    }
    CGSize targetSize = CGSizeMake(btWidth, btHeight);
    return [self imageByScalingAndCroppingForSourceImage:sourceImage targetSize:targetSize];
}

- (UIImage *)imageByScalingAndCroppingForSourceImage:(UIImage *)sourceImage targetSize:(CGSize)targetSize {
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor)
            scaleFactor = widthFactor; // scale to fit height
        else
            scaleFactor = heightFactor; // scale to fit width
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else
            if (widthFactor < heightFactor)
            {
                thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
            }
    }
    UIGraphicsBeginImageContext(targetSize); // this will crop
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil) //NSLog(@"could not scale image");
        
        //pop the context to get back to the default
        UIGraphicsEndImageContext();
    return newImage;
}

#pragma mark - UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
}

#pragma mark camera utility
- (BOOL) isCameraAvailable{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}

- (BOOL) isRearCameraAvailable{
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
}

- (BOOL) isFrontCameraAvailable {
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront];
}

- (BOOL) doesCameraSupportTakingPhotos {
    return [self cameraSupportsMedia:(__bridge NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypeCamera];
}

- (BOOL) isPhotoLibraryAvailable{
    return [UIImagePickerController isSourceTypeAvailable:
            UIImagePickerControllerSourceTypePhotoLibrary];
}
- (BOOL) canUserPickVideosFromPhotoLibrary{
    return [self
            cameraSupportsMedia:(__bridge NSString *)kUTTypeMovie sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}
- (BOOL) canUserPickPhotosFromPhotoLibrary{
    return [self
            cameraSupportsMedia:(__bridge NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}

- (BOOL) cameraSupportsMedia:(NSString *)paramMediaType sourceType:(UIImagePickerControllerSourceType)paramSourceType{
    __block BOOL result = NO;
    if ([paramMediaType length] == 0) {
        return NO;
    }
    NSArray *availableMediaTypes = [UIImagePickerController availableMediaTypesForSourceType:paramSourceType];
    [availableMediaTypes enumerateObjectsUsingBlock: ^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *mediaType = (NSString *)obj;
        if ([mediaType isEqualToString:paramMediaType]){
            result = YES;
            *stop= YES;
        }
    }];
    return result;
}

#pragma mark Web Services
-(void)fetchAllStates
{
    NSMutableDictionary *params=[[NSMutableDictionary alloc]initWithObjectsAndKeys:@"get_states",@"command", nil];
    
    [[NetworkHelper sharedInstance] commandWithParams:params onCompletion:^(NSDictionary *json) {
        
        NSLog(@"the json return is %@",json);
        
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        
        
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
    
    [MBProgressHUD showHUDAddedTo:self.nextView animated:YES];
    
    
    NSMutableDictionary *params=[[NSMutableDictionary alloc]initWithObjectsAndKeys:@"get_state_cities",@"command",stateId,@"state_id", nil];
    
    [[NetworkHelper sharedInstance] commandWithParams:params onCompletion:^(NSDictionary *json) {
        
        NSLog(@"the json return is %@",json);
        if (![json objectForKey:@"error"] && json != nil)
        {
            [cityNames removeAllObjects];
            [cityIds removeAllObjects];
            
            NSArray *results=[json objectForKey:@"result"];
            //NSLog(@"result %@",results);
            for (int i=0; i<results.count; i++) {
                NSDictionary *res =[results objectAtIndex:i];
                
                // adding user adis in array
                [cityNames addObject:[[res objectForKey:@"name"] capitalizedString]];
                [cityIds addObject:[res objectForKey:@"id"]];
            }
            [MBProgressHUD hideHUDForView:self.nextView animated:YES];
        }
        
        else
        {
            // if reques error call again
            [MBProgressHUD hideHUDForView:self.nextView animated:YES];
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


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    // Return the number of sections.
    // on select cities
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    // Return the number of rows in the section.
    if ([_stateTF isFirstResponder]) {
        return [stateIds count];
    }
    // on blood groub selection
    else if ([_cityTF isFirstResponder])
    {
        return [cityIds count];
        
    }
    return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *sectionName;
    // for cities
    if ([_stateTF isFirstResponder])
    {
        sectionName = @"Select State";
    }else if ([_cityTF isFirstResponder])
    {
        // for blood groups
        sectionName = @"Select City";
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
    if ([_stateTF isFirstResponder])
    {
        cell.textLabel.text= [stateNames objectAtIndex:indexPath.row];
        if ([cell.textLabel.text isEqualToString:_selectedStateName]) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            
        }else
        {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        
    }else if ([_cityTF isFirstResponder])
    {
        // for blood groups
        cell.textLabel.text= [cityNames objectAtIndex:indexPath.row];
        
        if ([cell.textLabel.text isEqualToString:_selectedCityName])
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
    //UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    // for cities
    if ([_stateTF isFirstResponder])
    {
        //zia
        _selectedStateId  =[stateIds objectAtIndex:indexPath.row];
        _selectedStateName =[stateNames objectAtIndex:indexPath.row];
        [self.stateTF setText:_selectedStateName];
        [self.cityTF setText:@""];
        _selectedCityName = @"";
        [self fetchAllCitiesFromStateId:_selectedStateId];
        [self.stateTF resignFirstResponder];
    }else if ([_cityTF isFirstResponder])
    {
        _selectedCityId  =[cityIds objectAtIndex:indexPath.row];
        _selectedCityName =[cityNames objectAtIndex:indexPath.row];
        [self.cityTF setText:_selectedCityName];
        [self.cityTF resignFirstResponder];
    }
    [self hideAlertView:alertView];
}
#pragma mark CustomAlertView

-(void)showslectionView
{
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
#pragma mark CustomAletrView Delegate

- (void)customIOS7dialogButtonTouchUpInside: (CustomIOSAlertView *)alert clickedButtonAtIndex: (NSInteger)buttonIndex
{
    NSLog(@"Delegate: Button at position %d is clicked on alertView %d.", (int)buttonIndex, (int)[alert tag]);
    [alert close];
}
#pragma mark portraitImageView getter
- (UIImageView *)portraitImageView {
    if (!self.imageView) {
        CGFloat w = 100.0f; CGFloat h = w;
        CGFloat x = (self.view.frame.size.width - w) / 2;
        CGFloat y = (self.view.frame.size.height - h) / 2;
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, w, h)];
        [self.imageView.layer setCornerRadius:(self.imageView.frame.size.height/2)];
        [self.imageView.layer setMasksToBounds:YES];
        [self.imageView setContentMode:UIViewContentModeScaleAspectFill];
        [self.imageView setClipsToBounds:YES];
        self.imageView.layer.shadowColor = [UIColor blackColor].CGColor;
        self.imageView.layer.shadowOffset = CGSizeMake(4, 4);
        self.imageView.layer.shadowOpacity = 0.5;
        self.imageView.layer.shadowRadius = 2.0;
        self.imageView.layer.borderColor = [[UIColor blackColor] CGColor];
        self.imageView.layer.borderWidth = 2.0f;
        self.imageView.userInteractionEnabled = YES;
        self.imageView.backgroundColor = [UIColor blackColor];
        
    }
    return self.imageView;
}


#pragma mark - Stripe

- (void)postStripeToken:(NSString* )token
{
    //1
    
    
    NSURL *postURL = [NSURL URLWithString:STRIPE_TEST_POST_URL];
    AFHTTPClient* httpClient = [AFHTTPClient clientWithBaseURL:postURL];
    httpClient.parameterEncoding = AFJSONParameterEncoding;
    [httpClient registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [httpClient setDefaultHeader:@"Content-Type" value:@"application/json"];
    
    NSMutableString *stripUrl =[[NSMutableString alloc] init];
    
    
    [stripUrl appendString:Kregister_stripe_url];
    
    [stripUrl appendString:[NSString stringWithFormat:@"stripeToken=%@&stripeEmail=%@",delg.cardTokenId,delg.ClientEmail]];
    NSLog(@"stripUrl %@",stripUrl);
    NSMutableURLRequest* request = [httpClient requestWithMethod:@"GET" path:stripUrl parameters:nil];
    
    self.httpOperation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON)
                          {
                              [MBProgressHUD hideHUDForView:self.view animated:YES];
                              [self chargeDidSucceed];
                          }
                                                                         failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON)
                          {
                              [self DeleteUser];
                              [MBProgressHUD hideHUDForView:self.view animated:YES];
                              //NSLog(@"%@",JSON);
                              //NSLog(@"error %@",error);
                              [self chargeDidNotSuceed];
                          }];
    [self.httpOperation start];
}


- (void)chargeDidSucceed {
    [self showCustomUIAlertViewWithtilet:@"New Account" andWithMessage:@"Your account has been successfully created."];
}

- (void)chargeDidNotSuceed {
    [self showCustomUIAlertViewWithtilet:@"Not successful" andWithMessage:@"Please try again later."];
    
}

-(void)DeleteUser
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc]initWithObjectsAndKeys:@"delete_user",@"command",delg.ClientEmail,@"email", nil];
    
    [[NetworkHelper sharedInstance] commandWithParams:params onCompletion:^(NSDictionary *json) {
        if (![json objectForKey:@"error"] && json!=nil) {
            NSLog(@"Success");
        }
        else{
            NSLog(@"failure");
        }
    }];
}



-(void) viewWillDisappear:(BOOL) animated
{
    [super viewWillDisappear:animated];
    if ([self isMovingFromParentViewController])
    {
        if (self.navigationController.delegate == self)
        {
            self.navigationController.delegate = nil;
        }
    }
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
                                             
                                             if ([message isEqualToString:@"Please enter valid email address"])
                                             {
                                                 [self.emailTf becomeFirstResponder];
                                             }
                                             
                                             if ([message isEqualToString:@"Your account has been successfully created."])
                                             {
                                                 NSString * storyboardName = @"Main";
                                                 UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle: nil];
                                                 delg.isgotToken = NO;
                                                 MainViewController * vc = [storyboard instantiateViewControllerWithIdentifier:@"MainView"];
                                                 UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:vc];
                                                 
                                                 [self presentViewController:navigationController animated:YES completion:nil];
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

- (void)dealloc {
    [_btn_Terms release];
    [super dealloc];
}



- (IBAction)action_Terms:(id)sender
{
    UIButton *btn_Temp = (UIButton *)sender;
    btn_Temp.selected = !btn_Temp.selected;
    if (btn_Temp.selected)
    {
        isTermsCondition = YES;
        UIImage *image_Check1  = [UIImage imageNamed:@"checktick"] ;
        [_btn_Terms setImage:image_Check1 forState:UIControlStateSelected];
        
    }
    else if (!btn_Temp.selected)
    {
        isTermsCondition = NO;
        UIImage *image_Check = [UIImage imageNamed:@"check"] ;
        [_btn_Terms setImage:image_Check forState:UIControlStateNormal];
        
    }
}




- (IBAction)action_TermsConditions:(id)sender
{
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable)
    {
        [self showCustomUIAlertViewWithtilet:@"Info" andWithMessage:@"Please check with your internet connection"];
    } else
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName: @"Main" bundle: nil];
        TermsAndConditionsView * sv = [storyboard instantiateViewControllerWithIdentifier:@"Terms"];
        sv.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self.navigationController pushViewController:sv animated:YES];
    }
}
@end
