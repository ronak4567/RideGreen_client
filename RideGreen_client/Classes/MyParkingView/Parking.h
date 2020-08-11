//
//  Parking.h
//  ridegreendriver
//
//  Created by Ridegreen on 28/08/2015.
//  Copyright (c) 2015 Ridegreen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Parking : NSObject
{
   
    NSString *parkingId;
    NSString *parkingName;
    NSString *parkingaddress;
    NSString *parkingLocation;
    NSString *perHourRent;
    NSString *disableEnable;
    NSString *usedDays;

}

@property (nonatomic ,copy) NSString *parkingId;
@property (nonatomic ,copy) NSString *parkingName;
@property (nonatomic ,copy) NSString *parkingaddress;
@property (nonatomic ,copy) NSString *parkingLocation;
@property (nonatomic ,copy) NSString *perHourRent;
@property (nonatomic ,copy)  NSString *disableEnable;
@property (nonatomic, copy) NSString *usedDays;
+(id)setParkingId :(NSString *)pId parkingName:(NSString *)pName  parkingaddress:(NSString *)pAddress parkingLocation :(NSString *) plocation perHourRent :(NSString *)phRent disableEnable:(NSString *) disableEnable noOfDays:(NSString *)noOfDays;
@end
