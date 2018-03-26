//
//  MASettingsCell.m
//  Mazda
//
//  Created by Nikita Merkel on 02.04.17.
//  Copyright © 2017 Nikita Merkel. All rights reserved.
//

#import "MACitySelectCell.h"

@implementation MACitySelectCell

-(void)layoutSubviews {
    
    self.textLabel.frame = CGRectMake(30, self.frame.size.height/2 - 10, self.frame.size.width - 60, 20);
    self.textLabel.font = [UIFont systemFontOfSize:17];
    self.textLabel.textAlignment = NSTextAlignmentCenter;
    
}

@end
