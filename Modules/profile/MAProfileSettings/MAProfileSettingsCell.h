//
//  MAProfileSettingsCell.h
//  Mazda
//
//  Created by Nikita Merkel on 31.03.17.
//  Copyright © 2017 Nikita Merkel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Catalog.h"

@interface MAProfileSettingsCell : UITableViewCell

@property(strong, nonatomic) UILabel *label;
@property(strong, nonatomic) UILabel *text;
@property(strong, nonatomic) UIImageView *arrow;
@property(strong, nonatomic) UIView *separatorLine;

@end
