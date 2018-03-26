//
//  MAUpdateMap.h
//  Mazda
//
//  Created by Egor Tikhomirov on 02.04.17.
//  Copyright © 2017 Nikita Merkel. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MAUpdateMap : NSObject

+ (id)sharedManager;

- (void)update:(id)mapView time:(NSTimeInterval)time  withCompletionUpdate:(void (^)(NSMutableArray *result))manager;

@end
