//
//	Result.m
//
//	Create by user on 9/2/2016
//	Copyright © 2016. All rights reserved.
//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "CProfile.h"
//#import "RootClass.h"

@interface CProfile ()
@end
@implementation CProfile

NSManagedObjectContext *contextCProfile;
NSString* entityNameCProfile = @"CProfile";

//@dynamic rootClass;
@dynamic inOut;
@dynamic cityId;
@dynamic country;
@dynamic creditcardNo;
@dynamic customerid;
@dynamic discount;
@dynamic driverRating;
@dynamic email;
@dynamic enable;
@dynamic firstName;
@dynamic fleetId;
@dynamic idField;
@dynamic isGuide;
@dynamic lastName;
@dynamic mobile;
@dynamic password;
@dynamic photo;
@dynamic rideCount;
@dynamic status;
@dynamic token;
@dynamic userName;
@dynamic userType;



/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary context:(NSManagedObjectContext *)context
{
	if(dictionary == nil || [dictionary isKindOfClass:[NSNull class]]){
		return nil;
	}
	NSEntityDescription * entityDescription = [NSEntityDescription entityForName:@"CProfile" inManagedObjectContext:context];
	self = [super initWithEntity:entityDescription insertIntoManagedObjectContext:context];

//	if(![dictionary[@"rootClass"] isKindOfClass:[NSNull class]]){
//		self.rootClass = [[RootClass alloc] initWithDictionary:dictionary[@"rootClass"] context:context];
//	}

	if(![dictionary[@"in_Out"] isKindOfClass:[NSNull class]]){
		self.inOut = dictionary[@"in_Out"];
	}

	if(![dictionary[@"city_id"] isKindOfClass:[NSNull class]]){
		self.cityId = dictionary[@"city_id"];
	}

	if(![dictionary[@"country"] isKindOfClass:[NSNull class]]){
		self.country = dictionary[@"country"];
	}

	if(![dictionary[@"creditcard_no"] isKindOfClass:[NSNull class]]){
		self.creditcardNo = dictionary[@"creditcard_no"];
	}

	if(![dictionary[@"customerid"] isKindOfClass:[NSNull class]]){
		self.customerid = dictionary[@"customerid"];
	}

	if(![dictionary[@"discount"] isKindOfClass:[NSNull class]]){
		self.discount = dictionary[@"discount"];
	}

	if(![dictionary[@"driver_rating"] isKindOfClass:[NSNull class]]){
		self.driverRating = dictionary[@"driver_rating"];
	}

	if(![dictionary[@"email"] isKindOfClass:[NSNull class]]){
		self.email = dictionary[@"email"];
	}

	if(![dictionary[@"enable"] isKindOfClass:[NSNull class]]){
		self.enable = dictionary[@"enable"];
	}

	if(![dictionary[@"first_name"] isKindOfClass:[NSNull class]]){
		self.firstName = dictionary[@"first_name"];
	}

	if(![dictionary[@"fleet_id"] isKindOfClass:[NSNull class]]){
		self.fleetId = dictionary[@"fleet_id"];
	}

	if(![dictionary[@"id"] isKindOfClass:[NSNull class]]){
		self.idField = dictionary[@"id"];
	}

	if(![dictionary[@"is_guide"] isKindOfClass:[NSNull class]]){
		self.isGuide = dictionary[@"is_guide"];
	}

	if(![dictionary[@"last_name"] isKindOfClass:[NSNull class]]){
		self.lastName = dictionary[@"last_name"];
	}

	if(![dictionary[@"mobile"] isKindOfClass:[NSNull class]]){
		self.mobile = dictionary[@"mobile"];
	}

	if(![dictionary[@"password"] isKindOfClass:[NSNull class]]){
		self.password = dictionary[@"password"];
	}

	if(![dictionary[@"photo"] isKindOfClass:[NSNull class]]){
		self.photo = dictionary[@"photo"];
	}

	if(![dictionary[@"ride_count"] isKindOfClass:[NSNull class]]){
		self.rideCount = dictionary[@"ride_count"];
	}

	if(![dictionary[@"status"] isKindOfClass:[NSNull class]]){
		self.status = dictionary[@"status"];
	}

	if(![dictionary[@"token"] isKindOfClass:[NSNull class]]){
		self.token = dictionary[@"token"];
	}

	if(![dictionary[@"user_name"] isKindOfClass:[NSNull class]]){
		self.userName = dictionary[@"user_name"];
	}

	if(![dictionary[@"user_type"] isKindOfClass:[NSNull class]]){
		self.userType = dictionary[@"user_type"];
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
	if(self.inOut != nil){
		dictionary[@"in_Out"] = self.inOut;
	}
	if(self.cityId != nil){
		dictionary[@"city_id"] = self.cityId;
	}
	if(self.country != nil){
		dictionary[@"country"] = self.country;
	}
	if(self.creditcardNo != nil){
		dictionary[@"creditcard_no"] = self.creditcardNo;
	}
	if(self.customerid != nil){
		dictionary[@"customerid"] = self.customerid;
	}
	if(self.discount != nil){
		dictionary[@"discount"] = self.discount;
	}
	if(self.driverRating != nil){
		dictionary[@"driver_rating"] = self.driverRating;
	}
	if(self.email != nil){
		dictionary[@"email"] = self.email;
	}
	if(self.enable != nil){
		dictionary[@"enable"] = self.enable;
	}
	if(self.firstName != nil){
		dictionary[@"first_name"] = self.firstName;
	}
	if(self.fleetId != nil){
		dictionary[@"fleet_id"] = self.fleetId;
	}
	if(self.idField != nil){
		dictionary[@"id"] = self.idField;
	}
	if(self.isGuide != nil){
		dictionary[@"is_guide"] = self.isGuide;
	}
	if(self.lastName != nil){
		dictionary[@"last_name"] = self.lastName;
	}
	if(self.mobile != nil){
		dictionary[@"mobile"] = self.mobile;
	}
	if(self.password != nil){
		dictionary[@"password"] = self.password;
	}
	if(self.photo != nil){
		dictionary[@"photo"] = self.photo;
	}
	if(self.rideCount != nil){
		dictionary[@"ride_count"] = self.rideCount;
	}
	if(self.status != nil){
		dictionary[@"status"] = self.status;
	}
	if(self.token != nil){
		dictionary[@"token"] = self.token;
	}
	if(self.userName != nil){
		dictionary[@"user_name"] = self.userName;
	}
	if(self.userType != nil){
		dictionary[@"user_type"] = self.userType;
	}
	return dictionary;

}


-(void)updateClientProfile:(NSDictionary *)res
{
    [self deleteAllDataProfile];
    
    NSError *error;
    
    CProfile *obj_cl = [NSEntityDescription insertNewObjectForEntityForName:entityNameCProfile inManagedObjectContext:[self getContext]];
    [self exciteLines:obj_cl dic:res[@"result"][0]];
    
    if (![[self getContext] save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }
    
    
    
    //for (int i = 0; i<[res[@"result"] count]; i++) {
        
    //}
}

-(void)exciteLines:(CProfile *)obj_dv dic:(NSDictionary *)res
{
    obj_dv.inOut = res[@"in_Out"];
    obj_dv.cityId = res[@"city_id"];
    obj_dv.country = res[@"country"];
    obj_dv.creditcardNo = res[@"creditcard_no"];
    obj_dv.customerid = res[@"customerid"];
    obj_dv.discount = res[@"discount"];
    obj_dv.driverRating = res[@"driver_rating"];
    obj_dv.email = res[@"email"];
    obj_dv.enable = res[@"enable"];
    obj_dv.firstName = res[@"first_name"];
    obj_dv.fleetId = res[@"fleet_id"];
    obj_dv.idField = res[@"id"];
    obj_dv.isGuide = res[@"is_guide"];
    obj_dv.lastName = res[@"last_name"];
    obj_dv.mobile = res[@"mobile"];
    obj_dv.password = res[@"password"];
    obj_dv.photo = res[@"photo"];
    obj_dv.rideCount = res[@"ride_count"];
    obj_dv.status = res[@"status"];
    obj_dv.token = res[@"token"];
    obj_dv.userName = res[@"user_name"];
    obj_dv.userType = res[@"user_type"];
}


-(NSMutableArray *)fetchClientProfile
{
    NSEntityDescription *entityDesc = [NSEntityDescription entityForName:entityNameCProfile
                                                  inManagedObjectContext:[self getContext]];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDesc];
    
    NSError *error;
    
    return  [(NSMutableArray *)[[self getContext] executeFetchRequest:request error:&error] mutableCopy] ;
}


-(void)deleteAllDataProfile{
    NSEntityDescription *entityDesc = [NSEntityDescription entityForName:entityNameCProfile
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
    if(contextCProfile==nil){
        contextCProfile=[kAppDelegate managedObjectContext];
    }
    return contextCProfile;
}

@end