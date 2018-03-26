//
//  MAProfileObject.m
//  Mazda
//
//  Created by Nikita Merkel on 07.02.17.
//  Copyright © 2017 Nikita Merkel. All rights reserved.
//

#import "MAProfileObject.h"

@implementation MAProfileObject

-(id)install:(NSDictionary *)data{
    
    if (data[@"id"]) self.id = [[NSString stringWithFormat:@"%@",data[@"id"]] intValue];
    
    if ([data[@"nickName"] isKindOfClass:[NSString class]]) self.nickName = [NSString stringWithFormat:@"%@",data[@"nickName"]];
    else self.nickName = @"";
    
    if ([data[@"fullName"] isKindOfClass:[NSString class]]) self.fullName = [NSString stringWithFormat:@"%@",data[@"fullName"]];
    else self.fullName = @"";
    
    if ([data[@"avatar"] isKindOfClass:[NSString class]]) self.avatar = [NSString stringWithFormat:@"%@",data[@"avatar"]];
    else self.avatar = @"";
    
    self.carPhotos = [NSMutableArray new];
    
    if ([data[@"carPhotos"] isKindOfClass:[NSArray class]]){
        
        for (id url in [[data[@"carPhotos"] reverseObjectEnumerator] allObjects]) {
            
            if ([url isKindOfClass:[NSString class]]){
                
                [self.carPhotos addObject:url];
                
            }
            
        }
        
    }
    
    if (data[@"clubId"]) self.clubId = [[NSString stringWithFormat:@"%@",data[@"clubId"]] intValue];
    
    if (data[@"cityId"]) self.cityId = [[NSString stringWithFormat:@"%@",data[@"cityId"]] intValue];
    
    if (data[@"smokeTo"]) self.smokeTo = [[NSString stringWithFormat:@"%@",data[@"smokeTo"]] intValue];
    
    if (data[@"smokeFrom"]) self.smokeFrom = [[NSString stringWithFormat:@"%@",data[@"smokeFrom"]] intValue];
    
    if (data[@"liked"]) self.liked = [[NSString stringWithFormat:@"%@",data[@"liked"]] intValue];
    
    if (data[@"canLike"]) self.canLike = [data[@"canLike"] boolValue];
    
    return self;
}

@end
