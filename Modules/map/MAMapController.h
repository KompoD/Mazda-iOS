//
//  MAMapController.h
//  Mazda
//
//  Created by Nikita Merkel on 06.02.17.
//  Copyright © 2017 Nikita Merkel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <YandexMapKit/YandexMapKit.h>
#import "MARequests.h"
#import "MALocationObject.h"
#import "MAUserAnnotation.h"
#import "MAMapCalloutContent.h"
#import "UIImageView+AFNetworking.h"
#import "MASmokeController.h"
#import "MAProfileController.h"

@interface MAMapController : UIViewController <YMKMapViewDelegate, MAMapCalloutDelegate>

@end
