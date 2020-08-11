//
//  Parking.m
//  ridegreendriver
//
//  Created by Ridegreen on 28/08/2015.
//  Copyright (c) 2015 Ridegreen. All rights reserved.
//

#import "Parking.h"

@implementation Parking
@synthesize parkingId,parkingName,parkingaddress,parkingLocation,perHourRent,disableEnable,usedDays;

+(id)setParkingId :(NSString *)pId parkingName:(NSString *)pName  parkingaddress:(NSString *)pAddress parkingLocation :(NSString *) plocation perHourRent :(NSString *)phRent disableEnable:(NSString *) disableEnable noOfDays:(NSString *)noOfDays
{
    Parking *park =[[Parking alloc] init];
    [park setParkingId:pId];
    [park setParkingName:pName];
    [park setParkingaddress:pAddress];
    [park setParkingLocation:plocation];
    [park setPerHourRent:phRent];
    [park setDisableEnable:disableEnable];
    [park setUsedDays:noOfDays];


    return park;
}

@end
