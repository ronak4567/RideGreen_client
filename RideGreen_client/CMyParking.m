//
//	Result.m
//
//	Create by user on 5/2/2016
//	Copyright © 2016. All rights reserved.
//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "CMyParking.h"
//#import "RootClass.h"

@interface CMyParking ()
@end
@implementation CMyParking

NSManagedObjectContext *contextPark;
NSString* entityNamePark = @"CMyParking";

//@dynamic rootClass;
@dynamic addedFrom;
@dynamic city;
@dynamic clientId;
@dynamic coordinate;
@dynamic createdDate;
@dynamic editDate;
@dynamic idField;
@dynamic isAvailable;
@dynamic is_Deleted;
@dynamic location;
@dynamic name;
@dynamic pricePerHour;
@dynamic status;
@dynamic usedDays;



/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary context:(NSManagedObjectContext *)context
{
	if(dictionary == nil || [dictionary isKindOfClass:[NSNull class]]){
		return nil;
	}
	NSEntityDescription * entityDescription = [NSEntityDescription entityForName:@"CMyParking" inManagedObjectContext:context];
	self = [super initWithEntity:entityDescription insertIntoManagedObjectContext:context];

//	if(![dictionary[@"rootClass"] isKindOfClass:[NSNull class]]){
//		self.rootClass = [[RootClass alloc] initWithDictionary:dictionary[@"rootClass"] context:context];
//	}

	if(![dictionary[@"added_from"] isKindOfClass:[NSNull class]]){
		self.addedFrom = dictionary[@"added_from"];
	}

	if(![dictionary[@"city"] isKindOfClass:[NSNull class]]){
		self.city = dictionary[@"city"];
	}

	if(![dictionary[@"client_id"] isKindOfClass:[NSNull class]]){
		self.clientId = dictionary[@"client_id"];
	}

	if(![dictionary[@"coordinate"] isKindOfClass:[NSNull class]]){
		self.coordinate = dictionary[@"coordinate"];
	}

	if(![dictionary[@"created_date"] isKindOfClass:[NSNull class]]){
		self.createdDate = dictionary[@"created_date"];
	}

	if(![dictionary[@"edit_date"] isKindOfClass:[NSNull class]]){
		self.editDate = dictionary[@"edit_date"];
	}

	if(![dictionary[@"id"] isKindOfClass:[NSNull class]]){
		self.idField = dictionary[@"id"];
	}

	if(![dictionary[@"is_available"] isKindOfClass:[NSNull class]]){
		self.isAvailable = dictionary[@"is_available"];
	}

	if(![dictionary[@"is_deleted"] isKindOfClass:[NSNull class]]){
		self.is_Deleted = dictionary[@"is_deleted"];
	}

	if(![dictionary[@"location"] isKindOfClass:[NSNull class]]){
		self.location = dictionary[@"location"];
	}

	if(![dictionary[@"name"] isKindOfClass:[NSNull class]]){
		self.name = dictionary[@"name"];
	}

	if(![dictionary[@"price_per_hour"] isKindOfClass:[NSNull class]]){
		self.pricePerHour = dictionary[@"price_per_hour"];
	}

	if(![dictionary[@"status"] isKindOfClass:[NSNull class]]){
		self.status = dictionary[@"status"];
	}
    
    if(![dictionary[@"Used_days"] isKindOfClass:[NSNull class]]){
        self.usedDays = dictionary[@"Used_days"];
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
	if(self.addedFrom != nil){
		dictionary[@"added_from"] = self.addedFrom;
	}
	if(self.city != nil){
		dictionary[@"city"] = self.city;
	}
	if(self.clientId != nil){
		dictionary[@"client_id"] = self.clientId;
	}
	if(self.coordinate != nil){
		dictionary[@"coordinate"] = self.coordinate;
	}
	if(self.createdDate != nil){
		dictionary[@"created_date"] = self.createdDate;
	}
	if(self.editDate != nil){
		dictionary[@"edit_date"] = self.editDate;
	}
	if(self.idField != nil){
		dictionary[@"id"] = self.idField;
	}
	if(self.isAvailable != nil){
		dictionary[@"is_available"] = self.isAvailable;
	}
	if(self.is_Deleted != nil){
		dictionary[@"is_deleted"] = self.is_Deleted;
	}
	if(self.location != nil){
		dictionary[@"location"] = self.location;
	}
	if(self.name != nil){
		dictionary[@"name"] = self.name;
	}
	if(self.pricePerHour != nil){
		dictionary[@"price_per_hour"] = self.pricePerHour;
	}
	if(self.status != nil){
		dictionary[@"status"] = self.status;
	}
    if(self.usedDays != nil){
        dictionary[@"Used_days"] = self.usedDays;
    }
	return dictionary;

}


-(void)updateClientPark:(NSDictionary *)res
{
    [self deleteAllDataPark];
    
    NSError *error;
    for (int i = 0; i<[res[@"result"] count]; i++) {
        CMyParking *obj_cl = [NSEntityDescription insertNewObjectForEntityForName:entityNamePark inManagedObjectContext:[self getContext]];
        [self exciteLines:obj_cl dic:res[@"result"][i]];
        
        if (![[self getContext] save:&error]) {
            NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
        }
    }
}

-(void)exciteLines:(CMyParking *)obj_dv dic:(NSDictionary *)res
{
    obj_dv.addedFrom = res[@"added_from"];
    obj_dv.city = res[@"city"];
    obj_dv.clientId = res[@"client_id"];
    obj_dv.coordinate = res[@"coordinate"];
    obj_dv.createdDate = res[@"created_date"];
    obj_dv.editDate = res[@"edit_date"];
    obj_dv.idField = res[@"id"];
    obj_dv.isAvailable = res[@"is_available"];
    obj_dv.is_Deleted = res[@"is_deleted"];
    obj_dv.location = res[@"location"];
    obj_dv.name = res[@"name"];
    obj_dv.pricePerHour = res[@"price_per_hour"];
    obj_dv.status = res[@"status"];
    obj_dv.usedDays = res[@"Used_days"];
}


-(NSMutableArray *)fetchClientPark
{
    NSEntityDescription *entityDesc = [NSEntityDescription entityForName:entityNamePark
                                                  inManagedObjectContext:[self getContext]];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDesc];
    
    NSError *error;
    
    return  [(NSMutableArray *)[[self getContext] executeFetchRequest:request error:&error] mutableCopy] ;
}


-(void)deleteAllDataPark{
    NSEntityDescription *entityDesc = [NSEntityDescription entityForName:entityNamePark
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
    NSEntityDescription *entityDesc = [NSEntityDescription entityForName:entityNamePark
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
    if(contextPark==nil){
        contextPark=[kAppDelegate managedObjectContext];
    }
    return contextPark;
}


@end