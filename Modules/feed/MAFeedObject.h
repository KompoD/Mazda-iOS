//
//  MAClubWallItemObject.h
//  Mazda
//
//  Created by Егор on 08.02.17.
//  Copyright © 2017 DDSZ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MALocationObject.h"
#import "MAFeedUserObject.h"

@interface MAFeedObject : NSObject

@property(nonatomic) int id;
@property(strong,nonatomic) NSString *photo;
@property(strong,nonatomic) NSDate *date;
@property(strong,nonatomic) NSString *text;
@property(strong,nonatomic) MALocationObject *geo;
@property(nonatomic) int likesCount;
@property(nonatomic) bool canLike;
@property(nonatomic) int commentsCount;
@property(strong,nonatomic) MAFeedUserObject *who;
@property(strong,nonatomic) MAFeedUserObject *whom;

-(id)install:(NSDictionary *)data;

@end
