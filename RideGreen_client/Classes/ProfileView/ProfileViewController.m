//
//  ProfileViewController.m
//  fivestar
//
//  Created by Ridegreen on 07/09/2014.
//  Copyright (c) 2014 Ridegreen. All rights reserved.
//
#import "NYAlertViewController.h"
#import "AppDelegate.h"
#import "NetworkHelper.h"
#import "MBProgressHUD.h"
#import "MainViewController.h"
#import "ProfileViewController.h"

#import <QuartzCore/QuartzCore.h>
@interface ProfileViewController ()
{
    NSString *oldPhoneNum;
    AppDelegate *delg;
       NSUserDefaults *prefs;
}

- (IBAction)backBtnPressed:(id)sender;
- (IBAction)signoutBtn:(id)sender;
- (IBAction)hideKeybordBtnPressed:(id)sender;

@end

@implementation ProfileViewController

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
    self.phoneTf.leftView = paddingView;
    self.phoneTf.leftViewMode = UITextFieldViewModeAlways;
    UIView *paddingView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 20)];
    self.nameTF.leftView = paddingView1;
    self.nameTF.leftViewMode = UITextFieldViewModeAlways;

    self.imgView.layer.cornerRadius = self.imgView.frame.size.width/2;
    self.imgView.layer.masksToBounds = YES;
    delg =(AppDelegate *)[[UIApplication sharedApplication]delegate];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@""style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backButton;
    prefs = [NSUserDefaults standardUserDefaults];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self.navigationItem setHidesBackButton:NO animated:YES];
    [[UITextField appearance] setTintColor:[UIColor whiteColor]];

    UIButton *logoutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [logoutBtn setFrame:CGRectMake(0.0f, 0.0f, 33.0f,33.0f)];
    [logoutBtn setImage:[UIImage imageNamed:@"logout.png"] forState:UIControlStateNormal];
    [logoutBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [logoutBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [logoutBtn addTarget:self action:@selector(logout) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *eng_btn = [[UIBarButtonItem alloc] initWithCustomView:logoutBtn];
    self.navigationItem.rightBarButtonItem = eng_btn;
    self.updateBtn.alpha = 0.0;
    [self.updateShdow setAlpha:0.0];
    
    CGFloat imgviewHight = CGRectGetHeight(self.imgView.frame);
    CGFloat imgviewWidth = CGRectGetWidth (self.imgView.frame);
    cSpinner = [[TJSpinner alloc] initWithSpinnerType:kTJSpinnerTypeCircular];
    cSpinner.center = CGPointMake(imgviewWidth / 2, imgviewHight / 2);
    cSpinner.hidesWhenStopped = YES;
    [cSpinner setHidden:YES];
    [self.imgView addSubview:cSpinner];
   
    [self fetchProfileDetail];
    // Do any additional setup after loading the view.
}
#pragma mark UITextField delegate methods
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == self.phoneTf) {
        
        if (textField == self.phoneTf)
        {
            NSUInteger newLength = [textField.text length] + [string length] - range.length;
            return (newLength > 12) ? NO : YES;
        }
        
    }
    
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField ==self.phoneTf)
    {
        [self showUpdateButton];
        
    }
    
    [self animatetexfield:textField up:YES];
    
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    
    
    
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
    
    [self animatetexfield:textField up:NO];
    
    
    
}
-(void)btnColorPressed
{
    [self.phoneTf becomeFirstResponder];
}
-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
    
    if (textField == self.phoneTf)
    {
        if([textField.text length]!= 12)
        {
           
            [self showCustomUIAlertViewWithtilet:@"Warning" andWithMessage:@"Please enter a valid phone number"];
            
          

            
        }
        [self hideUpdateButton];
    }
    
    [textField resignFirstResponder];
    return YES;
}


