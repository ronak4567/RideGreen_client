//
//	Result.h
//
//	Create by user on 5/2/2016
//	Copyright © 2016. All rights reserved.
//

//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

#import <CoreData/CoreData.h>
#import "AppConstant.h"
#import "AppDelegate.h"
//@class RootClass;

@interface CMyParking : NSManagedObject

//@property (nonatomic, strong) RootClass * rootClass;
@property (nonatomic, strong) NSString * addedFrom;
@property (nonatomic, strong) NSString * city;
@property (nonatomic, strong) NSString * clientId;
@property (nonatomic, strong) NSString * coordinate;
@property (nonatomic, strong) NSString * createdDate;
@property (nonatomic, strong) NSString * editDate;
@property (nonatomic, strong) NSString * idField;
@property (nonatomic, strong) NSString * isAvailable;
@property (nonatomic, strong) NSString * is_Deleted;
@property (nonatomic, strong) NSString * location;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * pricePerHour;
@property (nonatomic, strong) NSString * status;
@property (nonatomic, strong) NSString * usedDays;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary context:(NSManagedObjectContext *)context;

-(NSDictionary *)toDictionary;

-(void)updateClientPark:(NSDictionary *)res;
-(NSMutableArray *)fetchClientPark;
-(void)deleteAllDataPark;
-(void)deleteObjectAtIndex:(NSInteger)index;


@end