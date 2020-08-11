//
//  AvailableDriver.m
//  ridegreen
//
//  Created by Ridegreen on 31/08/2015.
//  Copyright (c) 2015 Ridegreen. All rights reserved.
//

#import "AvailableDriver.h"

@implementation AvailableDriver
@synthesize dId,dName,dIamge,dPerHourRate,dCity,dRating;

+(id)setDriverId :(NSString *) dId DriverName:(NSString *)dName DriverImage :(NSString *) dImage PerHourRate :(NSString *)phourRate driverCity :(NSString *)dCity dRating:(NSString *)dRating
{
    AvailableDriver *driver =[AvailableDriver new];
    [driver setDId:dId];
    [driver setDName:dName];
    [driver setDIamge:dImage];
    [driver setDPerHourRate:phourRate];
    [driver setDCity:dCity];
    [driver setDRating:dRating];
    return driver;
}
@end
