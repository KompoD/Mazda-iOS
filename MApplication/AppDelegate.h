//
//  AppDelegate.h
//  Mazda
//
//  Created by Nikita Merkel on 27.12.16.
//  Copyright © 2016 Nikita Merkel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CPTrackingLocation.h"
#import "MARequests.h"
#import "NSValue+YMKMapCoordinate.h"
#import "MALocationObject.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) NSString *notificationToken;

@property (strong, nonatomic) CPTrackingLocation *tracking;

-(void)installApplication;

-(void)showLoginScreen;

-(void)registerDevice;

@end
