//
//	Result.m
//
//	Create by user on 8/2/2016
//	Copyright © 2016. All rights reserved.
//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "CMyTours.h"
//#import "RootClass.h"

@interface CMyTours ()
@end
@implementation CMyTours

NSManagedObjectContext *contextCTours;
NSString* entityNameCTours = @"CMyTours";

//@dynamic rootClass;
@dynamic clientId;
@dynamic clientStatus;
@dynamic driverId;
@dynamic driverStatus;
@dynamic firstName;
@dynamic lastName;
@dynamic meetupAddress;
@dynamic meetupLocation;
@dynamic meetupTime;
@dynamic mobile;
@dynamic photo;
@dynamic status;
@dynamic tourDate;
@dynamic tourHourExpected;
@dynamic tourId;
@dynamic canceltour;
@dynamic customerId;
@dynamic tourprice;
@dynamic adminphone;
@dynamic refundpercentage;



/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary context:(NSManagedObjectContext *)context
{
	if(dictionary == nil || [dictionary isKindOfClass:[NSNull class]]){
		return nil;
	}
	NSEntityDescription * entityDescription = [NSEntityDescription entityForName:@"CMyTours" inManagedObjectContext:context];
	self = [super initWithEntity:entityDescription insertIntoManagedObjectContext:context];

//	if(![dictionary[@"rootClass"] isKindOfClass:[NSNull class]]){
//		self.rootClass = [[RootClass alloc] initWithDictionary:dictionary[@"rootClass"] context:context];
//	}

	if(![dictionary[@"client_id"] isKindOfClass:[NSNull class]]){
		self.clientId = dictionary[@"client_id"];
	}

	if(![dictionary[@"client_status"] isKindOfClass:[NSNull class]]){
		self.clientStatus = dictionary[@"client_status"];
	}

	if(![dictionary[@"driver_id"] isKindOfClass:[NSNull class]]){
		self.driverId = dictionary[@"driver_id"];
	}

	if(![dictionary[@"driver_status"] isKindOfClass:[NSNull class]]){
		self.driverStatus = dictionary[@"driver_status"];
	}

	if(![dictionary[@"first_name"] isKindOfClass:[NSNull class]]){
		self.firstName = dictionary[@"first_name"];
	}

	if(![dictionary[@"last_name"] isKindOfClass:[NSNull class]]){
		self.lastName = dictionary[@"last_name"];
	}

	if(![dictionary[@"meetup_address"] isKindOfClass:[NSNull class]]){
		self.meetupAddress = dictionary[@"meetup_address"];
	}

	if(![dictionary[@"meetup_location"] isKindOfClass:[NSNull class]]){
		self.meetupLocation = dictionary[@"meetup_location"];
	}

	if(![dictionary[@"meetup_time"] isKindOfClass:[NSNull class]]){
		self.meetupTime = dictionary[@"meetup_time"];
	}

	if(![dictionary[@"mobile"] isKindOfClass:[NSNull class]]){
		self.mobile = dictionary[@"mobile"];
	}

	if(![dictionary[@"photo"] isKindOfClass:[NSNull class]]){
		self.photo = dictionary[@"photo"];
	}

	if(![dictionary[@"status"] isKindOfClass:[NSNull class]]){
		self.status = dictionary[@"status"];
	}

	if(![dictionary[@"tour_date"] isKindOfClass:[NSNull class]]){
		self.tourDate = dictionary[@"tour_date"];
	}

	if(![dictionary[@"tour_hour_expected"] isKindOfClass:[NSNull class]]){
		self.tourHourExpected = dictionary[@"tour_hour_expected"];
	}

	if(![dictionary[@"tour_id"] isKindOfClass:[NSNull class]]){
		self.tourId = dictionary[@"tour_id"];
	}
    
    if(![dictionary[@"canceltour"] isKindOfClass:[NSNull class]]){
        self.canceltour = dictionary[@"canceltour"];
    }
    
    
    if(![dictionary[@"customerid"] isKindOfClass:[NSNull class]]){
        self.customerId = dictionary[@"customerid"];
    }
    
    if(![dictionary[@"total_payment"] isKindOfClass:[NSNull class]]){
        self.tourprice = dictionary[@"total_payment"];
    }
    
    if(![dictionary[@"admin_phone"] isKindOfClass:[NSNull class]]){
        self.adminphone = dictionary[@"admin_phone"];
    }
    
    if(![dictionary[@"driverfirstname"] isKindOfClass:[NSNull class]]){
        self.drivernam = dictionary[@"driverfirstname"];
    }
    
    if(![dictionary[@"drivermobile"] isKindOfClass:[NSNull class]]){
        self.driverphon = dictionary[@"drivermobile"];
    }
    
    
    if(![dictionary[@"refund_percentage"] isKindOfClass:[NSNull class]]){
        self.refundpercentage = dictionary[@"refund_percentage"];
    }
    
    //
    

    //
    
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
	if(self.clientId != nil){
		dictionary[@"client_id"] = self.clientId;
	}
	if(self.clientStatus != nil){
		dictionary[@"client_status"] = self.clientStatus;
	}
	if(self.driverId != nil){
		dictionary[@"driver_id"] = self.driverId;
	}
	if(self.driverStatus != nil){
		dictionary[@"driver_status"] = self.driverStatus;
	}
	if(self.firstName != nil){
		dictionary[@"first_name"] = self.firstName;
	}
	if(self.lastName != nil){
		dictionary[@"last_name"] = self.lastName;
	}
	if(self.meetupAddress != nil){
		dictionary[@"meetup_address"] = self.meetupAddress;
	}
	if(self.meetupLocation != nil){
		dictionary[@"meetup_location"] = self.meetupLocation;
	}
	if(self.meetupTime != nil){
		dictionary[@"meetup_time"] = self.meetupTime;
	}
	if(self.mobile != nil){
		dictionary[@"mobile"] = self.mobile;
	}
	if(self.photo != nil){
		dictionary[@"photo"] = self.photo;
	}
	if(self.status != nil){
		dictionary[@"status"] = self.status;
	}
	if(self.tourDate != nil){
		dictionary[@"tour_date"] = self.tourDate;
	}
	if(self.tourHourExpected != nil){
		dictionary[@"tour_hour_expected"] = self.tourHourExpected;
	}
	if(self.tourId != nil){
		dictionary[@"tour_id"] = self.tourId;
	}
    if(self.canceltour != nil){
        dictionary[@"canceltour"] = self.canceltour;
    }
    
    if(self.customerId != nil){
        dictionary[@"customerid"] = self.customerId;
    }
    
    if(self.tourprice != nil){
        dictionary[@"total_payment"] = self.tourprice;
    }
    
    
    if(self.adminphone != nil){
        dictionary[@"admin_phone"] = self.adminphone;
    }
    
    if(self.drivernam != nil){
        dictionary[@"driverfirstname"] = self.drivernam;
    }
    
    if(self.driverphon != nil){
        dictionary[@"drivermobile"] = self.driverphon;
    }
    
    
    if(self.refundpercentage != nil){
        dictionary[@"refund_percentage"] = self.refundpercentage;
    }
    
    
    //
    
	return dictionary;

}


