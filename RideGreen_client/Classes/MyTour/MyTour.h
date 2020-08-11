//
//  MyTour.h
//  ridegreen
//
//  Created by Ridegreen on 01/09/2015.
//  Copyright (c) 2015 Ridegreen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyTour : NSObject
{
    NSString *tId;
    NSString *tDate;
    NSString *driverId;
    NSString *driverName;
    NSString *driverPhone;
    NSString *driverImage;
    NSString *driverRate;
    
    NSString *clientId;
    NSString *meetupAddress;
    NSString *meetupLocation;
    NSString *meetupTime;
    NSString *expectedHours;
    NSString *status;
    NSString *driverStatus;
    NSString *clientStatus;
    NSString *canceltour;
    NSString *customerId;
    NSString *tourprice;
    NSString *adminphone;
    NSString *drivernam;
    NSString *driverphon;
    NSString *refundpercentage;
}
@property (nonatomic,copy) NSString *tId;
@property (nonatomic,copy) NSString *tDate;
@property (nonatomic,copy) NSString *driverId;
@property (nonatomic,copy) NSString *driverName;
@property (nonatomic,copy) NSString *driverImage;
@property (nonatomic,copy) NSString *driverRate;
@property (nonatomic,copy) NSString *driverPhone;
@property (nonatomic,copy) NSString *clientId;
@property (nonatomic,copy) NSString *meetupAddress;
@property (nonatomic,copy) NSString *meetupLocation;
@property (nonatomic,copy) NSString *meetupTime;
@property (nonatomic,copy) NSString *status;
@property (nonatomic,copy) NSString *expectedHours;
@property (nonatomic,copy) NSString *driverStatus;
@property (nonatomic,copy) NSString *clientStatus;
@property (nonatomic, strong) NSString *canceltour;
@property (nonatomic, strong) NSString *customerId;
@property (nonatomic, strong) NSString *tourprice;
@property (nonatomic,strong) NSString *adminphone;
@property (nonatomic,strong) NSString *drivernam;
@property (nonatomic, strong)NSString *driverphon;
@property (nonatomic, strong)NSString *refundpercentage;


+(id)setTourId :(NSString *)TourId tourDate :(NSString *)tourDate driverId :(NSString *)driverId driverName :(NSString *)driverName driverImage :(NSString *)driverImage driverRate:(NSString *)driverRate driverPhone:(NSString *)driverPhone  clientId:(NSString *)clientId meetupAddress:(NSString *)meetupAddress  meetupLocation:(NSString *)meetupLocation meetupTime:(NSString *)meetupTime  expectedHours:(NSString *)expectedHours status :(NSString *) status driverStatus :(NSString *) driverStatus clientStatus :(NSString *) clientStatus cancelstatus:(NSString *)canceltour customerId:(NSString *)customerId tourprice:(NSString *)tourprice adminphone:(NSString *)adminphone drivernam:(NSString *)drivernam driverphon:(NSString*)driverphon refundpercentage:(NSString*)refundpercentage;
@end
