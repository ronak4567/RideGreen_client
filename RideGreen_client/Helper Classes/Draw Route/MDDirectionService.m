//
//  MDDirectionService.m
//  MapsDirections
//
//  Created by Mano Marks on 4/8/13.
//  Copyright (c) 2013 Google. All rights reserved.
//

#import "MDDirectionService.h"

@implementation MDDirectionService{
  @private
  BOOL _sensor;
  BOOL _alternatives;
  NSURL *_directionsURL;
  NSArray *_waypoints;
}

static NSString *kMDDirectionsURL = @"http://maps.googleapis.com/maps/api/directions/json?";

- (void)setDirectionsQuery:(NSDictionary *)query withSelector:(SEL)selector
              withDelegate:(id)delegate{
  NSArray *waypoints = [query objectForKey:@"waypoints"];
  NSString *origin = [waypoints objectAtIndex:0];
  int waypointCount = (int)[waypoints count];
  int destinationPos = waypointCount -1;
  NSString *destination = [waypoints objectAtIndex:destinationPos];
  NSString *sensor = [query objectForKey:@"sensor"];
  NSMutableString *url =
  [NSMutableString stringWithFormat:@"%@&origin=%@&destination=%@&sensor=%@",
   kMDDirectionsURL,origin,destination, sensor];
  if(waypointCount>2) {
    [url appendString:@"&waypoints=optimize:true"];
    int wpCount = waypointCount-2;
    for(int i=1;i<wpCount;i++){
      [url appendString: @"|"];
      [url appendString:[waypoints objectAtIndex:i]];
    }
  }
    url = [NSMutableString stringWithString: [url
           stringByAddingPercentEscapesUsingEncoding: NSASCIIStringEncoding]];
//    url = [NSMutableString stringWithString:@"http://maps.googleapis.com/maps/api/directions/json?origin=31.372996%2C73.101954&destination=31.414592%2C73.115783&sensor=true&mode=driving&client=gme-fivestarluxurycars&signature=diNrw-AL7Ja-ARoaaDPeyY5O4z0="];
//    ////NSLog(@"url %@",url);
    
    ///Users/us14/Documents/Desktop/RideGreen/RideGreen_client/RideGreen_client/Helper Classes/Draw Route/MDDirectionService.m:64:13: PerformSelector may cause a leak because its selector is unknown
    _directionsURL = [NSURL URLWithString:url];
  [self retrieveDirections:selector withDelegate:delegate];
}
- (void)retrieveDirections:(SEL)selector withDelegate:(id)delegate{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSData* data =
        [NSData dataWithContentsOfURL:_directionsURL];
      [self fetchedData:data withSelector:selector withDelegate:delegate];
    });
}

- (void)fetchedData:(NSData *)data
       withSelector:(SEL)selector
       withDelegate:(id)delegate{
  
  NSError* error;
  NSDictionary *json = [NSJSONSerialization
                        JSONObjectWithData:data
                                   options:kNilOptions
                                     error:&error];
  [delegate performSelector:@selector(selector) withObject:json];
}

@end
