//
//  MAProfileController.m
//  Mazda
//
//  Created by Nikita Merkel on 10.02.17.
//  Copyright © 2017 Nikita Merkel. All rights reserved.
//

#import "MAProfileController.h"
#import <AFNetworking.h>


@interface MAProfileController () <MXSegmentedPagerDelegate, MXSegmentedPagerDataSource, MAFeedDelegate>{
    
    MAProfileObject *profileObj;
    
    MASliderImageView *slider;
    
    MAFeedTable *smokeFrom;
    
    MAFeedTable *smokeTo;
    
    DZNSegmentedControl *control;
    
    MXSegmentedPager *pagerView;
    
}

@end

@implementation MAProfileController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    pagerView = [[MXSegmentedPager alloc] initWithFrame:self.view.bounds];
    pagerView.backgroundColor = [UIColor whiteColor];
    pagerView.delegate = self;
    pagerView.dataSource = self;
    [self.view addSubview:pagerView];
    
    slider = [[MASliderImageView alloc] initWithFrame:CGRectMake(0, 0, pagerView.frame.size.width, 320)];
    
    pagerView.parallaxHeader.view = slider;
    pagerView.parallaxHeader.mode = MXParallaxHeaderModeFill;
    pagerView.parallaxHeader.height = slider.frame.size.height;
    pagerView.parallaxHeader.minimumHeight = 70;
    pagerView.bounces = NO;
    
    control = [[DZNSegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"застукал", @"астукали", @"собрал лайков", nil]];
    control.frame = CGRectMake(0,0, pagerView.frame.size.width, 65);
    control.backgroundColor = [UIColor whiteColor];
    [control setTitle:@"спалил" forSegmentAtIndex:0];
    [control setTitle:@"спалили" forSegmentAtIndex:1];
    [control setTitle:@"собрал лайков" forSegmentAtIndex:2];
    control.tintColor = tint_color;
    [control setTitleColor:[UIColor darkGrayColor] forState:UIControlStateSelected];
    [control setTitleColor:[UIColor darkGrayColor] forState:UIControlStateDisabled];
    [control setEnabled:NO forSegmentAtIndex:2];
    control.selectionIndicatorHeight = 4;
    control.hairlineColor = [UIColor clearColor];
    control.autoAdjustSelectionIndicatorWidth = NO;
    control.inverseTitles = YES;
    [control addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
    [pagerView.segmentedControl addSubview:control];
    
    [self getProfile];
    
    smokeFrom = [[MAFeedTable alloc] initWithUserId:self.user_id isFrom:YES];
    smokeFrom.frame = pagerView.bounds;
    smokeFrom.feedDelegate = self;
    smokeFrom.contentInset = UIEdgeInsetsMake(0,
                                              0,
                                              self.user_id ? 0
                                              : self.tabBarController.tabBar.frame.size.height,
                                              0);
    smokeFrom.scrollIndicatorInsets = smokeFrom.contentInset;
    [smokeFrom requestFeed];
    
    smokeTo = [[MAFeedTable alloc] initWithUserId:self.user_id isFrom:NO];
    smokeTo.frame = pagerView.bounds;
    smokeTo.feedDelegate = self;
    smokeTo.contentInset = smokeFrom.contentInset;
    smokeTo.scrollIndicatorInsets = smokeTo.contentInset;
    [smokeTo requestFeed];
    
}

#pragma mark <MXSegmentedPagerDelegate>

- (CGFloat)heightForSegmentedControlInSegmentedPager:(MXSegmentedPager *)segmentedPager {
    
    return 65;
    
}

#pragma mark <MXSegmentedPagerDataSource>

- (NSInteger)numberOfPagesInSegmentedPager:(MXSegmentedPager *)segmentedPager {
    
    return 2;
    
}

- (UIView *)segmentedPager:(MXSegmentedPager *)segmentedPager viewForPageAtIndex:(NSInteger)index {
    
    return @[smokeFrom,smokeTo][index];
    
}

- (void)segmentedPager:(MXSegmentedPager *)segmentedPager didSelectViewWithIndex:(NSInteger)index{
    
    [control setSelectedSegmentIndex:index animated:YES];
    
}

#pragma mark <DZNSegmentedControl>

-(void)valueChanged:(DZNSegmentedControl *)segment {
    
    [pagerView.pager showPageAtIndex:segment.selectedSegmentIndex animated:YES];
    
}

-(void)getProfile{
    
    [MARequests getProfile:(self.user_id) ? self.user_id : [[MAAuthData get] user_id]
                   success:^(MAProfileObject *profile) {
                       
                       profileObj = profile;
                       
                       if (!self.user_id || self.user_id == [[MAAuthData get] user_id])
                           self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"more"] style:UIBarButtonItemStylePlain target:self action:@selector(openSettings)];
                       
                       [self setInfo];
                       
                   } error:^(NSString *message) {
                       
                       if(!self.user_id) {
                           
                           [self.navigationController popViewControllerAnimated:YES];
                           
                           [SVProgressHUD showErrorWithStatus:message];
                           
                       } else [self getProfile];
                       
                   }];
    
}

-(void)setInfo {
    
    [control setCount:[NSNumber numberWithInt:profileObj.smokeFrom] forSegmentAtIndex:0];
    [control setCount:[NSNumber numberWithInt:profileObj.smokeTo] forSegmentAtIndex:1];
    [control setCount:[NSNumber numberWithInt:profileObj.liked] forSegmentAtIndex:2];
    
    [slider setWebImages:profileObj
             placeholder:[UIImage imageNamed:@"background"]
              isGradient:NO];
    
}

-(void)didSelectPost:(MAFeedObject *)postObject {
    
    MAPostDetailController *postController = [MAPostDetailController new];
    [postController setTitle:@"Запись"];
    postController.feedObject = postObject;
    
    postController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:postController animated:YES];
    
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    MANavigationBar *bar = (MANavigationBar *)self.navigationController.navigationBar;
    [bar updateTranslucent:YES];
    
    [self setInfo];
    
    [smokeTo reloadData];
    [smokeFrom reloadData];
    
}

-(void)openSettings{
    
    MAProfileSettingsController *settingsController = [MAProfileSettingsController new];
    settingsController.title = @"Настройки";
    settingsController.profileObj = profileObj;
    
    settingsController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:settingsController animated:YES];
    
}

-(void)didSelectProfile:(int)userId {
    
    MAProfileController *profileController = [MAProfileController new];
    profileController.user_id = userId;
    
    profileController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:profileController animated:YES];
    
}

@end