- (void) animatetexfield: (UITextField*) texfield up: (BOOL) up
{
    const int movementDistance = 80; // tweak as needed
    const float movementDuration = 0.3f; // tweak as needed
    
    int movement = (up ? -movementDistance : movementDistance);
    
    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)fetchProfileDetail
{
//    CProfile *profile = [[CProfile alloc]ini];
//    //[profile initWithDictionary:<#(NSDictionary *)#> context:<#(NSManagedObjectContext *)#>]
    
        MBProgressHUD *hue=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hue.labelText=@"Fetching Additional Info...";
  
    
    NSMutableDictionary *params=[[NSMutableDictionary alloc]initWithObjectsAndKeys:@"client_profile",@"command",delg.userId,@"user_id", nil];
    
    [[NetworkHelper sharedInstance] commandWithParams:params onCompletion:^(NSDictionary *json)
     {
         [MBProgressHUD hideHUDForView:self.view animated:YES];
         
         if (![json objectForKey:@"error"]&&json!=nil)
         {
             [[CProfile alloc] updateClientProfile:json];
         }else
         {
             NSString *errorMsg =[json objectForKey:@"error"];
             if ([ErrorFunctions isError:errorMsg])
             {
                 [self fetchProfileDetail];
             }
             else
             {
                 [MBProgressHUD hideHUDForView:self.view animated:YES];
                 //////NSLog(@"Error :%@",[json objectForKey:@"error"]);

                 [self showCustomUIAlertViewWithtilet:@"Some thing wrong" andWithMessage:[json objectForKey:@"error"]];
             }
         }
         
         [self updateProfileUI];
     }];
   
    
}


-(void)updateProfileUI
{
    NSString *imageUrl;
//    NSArray *results=[json objectForKey:@"result"];
    NSMutableArray *results = [[CProfile alloc] fetchClientProfile];
    NSDictionary *res=[results objectAtIndex:0];
    //NSLog(@"resul is %@",res);
    CProfile *obj_cl = (CProfile *)res;
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [self.nameTF setText:[NSString stringWithFormat:@"%@",obj_cl.firstName]];
    
    NSString *number =[NSString stringWithFormat:@"%@",obj_cl.mobile];
    oldPhoneNum = obj_cl.mobile;
    [self.phoneTf setText:number];
    
    //////NSLog(@"image %@",[res objectForKey:@"photo"]);
    NSString *imageName = obj_cl.photo;
    delg.profileImageName = imageName;
    if (![imageName isEqualToString:@"0"])
    {
        if([imageName hasPrefix:@"http://"])
        {
            imageUrl =[NSString stringWithFormat:@"%@",imageName];
        }
        else
        {
            imageUrl =[NSString stringWithFormat:@"%@upload/%@",kAPIHost,imageName];
        };
        
        [cSpinner setHidden:YES];
        [cSpinner startAnimating];
        [self.imgView setImageWithURLRequest:[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:imageUrl]]
                            placeholderImage:[UIImage imageNamed:@"image_blank.png"]//image_blank.png
                                     success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image)
         {
             
             self.imgView .image = image;
             self.imgView.contentMode = UIViewContentModeScaleAspectFit;
             [cSpinner stopAnimating];
             _isImage = YES;
             [[NSUserDefaults standardUserDefaults] setObject:UIImagePNGRepresentation(image) forKey:@"clProfilePic"];
             
             
         }
        failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error){
                                         [cSpinner stopAnimating];
                                         _isImage = NO;
            NSData *imagedata = [[NSUserDefaults standardUserDefaults] objectForKey:@"clProfilePic"];
            
            if (imagedata != nil) {
                self.imgView .image = [UIImage imageWithData:imagedata];
                self.imgView.contentMode = UIViewContentModeScaleAspectFit;
            }
                                     }];
    }
    else
    {
        [cSpinner stopAnimating];
        _isImage = NO;
        
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark- UpdatePhoneNuberWebService
-(void)updatePhoneNumber
{
    
    NSString *phone =[self.phoneTf text];
    //////NSLog(@"tatus is %@",status);
    MBProgressHUD *hue=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hue.labelText=@"";
    NSMutableDictionary *params=[[NSMutableDictionary alloc]initWithObjectsAndKeys:@"update_phone",@"command",delg.userId,@"user_id",phone,@"phone", nil];
    
    [[NetworkHelper sharedInstance] commandWithParams:params onCompletion:^(NSDictionary *json)
     {
         [MBProgressHUD hideHUDForView:self.view animated:YES];
         
         if (![json objectForKey:@"error"]&&json!=nil)
         {
             //   NSArray *results=[json objectForKey:@"result"];
             //             NSDictionary *res=[results objectAtIndex:0];
             //////NSLog(@"res is %@",res);
             
             
             [self hideUpdateButton];
             [MBProgressHUD hideHUDForView:self.view animated:YES];
             
             
             
         }else
         {
             [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
             NSString *errorMsg =[json objectForKey:@"error"];
             if ([ErrorFunctions isError:errorMsg])
             {
                 [self updatePhoneNumber];    
             }
             else
             {
                 
                  [self showCustomUIAlertViewWithtilet:@"Some thing wrong" andWithMessage:[json objectForKey:@"error"]];
                 
             }

             
            

         }
     }];
    
    
}
-(void)showUpdateButton
{
    // to show (implement in another method)
    [UIView animateWithDuration:0.5
                          delay:1.0
                        options: UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.updateBtn.alpha = 1.0;
                         [self.updateShdow setAlpha:1.0];
                     }
                     completion:^(BOOL finished){
                         ////NSLog(@"Done!");
                     }];
}
-(void)hideUpdateButton
{
    [UIView animateWithDuration:0.5
                          delay:1.0
                        options: UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.updateBtn.alpha = 0.0;
                          [self.updateShdow setAlpha:0.0];
                     }
                     completion:^(BOOL finished){
                         ////NSLog(@"Done!");
                     }];
    
    
}


