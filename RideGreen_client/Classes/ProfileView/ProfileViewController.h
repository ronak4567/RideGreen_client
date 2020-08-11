//
//  ProfileViewController.h
//  fivestar
//
//  Created by Ridegreen on 07/09/2014.
//  Copyright (c) 2014 Ridegreen. All rights reserved.
//
#import "AppDelegate.h"
#import "EXPhotoViewer.h"

#import <UIKit/UIKit.h>
#import "CProfile.h"
#define ORIGINAL_MAX_WIDTH 640.0f

@interface ProfileViewController : UIViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate,VPImageCropperDelegate>
{
    UIImagePickerController *imagePickerController;
    TJSpinner *cSpinner;
    int aid ;
    NSString *advId;
}
@property (assign) BOOL isImage;
@property (retain, nonatomic) IBOutlet UIImageView *imgView;
@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (retain, nonatomic) IBOutlet UITextField *nameTF;
@property (retain, nonatomic) IBOutlet UITextField *phoneTf;
@property (retain, nonatomic) IBOutlet UIButton *updateBtn;
- (IBAction)updateBtnPressed:(id)sender;
@property (retain, nonatomic) IBOutlet UIImageView *updateShdow;
- (IBAction)imgViewBtnPressed:(id)sender;

- (IBAction)iRantedBtnPressed:(id)sender;

@end
