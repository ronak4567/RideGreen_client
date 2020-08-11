//
//	Result.h
//
//	Create by user on 12/2/2016
//	Copyright © 2016. All rights reserved.
//

//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

#import <CoreData/CoreData.h>
#import "AppConstant.h"
#import "AppDelegate.h"
//@class RootClass;

@interface CMyRequested : NSManagedObject

//@property (nonatomic, strong) RootClass * rootClass;
@property (nonatomic, strong) NSString * beds;
@property (nonatomic, strong) NSString * checkinDate;
@property (nonatomic, strong) NSString * checkoutDate;
@property (nonatomic, strong) NSString * cityId;
@property (nonatomic, strong) NSString * clientAddress;
@property (nonatomic, strong) NSString * createdon;
@property (nonatomic, strong) NSString * customerid;
@property (nonatomic, strong) NSString * firstName;
@property (nonatomic, strong) NSString * idField;
@property (nonatomic, strong) NSString * isCheckIn;
@property (nonatomic, strong) NSString * isCheckOut;
@property (nonatomic, strong) NSString * lastName;
@property (nonatomic, strong) NSString * mobile;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * noOfDays;
@property (nonatomic, strong) NSString * paymentOption;
@property (nonatomic, strong) NSString * paymentStatus;
@property (nonatomic, strong) NSString * phone;
@property (nonatomic, strong) NSString * photo;
@property (nonatomic, strong) NSString * ratePerMonth;
@property (nonatomic, strong) NSString * rentedDate;
@property (nonatomic, strong) NSString * rentedStatus;
@property (nonatomic, strong) NSString * renterId;
@property (nonatomic, strong) NSString * requestedDate;
@property (nonatomic, strong) NSString * roomAddress;
@property (nonatomic, strong) NSString * roomImage;
@property (nonatomic, strong) NSString * roomType;
@property (nonatomic, strong) NSString * rooms;
@property (nonatomic, strong) NSString * stateId;
@property (nonatomic, strong) NSString * status;
@property (nonatomic, strong) NSString * totalPayment;
@property (nonatomic, strong) NSString * userId;
@property (nonatomic, strong) NSString * tempCheckinDate;
@property (nonatomic, strong) NSString * bookingId;
@property (nonatomic, strong) NSString * cancelRoom;
@property (nonatomic, strong) NSString * taxRate;
@property (nonatomic,strong) NSString *roomrating;
@property (nonatomic,strong) NSString *adminphone;
@property (nonatomic,strong) NSString *clientrating;
@property (nonatomic,strong) NSString *refundpercentage;



-(instancetype)initWithDictionary:(NSDictionary *)dictionary context:(NSManagedObjectContext *)context;

-(NSDictionary *)toDictionary;

-(void)updateClientRequested:(NSDictionary *)res;
-(NSMutableArray *)fetchClientRequested;
-(void)deleteAllDataRequested;
-(void)deleteDataAtIndex:(NSInteger)index;

@end