- (IBAction)updateBtnPressed:(id)sender
{
    
    [self.phoneTf resignFirstResponder];
    if (self.phoneTf.text.length!=0)
    {
        ////NSLog(@"self.phoneTf.text  %@",self.phoneTf.text);
        ////NSLog(@"oldPhoneNum %@",oldPhoneNum);
        if ([oldPhoneNum isEqualToString:self.phoneTf.text])
        {
           
            
            [self showCustomUIAlertViewWithtilet:@"Warning" andWithMessage:@"No New Info"];
        }
        if([self.phoneTf.text length]!= 12)
        {
            [self showCustomUIAlertViewWithtilet:@"Info" andWithMessage:@"Please enter a valid phone number"];
            
        }
        else
        {
            [self updatePhoneNumber];
        }
    }
    else
    {
        // emailtext = @"NO";
        [self showCustomUIAlertViewWithtilet:@"Info" andWithMessage:@"Please Provide Correct Information"];
    }
}
-(void)logout
{
    MBProgressHUD *hue=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hue.labelText=@"Trying to Logout..";
    NSString* Identifier = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    NSLog(@"output is : %@", Identifier);
    
    NSMutableDictionary *params=[[NSMutableDictionary alloc]initWithObjectsAndKeys:@"signout_user",@"command",delg.userId,@"user_id",Identifier,@"uid", nil];
    
    [[NetworkHelper sharedInstance] commandWithParams:params onCompletion:^(NSDictionary *json) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        ////NSLog(@"the json return is %@",json);
        if (![json objectForKey:@"error"]&&json!=nil)
        {
            [delg.checkingTimer invalidate];
            delg.checkingTimer = nil;
            prefs = [NSUserDefaults standardUserDefaults];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [prefs removeObjectForKey:@"user_id"];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"user"];
            UIStoryboard *storyBoard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
            MainViewController*mv =[storyBoard instantiateViewControllerWithIdentifier:@"MainView"];
            [self.navigationController setViewControllers:[NSArray arrayWithObject:mv] animated:NO];
            [self.navigationController popToViewController:mv animated:NO];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }else
        {
            NSString *errorMsg =[json objectForKey:@"error"];
            if ([ErrorFunctions isError:errorMsg])
            {
                [self logout];    
            }
            else
            {
                
                [self showCustomUIAlertViewWithtilet:@"Some thing wrong" andWithMessage:[json objectForKey:@"error"]];
                
            }
           
        }
    }];
    
    
}

- (IBAction)backBtnPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)signoutBtn:(id)sender
{
    [self logout];
}

