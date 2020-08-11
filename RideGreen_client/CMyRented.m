//
//	Result.m
//
//	Create by user on 12/2/2016
//	Copyright © 2016. All rights reserved.
//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "CMyRented.h"
//#import "RootClass.h"

@interface CMyRented ()
@end
@implementation CMyRented

NSManagedObjectContext *contextRented;
NSString* entityNameRented = @"CMyRented";

//@dynamic rootClass;
@dynamic beds;
@dynamic checkinDate;
@dynamic checkoutDate;
@dynamic cityId;
@dynamic clientAddress;
@dynamic createdon;
@dynamic customerid;
@dynamic firstName;
@dynamic idField;
@dynamic isCheckIn;
@dynamic isCheckOut;
@dynamic lastName;
@dynamic mobile;
@dynamic name;
@dynamic noOfDays;
@dynamic paymentOption;
@dynamic paymentStatus;
@dynamic phone;
@dynamic photo;
@dynamic ratePerMonth;
@dynamic rentedDate;
@dynamic rentedStatus;
@dynamic renterId;
@dynamic requestedDate;
@dynamic roomAddress;
@dynamic roomImage;
@dynamic roomType;
@dynamic rooms;
@dynamic stateId;
@dynamic status;
@dynamic totalPayment;
@dynamic userId;
@dynamic bookingId;
@dynamic cancelRoom;
@dynamic tempCheckinDate;
@dynamic taxRate;
@dynamic roomrating;
@dynamic adminphone;



