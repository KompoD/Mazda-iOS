//
//  CPTrackingLocation.m
//  Beta Project
//
//  Created by C-Project LLC on 28.03.17.
//  Copyright © 2017 C-Project, LLC. All rights reserved.
//

#import "CPTrackingLocation.h"
#import <UIKit/UIKit.h>

#define IS_OS_8_OR_LATER [[UIDevice currentDevice].systemVersion floatValue]

@interface CPTrackingLocation () <CLLocationManagerDelegate>

@property (nonatomic, strong) void(^completionUpdate)(CLLocationManager *);

@end


@implementation CPTrackingLocation

+ (id)sharedManager {
    static id sharedMyModel = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedMyModel = [[self alloc] init];
    });
    
    return sharedMyModel;
}


- (void)monitoring:(BOOL)type withCompletionUpdate:(void (^)(CLLocationManager *manager))manager{
    
    self.completionUpdate = manager;
    
    self.isAuto = type;
    
}

#pragma mark - CLLocationManager

- (void)startMonitoringLocation {
    
    if (_anotherLocationManager) [_anotherLocationManager stopMonitoringSignificantLocationChanges];
    
    self.anotherLocationManager = [[CLLocationManager alloc]init];
    _anotherLocationManager.delegate = self;
    _anotherLocationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
    if (self.isAuto) _anotherLocationManager.activityType = CLActivityTypeOtherNavigation;
    
    if(IS_OS_8_OR_LATER)  [_anotherLocationManager requestAlwaysAuthorization];
    
    [_anotherLocationManager startMonitoringSignificantLocationChanges];
    
}

- (void)restartMonitoringLocation {
    
    [_anotherLocationManager stopMonitoringSignificantLocationChanges];
    
    if (IS_OS_8_OR_LATER)[_anotherLocationManager requestAlwaysAuthorization];
    
    [_anotherLocationManager startMonitoringSignificantLocationChanges];
    
}

- (void)stopMonitoringLocation {
    
    [_anotherLocationManager stopMonitoringSignificantLocationChanges];
    
}


#pragma mark - CLLocationManager Delegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        self.completionUpdate(manager);
        
    });
    
}

@end

