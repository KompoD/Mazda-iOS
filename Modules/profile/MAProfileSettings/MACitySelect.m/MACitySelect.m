//
//  MASettingsTableController.m
//  Mazda
//
//  Created by Nikita Merkel on 02.04.17.
//  Copyright © 2017 Nikita Merkel. All rights reserved.
//

#import "MACitySelect.h"

@interface MACitySelect (){
    
    UIActivityIndicatorView *spinner;
    
    UILabel *footer_label;
    
    NSMutableArray *cities;
    
}

@end

@implementation MACitySelect

- (void)viewDidLoad {
    [super viewDidLoad];
    
    cities = [NSMutableArray new];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    spinner = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    spinner.frame = CGRectMake(0,0, self.view.frame.size.width, 50);
    [spinner startAnimating];
    
    footer_label = [[UILabel alloc] initWithFrame:spinner.bounds];
    footer_label.textAlignment = NSTextAlignmentCenter;
    footer_label.font = [UIFont systemFontOfSize:15];
    footer_label.textColor = [UIColor grayColor];
    
    [self getCities];
    
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return cities.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MACitySelectCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MACitySelectCell"];
    
    if (cell == nil) cell = [[MACitySelectCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"MACitySelectCell"];
    
    MACityObject *cityObj = cities[indexPath.row];
    
    cell.textLabel.text = cityObj.title;
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([self.delegate respondsToSelector:@selector(didSelectCity:)]){
        
        [self.delegate didSelectCity:cities[indexPath.row]];
        
        [self.navigationController popViewControllerAnimated:YES];
        
    }
    
}

-(void)getCities {
    
    self.tableView.tableFooterView = spinner;
    
    [MARequests getCities:@""
                     skip:0
                    limit:10
                  success:^(NSMutableArray *items) {
                      
                      for (int i = 0; i < items.count; i++) {
                          
                          [cities addObject:items[i]];
                          
                      }
                      
                      self.tableView.tableFooterView = nil;
                      
                      [self.tableView reloadData];
                      
                      
                  } error:^(NSString *message) {
                      
                      
                      [self.navigationController popViewControllerAnimated:YES];
                      [SVProgressHUD showErrorWithStatus:@"Не удалось получить список городов"];
                      
                  }];
    
}

@end
