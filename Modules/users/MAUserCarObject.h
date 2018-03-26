//
//  MAUserCarObject.h
//  Mazda
//
//  Created by Egor Tikhomirov on 13.04.17.
//  Copyright © 2017 Nikita Merkel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MACarObject.h"

@interface MAUserCarObject : NSObject

@property (strong, nonatomic) NSString *avatar;

@property (strong, nonatomic) MACarObject *carMark;

@property (strong, nonatomic) MACarObject *carModel;

@property (nonatomic) int modelYear;

@property (strong, nonatomic) NSString *name;

@property (strong, nonatomic) NSString *regNumber;

-(id)install:(NSDictionary *)data;

@end
