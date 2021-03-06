//
//  MASmokeObject.h
//  Mazda
//
//  Created by Егор on 20.03.17.
//  Copyright © 2017 Nikita Merkel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSValue+YMKMapCoordinate.h"

@interface MASmokeObject : NSObject

@property (nonatomic) YMKMapCoordinate coordinate;
@property (strong, nonatomic) NSString *text;
@property (strong, nonatomic) NSString *photo;
@property (nonatomic) int whom_id;

@end
