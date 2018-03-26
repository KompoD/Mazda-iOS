//
//  Catalog.h
//  Mazda
//
//  Created by Nikita Merkel on 07.02.17.
//  Copyright © 2017 Nikita Merkel. All rights reserved.
//

#ifndef Catalog_h
#define Catalog_h

#import <AFNetworking.h>
#import <UIImageView+AFNetworking.h>
#import "SVProgressHUD.h"
#import "UITextView+Placeholder.h"
#import <OneSignal/OneSignal.h>

#import "MAAuthData.h"
#import "MANavigationBar.h"

#define api_domain @"http://mapp.mazda3.ru/app/"
#define yandex_geo_domain @"http://geocode-maps.yandex.ru/1.x/"

#define mapkit_key @"BUOF3IriJnrFvS4mmV8Jc5clwHJTAL9PYvo2LiiBvy10w0GpFAhUSYCIluNXFrC0p1cOA4TvyLzsVn9Qp1Mo94Ch8Rq2PZYnlY8EnJNQi~I="

#define onesignal_key @"63686c99-9b77-4b41-b8f8-c0218f87c6ef"

#define light_text_color [UIColor colorWithRed:225/225.0f green:225/225.0f blue:225/225.0f alpha:0.5]
#define tint_color [UIColor colorWithRed:187/255.0f green:60/255.0f blue:60/255.0f alpha:1.0]
#define light_tint_color [UIColor colorWithRed:187/255.0f green:60/255.0f blue:60/255.0f alpha:.5]
#define separator_color [UIColor colorWithRed:202/255.0f green:202/255.0f blue:202/255.0f alpha:1.0]
#define light_background_color [UIColor colorWithRed:244/255.0f green:244/255.0f blue:244/255.0f alpha:1.0]
#define selectUser_color [UIColor colorWithRed:187/255.0f green:60/255.0f blue:60/255.0f alpha:0.08]
#define fill_color [UIColor colorWithRed:216/255.0f green:216/255.0f blue:216/255.0f alpha:1.0]

#endif /* Catalog_h */