-(void)updateClientMyTours:(NSDictionary *)res
{
    [self deleteAllDataMyTours];
    
    NSError *error;
    for (int i = 0; i<[res[@"result"] count]; i++) {
        CMyTours *obj_cl = [NSEntityDescription insertNewObjectForEntityForName:entityNameCTours inManagedObjectContext:[self getContext]];
        [self exciteLines:obj_cl dic:res[@"result"][i]];
        
        if (![[self getContext] save:&error]) {
            NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
        }
    }
}

-(void)exciteLines:(CMyTours *)obj_dv dic:(NSDictionary *)res
{
    obj_dv.clientId = res[@"client_id"];
    obj_dv.clientStatus = res[@"client_status"];
    obj_dv.driverId = res[@"driver_id"];
    obj_dv.driverStatus = res[@"driver_status"];
    obj_dv.firstName = res[@"first_name"];
    obj_dv.lastName = res[@"last_name"];
    obj_dv.meetupAddress = res[@"meetup_address"];
    obj_dv.meetupLocation = res[@"meetup_location"];
    obj_dv.meetupTime = res[@"meetup_time"];
    obj_dv.mobile = res[@"mobile"];
    obj_dv.photo = res[@"photo"];
    obj_dv.status = res[@"status"];
    obj_dv.tourDate = res[@"tour_date"];
    obj_dv.tourHourExpected = res[@"tour_hour_expected"];
    obj_dv.tourId = res[@"tour_id"];
    obj_dv.canceltour = res[@"canceltour"];
    obj_dv.customerId = res[@"customerid"];
    obj_dv.tourprice = res[@"total_payment"];
    obj_dv.adminphone = res[@"admin_phone"];
    obj_dv.drivernam = res[@"driverfirstname"];
    obj_dv.driverphon = res[@"drivermobile"];
    obj_dv.refundpercentage = res[@"refund_percentage"];
    
    //driverfirstname drivermobile
}


-(NSMutableArray *)fetchClientMyTours
{
    NSEntityDescription *entityDesc = [NSEntityDescription entityForName:entityNameCTours
                                                  inManagedObjectContext:[self getContext]];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDesc];
    
    NSError *error;
    
    return  [(NSMutableArray *)[[self getContext] executeFetchRequest:request error:&error] mutableCopy] ;
}


-(void)deleteAllDataMyTours{
    NSEntityDescription *entityDesc = [NSEntityDescription entityForName:entityNameCTours
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



-(void)deleteObjectAtIndex:(NSInteger)index
{
    NSEntityDescription *entityDesc = [NSEntityDescription entityForName:entityNameCTours
                                                  inManagedObjectContext:[self getContext]];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDesc];
    
    NSError *error;
    NSArray *filterArray = [[self getContext] executeFetchRequest:request error:&error];
    
    
    [[self getContext] deleteObject:[filterArray objectAtIndex:index]];
    
    if (![[self getContext] save:&error]) {
        //NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }
    
}



-(NSManagedObjectContext*) getContext{
    if(contextCTours==nil){
        contextCTours=[kAppDelegate managedObjectContext];
    }
    return contextCTours;
}

@end
