//
//  AvailableDriver.h
//  ridegreen
//
//  Created by Ridegreen on 31/08/2015.
//  Copyright (c) 2015 Ridegreen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AvailableDriver : NSObject
{
    NSString *dId;
    NSString *dName;
    NSString *dIamge;
    NSString *dPerHourRate;
    NSString *dCity;
    NSString *dRating;
    

}
@property (nonatomic,copy) NSString *dId;
@property (nonatomic,copy) NSString *dName;
@property (nonatomic,copy) NSString *dIamge;
@property (nonatomic,copy) NSString *dPerHourRate;
@property (nonatomic,copy) NSString *dCity;
@property (nonatomic,copy) NSString *dRating;

+(id)setDriverId :(NSString *) dId DriverName:(NSString *)dName DriverImage :(NSString *) dImage PerHourRate :(NSString *)phourRate driverCity :(NSString *)dCity dRating:(NSString *)dRating; 

@end
