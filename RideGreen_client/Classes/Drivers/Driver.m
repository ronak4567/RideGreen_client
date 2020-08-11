//
//  Driver.m
//  ridegreendriver
//
//  Created by Ridegreen on 08/09/2015.
//  Copyright (c) 2015 Ridegreen. All rights reserved.
//

#import "Driver.h"



@implementation Driver
@synthesize driverId,driverName,driverPhone,driverPhoto,driverCarId,driverLocation,driverDistance;
@synthesize availableSeats,carBasefare,carImage,carNumber,carPerMilefare,driverRating,drivermile,str_model_image,driverCarModel,driverGender,str_CityName,str_StateName,str_OwnershipType;


+(id)setDriverId :(NSString *)driverId driverName :(NSString *)driverName driverPhone:(NSString *)driverPhone driverPhoto:(NSString *)driverPhoto driverCarId:(NSString *)driverCarId driverLocation:(NSString *)driverLocation driverDistance:(NSString *)driverDistance availableSeats:(NSString *)availableSeats carImage:(NSString *)carImage carNumber:(NSString *)carNumber carBasefare:(NSString *)carBasefare carPerMilefare:(NSString *)carPerMilefare driverRating:(NSString *) driverRating drivermile:(NSString *)drivermile driverGender:(NSString *)driverGender driverCarModel:(NSString*)driverCarModel str_model_image:(NSString*)str_model_image str_StateName:(NSString*)str_StateName str_CityName:(NSString*)str_CityName str_OwnershipType:(NSString*)str_OwnershipType
{
    Driver *driver =[Driver new];
    [driver setDriverId:driverId];
    [driver setDriverName:driverName];
    [driver setDriverPhone:driverPhone];
    [driver setDriverPhoto:driverPhoto];
    [driver setDriverCarId:driverCarId];
    [driver setDriverLocation:driverLocation];
    [driver setDriverDistance:driverDistance];
    [driver setAvailableSeats:availableSeats];
    [driver setCarPerMilefare:carPerMilefare];
    [driver setCarBasefare:carBasefare];
    [driver setCarNumber:carNumber];
    [driver setCarImage:carImage];
    [driver setDriverRating:driverRating];
    [driver setDrivermile:drivermile];
    [driver setDriverGender:driverGender];
    [driver setDriverCarModel:driverCarModel];
    [driver setStr_model_image:str_model_image];
    [driver setStr_CityName:str_CityName];
    [driver setStr_StateName:str_StateName];
    [driver setStr_OwnershipType:str_OwnershipType];
    return driver;
}
@end
