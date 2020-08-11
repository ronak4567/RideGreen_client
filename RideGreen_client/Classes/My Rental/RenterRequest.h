//
//  RenterRequest.h
//  ridegreen
//
//  Created by Ridegreen on 29/10/2015.
//  Copyright (c) 2015 Ridegreen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RenterRequest : NSObject

@property (nonatomic,copy) NSString *roomId;
@property (nonatomic,copy) NSString *roomAddress;
@property (nonatomic,copy) NSString *roomRentalPrice;
@property (nonatomic,copy) NSString *roomRentaldate;
@property (nonatomic,copy) NSString *nubmerOfRooms;
@property (nonatomic,copy) NSString *nubmerOfBeds;
@property (nonatomic,copy) NSString *isEnable;
@property (nonatomic,copy) NSString *clientId;
@property (nonatomic,copy) NSString *clientName;
@property (nonatomic,copy) NSString *clientphone;
@property (nonatomic,copy) NSString *clientadress;
@property (nonatomic,copy) NSString *clientphoto;
@property (nonatomic,copy) NSString *customerId;
@property (nonatomic,copy) NSString *totelRent;
@property (nonatomic,copy) NSString *roomImage;
@property (nonatomic,copy) NSString *roomType;
@property (nonatomic,copy) NSString *numberOfDays;
@property (nonatomic,copy) NSString *requestedDate;
@property (nonatomic,copy) NSString *checkInDate;
@property (nonatomic,copy) NSString *isCheckIn;
@property (nonatomic,copy) NSString *bookingId;
@property (nonatomic,copy) NSString *cancelRoom;
@property (nonatomic,copy) NSString *temp_checkin_date;//
@property (nonatomic,copy) NSString *taxRate;
@property (nonatomic, copy) NSString *requestStatus;
@property (nonatomic, copy) NSString *roomrating;
@property (nonatomic, copy) NSString *descript;
@property (nonatomic, copy) NSString *adminphone;
@property (nonatomic,copy)  NSString *clientrating;
@property (nonatomic,copy) NSString *securitydeposit;
@property (nonatomic,copy) NSString *refundpercentage;



+(id)setRequestedRoomId:(NSString *)roomId roomAddress:(NSString *)roomAddress nubmerOfRooms :(NSString *) nubmerOfRooms nubmerOfBeds:(NSString *) nubmerOfBeds roomRentalPrice:(NSString *)roomRentalPrice roomRentaldate:(NSString *)roomRentaldate isEnable:(NSString *)isRoomEnable clientId:(NSString *)clientId  clientName:(NSString *)clientName clientphone:(NSString *)clientphone clientadress:(NSString*)clientadress clientphoto:(NSString *)clientphoto customerId:(NSString *)customerId totelRent:(NSString *)totelRent roomImage:(NSString *)roomImage roomType:(NSString *)roomType numberOfDays:(NSString *)numberOfDays requestedDate:(NSString *)requestedDate isCheckIn:(NSString *)isCheckIn checkInDate:(NSString *)checkInDate bookid:(NSString *)bookingid cancelRoom:(NSString *)cancelRoom temp_checkin_date:(NSString *)temp_checkin_date taxrate:(NSString *)taxRate requestStatus:(NSString *)requestStatus roomrating:(NSString *)roomrating descrip:(NSString *)description adminphone:(NSString *)adminphone clientrating:(NSString*)clientrating securitydeposit:(NSString *)securitydeposit refundpercentage:(NSString *)refundpercentage ;
@end






