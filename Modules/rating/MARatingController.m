//
//  MARatingController.m
//  Mazda
//
//  Created by Nikita Merkel on 06.02.17.
//  Copyright © 2017 Nikita Merkel. All rights reserved.
//

#import "MARatingController.h"

@interface MARatingController () <MXSegmentedPagerDelegate, MXSegmentedPagerDataSource>{
    
    MXSegmentedPager *pagerView;
    
    MARatingTable *common;
    
    MARatingTable *club;
    
}

@end

@implementation MARatingController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    //self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"more"] style:UIBarButtonItemStylePlain target:self action:nil];
    
    //создание и добавление на экран сегмента
    pagerView = [[MXSegmentedPager alloc] initWithFrame:self.view.bounds];
    pagerView.backgroundColor = [UIColor whiteColor];
    pagerView.segmentedControl.selectedSegmentIndex = 0;
    pagerView.segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    pagerView.segmentedControl.selectionStyle = HMSegmentedControlSelectionStyleFullWidthStripe;
    pagerView.segmentedControl.selectionIndicatorColor = tint_color;
    pagerView.segmentedControl.selectionIndicatorHeight = 4;
    pagerView.segmentedControl.titleTextAttributes = @{NSFontAttributeName: [UIFont systemFontOfSize:15], NSForegroundColorAttributeName: [UIColor darkGrayColor]};
    pagerView.segmentedControl.selectedTitleTextAttributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:15], NSForegroundColorAttributeName: [UIColor darkGrayColor]};
    pagerView.segmentedControl.layer.shadowColor = [[UIColor blackColor] CGColor];
    pagerView.segmentedControl.layer.shadowOffset = CGSizeMake(1.0, 1.0);
    pagerView.segmentedControl.layer.shadowOpacity = .2;
    pagerView.segmentedControl.layer.shadowRadius = 3.0;
    pagerView.delegate = self;
    pagerView.dataSource = self;
    [self.view addSubview:pagerView];
    
    common = [[MARatingTable alloc] initWithFrame:pagerView.bounds];
    common.contentInset = UIEdgeInsetsMake(0, 0, self.tabBarController.tabBar.frame.size.height*2 + 15, 0);
    common.scrollIndicatorInsets = common.contentInset;
    common.ratingDelegate = self;
    common.isCommon = YES;
    [common getRating];
    
    club = [[MARatingTable alloc] initWithFrame:pagerView.bounds];
    club.contentInset = common.contentInset;
    club.scrollIndicatorInsets = club.contentInset;
    club.ratingDelegate = self;
    club.isCommon = NO;
    [club getRating];
    
}

//добавление названий и кол-во стобцов

-(NSString *)segmentedPager:(MXSegmentedPager *)segmentedPager titleForSectionAtIndex:(NSInteger)index{
    
    return @[@"Общий", @"Клубный"][index];
    
}

- (NSInteger)numberOfPagesInSegmentedPager:(MXSegmentedPager *)segmentedPager {
    
    return 2;
    
}

- (UIView *)segmentedPager:(MXSegmentedPager *)segmentedPager viewForPageAtIndex:(NSInteger)index {
    
    return @[common, club][index];
    
}

-(void)didSelectUser:(MARatingObject *)ratingObject {
    
    MAProfileController *profileController = [MAProfileController new];
    [profileController setTitle:@""];
    profileController.user_id = ratingObject.userId;
    
    profileController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:profileController animated:YES];
    
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
        
    MANavigationBar *bar = (MANavigationBar *)self.navigationController.navigationBar;
    [bar updateTranslucent:NO];
    
}

@end
