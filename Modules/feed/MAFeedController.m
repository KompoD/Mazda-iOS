//
//  MAFeedController.m
//  Mazda
//
//  Created by Nikita Merkel on 06.02.17.
//  Copyright © 2017 Nikita Merkel. All rights reserved.
//

#import "MAFeedController.h"

@interface MAFeedController ()

@end

@implementation MAFeedController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed:244/255.0f green:244/255.0f blue:244/255.0f alpha:1.0];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"sort"] style:UIBarButtonItemStylePlain target:self action:@selector(selectSort)];
    
    self.tableView = [[MAFeedTable alloc] initWithClubId:0];
    self.tableView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    self.tableView.feedDelegate = self;
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, self.tabBarController.tabBar.frame.size.height + self.navigationController.navigationBar.frame.size.height + 20, 0);
    self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
    [self.view addSubview:self.tableView];
    
    [self.tableView requestFeed];
    
}

-(void)selectSort {
    
    UIAlertController *view = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    view.popoverPresentationController.sourceView = self.navigationController.navigationBar;
    view.popoverPresentationController.sourceRect = self.navigationController.navigationBar.bounds;
    
    UIAlertAction *date = [UIAlertAction actionWithTitle:@"Новые"
                                                   style:UIAlertActionStyleDefault
                                                 handler:^(UIAlertAction * action) {
                                                     
                                                     self.tableView.sort = @"date";
                                                     [view dismissViewControllerAnimated:YES completion:nil];
                                                     
                                                     [self.tableView refreshFeed];
                                                     
                                                 }];
    date.enabled = ![self.tableView.sort isEqualToString:@"date"];
    [date setValue:tint_color forKey:@"titleTextColor"];
    
    UIAlertAction *likes = [UIAlertAction actionWithTitle:@"Популярные"
                                                    style:UIAlertActionStyleDefault
                                                  handler:^(UIAlertAction * action) {
                                                      
                                                      self.tableView.sort = @"likesCount";
                                                      [view dismissViewControllerAnimated:YES completion:nil];
                                                      
                                                      [self.tableView refreshFeed];
                                                      
                                                  }];
    likes.enabled = ![self.tableView.sort isEqualToString:@"likesCount"];
    [likes setValue:tint_color forKey:@"titleTextColor"];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Отмена"
                                                     style:UIAlertActionStyleCancel
                                                   handler:^(UIAlertAction * action) {
                                                       
                                                       [view dismissViewControllerAnimated:YES completion:nil];
                                                       
                                                   }];
    [cancel setValue:tint_color forKey:@"titleTextColor"];
    
    [view addAction:date];
    [view addAction:likes];
    [view addAction:cancel];
    
    [self presentViewController:view animated:YES completion:nil];
    
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    MANavigationBar *bar = (MANavigationBar *)self.navigationController.navigationBar;
    [bar updateTranslucent:NO];
    
    [self.tableView reloadData];
    
}

-(void)didSelectPost:(MAFeedObject *)postObject {
    
    MAPostDetailController *postController = [MAPostDetailController new];
    [postController setTitle:@"Запись"];
    postController.feedObject = postObject;
    
    postController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:postController animated:YES];
    
}

-(void)didSelectProfile:(int)userId {
    
    MAProfileController *profileController = [MAProfileController new];
    profileController.user_id = userId;
    
    profileController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:profileController animated:YES];
    
}

@end
