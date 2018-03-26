//
//  CPTrackingLocation.h
//  Beta Project
//
//  Created by C-Project LLC on 28.03.17.
//  Copyright © 2017 C-Project, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface CPTrackingLocation : NSObject

@property (nonatomic) CLLocationManager *anotherLocationManager;

@property (nonatomic) BOOL isAuto;

+ (id)sharedManager;

- (void)monitoring:(BOOL)type withCompletionUpdate:(void (^)(CLLocationManager *manager))manager;
- (void)startMonitoringLocation;
- (void)restartMonitoringLocation;
- (void)stopMonitoringLocation;


@end
