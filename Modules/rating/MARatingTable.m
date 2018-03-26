//
//  MARatingTable.m
//  Mazda
//
//  Created by Nikita Merkel on 25.03.17.
//  Copyright © 2017 Nikita Merkel. All rights reserved.
//

#import "MARatingTable.h"

@implementation MARatingTable{
    
    UIActivityIndicatorView *spinner;
    
    UILabel *footer_label;
    
    UIRefreshControl *refreshControl;
    
    BOOL moreUsers;
    int skipUsers;
    
}

-(id)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    if (self)[self install];
    
    return self;
    
}

-(void)install{
    
    moreUsers = YES;
    
    self.delegate = self;
    self.dataSource = self;
    self.backgroundColor = [UIColor clearColor];
    
    self.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    spinner = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    spinner.frame = CGRectMake(0,0, self.frame.size.width, 50);
    [spinner startAnimating];
    
    refreshControl = [[UIRefreshControl alloc]init];
    [refreshControl addTarget:self action:@selector(refreshRating) forControlEvents:UIControlEventValueChanged];
    [self addSubview:refreshControl];
    
    footer_label = [[UILabel alloc] initWithFrame:spinner.bounds];
    footer_label.textAlignment = NSTextAlignmentCenter;
    footer_label.font = [UIFont systemFontOfSize:15];
    footer_label.textColor = [UIColor grayColor];
    
    self.items = [NSMutableArray new];
    
}

-(void)getRating{
    
    if(![refreshControl isRefreshing]) self.tableFooterView = spinner;
    
    moreUsers = NO;
    
    [MARequests getRating:self.isCommon
                     skip:skipUsers
                    limit:20
                  success:^(NSMutableArray *peoples) {
                      
                      if(refreshControl.isRefreshing) self.items = [NSMutableArray new];
                      
                      if (peoples.count == 0 && skipUsers == 0) {
                          
                          footer_label.text = @"Нет пользователей";
                          self.tableFooterView = footer_label;
                          
                      } else {
                          
                          if(peoples.count == 20) moreUsers = YES;
                          
                          for (int i = 0; i < peoples.count; i++) [self.items addObject:peoples[i]];
                          
                          self.tableFooterView = nil;
                          
                      }
                      
                      skipUsers = (int)self.items.count;
                      
                      [refreshControl endRefreshing];
                      [self reloadData];
                      
                  } error:^(NSString *message) {
                      
                      moreUsers = YES;
                      
                      footer_label.text = message;
                      self.tableFooterView = footer_label;
                      
                      [self.items removeAllObjects];
                      [refreshControl endRefreshing];
                      [self reloadData];
                      
                  }];
    
}

-(void)refreshRating {
    
    moreUsers = YES;
    skipUsers = 0;
    
    [self getRating];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 55;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.items.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MARatingTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MARatingTableCell"];
    
    if (cell == nil) cell = [[MARatingTableCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"MARatingTableCell"];
    
    MARatingObject *people = self.items[indexPath.row];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (people.userId == [[MAAuthData get] user_id]) cell.backgroundColor = selectUser_color;
    else cell.backgroundColor = [UIColor clearColor];
    
    cell.position.text = [NSString stringWithFormat:@"%d", people.position];
    
    [cell.avatar setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@images/%@", api_domain, people.avatar]] placeholderImage:[UIImage imageNamed:@"avatar_placeholder"]];
    
    cell.nickName.text = people.nickName;
    
    cell.smokeFrom.text = [NSString stringWithFormat:@"%d", people.smokeFrom];
    
    if (people.shift > 0) {
        cell.shiftTriangle.image = [UIImage imageNamed:@"high"];
    } else if (people.shift < 0){
        cell.shiftTriangle.image = [UIImage imageNamed:@"low"];
    } else {
        cell.shiftTriangle.image = nil;
    }
    
    if (people.shift == 0) cell.shift.text = @"";
    else cell.shift.text = [NSString stringWithFormat:@"%d", people.shift];
    
    if (self.items.count > 0 && (indexPath.row == self.items.count-1 && moreUsers))
        [self getRating];
    
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.ratingDelegate && [self.ratingDelegate respondsToSelector:@selector(didSelectUser:)]) {
        
        [self.ratingDelegate didSelectUser:self.items[indexPath.row]];
        
    }
    
}

@end


@implementation MARatingTableCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        self.position = [UILabel new];
        [self addSubview:self.position];
        
        self.avatar = [UIImageView new];
        [self addSubview:self.avatar];
        
        self.nickName = [UILabel new];
        [self addSubview:self.nickName];
        
        self.fire = [UIImageView new];
        [self addSubview:self.fire];
        
        self.smokeFrom = [UILabel new];
        [self addSubview:self.smokeFrom];
        
        self.shiftTriangle = [UIImageView new];
        [self addSubview:self.shiftTriangle];
        
        self.shift = [UILabel new];
        [self addSubview:self.shift];
        
    }
    
    return self;
}

-(void)layoutSubviews{
    
    [super layoutSubviews];
    
    self.position.frame = CGRectMake(38, self.frame.size.height/2 - 9.5, 30, 19);
    self.position.font = [UIFont systemFontOfSize:17];
    
    self.avatar.frame = CGRectMake(self.position.frame.size.width + self.position.frame.origin.x + 20, self.frame.size.height/2 - 16.5, 33, 33);
    self.avatar.clipsToBounds = YES;
    self.avatar.contentMode = UIViewContentModeScaleAspectFill;
    self.avatar.layer.cornerRadius = self.avatar.frame.size.height/2;
    
    self.shift.frame = CGRectMake(self.frame.size.width - 58, self.frame.size.height/2 - 7.5, 20, 13);
    self.shift.font = [UIFont systemFontOfSize:13];
    self.shift.textColor = [UIColor lightGrayColor];
    
    self.shiftTriangle.frame = CGRectMake(self.shift.frame.origin.x - self.shift.frame.size.width - 10, self.shift.frame.origin.y, 16, 12);
    
    self.nickName.frame = CGRectMake(self.avatar.frame.origin.x + self.avatar.frame.size.width + 15, self.avatar.frame.origin.y, self.shiftTriangle.frame.origin.x - (self.avatar.frame.origin.x + self.avatar.frame.size.width), 15);
    self.nickName.font = [UIFont systemFontOfSize:13];
    
    self.fire.frame = CGRectMake(self.nickName.frame.origin.x, self.avatar.frame.origin.y + self.avatar.frame.size.height/2, 10.25, 10);
    self.fire.image = [UIImage imageNamed:@"fire_red"];
    
    self.smokeFrom.frame = CGRectMake(self.fire.frame.origin.x + self.fire.frame.size.width + 5, self.fire.frame.origin.y, self.nickName.frame.size.width - (self.fire.frame.size.width + 5), 13);
    self.smokeFrom.font = self.nickName.font;
    self.smokeFrom.textColor = [UIColor lightGrayColor];
    
}

@end
