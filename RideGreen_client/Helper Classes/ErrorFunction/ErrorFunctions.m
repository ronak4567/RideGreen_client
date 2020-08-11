 //
//  ErrorFunctions.m
//  ridegreen
//
//  Created by Ridegreen on 24/11/2015.
//  Copyright © 2015 Ridegreen. All rights reserved.
//

#import "ErrorFunctions.h"
        
    

       
@implementation ErrorFunctions
+(BOOL)isError:(NSString *)errorString


{
    if([errorString  isEqualToString:GOT_500])
    {
        return YES;
    }
    else if([errorString  isEqualToString:NETWORK_LOST])
    {
        return YES;
    }
    else if([errorString  isEqualToString:STREAM_EXHAUSTED])
    {
        return YES;
    }
    else if([errorString  isEqualToString:TIME_OUT])
    {
        return YES;
    }else 
    {
        return NO;
    }


}
@end
