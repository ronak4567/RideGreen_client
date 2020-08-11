//
//  AppDelegate.m
//  fiveStarLuxuryCars
//
//  Created by Ridegreen on 06/05/2014.
//  Copyright (c) 2014 Ridegreen. All rights reserved.
//

#import "AppDelegate.h"



#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
@implementation AppDelegate

@synthesize managedObjectContext = __managedObjectContext;
@synthesize managedObjectModel = __managedObjectModel;
@synthesize persistentStoreCoordinator = __persistentStoreCoordinator;

@synthesize bgImageName,fontName,userId,selectedDriverId,userImageName,distinationId,getCarBtntag,locationManager,isConected,distanceIs,soureceDestinationDistance,isSelectedSourecAndDistination,finalFare,image,estimatedTime,isregisterview,isgotToken,isActivityPaid,custromId,drieverLatitude,driverlongitude,driverName,driverpic,driverNumber,checkingTimer,profileImageName,selectedBtnIndex,isEidtParking,tourSelectedDate,isRigesterTour,totalRent,imgTitel,tourStartUpTime,tourTravelHours,tourTaxRate;

@synthesize selectedCarType,selectedTypeId,whenRide,fare,isResevationSeen,isEdited,vehicleImg;
@synthesize pickDropAddress,zipCode,currentCoordinats;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    
    
    
    //[self check_CreditExpire];
    
    
    isregisterview = NO;
    isgotToken = NO;
    isActivityPaid = NO;
    isEdited = NO;
    isRigesterTour = NO;
    //iphone 6
        
    [GMSServices provideAPIKey:@"AIzaSyAaJM34T3OzmzpoYPCL0bMTg2UAQ8HqK_U"]; // // //AIzaSyC3EA3LR_g3CyJ_Fm9RPjFJJbP8mnLVnMw
    
    fontName =@"Street-Plain";
    bgImageName = @"faulltoo.png";
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.distanceFilter = 5; // whenever we move
    locationManager.desiredAccuracy = kCLLocationAccuracyBest; // 100 m
    if(IS_OS_8_OR_LATER) {
        
        [self.locationManager  requestAlwaysAuthorization];
        [self.locationManager requestWhenInUseAuthorization];
    }
    else
    {
        [locationManager startUpdatingLocation];
    }

    // Override point for customization after application launch.
    
    if ([application respondsToSelector:@selector(isRegisteredForRemoteNotifications)])
    {
        // iOS 8 Notifications
        [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        
        [application registerForRemoteNotifications];
    }
    else
    {
        // iOS < 8 Notifications
        
    }
    
    
    UILocalNotification *locationNotification = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    if (locationNotification) {
        // Set icon badge number to zero
        application.applicationIconBadgeNumber = 0;
    }
    prefs = [NSUserDefaults standardUserDefaults];
    [[NSUserDefaults standardUserDefaults] synchronize];
    // getting an NSString
    NSString *myString = [prefs stringForKey:@"user_id"];
    
    ////NSLog(@"my srting lenght %lu",(unsigned long)myString.length);
    if(myString.length !=0)
    {
        UIStoryboard *storyBoard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
        CurrentLocatioView*cl =[storyBoard instantiateViewControllerWithIdentifier:@"CurrentLocation"];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:cl];
        [nav.navigationBar setBackgroundImage:[UIImage imageNamed: @"categories_header.png"]
                                forBarMetrics:UIBarMetricsDefault];
        _window.rootViewController = nav;
        [_window makeKeyAndVisible];
        
    }else
    {
       
        
        UIStoryboard *storyBoard =[UIStoryboard storyboardWithName:@"Main" bundle:nil];
        MainViewController*mv =[storyBoard instantiateViewControllerWithIdentifier:@"MainView"];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:mv];
        [nav.navigationBar setBackgroundImage:[UIImage imageNamed: @"categories_header.png"]
                                forBarMetrics:UIBarMetricsDefault];
        _window.rootViewController = nav;
        [_window makeKeyAndVisible];
    }

    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    
    [self check_CreditExpire];
    
    
}


-(void)check_CreditExpire
{
    NSString *savedValue = [[NSUserDefaults standardUserDefaults]
                            stringForKey:@"user"];
    
    NSLog(@"savedvalues : %@",savedValue);
    
    if (savedValue != nil) {
        NSMutableDictionary *params=[[NSMutableDictionary alloc]initWithObjectsAndKeys:@"check_card_expiry",@"command",savedValue,@"client_id", nil];
        
        [[NetworkHelper sharedInstance] commandWithParams:params onCompletion:^(NSDictionary *json) {
            
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
                
                if (str_ExpirationYear > str_Year)
                {
                }
                else if (str_ExpirationYear == str_Year)
                {
                    if (str_Expiration_Month >= str_Month)
                    {
                    }
                    else{
                        
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Info"
                                                                        message:@"Your card has expired. Please contact Ridegreen admin to update your credit card information."
                                                                       delegate:self
                                                              cancelButtonTitle:nil
                                                              otherButtonTitles:nil];
                        [alert show];
                        
                    }
                }
            }
            else
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Info"
                                                                message:@"Your card has expired. Please contact Ridegreen admin to update your credit card information."
                                                               delegate:self
                                                      cancelButtonTitle:nil
                                                      otherButtonTitles:nil];
                [alert show];
                
            }
            
            
        }];
    }
    
    
    

}




- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    UIApplicationState state = [application applicationState];
    if (state == UIApplicationStateActive)
    {
        
        alertView =[[UIAlertView alloc] initWithTitle:@"Info" message:notification.alertBody delegate:self cancelButtonTitle:@"Dissmis" otherButtonTitles:nil, nil];
        [alertView show];
              
        //[self performSelector:@selector(hideAlert) withObject:self afterDelay:11];
        
    }
    
    // Request to reload table view data
    
    
    // Set icon badge number to zero
    application.applicationIconBadgeNumber = 0;
}
-(void)hideAlert
{
     [alertView dismissWithClickedButtonIndex:0 animated:YES];
}

#pragma mark - Coredata methods:
- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (__managedObjectContext != nil) {
        return __managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        __managedObjectContext = [[NSManagedObjectContext alloc] init];
        [__managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return __managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (__managedObjectModel != nil) {
        return __managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"RideGreenClientDB" withExtension:@"momd"];
    __managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return __managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (__persistentStoreCoordinator != nil) {
        return __persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"RideGreenClientDB.sqlite"];
    
    NSError *error = nil;
    __persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![__persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return __persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}




@end
