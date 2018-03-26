//
//  MALocationObject.h
//  Mazda
//
//  Created by Егор on 21.03.17.
//  Copyright © 2017 Nikita Merkel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSValue+YMKMapCoordinate.h"
//#import "MARequests.h"

@interface MALocationObject : NSObject

@property (strong,nonatomic) NSString *deviceId;
@property (nonatomic) YMKMapCoordinate coordinate;
@property (strong,nonatomic) NSString *placeName;

-(id)install:(NSDictionary *)data;

@end
