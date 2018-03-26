//
//  MARatingObject.m
//  Mazda
//
//  Created by Nikita Merkel on 25.03.17.
//  Copyright © 2017 Nikita Merkel. All rights reserved.
//

#import "MARatingObject.h"

@implementation MARatingObject

-(id)install:(NSDictionary *)data{
    
    if ([data[@"avatar"]isKindOfClass:[NSString class]]) self.avatar = [NSString stringWithFormat:@"%@",data[@"avatar"]];
    
    if ([data[@"nickName"]isKindOfClass:[NSString class]]) self.nickName= [NSString stringWithFormat:@"%@",data[@"nickName"]];
    else self.nickName = @"";
    
    if(data[@"position"]) self.position = [[NSString stringWithFormat:@"%@", data[@"position"]] intValue];
    
    if(data[@"shift"]) self.shift = [[NSString stringWithFormat:@"%@", data[@"shift"]] intValue];
    
    if(data[@"smokeFrom"]) self.smokeFrom = [[NSString stringWithFormat:@"%@", data[@"smokeFrom"]] intValue];
    
    if(data[@"userId"]) self.userId = [[NSString stringWithFormat:@"%@", data[@"userId"]] intValue];
    
    return self;
}

@end