- (IBAction)hideKeybordBtnPressed:(id)sender
{
    [self.phoneTf resignFirstResponder];
}
- (IBAction)imgViewBtnPressed:(id)sender
{
    
    [self showActionSheet];
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
    [self upLoadImage:editedImage];
    [cropperViewController dismissViewControllerAnimated:YES completion:
     ^
     {
         NSLog(@"Upload image here");
     }];
    //[self upLoadImageNew];
    
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
        VPImageCropperViewController *imgCropperVC = [[VPImageCropperViewController alloc] initWithImage:portraitImg cropFrame:CGRectMake(0, 100.0f, self.view.frame.size.width, self.view.frame.size.width) limitScaleRatio:11.0];
        
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

- (UIImage *)imageByScalingAndCroppingForSourceImage:(UIImage *)sourceImage targetSize:(CGSize)targetSize 
{
    
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

#pragma mark portraitImageView getter
- (UIImageView *)portraitImageView {
    
    if (!self.imgView) {
        
        CGFloat w = 100.0f; CGFloat h = w;
        CGFloat x = (self.view.frame.size.width - w) / 2;
        CGFloat y = (self.view.frame.size.height - h) / 2;
        self.imgView = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, w, h)];
        [self.imgView.layer setCornerRadius:(self.imgView.frame.size.height/2)];
        [self.imgView.layer setMasksToBounds:YES];
        [self.imgView setContentMode:UIViewContentModeScaleAspectFill];
        [self.imgView setClipsToBounds:YES];
        self.imgView.layer.shadowColor = [UIColor blackColor].CGColor;
        self.imgView.layer.shadowOffset = CGSizeMake(4, 4);
        self.imgView.layer.shadowOpacity = 0.5;
        self.imgView.layer.shadowRadius = 2.0;
        self.imgView.layer.borderColor = [[UIColor blackColor] CGColor];
        self.imgView.layer.borderWidth = 2.0f;
        self.imgView.userInteractionEnabled = YES;
        self.imgView.backgroundColor = [UIColor blackColor];
        
    }
    return self.imgView;
}
#pragma mark upload image

-(void)upLoadImage:(UIImage *)image
{
    
    // [self hideNextView];
  //  NSString *titel =[delg.profileImageName stringByDeletingPathExtension];
    
    
    aid = arc4random() % 10000;
    advId =[NSString stringWithFormat:@"adv%d",aid];
    
    //NSLog(@"dleg.profileImageName : %@",dleg.profileImageName);
    
    MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText=@"Uploding Image";
    [[API sharedInstance] commandWithParams:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"uploadNew", @"command", UIImageJPEGRepresentation(image,0.6), @"file",advId, @"title",delg.userId, @"user_id", nil] onCompletion:^(NSDictionary *json)
     {
         ////NSLog(@"result is %@",[json objectForKey:@"result"]);
         //completion
         if (![json objectForKey:@"error"]&&[json objectForKey:@"result"]!=nil)
         {
             [MBProgressHUD hideHUDForView:self.view animated:YES];
             //success
             
             
         } else
         {
             [MBProgressHUD hideHUDForView:self.view animated:YES];
             NSString* errorMsg = [json objectForKey:@"error"];
             //////NSLog(@"error :%@",errorMsg);
             [self upLoadImage:image];
             
             
             if ([@"Authorization required" compare:errorMsg]==NSOrderedSame)
             {
             }
         }
     }];
    
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
    
    //    [alertViewController addAction:[NYAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil)
    //                                                            style:UIAlertActionStyleCancel
    //                                                          handler:^(NYAlertAction *action) {
    //                                                              [self dismissViewControllerAnimated:YES completion:nil];
    //                                                          }]];
    
    [self presentViewController:alertViewController animated:YES completion:nil];
}

//- (IBAction)imgViewBtnPressed:(id)sender 
//{
//
//    [EXPhotoViewer showImageFrom:self.imgView];
//}

- (IBAction)iRantedBtnPressed:(id)sender 
{
    
    UIStoryboard *storyBoard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    MyRentalView*mv =[storyBoard instantiateViewControllerWithIdentifier:@"MyRental"];
    mv.isMyRented = YES;
    [self.navigationController pushViewController:mv animated:YES];

    
}
@end
