//
//  MACarObject.m
//  Mazda
//
//  Created by Nikita Merkel on 03.04.17.
//  Copyright © 2017 Nikita Merkel. All rights reserved.
//

#import "MACarObject.h"

@implementation MACarObject

-(id)install:(NSDictionary *)data {
    
    if([data[@"id"] isKindOfClass:[NSNumber class]])
        self.id = [data[@"id"] intValue];
    
    if ([data[@"title"]isKindOfClass:[NSString class]]) self.title = [NSString stringWithFormat:@"%@",data[@"title"]];
    else self.title= @"";
    
    return self;
    
}

@end
