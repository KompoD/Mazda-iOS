//
//  MAClubsController.m
//  Mazda
//
//  Created by Nikita Merkel on 17.01.17.
//  Copyright © 2017 Nikita Merkel. All rights reserved.
//

#import "MAClubsController.h"

@interface MAClubsController () {
    
    NSMutableArray *clubs;
    
    UIActivityIndicatorView *spinner;
    
    UILabel *footer_label;
    
    BOOL moreClubs;
    int skipClubs;
    
}

@end

@implementation MAClubsController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    moreClubs = YES;
    
    UIImageView *backImg = [[UIImageView alloc] initWithFrame:self.view.bounds];
    backImg.image = [UIImage imageNamed:@"background"];
    backImg.userInteractionEnabled = YES;
    [self.view addSubview:backImg];
    
    self.tableView = [UITableView new];
    self.tableView.frame = CGRectMake(0, self.view.frame.size.height/2 - self.view.frame.size.height/4, self.view.frame.size.width, 246);
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.tableView];
    
    spinner = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    spinner.frame = CGRectMake(0,0, self.tableView.frame.size.width, 50);
    [spinner startAnimating];
    
    footer_label = [UILabel new];
    footer_label.frame = spinner.bounds;
    footer_label.textAlignment = NSTextAlignmentCenter;
    footer_label.font = [UIFont systemFontOfSize:15];
    footer_label.textColor = [UIColor colorWithWhite:1 alpha:.8];
    
    clubs = [NSMutableArray new];
    
    [self request];
    
}

-(void)request {
    
    self.tableView.tableFooterView = spinner;
    
    [MARequests getClubs:skipClubs
                   limit:10
                 success:^(NSMutableArray *items) {
                     
                     moreClubs = NO;
                     
                     if (items.count == 0 && skipClubs == 0) {
                         
                         footer_label.text = @"Нет клубов для выбора";
                         self.tableView.tableFooterView = footer_label;
                         
                     } else {
                         
                         if(items.count == 10) moreClubs = YES;
                         
                         for (int i = 0; i < items.count; i++) [clubs addObject:items[i]];
                         
                         self.tableView.tableFooterView = nil;
                         [self.tableView reloadData];
                         
                     }
                     
                     skipClubs = (int)clubs.count;
                     
                 } error:^(NSString *message) {
                     
                     moreClubs = YES;
                     
                     footer_label.text = message;
                     self.tableView.tableFooterView = footer_label;
                     
                 }];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return clubs.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MAClubsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MAClubsCell"];
    
    if (cell == nil) cell = [[MAClubsCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"MAClubsCell"];
    
    MAClubObject *object = clubs[indexPath.row];
    
    cell.selectionStyle= UITableViewCellSelectionStyleNone;
    cell.mainLabel.text = object.title;
    
    if (clubs.count > 0 && (indexPath.row == clubs.count - 1 && moreClubs))
        [self request];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([self.delegate respondsToSelector:@selector(clubReturn:)]){
        
        [self.delegate clubReturn:clubs[indexPath.row]];
        
        [self.navigationController popViewControllerAnimated:YES];
        
    }
    
}

-(UIStatusBarStyle)preferredStatusBarStyle {
    
    return UIStatusBarStyleLightContent;
    
}

@end


@implementation MAClubsCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.mainLabel = [UILabel new];
        [self addSubview:self.mainLabel];
        
        self.separatorLine = [UIView new];
        [self addSubview:self.separatorLine];
        
    }
    
    return self;
}

-(void)layoutSubviews{
    
    [super layoutSubviews];
    
    self.backgroundColor= [UIColor clearColor];
    
    self.mainLabel.frame= CGRectMake(self.frame.size.width/2-50, 5, 100, self.frame.size.height-5);
    self.mainLabel.textAlignment = NSTextAlignmentCenter;
    self.mainLabel.font = [UIFont systemFontOfSize:13];
    self.mainLabel.textColor = [UIColor whiteColor];
    
    self.separatorLine.frame = CGRectMake(71, self.mainLabel.frame.origin.y + self.mainLabel.frame.size.height, self.frame.size.width-142, 0.5);
    self.separatorLine.backgroundColor = [UIColor colorWithRed:225/225.0f green:225/225.0f blue:225/225.0f alpha:0.5];
    
}


@end

