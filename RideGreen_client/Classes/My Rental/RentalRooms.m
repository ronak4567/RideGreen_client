//
//  RentalRooms.m
//  ridegreen
//
//  Created by Ridegreen on 28/10/2015.
//  Copyright (c) 2015 Ridegreen. All rights reserved.
//

#import "RentalRooms.h"

@implementation RentalRooms


+(id)setRoomId:(NSString *)roomId roomAddress:(NSString *)roomAddress nubmerOfRooms :(NSString *) nubmerOfRooms nubmerOfBeds:(NSString *) nubmerOfBeds roomRentalPrice:(NSString *)roomRentalPrice roomRentaldate:(NSString *)roomRentaldate isEnable:(NSString *)isRoomEnable roomStatus:(NSString *)roomStatus requestedDate :(NSString *)requestedDate roomImage:(NSString *)roomImage roomType:(NSString *)roomType 
{
    RentalRooms *room =[RentalRooms new];
    
    [room setRoomId:roomId];
    [room setRoomAddress:roomAddress];
    [room setNubmerOfRooms:nubmerOfRooms];
    [room setNubmerOfBeds:nubmerOfBeds];
    [room setRoomRentalPrice:roomRentalPrice];
    [room setRoomRentaldate:roomRentaldate];
    [room setIsEnable:isRoomEnable];
    [room setRoomStatus:roomStatus];
    [room setRequestedDate:requestedDate];
    [room setRoomImage:roomImage];
    [room setRoomType:roomType];
    return room;


}
@end
