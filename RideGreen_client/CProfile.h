//
//	Result.h
//
//	Create by user on 9/2/2016
//	Copyright © 2016. All rights reserved.
//

//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

#import <CoreData/CoreData.h>
#import "AppConstant.h"
#import "AppDelegate.h"
//@class RootClass;

@interface CProfile : NSManagedObject

//@property (nonatomic, strong) RootClass * rootClass;
@property (nonatomic, strong) NSString * inOut;
@property (nonatomic, strong) NSString * cityId;
@property (nonatomic, strong) NSString * country;
@property (nonatomic, strong) NSString * creditcardNo;
@property (nonatomic, strong) NSString * customerid;
@property (nonatomic, strong) NSString * discount;
@property (nonatomic, strong) NSString * driverRating;
@property (nonatomic, strong) NSString * email;
@property (nonatomic, strong) NSString * enable;
@property (nonatomic, strong) NSString * firstName;
@property (nonatomic, strong) NSString * fleetId;
@property (nonatomic, strong) NSString * idField;
@property (nonatomic, strong) NSString * isGuide;
@property (nonatomic, strong) NSString * lastName;
@property (nonatomic, strong) NSString * mobile;
@property (nonatomic, strong) NSString * password;
@property (nonatomic, strong) NSString * photo;
@property (nonatomic, strong) NSString * rideCount;
@property (nonatomic, strong) NSString * status;
@property (nonatomic, strong) NSString * token;
@property (nonatomic, strong) NSString * userName;
@property (nonatomic, strong) NSString * userType;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary context:(NSManagedObjectContext *)context;

-(NSDictionary *)toDictionary;

-(void)updateClientProfile:(NSDictionary *)res;
-(NSMutableArray *)fetchClientProfile;
-(void)deleteAllDataProfile;

@end