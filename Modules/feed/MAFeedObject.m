//
//  MAClubWallItemObject.m
//  Mazda
//
//  Created by Егор on 08.02.17.
//  Copyright © 2017 DDSZ. All rights reserved.
//

#import "MAFeedObject.h"

@implementation MAFeedObject

-(id)install:(NSDictionary *)data{
    
    if (data[@"id"]) self.id = [[NSString stringWithFormat:@"%@",data[@"id"]] intValue];
    
    if ([data[@"photo"] isKindOfClass:[NSString class]]) self.photo = [NSString stringWithFormat:@"%@",data[@"photo"]];
    else self.photo = @"";
    
    if ([data[@"date"] isKindOfClass:[NSNumber class]]) self.date = [[NSDate alloc] initWithTimeIntervalSince1970:([[NSString stringWithFormat:@"%@",data[@"date"]] doubleValue] / 1000) - 7200];
    
    if ([data[@"text"] isKindOfClass:[NSString class]]) self.text = [NSString stringWithFormat:@"%@",data[@"text"]];
    else self.text = @"";
    
    if ([data[@"geo"] isKindOfClass:[NSDictionary class]]) self.geo = [[MALocationObject new] install:data[@"geo"]];
    
    if ([data[@"like"][@"likesCount"] isKindOfClass:[NSNumber class]]) self.likesCount = [[NSString stringWithFormat:@"%@",data[@"like"][@"likesCount"]] intValue];
    
    if (data[@"like"][@"canLike"]) self.canLike = [[NSString stringWithFormat:@"%@",data[@"like"][@"canLike"]] boolValue];
    
    if ([data[@"commentsCount"] isKindOfClass:[NSNumber class]]) self.commentsCount = [[NSString stringWithFormat:@"%@",data[@"commentsCount"]] intValue];
    
    if ([data[@"who"] isKindOfClass:[NSDictionary class]]) self.who = [[MAFeedUserObject new] install:data[@"who"]];
    
    if ([data[@"whom"] isKindOfClass:[NSDictionary class]]) self.whom = [[MAFeedUserObject new] install:data[@"whom"]];
    
    return self;
    
}

@end
