//
//  Driver.h
//  ridegreendriver
//
//  Created by Ridegreen on 08/09/2015.
//  Copyright (c) 2015 Ridegreen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Driver : NSObject
{
    NSString *driverId;
    NSString *driverName;
    NSString *driverPhone;
    NSString *driverPhoto;
    NSString *driverCarId;
    NSString *carImage;
    NSString *carNumber;
    NSString *carBasefare;
    NSString *carPerMilefare;
    NSString *availableSeats;
    NSString *driverLocation;
    NSString *driverDistance;
    NSString *driverRating;
    NSString *drivermile;
    NSString *driverGender;
    NSString *driverCarModel;
    NSString *str_model_image;
    NSString *str_StateName;
    NSString *str_CityName;
    NSString *str_OwnershipType;

    

}
@property (nonatomic,copy) NSString *driverId;
@property (nonatomic,copy) NSString *driverName;
@property (nonatomic,copy) NSString *driverPhone;
@property (nonatomic,copy) NSString *driverPhoto;
@property (nonatomic,copy) NSString *driverCarId;
@property (nonatomic,copy) NSString *driverLocation;
@property (nonatomic,copy) NSString *driverDistance;
@property (nonatomic,copy) NSString *availableSeats;
@property (nonatomic,copy) NSString *carImage;
@property (nonatomic,copy) NSString *carNumber;
@property (nonatomic,copy) NSString *carBasefare;
@property (nonatomic,copy) NSString *carPerMilefare;
@property (nonatomic,copy) NSString *driverRating;
@property (nonatomic,copy) NSString *drivermile;
@property (nonatomic,copy) NSString *driverGender;
@property (nonatomic,copy) NSString *driverCarModel;
@property (nonatomic,copy) NSString *str_model_image;
@property (nonatomic,copy) NSString *str_StateName;
@property (nonatomic,copy) NSString *str_CityName;
@property (nonatomic,copy) NSString *str_OwnershipType;


+(id)setDriverId :(NSString *)driverId driverName :(NSString *)driverName driverPhone:(NSString *)driverPhone driverPhoto:(NSString *)driverPhoto driverCarId:(NSString *)driverCarId driverLocation:(NSString *)driverLocation driverDistance:(NSString *)driverDistance availableSeats:(NSString *)availableSeats carImage:(NSString *)carImage carNumber:(NSString *)carNumber carBasefare:(NSString *)carBasefare carPerMilefare:(NSString *)carPerMilefare driverRating:(NSString *) driverRating drivermile:(NSString *)drivermile driverGender:(NSString*)driverGender driverCarModel:(NSString*)driverCarModel str_model_image:(NSString*)str_model_image  str_StateName:(NSString*)str_StateName str_CityName:(NSString*)str_CityName str_OwnershipType:(NSString*)str_OwnershipType;
@end
