//
//  MAUpdateMap.m
//  Mazda
//
//  Created by Egor Tikhomirov on 02.04.17.
//  Copyright © 2017 Nikita Merkel. All rights reserved.
//

#import "MAUpdateMap.h"
#import "MARequests.h"
#import <YandexMapKit/YandexMapKit.h>

@interface MAUpdateMap ()

@property (nonatomic, strong) void(^completionUpdate)(NSMutableArray *);

@end


@implementation MAUpdateMap{
    
    NSTimeInterval interval;
    
    YMKMapView *map;
    
    MARequests *request;
    
}

+ (id)sharedManager {
    static id sharedMyModel = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedMyModel = [[self alloc] init];
    });
    
    return sharedMyModel;
}

- (void)update:(id)mapView time:(NSTimeInterval)time withCompletionUpdate:(void (^)(NSMutableArray *result))manager{
    
    map = mapView;
    
    interval = time;
    
    self.completionUpdate = manager;
    
    [self update];
    
}

-(void)update{
    
    NSLog(@"userGeoList - update");
    
    if(!YMKMapCoordinateIsZero(map.userLocation.coordinate))
        [MARequests userGeoList:5000
                         coords:map.userLocation.coordinate
                        success:^(NSMutableArray *userGeoList) {
                            
                            [NSTimer scheduledTimerWithTimeInterval:interval
                                                             target:self
                                                           selector:@selector(update)
                                                           userInfo:nil
                                                            repeats:NO];
                            
                            dispatch_async(dispatch_get_main_queue(), ^{
                                
                                self.completionUpdate(userGeoList);
                                
                            });
                            
                        } error:^(NSString *message) {
                            
                            [NSTimer scheduledTimerWithTimeInterval:30
                                                             target:self
                                                           selector:@selector(update)
                                                           userInfo:nil
                                                            repeats:NO];
                            
                        }];
    else [NSTimer scheduledTimerWithTimeInterval:10
                                          target:self
                                        selector:@selector(update)
                                        userInfo:nil
                                         repeats:NO];
    
}

@end
