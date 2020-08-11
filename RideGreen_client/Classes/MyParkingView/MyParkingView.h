//
//  MyParkingView.h
//  ridegreen
//
//  Created by Ridegreen on 30/08/2015.
//  Copyright (c) 2015 Ridegreen. All rights reserved.
//
#import "AppDelegate.h"
#import <UIKit/UIKit.h>
#import "CMyParking.h"

@interface MyParkingView : UIViewController <UITableViewDataSource,UITableViewDelegate>
{

    NSMutableArray *allprakings;
    NSUserDefaults *userdefault;
    NSString *renewalPostWithTax,*str_amount;
}
@property (strong ,nonatomic) NSString *userId;
@property (strong ,nonatomic) NSString *renewalPostWithTax,*str_amount;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)backBtnPressed:(id)sender;

@end
