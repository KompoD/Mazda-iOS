//
//  MALocationObject.m
//  Mazda
//
//  Created by Егор on 21.03.17.
//  Copyright © 2017 Nikita Merkel. All rights reserved.
//

#import "MALocationObject.h"

@implementation MALocationObject

-(id)install:(NSDictionary *)data {
    
    if ([data[@"deviceId"] isKindOfClass:[NSString class]]) self.deviceId = [NSString stringWithFormat:@"%@",data[@"deviceId"]];
    else self.deviceId = @"";
    
    //self.coordinate = YMKMapCoordinateMake([data[@"latitude"] doubleValue], [data[@"longitude"] doubleValue]);
    //Костыль
    self.coordinate = YMKMapCoordinateMake([data[@"longitude"] doubleValue], [data[@"latitude"] doubleValue]);
    
    if ([data[@"placeName"]isKindOfClass:[NSString class]]) self.placeName = [NSString stringWithFormat:@"%@",data[@"placeName"]];
    else self.placeName = @"";
    
    return self;
    
}

@end
