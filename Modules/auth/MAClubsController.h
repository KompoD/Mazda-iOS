//
//  MAClubsController.h
//  Mazda
//
//  Created by Nikita Merkel on 17.01.17.
//  Copyright © 2017 Nikita Merkel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIButton+TouchAreaInsets.h>
#import <AFNetworking.h>
#import "MAClubObject.h"
#import "MARequests.h"

@protocol MAClubDelegate <NSObject>
@optional

-(void)clubReturn:(MAClubObject *)club;

@end


@interface MAClubsController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (retain, nonatomic) MAClubObject *club;
@property (weak, nonatomic) id <MAClubDelegate> delegate;
@property (strong,nonatomic) UITableView *tableView;

@end


@interface MAClubsCell : UITableViewCell

@property(strong, nonatomic) UILabel * mainLabel;
@property(strong, nonatomic) UIView * separatorLine;

@end
