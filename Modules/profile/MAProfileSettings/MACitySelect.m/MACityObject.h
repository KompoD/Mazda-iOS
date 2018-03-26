//
//  MACityObject.h
//  Mazda
//
//  Created by Egor Tikhomirov on 31.03.17.
//  Copyright © 2017 Nikita Merkel. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MACityObject : NSObject

@property (nonatomic) int id;

@property (strong,nonatomic) NSString *title;

-(id)install:(NSDictionary *)data;

@end