/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary context:(NSManagedObjectContext *)context
{
	if(dictionary == nil || [dictionary isKindOfClass:[NSNull class]]){
		return nil;
	}
	NSEntityDescription * entityDescription = [NSEntityDescription entityForName:@"CMyRented" inManagedObjectContext:context];
	self = [super initWithEntity:entityDescription insertIntoManagedObjectContext:context];

//	if(![dictionary[@"rootClass"] isKindOfClass:[NSNull class]]){
//		self.rootClass = [[RootClass alloc] initWithDictionary:dictionary[@"rootClass"] context:context];
//	}

	if(![dictionary[@"beds"] isKindOfClass:[NSNull class]]){
		self.beds = dictionary[@"beds"];
	}

	if(![dictionary[@"checkin_date"] isKindOfClass:[NSNull class]]){
		self.checkinDate = dictionary[@"checkin_date"];
	}

	if(![dictionary[@"checkout_date"] isKindOfClass:[NSNull class]]){
		self.checkoutDate = dictionary[@"checkout_date"];
	}

	if(![dictionary[@"city_id"] isKindOfClass:[NSNull class]]){
		self.cityId = dictionary[@"city_id"];
	}

	if(![dictionary[@"client_address"] isKindOfClass:[NSNull class]]){
		self.clientAddress = dictionary[@"client_address"];
	}

	if(![dictionary[@"createdon"] isKindOfClass:[NSNull class]]){
		self.createdon = dictionary[@"createdon"];
	}

	if(![dictionary[@"customerid"] isKindOfClass:[NSNull class]]){
		self.customerid = dictionary[@"customerid"];
	}

	if(![dictionary[@"first_name"] isKindOfClass:[NSNull class]]){
		self.firstName = dictionary[@"first_name"];
	}

	if(![dictionary[@"id"] isKindOfClass:[NSNull class]]){
		self.idField = dictionary[@"id"];
	}

	if(![dictionary[@"is_check_in"] isKindOfClass:[NSNull class]]){
		self.isCheckIn = dictionary[@"is_check_in"];
	}

	if(![dictionary[@"is_check_out"] isKindOfClass:[NSNull class]]){
		self.isCheckOut = dictionary[@"is_check_out"];
	}

	if(![dictionary[@"last_name"] isKindOfClass:[NSNull class]]){
		self.lastName = dictionary[@"last_name"];
	}

	if(![dictionary[@"mobile"] isKindOfClass:[NSNull class]]){
		self.mobile = dictionary[@"mobile"];
	}

	if(![dictionary[@"name"] isKindOfClass:[NSNull class]]){
		self.name = dictionary[@"name"];
	}

	if(![dictionary[@"no_of_days"] isKindOfClass:[NSNull class]]){
		self.noOfDays = dictionary[@"no_of_days"];
	}

	if(![dictionary[@"payment_option"] isKindOfClass:[NSNull class]]){
		self.paymentOption = dictionary[@"payment_option"];
	}

	if(![dictionary[@"payment_status"] isKindOfClass:[NSNull class]]){
		self.paymentStatus = dictionary[@"payment_status"];
	}

	if(![dictionary[@"phone"] isKindOfClass:[NSNull class]]){
		self.phone = dictionary[@"phone"];
	}

	if(![dictionary[@"photo"] isKindOfClass:[NSNull class]]){
		self.photo = dictionary[@"photo"];
	}

	if(![dictionary[@"rate_per_month"] isKindOfClass:[NSNull class]]){
		self.ratePerMonth = dictionary[@"rate_per_month"];
	}

	if(![dictionary[@"rented_date"] isKindOfClass:[NSNull class]]){
		self.rentedDate = dictionary[@"rented_date"];
	}

	if(![dictionary[@"rented_status"] isKindOfClass:[NSNull class]]){
		self.rentedStatus = dictionary[@"rented_status"];
	}

	if(![dictionary[@"renter_id"] isKindOfClass:[NSNull class]]){
		self.renterId = dictionary[@"renter_id"];
	}

	if(![dictionary[@"requested_date"] isKindOfClass:[NSNull class]]){
		self.requestedDate = dictionary[@"requested_date"];
	}

	if(![dictionary[@"room_address"] isKindOfClass:[NSNull class]]){
		self.roomAddress = dictionary[@"room_address"];
	}

	if(![dictionary[@"room_image"] isKindOfClass:[NSNull class]]){
		self.roomImage = dictionary[@"room_image"];
	}

	if(![dictionary[@"room_type"] isKindOfClass:[NSNull class]]){
		self.roomType = dictionary[@"room_type"];
	}

	if(![dictionary[@"rooms"] isKindOfClass:[NSNull class]]){
		self.rooms = dictionary[@"rooms"];
	}

	if(![dictionary[@"state_id"] isKindOfClass:[NSNull class]]){
		self.stateId = dictionary[@"state_id"];
	}

	if(![dictionary[@"status"] isKindOfClass:[NSNull class]]){
		self.status = dictionary[@"status"];
	}

	if(![dictionary[@"total_payment"] isKindOfClass:[NSNull class]]){
		self.totalPayment = dictionary[@"total_payment"];
	}

	if(![dictionary[@"user_id"] isKindOfClass:[NSNull class]]){
		self.userId = dictionary[@"user_id"];
	}
    
    if(![dictionary[@"booking_id"] isKindOfClass:[NSNull class]]){
        self.bookingId = dictionary[@"booking_id"];
    }
    if(![dictionary[@"cancelroom"] isKindOfClass:[NSNull class]]){
        self.cancelRoom = dictionary[@"cancelroom"];
    }
    if(![dictionary[@"temp_checkin_date"] isKindOfClass:[NSNull class]]){
        self.tempCheckinDate = dictionary[@"temp_checkin_date"];
    }
    if(![dictionary[@"taxrate"] isKindOfClass:[NSNull class]]){
        self.taxRate = dictionary[@"taxrate"];
    }
    if(![dictionary[@"room_rating"] isKindOfClass:[NSNull class]]){
        self.roomrating = dictionary[@"room_rating"];
    }
    if(![dictionary[@"admin_phone"] isKindOfClass:[NSNull class]]){
        self.adminphone = dictionary[@"admin_phone"];
    }
    if(![dictionary[@"client_rating"] isKindOfClass:[NSNull class]]){
        self.clientrating = dictionary[@"client_rating"];
    }

	return self;
}


/**
 * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
 */
-(NSDictionary *)toDictionary
{
	NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];
