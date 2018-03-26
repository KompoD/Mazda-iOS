//
//  MAUsersController.m
//  Mazda
//
//  Created by Egor Tikhomirov on 31.03.17.
//  Copyright © 2017 Nikita Merkel. All rights reserved.
//

#import "MAUsersController.h"

const int limitUsers = 15;

@interface MAUsersController () {
    
    NSMutableArray *users;
    
    NSString *searchString;
    
    UIActivityIndicatorView *spinner;
    
    UILabel *footer_label;
    
    BOOL moreUsers;
    int skipUsers;
    
}

@end

@implementation MAUsersController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    users = [NSMutableArray new];
    
    searchString = @"";
    
    moreUsers = YES;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UISearchBar *searchBar = [UISearchBar new];
    searchBar.delegate = self;
    searchBar.placeholder = @"Поиск";
    searchBar.searchBarStyle = UISearchBarStyleMinimal;
    searchBar.enablesReturnKeyAutomatically = NO;
    [searchBar sizeToFit];
    self.tableView.tableHeaderView = searchBar;
    
    spinner = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    spinner.frame = CGRectMake(0,0, self.tableView.frame.size.width, 50);
    [spinner startAnimating];
    
    footer_label = [[UILabel alloc] initWithFrame:spinner.bounds];
    footer_label.textAlignment = NSTextAlignmentCenter;
    footer_label.font = [UIFont systemFontOfSize:15];
    footer_label.textColor = [UIColor grayColor];
    
    [self getUsers];
    
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return users.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MAUsersCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MAUsersCell"];
    
    if (cell == nil) cell = [[MAUsersCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"MAUsersCell"];
    
    MAUserObject *userObj = users[indexPath.row];
    
    cell.textLabel.text = userObj.nickName;
    
    if(userObj.car.avatar) [cell.imageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@images/%@", api_domain, userObj.car.avatar]] placeholderImage:[UIImage imageNamed:@"avatar_placeholder"]];
    else [cell.imageView setImage:[UIImage imageNamed:@"avatar_placeholder"]];
    
    if ((indexPath.row == users.count-1 && users.count > 0) && moreUsers)
        [self getUsers];
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([self.delegate respondsToSelector:@selector(didSelectUser:)]){
        
        [self.delegate didSelectUser:users[indexPath.row]];
        
        [self.navigationController popViewControllerAnimated:YES];
        
    }
    
}

#pragma mark - Search bar

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    [self searchAction:searchBar.text];
    
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
    [self.tableView setContentOffset:CGPointZero animated:YES];
    
}

-(void)searchAction:(NSString *)string {
    
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    
    [users removeAllObjects];
    [self.tableView reloadData];
    
    searchString = string;
    skipUsers = 0;
    moreUsers = YES;
    
    [self getUsers];
    
}

#pragma mark - Requests

-(void)getUsers {
    
    moreUsers = NO;
    
    self.tableView.tableFooterView = spinner;
    
    [MARequests userSearch:searchString
                      skip:skipUsers
                     limit:limitUsers
                   success:^(NSMutableArray *userlist) {
                       
                       if (userlist.count == 0 && skipUsers == 0) {
                           
                           footer_label.text = @"Пользователь не найден";
                           self.tableView.tableFooterView = footer_label;
                           
                       } else {
                           
                           self.tableView.tableFooterView = nil;
                           
                           if (userlist.count > 0 && skipUsers == 0) users = [NSMutableArray new];
                           
                           if (userlist.count == limitUsers) moreUsers = YES;
                           
                           for (MAUserObject *user in userlist)
                               [users addObject:user];
                           
                       }
                       
                       skipUsers = (int)users.count;
                       
                       [self.tableView reloadData];
                       
                       NSLog(@"getUsers skip=%d, more=%@", skipUsers, moreUsers ? @"YES" : @"NO");
                       
                   } error:^(NSString *message) {
                       
                       [self.navigationController popViewControllerAnimated:YES];
                       [SVProgressHUD showErrorWithStatus:@"Не удалось получить список пользователей"];
                       
                   }];
    
}

@end


@implementation MAUsersCell

-(void)layoutSubviews {
    
    self.imageView.frame = CGRectMake(10, 5, self.frame.size.height-10, self.frame.size.height-10);
    self.imageView.layer.cornerRadius = self.imageView.frame.size.height/2;
    self.imageView.clipsToBounds = YES;
    
    self.textLabel.frame = CGRectMake(self.imageView.frame.origin.x + self.imageView.frame.size.width + 20, 0, self.frame.size.width, self.frame.size.height);
    
}

@end
