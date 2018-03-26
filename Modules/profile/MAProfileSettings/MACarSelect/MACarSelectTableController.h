//
//  MACarSelectTableController.h
//  Mazda
//
//  Created by Nikita Merkel on 03.04.17.
//  Copyright © 2017 Nikita Merkel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MACitySelectCell.h"
#import "MACarObject.h"
#import "MARequests.h"

@protocol MACarSelectDelegate <NSObject>
@optional

-(void)didSelectMark:(MACarObject *)carObject;
-(void)didSelectModel:(MACarObject *)carObject;

@end


@interface MACarSelectTableController : UITableViewController

@property (nonatomic) int markId;
@property (weak, nonatomic) id <MACarSelectDelegate> delegate;

@end
