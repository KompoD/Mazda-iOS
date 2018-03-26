//
//  MAClubObject.h
//  Mazda
//
//  Created by Nikita Merkel on 20.01.17.
//  Copyright © 2017 Nikita Merkel. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MAClubObject : NSObject

@property(nonatomic) int id;
@property(strong,nonatomic) NSString *title;

-(id)install:(NSDictionary *)data;

@end
