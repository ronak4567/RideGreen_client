//
//  RenterRequest.m
//  ridegreen
//
//  Created by Ridegreen on 29/10/2015.
//  Copyright (c) 2015 Ridegreen. All rights reserved.
//
#import "RenterRequest.h"

@implementation RenterRequest


+(id)setRequestedRoomId:(NSString *)roomId roomAddress:(NSString *)roomAddress nubmerOfRooms :(NSString *) nubmerOfRooms nubmerOfBeds:(NSString *) nubmerOfBeds roomRentalPrice:(NSString *)roomRentalPrice roomRentaldate:(NSString *)roomRentaldate isEnable:(NSString *)isRoomEnable clientId:(NSString *)clientId  clientName:(NSString *)clientName clientphone:(NSString *)clientphone clientadress:(NSString*)clientadress clientphoto:(NSString *)clientphoto customerId:(NSString *)customerId totelRent:(NSString *)totelRent roomImage:(NSString *)roomImage roomType:(NSString *)roomType numberOfDays:(NSString *)numberOfDays requestedDate:(NSString *)requestedDate isCheckIn:(NSString *)isCheckIn checkInDate:(NSString *)checkInDate bookid:(NSString *)bookingid cancelRoom:(NSString *)cancelRoom temp_checkin_date:(NSString *)temp_checkin_date taxrate:(NSString *)taxRate requestStatus:(NSString *)requestStatus roomrating:(NSString *)roomrating descrip:(NSString*)description adminphone:(NSString *)adminphone clientrating:(NSString*)clientrating securitydeposit:(NSString *)securitydeposit refundpercentage:(NSString *)refundpercentage;
{
    RenterRequest *room =[RenterRequest new];
    [room setRoomId:roomId];
    [room setRoomAddress:roomAddress];
    [room setNubmerOfRooms:nubmerOfRooms];
    [room setNubmerOfBeds:nubmerOfBeds];
    [room setRoomRentalPrice:roomRentalPrice];
    [room setRoomRentaldate:roomRentaldate];
    [room setIsEnable:isRoomEnable];
    [room setClientId:clientId];
    [room setClientName:clientName];
    [room setClientphone:clientphone];
    [room setClientphoto:clientphoto];
    [room setClientadress:clientadress];
    [room setCustomerId:customerId];
    [room setTotelRent:totelRent];
    [room setRoomImage:roomImage];
    [room setRoomType:roomType];
    [room setNumberOfDays:numberOfDays];
    [room setRequestedDate:requestedDate];
    [room setCheckInDate:checkInDate];
    [room setIsCheckIn:isCheckIn];
    [room setBookingId:bookingid];
    [room setCancelRoom:cancelRoom];
    [room setTemp_checkin_date:temp_checkin_date];
    [room setTaxRate:taxRate];
    [room setRequestStatus:requestStatus];
    [room setRoomrating:roomrating];
    [room setDescript:description];
    [room setAdminphone:adminphone];
    [room setClientrating:clientrating];
    [room setSecuritydeposit:securitydeposit];
    [room setRefundpercentage:refundpercentage];
    
    return room;
}

//						

@end














