//
//  MACarSelectTableController.m
//  Mazda
//
//  Created by Nikita Merkel on 03.04.17.
//  Copyright © 2017 Nikita Merkel. All rights reserved.
//

#import "MACarSelectTableController.h"

@interface MACarSelectTableController (){
    
    UIActivityIndicatorView *spinner;
    
    UILabel *footer_label;
    
    NSMutableArray *cars;
    
}

@end

@implementation MACarSelectTableController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    cars = [NSMutableArray new];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    spinner = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    spinner.frame = CGRectMake(0,0, self.view.frame.size.width, 50);
    [spinner startAnimating];
    
    footer_label = [[UILabel alloc] initWithFrame:spinner.bounds];
    footer_label.textAlignment = NSTextAlignmentCenter;
    footer_label.font = [UIFont systemFontOfSize:15];
    footer_label.textColor = [UIColor grayColor];
    
    self.markId ? [self getCarModel:self.markId] : [self getCarMark];
    
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return cars.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MACitySelectCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MACitySelectCell"];
    
    if (cell == nil) cell = [[MACitySelectCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"MACitySelectCell"];
    
    MACarObject *carObj = cars[indexPath.row];
    
    cell.textLabel.text = carObj.title;
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MACarObject *carObject = [cars objectAtIndex:indexPath.row];
    
    if(self.markId == 0) {
        
        if ([self.delegate respondsToSelector:@selector(didSelectMark:)]){
            
            [self.delegate didSelectMark:carObject];
            
        }
        
    } else {
        
        if ([self.delegate respondsToSelector:@selector(didSelectModel:)]){
            
            [self.delegate didSelectModel:carObject];
            
        }
        
    }
    
}

//delegate
/*- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
 
 if ([self.delegate respondsToSelector:@selector(didSelectCity:)]){
 
 [self.delegate didSelectCity:cities[indexPath.row]];
 
 [self.navigationController popViewControllerAnimated:YES];
 
 }
 
 }*/

-(void)getCarMark{
    
    self.tableView.tableFooterView = spinner;
    
    [MARequests getCarMarks:@""
                       skip:0
                      limit:10
                    success:^(NSMutableArray *items) {
                        
                        [self fillTable:items];
                        
                    } error:^(NSString *message) {
                        
                        [self.navigationController popViewControllerAnimated:YES];
                        [SVProgressHUD showErrorWithStatus:@"Не удалось получить список марок машин"];
                        
                    }];
    
}

-(void)getCarModel:(int)carModelId{
    
    self.tableView.tableFooterView = spinner;
    
    [MARequests getCarModels:carModelId
                       title:@""
                        skip:0
                       limit:10
                     success:^(NSMutableArray *items) {
                         
                         [self fillTable:items];
                         
                     } error:^(NSString *message) {
                         
                         [self.navigationController popViewControllerAnimated:YES];
                         [SVProgressHUD showErrorWithStatus:@"Не удалось получить список моделей машин"];
                         
                     }];
    
}

-(void)fillTable:(NSMutableArray *)items {
    
    for (MACarObject *object in items)
        [cars addObject:object];
    
    self.tableView.tableFooterView = nil;
    
    [self.tableView reloadData];
    
}

@end
