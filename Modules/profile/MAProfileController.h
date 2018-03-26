//
//  MAProfileController.h
//  Mazda
//
//  Created by Nikita Merkel on 10.02.17.
//  Copyright © 2017 Nikita Merkel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+AFNetworking.h"
#import "Catalog.h"
#import <TYBlurImage/UIImage+BlurEffects.h>
#import <MXSegmentedPager.h>
#import <DZNSegmentedControl.h>
#import "MASliderImageView.h"
#import "MARequests.h"
#import "MAProfileObject.h"
#import <DateTools.h>
#import "MAFeedTable.h"
#import "MAProfileSettingsController.h"
#import "MANavigationBar.h"

@interface MAProfileController : UIViewController

@property (nonatomic) int user_id;

@end