//	if(self.rootClass != nil){
//		dictionary[@"rootClass"] = [self.rootClass toDictionary];
//	}
	if(self.beds != nil){
		dictionary[@"beds"] = self.beds;
	}
	if(self.checkinDate != nil){
		dictionary[@"checkin_date"] = self.checkinDate;
	}
	if(self.checkoutDate != nil){
		dictionary[@"checkout_date"] = self.checkoutDate;
	}
	if(self.cityId != nil){
		dictionary[@"city_id"] = self.cityId;
	}
	if(self.clientAddress != nil){
		dictionary[@"client_address"] = self.clientAddress;
	}
	if(self.createdon != nil){
		dictionary[@"createdon"] = self.createdon;
	}
	if(self.customerid != nil){
		dictionary[@"customerid"] = self.customerid;
	}
	if(self.firstName != nil){
		dictionary[@"first_name"] = self.firstName;
	}
	if(self.idField != nil){
		dictionary[@"id"] = self.idField;
	}
	if(self.isCheckIn != nil){
		dictionary[@"is_check_in"] = self.isCheckIn;
	}
	if(self.isCheckOut != nil){
		dictionary[@"is_check_out"] = self.isCheckOut;
	}
	if(self.lastName != nil){
		dictionary[@"last_name"] = self.lastName;
	}
	if(self.mobile != nil){
		dictionary[@"mobile"] = self.mobile;
	}
	if(self.name != nil){
		dictionary[@"name"] = self.name;
	}
	if(self.noOfDays != nil){
		dictionary[@"no_of_days"] = self.noOfDays;
	}
	if(self.paymentOption != nil){
		dictionary[@"payment_option"] = self.paymentOption;
	}
	if(self.paymentStatus != nil){
		dictionary[@"payment_status"] = self.paymentStatus;
	}
	if(self.phone != nil){
		dictionary[@"phone"] = self.phone;
	}
	if(self.photo != nil){
		dictionary[@"photo"] = self.photo;
	}
	if(self.ratePerMonth != nil){
		dictionary[@"rate_per_month"] = self.ratePerMonth;
	}
	if(self.rentedDate != nil){
		dictionary[@"rented_date"] = self.rentedDate;
	}
	if(self.rentedStatus != nil){
		dictionary[@"rented_status"] = self.rentedStatus;
	}
	if(self.renterId != nil){
		dictionary[@"renter_id"] = self.renterId;
	}
	if(self.requestedDate != nil){
		dictionary[@"requested_date"] = self.requestedDate;
	}
	if(self.roomAddress != nil){
		dictionary[@"room_address"] = self.roomAddress;
	}
	if(self.roomImage != nil){
		dictionary[@"room_image"] = self.roomImage;
	}
	if(self.roomType != nil){
		dictionary[@"room_type"] = self.roomType;
	}
	if(self.rooms != nil){
		dictionary[@"rooms"] = self.rooms;
	}
	if(self.stateId != nil){
		dictionary[@"state_id"] = self.stateId;
	}
	if(self.status != nil){
		dictionary[@"status"] = self.status;
	}
	if(self.totalPayment != nil){
		dictionary[@"total_payment"] = self.totalPayment;
	}
	if(self.userId != nil){
		dictionary[@"user_id"] = self.userId;
	}
    if(self.bookingId != nil){
        dictionary[@"booking_id"] = self.bookingId;
    }
    if(self.cancelRoom != nil){
        dictionary[@"cancelroom"] = self.cancelRoom;
    }
    if(self.tempCheckinDate != nil){
        dictionary[@"temp_checkin_date"] = self.tempCheckinDate;
    }
    if(self.taxRate != nil){
        dictionary[@"taxrate"] = self.taxRate;
    }
    if(self.roomrating != nil){
        dictionary[@"room_rating"] = self.roomrating;
    }
    if(self.adminphone != nil){
        dictionary[@"admin_phone"] = self.adminphone;
    }
    
    if(self.clientrating != nil){
        dictionary[@"client_rating"] = self.clientrating;
    }
    
	return dictionary;

}

