//
//  MAPostDetailController.h
//  Mazda
//
//  Created by Nikita Merkel on 13.02.17.
//  Copyright © 2017 Nikita Merkel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Catalog.h"
#import "MAFeedObject.h"
#import "MACommentObject.h"
#import "MARequests.h"
#import <UIButton+TouchAreaInsets.h>
#import <DateTools.h>
#import "MAProfileController.h"
#import "UIImageView+AFNetworking.h"
#import <MXSegmentedPager.h>

@interface MAPostDetailController : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextViewDelegate, MXSegmentedPagerDelegate, MXSegmentedPagerDataSource>

@property (strong, nonatomic) MAFeedObject *feedObject;
@property (strong,nonatomic) UITableView *tableView;

@end


@interface MADetailViewCell : UITableViewCell

@property(strong, nonatomic) UIImageView *avatar;
@property(strong, nonatomic) UILabel *nick;
@property(strong, nonatomic) UILabel *message;
@property(strong, nonatomic) UILabel *lastSeen;
@property(strong, nonatomic) UIView *separatorLine;

@end
