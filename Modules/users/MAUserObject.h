//
//  MAUserObject.h
//  Mazda
//
//  Created by Egor Tikhomirov on 13.04.17.
//  Copyright © 2017 Nikita Merkel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MAUserCarObject.h"
#import "MALocationObject.h"

@interface MAUserObject : NSObject

@property (strong, nonatomic) MAUserCarObject *car;

@property (strong, nonatomic) MALocationObject *geo;

@property (nonatomic) int id;

@property (strong,nonatomic) NSString *nickName;

-(id)install:(NSDictionary *)data;

@end
