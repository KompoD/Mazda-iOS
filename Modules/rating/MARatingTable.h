//
//  MARatingTable.h
//  Mazda
//
//  Created by Nikita Merkel on 25.03.17.
//  Copyright © 2017 Nikita Merkel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MARequests.h"
#import "MAProfileController.h"

@protocol MARatingDelegate <NSObject>
@optional

-(void)didSelectUser:(MARatingObject *)ratingObject;

@end


@interface MARatingTable : UITableView <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) id <MARatingDelegate> ratingDelegate;
@property (strong, nonatomic) NSMutableArray *items;
@property (nonatomic) BOOL isCommon;

-(void)getRating;

@end


@interface MARatingTableCell : UITableViewCell

@property(strong, nonatomic) UILabel *position;
@property(strong, nonatomic) UIImageView *avatar;
@property(strong, nonatomic) UILabel *nickName;
@property(strong, nonatomic) UIImageView *fire;
@property(strong, nonatomic) UILabel *smokeFrom;
@property(strong, nonatomic) UIImageView *shiftTriangle;
@property(strong, nonatomic) UILabel *shift;

@end
