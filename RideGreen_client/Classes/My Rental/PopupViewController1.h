//
//  PopupViewController1.h
//  STPopup
//
//  Created by Kevin Lin on 11/9/15.
//  Copyright (c) 2015 Sth4Me. All rights reserved.
//
#import "AppDelegate.h"
@class RenterRequest;
@interface PopupViewController1 : UIViewController
{
    AppDelegate *delg;
    BOOL isFixed;
    TJSpinner *cSpinner;
    
}
@property (assign) BOOL isMyRented;
@property (strong,nonatomic) RenterRequest *request; 

@property (strong, nonatomic) NSString *sourceLatitude;
@property (strong, nonatomic) NSString *sourceLongitude;
@property (strong, nonatomic) NSString *destinationLatitude;
@property (strong, nonatomic) NSString *destinationLongitude;
@property BOOL isPickAndDropLocationselected;


 @end
