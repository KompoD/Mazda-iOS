//
//  MAUserCarObject.m
//  Mazda
//
//  Created by Egor Tikhomirov on 13.04.17.
//  Copyright © 2017 Nikita Merkel. All rights reserved.
//

#import "MAUserCarObject.h"

@implementation MAUserCarObject

-(id)install:(NSDictionary *)data {
    
    if ([data[@"avatar"]isKindOfClass:[NSString class]])
        self.avatar = [NSString stringWithFormat:@"%@",data[@"avatar"]];
    else self.avatar = @"";
    
    if ([data[@"carMark"] isKindOfClass:[NSDictionary class]])
        self.carMark = [[MACarObject new] install:data[@"carMark"]];
    
    if ([data[@"carModel"] isKindOfClass:[NSDictionary class]])
        self.carModel = [[MACarObject new] install:data[@"carModel"]];
    
    if([data[@"modelYear"] isKindOfClass:[NSNumber class]])
        self.modelYear = [data[@"modelYear"] intValue];
    
    if ([data[@"name"]isKindOfClass:[NSString class]])
        self.name = [NSString stringWithFormat:@"%@",data[@"name"]];
    else self.name = @"";
    
    if ([data[@"regNumber"]isKindOfClass:[NSString class]])
        self.regNumber = [NSString stringWithFormat:@"%@",data[@"regNumber"]];
    else self.regNumber = @"";
    
    return self;
    
}

@end