-(void)updateClientRented:(NSDictionary *)res
{
    [self deleteAllDataRented];
    
    NSError *error;
    for (int i = 0; i<[res[@"result"] count]; i++) {
        CMyRented *obj_cl = [NSEntityDescription insertNewObjectForEntityForName:entityNameRented inManagedObjectContext:[self getContext]];
        [self exciteLines:obj_cl dic:res[@"result"][i]];
        
        if (![[self getContext] save:&error]) {
            NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
        }
    }
}

-(void)exciteLines:(CMyRented *)obj_dv dic:(NSDictionary *)res
{
    obj_dv.beds = res[@"beds"];
    obj_dv.checkinDate = res[@"checkin_date"];
    obj_dv.checkoutDate = res[@"checkout_date"];
    obj_dv.cityId = res[@"city_id"];
    obj_dv.clientAddress = res[@"client_address"];
    obj_dv.createdon = res[@"createdon"];
    obj_dv.customerid = res[@"customerid"];
    obj_dv.firstName = res[@"first_name"];
    obj_dv.idField = res[@"id"];
    obj_dv.isCheckIn = res[@"is_check_in"];
    obj_dv.isCheckOut = res[@"is_check_out"];
    obj_dv.lastName = res[@"last_name"];
    obj_dv.mobile = res[@"mobile"];
    obj_dv.name = res[@"name"];
    obj_dv.noOfDays = res[@"no_of_days"];
    obj_dv.paymentOption = res[@"payment_option"];
    obj_dv.paymentStatus = res[@"payment_status"];
    obj_dv.phone = res[@"phone"];
    obj_dv.photo = res[@"photo"];
    obj_dv.ratePerMonth = res[@"rate_per_month"];
    obj_dv.rentedDate = res[@"rented_date"];
    obj_dv.rentedStatus = res[@"rented_status"];
    obj_dv.renterId = res[@"renter_id"];
    obj_dv.requestedDate = res[@"requested_date"];
    obj_dv.roomAddress = res[@"room_address"];
    obj_dv.roomImage = res[@"room_image"];
    obj_dv.roomType = res[@"room_type"];
    obj_dv.rooms = res[@"rooms"];
    obj_dv.stateId = res[@"state_id"];
    obj_dv.status = res[@"status"];
    obj_dv.totalPayment = res[@"total_payment"];
    obj_dv.userId = res[@"user_id"];
    obj_dv.bookingId = res[@"booking_id"];
    obj_dv.cancelRoom = res[@"cancelroom"];
    obj_dv.tempCheckinDate = res[@"temp_checkin_date"];
    obj_dv.taxRate = res[@"taxrate"];
    obj_dv.roomrating = res[@"room_rating"];
    obj_dv.adminphone = res[@"admin_phone"];
    obj_dv.clientrating = res[@"client_rating"];

}


-(NSMutableArray *)fetchClientRented
{
    NSEntityDescription *entityDesc = [NSEntityDescription entityForName:entityNameRented
                                                  inManagedObjectContext:[self getContext]];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDesc];
    
    NSError *error;
    
    return  [(NSMutableArray *)[[self getContext] executeFetchRequest:request error:&error] mutableCopy] ;
}


-(void)deleteAllDataRented{
    NSEntityDescription *entityDesc = [NSEntityDescription entityForName:entityNameRented
                                                  inManagedObjectContext:[self getContext]];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDesc];
    
    NSError *error;
    NSArray *filterArray = [[self getContext] executeFetchRequest:request error:&error];
    
    for (int i=0; i<[ filterArray count]; i++) {
        [[self getContext] deleteObject:[filterArray objectAtIndex:i]];
        
        if (![[self getContext] save:&error]) {
            //NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
        }
    }
}


-(NSManagedObjectContext*) getContext{
    if(contextRented==nil){
        contextRented=[kAppDelegate managedObjectContext];
    }
    return contextRented;
}


@end