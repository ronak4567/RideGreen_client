//
//	Result.h
//
//	Create by user on 8/2/2016
//	Copyright © 2016. All rights reserved.
//

//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

#import <CoreData/CoreData.h>
#import "AppConstant.h"
#import "AppDelegate.h"
//@class RootClass;

@interface CMyTours : NSManagedObject

//@property (nonatomic, strong) RootClass * rootClass;
@property (nonatomic, strong) NSString * clientId;
@property (nonatomic, strong) NSString * clientStatus;
@property (nonatomic, strong) NSString * driverId;
@property (nonatomic, strong) NSString * driverStatus;
@property (nonatomic, strong) NSString * firstName;
@property (nonatomic, strong) NSString * lastName;
@property (nonatomic, strong) NSString * meetupAddress;
@property (nonatomic, strong) NSString * meetupLocation;
@property (nonatomic, strong) NSString * meetupTime;
@property (nonatomic, strong) NSString * mobile;
@property (nonatomic, strong) NSString * photo;
@property (nonatomic, strong) NSString * status;
@property (nonatomic, strong) NSString * tourDate;
@property (nonatomic, strong) NSString * tourHourExpected;
@property (nonatomic, strong) NSString * tourId;
@property (nonatomic, strong) NSString * canceltour;
@property (nonatomic, strong) NSString *customerId;
@property (nonatomic, strong) NSString *tourprice;
@property (nonatomic,strong) NSString *adminphone;
@property (nonatomic,strong) NSString *drivernam;
@property (nonatomic,strong) NSString *driverphon;
@property (nonatomic,strong) NSString *refundpercentage;



-(instancetype)initWithDictionary:(NSDictionary *)dictionary context:(NSManagedObjectContext *)context;

-(NSDictionary *)toDictionary;

-(void)updateClientMyTours:(NSDictionary *)res;
-(NSMutableArray *)fetchClientMyTours;
-(void)deleteAllDataMyTours;
-(void)deleteObjectAtIndex:(NSInteger)index;


@end
