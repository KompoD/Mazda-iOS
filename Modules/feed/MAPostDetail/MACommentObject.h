//
//  MASmokeComments.h
//  Mazda
//
//  Created by Егор on 10.02.17.
//  Copyright © 2017 DDSZ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MAFeedUserObject.h"

@interface MACommentObject : NSObject

@property(nonatomic) int id;
@property(nonatomic) NSDate *date;
@property(strong,nonatomic) NSString *text;
@property(strong,nonatomic) MAFeedUserObject *author;

-(id)install:(NSDictionary *)data;

@end
