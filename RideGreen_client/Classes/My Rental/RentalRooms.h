//
//  RentalRooms.h
//  ridegreen
//
//  Created by Ridegreen on 28/10/2015.
//  Copyright (c) 2015 Ridegreen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RentalRooms : NSObject

@property (nonatomic,copy) NSString *roomId;
@property (nonatomic,copy) NSString *roomAddress;
@property (nonatomic,copy) NSString *roomRentalPrice;
@property (nonatomic,copy) NSString *roomRentaldate;
@property (nonatomic,copy) NSString *roomStatus;
@property (nonatomic,copy) NSString *nubmerOfRooms;
@property (nonatomic,copy) NSString *nubmerOfBeds;
@property (nonatomic,copy) NSString *isEnable;
@property (nonatomic,copy) NSString *requestedDate;
@property (nonatomic,copy) NSString *roomImage;
@property (nonatomic,copy) NSString *roomType;
+(id)setRoomId:(NSString *)roomId roomAddress:(NSString *)roomAddress nubmerOfRooms :(NSString *) nubmerOfRooms nubmerOfBeds:(NSString *) nubmerOfBeds roomRentalPrice:(NSString *)roomRentalPrice roomRentaldate:(NSString *)roomRentaldate isEnable:(NSString *)isRoomEnable roomStatus:(NSString *)roomStatus requestedDate :(NSString *)requestedDate roomImage:(NSString *)roomImage roomType:(NSString *)roomType ;
@end
