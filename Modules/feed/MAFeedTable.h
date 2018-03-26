//
//  MAFeedTable.h
//  Mazda
//
//  Created by Nikita Merkel on 14.03.17.
//  Copyright © 2017 Nikita Merkel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Catalog.h"
#import "MARequests.h"
#import "MAFeedObject.h"
#import "MAPostDetailController.h"
#import <DateTools.h>
#import "UIImageView+AFNetworking.h"

@protocol MAFeedDelegate <NSObject>
@optional

-(void)didSelectPost:(MAFeedObject *)postObject;

-(void)didSelectProfile:(int)userId;

@end

@interface MAFeedTable : UITableView <UITableViewDelegate, UITableViewDataSource, UITextViewDelegate>

@property (nonatomic, weak) id <MAFeedDelegate> feedDelegate;
@property (strong, nonatomic) NSMutableArray *items;
@property (nonatomic) int ownerId;
@property (nonatomic) BOOL isUser;
@property (nonatomic) BOOL isFrom;
@property (nonatomic) NSString *sort;

-(id)initWithUserId:(int)userId
             isFrom:(bool)isFrom;

-(id)initWithClubId:(int)clubId;

-(void)requestFeed;

-(void)refreshFeed;

@end


@interface MAFeedTableCell : UITableViewCell

@property(strong, nonatomic) UILabel *postDate;
@property(strong, nonatomic) UILabel *postGeo;
@property(strong, nonatomic) UIImageView *postImage;
@property(strong, nonatomic) UITextView *postInfo;
@property(strong, nonatomic) UILabel *postText;
@property(strong, nonatomic) UIButton *commentButton;
@property(strong, nonatomic) UIButton *likeButton;
@property(strong, nonatomic) UIView *separatorLine;
@property(strong, nonatomic) UIActivityIndicatorView *activityIndicator;

@property(strong, nonatomic) UITapGestureRecognizer *likeTap;
@property(strong, nonatomic) UITapGestureRecognizer *cellTap;

@end
