//
//  MAProfileSettingsCell.m
//  Mazda
//
//  Created by Nikita Merkel on 31.03.17.
//  Copyright © 2017 Nikita Merkel. All rights reserved.
//

#import "MAProfileSettingsCell.h"

@implementation MAProfileSettingsCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.label = [UILabel new];
        [self addSubview:self.label];
        
        self.text = [UILabel new];
        [self addSubview:self.text];
        
        self.arrow = [UIImageView new];
        [self addSubview:self.arrow];
        
        self.separatorLine = [UIView new];
        [self addSubview:self.separatorLine];
        
    }
    
    return self;
}

-(void)layoutSubviews{
    
    [super layoutSubviews];
    
    self.backgroundColor = [UIColor clearColor];
    
    self.label.frame = CGRectMake(30, 15, 120, 17);
    self.label.font = [UIFont systemFontOfSize:15];
    
    self.arrow.frame = CGRectMake(self.frame.size.width - 20, self.label.frame.origin.y + 2, 15, 15);
    self.arrow.image = [UIImage imageNamed:@"arrow"];
    
    self.text.frame = CGRectMake(self.label.frame.origin.x + self.label.frame.size.width, self.label.frame.origin.y, self.frame.size.width - (self.label.frame.origin.x + self.label.frame.size.width + self.arrow.frame.size.width + 10), self.label.frame.size.height);
    self.text.font = self.label.font;
    self.text.textAlignment = NSTextAlignmentRight;
    self.text.textColor = [UIColor grayColor];
    
    self.separatorLine.frame = CGRectMake(self.label.frame.origin.x, self.label.frame.origin.y + self.label.frame.size.height + 15, self.frame.size.width - self.label.frame.origin.x, 1);
    self.separatorLine.backgroundColor = [UIColor colorWithRed:202/225.0f green:202/225.0f blue:202/225.0f alpha:1];
    
}

@end
