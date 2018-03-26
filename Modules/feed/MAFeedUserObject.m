//
//  MAFeedUserObject.m
//  Mazda
//
//  Created by Egor Tikhomirov on 30.05.17.
//  Copyright © 2017 Nikita Merkel. All rights reserved.
//

#import "MAFeedUserObject.h"

@implementation MAFeedUserObject

-(id)install:(NSDictionary *)data{
    
    if ([data[@"id"] isKindOfClass:[NSNumber class]]) self.id = [[NSString stringWithFormat:@"%@",data[@"id"]] intValue];
    
    if ([data[@"name"] isKindOfClass:[NSString class]]) self.name = [NSString stringWithFormat:@"%@",data[@"name"]];
    else self.name = @"";
    
    if ([data[@"avatar"] isKindOfClass:[NSString class]]) self.avatar = [NSString stringWithFormat:@"%@",data[@"avatar"]];
    else self.avatar = @"";
    
    return self;
    
}

@end
