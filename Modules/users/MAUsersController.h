//
//  MAUsersController.h
//  Mazda
//
//  Created by Egor Tikhomirov on 31.03.17.
//  Copyright © 2017 Nikita Merkel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Catalog.h"
#import "MARequests.h"
#import "MAUserObject.h"

@protocol MAUsersDelegate <NSObject>
@optional
-(void)didSelectUser:(MAUserObject *)user;
@end

@interface MAUsersController : UITableViewController <UISearchBarDelegate>

@property (weak, nonatomic) id <MAUsersDelegate> delegate;

@end


@interface MAUsersCell : UITableViewCell

@end
