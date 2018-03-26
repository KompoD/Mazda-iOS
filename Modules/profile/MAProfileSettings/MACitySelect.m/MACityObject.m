//
//  MACityObject.m
//  Mazda
//
//  Created by Egor Tikhomirov on 31.03.17.
//  Copyright © 2017 Nikita Merkel. All rights reserved.
//

#import "MACityObject.h"

@implementation MACityObject

-(id)install:(NSDictionary *)data {
    
    if([data[@"id"] isKindOfClass:[NSNumber class]])
        self.id = [data[@"id"] intValue];
    
    if ([data[@"title"] isKindOfClass:[NSString class]]) self.title = [NSString stringWithFormat:@"%@",data[@"title"]];
    else self.title= @"";
    
    return self;
    
}

@end
