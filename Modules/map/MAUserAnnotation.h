//
//  MAUserAnnotation.h
//  Mazda
//
//  Created by Egor Tikhomirov on 01.04.17.
//  Copyright © 2017 Nikita Merkel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YMKAnnotation.h"
#import "NSValue+YMKMapCoordinate.h"
#import "MAUserObject.h"

@interface MAUserAnnotation : NSObject <YMKAnnotation>

+ (id)pointAnnotation;

@property (nonatomic) MAUserObject *userObject;
@property (nonatomic, assign) YMKMapCoordinate coordinate;

@end
