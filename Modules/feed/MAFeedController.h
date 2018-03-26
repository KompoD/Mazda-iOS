//
//  MAFeedController.h
//  Mazda
//
//  Created by Nikita Merkel on 06.02.17.
//  Copyright © 2017 Nikita Merkel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MAFeedTable.h"

@interface MAFeedController : UIViewController <MAFeedDelegate>

@property (nonatomic) MAFeedTable *tableView;

@end
