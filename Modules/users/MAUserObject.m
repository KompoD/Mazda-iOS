//
//  MAUserObject.m
//  Mazda
//
//  Created by Egor Tikhomirov on 13.04.17.
//  Copyright © 2017 Nikita Merkel. All rights reserved.
//

#import "MAUserObject.h"

@implementation MAUserObject

-(id)install:(NSDictionary *)data {
    
    if ([data[@"car"] isKindOfClass:[NSDictionary class]]) self.car = [[MAUserCarObject new] install:data[@"car"]];
    
    if ([data[@"geo"] isKindOfClass:[NSDictionary class]]) self.geo = [[MALocationObject new] install:data[@"geo"]];

    self.id = [data[@"id"] intValue];
    
    if ([data[@"nickName"] isKindOfClass:[NSString class]]) self.nickName = [NSString stringWithFormat:@"%@",data[@"nickName"]];
    else self.nickName = @"";
    
    return self;
    
}


@end
