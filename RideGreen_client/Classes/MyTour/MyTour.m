//
//  MyTour.m
//  ridegreen
//
//  Created by Ridegreen on 01/09/2015.
//  Copyright (c) 2015 Ridegreen. All rights reserved.
//

#import "MyTour.h"

@implementation MyTour
@synthesize tId,tDate,driverId,driverImage,driverName,driverPhone,driverRate,clientId,meetupAddress,meetupLocation,meetupTime,expectedHours,status,driverStatus,clientStatus,canceltour,customerId,tourprice,adminphone,drivernam,driverphon,refundpercentage;


+(id)setTourId :(NSString *)TourId tourDate :(NSString *)tourDate driverId :(NSString *)driverId driverName :(NSString *)driverName driverImage :(NSString *)driverImage driverRate:(NSString *)driverRate driverPhone:(NSString *)driverPhone  clientId:(NSString *)clientId meetupAddress:(NSString *)meetupAddress  meetupLocation:(NSString *)meetupLocation meetupTime:(NSString *)meetupTime  expectedHours:(NSString *)expectedHours status :(NSString *) status driverStatus :(NSString *) driverStatus clientStatus :(NSString *) clientStatus cancelstatus:(NSString *)canceltour customerId:(NSString *)customerId tourprice:(NSString *)tourprice adminphone:(NSString *)adminphone drivernam:(NSString*)drivernam driverphon:(NSString*)driverphon refundpercentage:(NSString*)refundpercentage
{
    MyTour *tour =[MyTour new];
    [tour setTId:TourId];
    [tour setTDate:tourDate];
    [tour setDriverId:driverId];
    [tour setDriverName:driverName];
    [tour setDriverPhone:driverPhone];
    [tour setDriverImage:driverImage];
    [tour setDriverRate:driverRate];
    [tour setClientId:clientId];
    [tour setMeetupAddress:meetupAddress];
    [tour setMeetupLocation:meetupLocation];
    [tour setMeetupTime:meetupTime];
    [tour setExpectedHours:expectedHours];
    [tour setStatus:status];
    [tour setDriverStatus:driverStatus];
    [tour setClientStatus:clientStatus];
    [tour setCanceltour:canceltour];
    [tour setCustomerId:customerId];
    [tour setTourprice:tourprice];
    [tour setAdminphone:adminphone];
    [tour setDrivernam:drivernam];
    [tour setDriverphon:driverphon];
    [tour setRefundpercentage:refundpercentage];
    return tour;
    
}
@end
