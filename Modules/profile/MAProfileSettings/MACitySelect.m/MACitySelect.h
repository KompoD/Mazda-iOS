//
//  MASettingsTableController.h
//  Mazda
//
//  Created by Nikita Merkel on 02.04.17.
//  Copyright © 2017 Nikita Merkel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MACitySelectCell.h"
#import "MARequests.h"
#import "MACityObject.h"

@protocol MACitiesDelegate <NSObject>
@optional
-(void)didSelectCity:(MACityObject *)title;
@end

@interface MACitySelect : UITableViewController

@property (weak, nonatomic) id <MACitiesDelegate> delegate;

@end
