//
//  AppDelegate.m
//  Mazda
//
//  Created by Nikita Merkel on 27.12.16.
//  Copyright © 2016 Nikita Merkel. All rights reserved.
//

#import "AppDelegate.h"
#import "Catalog.h"
#import "MASignInController.h"
#import "MASignUpController.h"
#import "MANavigation.h"
#import "MANavigationBar.h"
#import "MAClubsController.h"
#import "MAFeedController.h"
#import "MAMapController.h"
#import "MASmokeController.h"
#import "MARatingController.h"
#import "MAProfileController.h"
#import "MASignupObject.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.window makeKeyAndVisible];
    [self.window becomeFirstResponder];
    self.window.backgroundColor = [UIColor blackColor];
    
    //SVProgressHUD
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [SVProgressHUD setMaximumDismissTimeInterval:2];
    
    //Onesignal
    [OneSignal initWithLaunchOptions:launchOptions
                               appId:onesignal_key
            handleNotificationAction:^(OSNotificationOpenedResult *result) {
                
            } settings:@{kOSSettingsKeyInAppAlerts : @NO}];
    
    [OneSignal IdsAvailable:^(NSString* userId, NSString* pushToken) {
        
        self.notificationToken = [NSString stringWithFormat:@"%@",userId];
        
    }];
    
    //YandexMapKit
    [[YMKConfiguration sharedInstance] setApiKey:mapkit_key];
    
    //Tracking
    self.tracking = [CPTrackingLocation sharedManager];
    
    [self.tracking.anotherLocationManager requestAlwaysAuthorization];
    
    MALocationObject *locationObj = [MALocationObject new];
    
    [self.tracking monitoring:YES
         withCompletionUpdate:^(CLLocationManager *manager) {
             
             if(self.notificationToken &&
                [MAAuthData isAuth] &&
                !YMKMapCoordinateIsZero(manager.location.coordinate)) {
                 
                 locationObj.deviceId = self.notificationToken;
                 locationObj.coordinate = YMKMapCoordinateMake(manager.location.coordinate.latitude, manager.location.coordinate.longitude);
                 
                 [MARequests addressByCoords:locationObj.coordinate
                                     success:^(NSString *address) {
                                         
                                         locationObj.placeName = address;
                                         
                                         [MARequests updateLocation:locationObj
                                                            success:^(int count) {
                                                                
                                                                NSLog(@"trackingLocation - updated to: [%f;%f] (%@)", locationObj.coordinate.latitude, locationObj.coordinate.longitude, locationObj.placeName);
                                                                
                                                            }
                                                              error:^(NSString *message) {
                                                                  
                                                                  NSLog(@"trackingLocation - update error: %@", message);
                                                                  
                                                              }];
                                         
                                     } error:^(NSString *message) {
                                         
                                         NSLog(@"trackingLocation - address error %@", message);
                                         
                                     }];
                 
             }
             
         }];
    
    //Запуск отслеживания местоположения
    if (launchOptions[UIApplicationLaunchOptionsLocationKey] && ![[MAAuthData get] stealth]) {
        
        [self.tracking startMonitoringLocation];
        
    }
    
    //Запуск приложения
    if ([MAAuthData isAuth] && [[MAAuthData get] user_id] && [[MAAuthData get] club_id]) {
        
        NSLog(@"Token: %@",[[MAAuthData get] token]);
        [self installApplication];
        
    } else [self showLoginScreen];
    
    return YES;
    
}

-(void)showLoginScreen{
    
    self.window.rootViewController = [self navigation:[MASignInController new]];
    
}

-(void)installApplication{
    
    MAFeedController *feedController = [MAFeedController new];
    feedController.title = @"Лента";
    feedController.tabBarItem = [self itemTabBar:[UIImage imageNamed:@"m_feed"]];
    
    MAMapController *mapController = [MAMapController new];
    mapController.title = @"Локатор";
    mapController.tabBarItem = [self itemTabBar:[UIImage imageNamed:@"m_map"]];
    
    MASmokeController *smokeController = [MASmokeController new];
    smokeController.title = @"Спалить!";
    smokeController.tabBarItem = [self itemTabBar:[[UIImage imageNamed:@"m_smoke"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    MARatingController *ratingController = [MARatingController new];
    ratingController.title = @"Рейтинг";
    ratingController.tabBarItem = [self itemTabBar:[UIImage imageNamed:@"m_rating"]];
    
    MAProfileController *profileController = [MAProfileController new];
    profileController.title = @"Мой профиль";
    profileController.tabBarItem = [self itemTabBar:[UIImage imageNamed:@"m_profile"]];
    
    UITabBarController *tabBarController = [[UITabBarController alloc] init];
    tabBarController.tabBar.tintColor = tint_color;
    tabBarController.tabBar.barTintColor = [UIColor whiteColor];
    tabBarController.tabBar.translucent = NO;
    [tabBarController setViewControllers:@[[self navigation:feedController], [self navigation:mapController], [self navigation:smokeController], [self navigation:ratingController], [self navigation:profileController]]];
    
    self.window.rootViewController = tabBarController;
    
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    
    if(![[MAAuthData get] stealth]) [self.tracking startMonitoringLocation];
    
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    
    if(![[MAAuthData get] stealth]) [self.tracking restartMonitoringLocation];
    
}


- (void)applicationWillTerminate:(UIApplication *)application {
    
    if(![[MAAuthData get] stealth]) [self.tracking restartMonitoringLocation];
    
}

- (void)registerDevice {
    
    if(self.notificationToken && [MAAuthData isAuth]) {
        
        [MARequests registerDevice:self.notificationToken
                           success:^{
                               
                               NSLog(@"Device registered: %@", self.notificationToken);
                               
                           } error:^(NSString *message) {
                               
                               NSLog(@"Device registration failed: %@", message);
                               
                           }];
        
    } else {
        
        [NSTimer scheduledTimerWithTimeInterval:10
                                         target:self
                                       selector:@selector(registerDevice)
                                       userInfo:nil
                                        repeats:NO];
        
        NSLog(@"Authorization is required");
        
    }
    
}

-(UITabBarItem *)itemTabBar:(UIImage *)image{
    
    UITabBarItem *item = [UITabBarItem new];
    item.image = image;
    item.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
    
    return item;
    
}

-(MANavigation *)navigation:(id)root{
    
    MANavigation *navigation = [[MANavigation alloc] initWithNavigationBarClass:[MANavigationBar class] toolbarClass:nil];
    [navigation setViewControllers:@[root]];
    
    return navigation;
    
}

@end
