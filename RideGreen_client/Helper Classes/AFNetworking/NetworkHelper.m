//
//  NetworkHelper.m
//  PavelProject
//
//  Created by Shabir on 4/29/13.
//  Copyright (c) 2013 WellDoneApps. All rights reserved.
//

#import "NetworkHelper.h"



@implementation NetworkHelper

#pragma mark -Singelton Method
+(NetworkHelper*)sharedInstance{
    static NetworkHelper *sharedInstance=nil;
    
    static dispatch_once_t oncePredicate;
    
    
    dispatch_once(&oncePredicate, ^{
        sharedInstance=[[self alloc]initWithBaseURL:[NSURL URLWithString:kAPIHost]];
    });
    return sharedInstance;
}

#pragma mark - init

-(NetworkHelper*)init{
    self=[super init];
    
    if(self!=nil){
        [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
        [self setDefaultHeader:@"Accept" value:@"application/json"];
    }
    return self;
}

-(void)commandWithParams:(NSMutableDictionary *)params onCompletion:(JSONResponseBlock)completionBlock{
    NSData *uploadFile=nil;
    if([params objectForKey:@"file"]){
        uploadFile=(NSData*)[params objectForKey:@"file"];
        [params removeObjectForKey:@"file"];
    }
    
    NSMutableURLRequest *apiRequest=[self multipartFormRequestWithMethod:@"POST" path:kAPIPath parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        if(uploadFile){
            [formData appendPartWithFileData:uploadFile name:@"file" fileName:@"photo.jpg" mimeType:@"image/jpeg"];
        }
    }];
    AFJSONRequestOperation *operation=[[AFJSONRequestOperation alloc]initWithRequest:apiRequest];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        completionBlock(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completionBlock([NSDictionary dictionaryWithObject:[error localizedDescription] forKey:@"error"]);
    }];
    [operation start];
}
@end
