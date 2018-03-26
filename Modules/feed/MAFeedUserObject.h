//
//  MAFeedUserObject.h
//  Mazda
//
//  Created by Egor Tikhomirov on 30.05.17.
//  Copyright © 2017 Nikita Merkel. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MAFeedUserObject : NSObject

@property(nonatomic) int id;
@property(strong,nonatomic) NSString *name;
@property(strong,nonatomic) NSString *avatar;

-(id)install:(NSDictionary *)data;

@end
