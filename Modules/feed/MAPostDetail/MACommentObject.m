//
//  MASmokeComments.m
//  Mazda
//
//  Created by Егор on 10.02.17.
//  Copyright © 2017 DDSZ. All rights reserved.
//

#import "MACommentObject.h"

@implementation MACommentObject

-(id)install:(NSDictionary *)data{
    
    if (data[@"id"]) self.id = [[NSString stringWithFormat:@"%@",data[@"id"]] intValue];
    
    if ([data[@"date"] isKindOfClass:[NSNumber class]]) self.date = [[NSDate alloc] initWithTimeIntervalSince1970:([[NSString stringWithFormat:@"%@",data[@"date"]] doubleValue] / 1000) - 7200];
    
    if ([data[@"text"] isKindOfClass:[NSString class]]) self.text = [NSString stringWithFormat:@"%@",data[@"text"]];
    else self.text = @"";
    
    if ([data[@"author"] isKindOfClass:[NSDictionary class]]) self.author = [[MAFeedUserObject new] install:data[@"author"]];
    
    return self;
    
}

@end
