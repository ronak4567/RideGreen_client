//
//  NetworkHelper.h
//  PavelProject
//
//  Created by syed zi on 4/29/13.
//  Copyright (c) 2013 WellDoneApps. All rights reserved.
//==================== to use this class===========

#import "AppDelegate.h"
#import "AFHTTPClient.h"
#import "AFNetworking.h"

//#define kAPIPath @"http://223.30.193.83:7072/ridegreen/mappservicesia/"
//#define kAPIPath @"http://192.168.2.176/ridegreen/mappservicesia/"
#define kAPIPath @"https://ridegreen.com/ridegreen/mappservicesia/"

typedef  void (^JSONResponseBlock) (NSDictionary *json);
@interface NetworkHelper : AFHTTPClient

+(NetworkHelper*)sharedInstance;

-(void)commandWithParams:(NSMutableDictionary*)params onCompletion:(JSONResponseBlock)completionBlock;
@end
