//
//  MAClubObject.m
//  Mazda
//
//  Created by Nikita Merkel on 20.01.17.
//  Copyright © 2017 Nikita Merkel. All rights reserved.
//

#import "MAClubObject.h"

@implementation MAClubObject

-(id)install:(NSDictionary *)data{
    
    if (data[@"id"]) self.id = [[NSString stringWithFormat:@"%@",data[@"id"]] intValue];
    
    if ([data[@"title"]isKindOfClass:[NSString class]]) self.title= [NSString stringWithFormat:@"%@",data[@"title"]];
    else self.title= @"";
    
    return self;
}

@end
