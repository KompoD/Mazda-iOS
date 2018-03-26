//
//  MAMapController.m
//  Mazda
//
//  Created by Nikita Merkel on 06.02.17.
//  Copyright © 2017 Nikita Merkel. All rights reserved.
//

#import "MAMapController.h"
#import "MAUpdateMap.h"

@interface MAMapController ()

@end

@implementation MAMapController{
    
    YMKMapView *map;
    
    MAUpdateMap *manager;
    
    BOOL isUpdated;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    manager = [MAUpdateMap sharedManager];
    
    UIActivityIndicatorView *actionView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [actionView startAnimating];
    actionView.frame = CGRectMake(self.view.frame.origin.x,
                                  self.view.frame.origin.y,
                                  self.view.frame.size.width,
                                  self.view.frame.size.height - self.navigationController.navigationBar.frame.size.height - self.tabBarController.tabBar.frame.size.height);
    [self.view addSubview:actionView];
    
    map = [[YMKMapView alloc] initWithFrame:self.view.frame];
    map.delegate = self;
    map.showsUserLocation = YES;
    map.tracksUserLocation = YES;
    map.showTraffic = NO;
    map.alpha = 0;
    [self.view addSubview:map];
    
    UIButton *minus = [UIButton buttonWithType:UIButtonTypeCustom];
    minus.frame = CGRectMake(self.view.frame.size.width - 60, self.view.frame.size.height/2 - 74, 50, 50);
    [minus setImage:[UIImage imageNamed:@"minus"] forState:UIControlStateNormal];
    minus.tag = 1;
    [minus addTarget:self action:@selector(mapButtons:) forControlEvents:UIControlEventTouchUpInside];
    [self makeShadow:minus];
    [map addSubview:minus];
    
    UIButton *plus = [UIButton buttonWithType:UIButtonTypeCustom];
    plus.frame = CGRectMake(self.view.frame.size.width - 60, minus.frame.origin.y - minus.frame.size.height - 15, 50, 50);
    [plus setImage:[UIImage imageNamed:@"plus"] forState:UIControlStateNormal];
    plus.tag = 0;
    [plus addTarget:self action:@selector(mapButtons:) forControlEvents:UIControlEventTouchUpInside];
    [self makeShadow:plus];
    [map addSubview:plus];
    
    UIButton *geo = [UIButton buttonWithType:UIButtonTypeCustom];
    geo.frame = CGRectMake(self.view.frame.size.width - 60, minus.frame.origin.y + minus.frame.size.height + 30, 50, 50);
    geo.tag = 2;
    [geo addTarget:self action:@selector(mapButtons:) forControlEvents:UIControlEventTouchUpInside];
    [geo setImage:[UIImage imageNamed:@"geo"] forState:UIControlStateNormal];
    [self makeShadow:geo];
    [map addSubview:geo];
    
}

-(void)mapView:(YMKMapView *)mapView didUpdateUserLocation:(YMKUserLocation *)userLocation{
    
    if(!YMKMapCoordinateIsZero(userLocation.location.coordinate) && !isUpdated) {
        
        isUpdated = YES;
        
        [self startUpdate];
        
    }
    
}

-(BOOL)mapViewShouldFollowUserLocation:(YMKMapView *)mapView {
    
    return YES;
    
}

-(void)startUpdate{
    
    [map setCenterCoordinate:map.userLocation.coordinate atZoomLevel:18 animated:YES];
    
    [manager update:map time:60 withCompletionUpdate:^(NSMutableArray *result) {
        
        [self clearMap];
        
        int user_id = [[MAAuthData get] user_id];
        
        for (MAUserObject *userObject in result) {
            
            if (user_id != userObject.id) {
                
                MAUserAnnotation *userAnnotation = [MAUserAnnotation pointAnnotation];
                userAnnotation.userObject = userObject;
                userAnnotation.coordinate = userObject.geo.coordinate;
                [map addAnnotation:userAnnotation];
                
            }
            
        }
        
        [UIView animateWithDuration:.5 animations:^{
            
            map.alpha = 1;
            
        }];
        
    }];
    
}

-(void)mapButtons:(UIButton *)sender{
    
    switch (sender.tag) {
        case 0:
            [map zoomIn];
            break;
            
        case 1:
            [map zoomOut];
            break;
            
        case 2:
            if (!YMKMapCoordinateIsZero(map.userLocation.coordinate)) [map setCenterCoordinate:map.userLocation.coordinate atZoomLevel:18 animated:YES];
            break;
            
        default:
            break;
    }
    
    
    
}

-(void)clearMap{
    
    for (id annotation in map.annotations) {
        
        if ([annotation isKindOfClass:[MAUserAnnotation class]]) [map removeAnnotation:annotation];
        
    }
    
}

- (YMKAnnotationView *)mapView:(YMKMapView *)mapView viewForAnnotation:(id<YMKAnnotation>)annotation {
    
    static NSString *identifier = @"pointAnnotation";
    
    if ([annotation isKindOfClass:[MAUserAnnotation class]]) {
        
        YMKPinAnnotationView *view = (YMKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        
        if (view == nil) view = [[YMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
        else [view setAnnotation:annotation];
        
        view.canShowCallout = YES;
        view.calloutOffset = CGPointZero;
        
        [self configureAnnotationView:view forAnnotation:annotation];
        
        return view;
        
    } else return nil;
    
}

- (void)configureAnnotationView:(YMKPinAnnotationView *)view forAnnotation:(MAUserAnnotation *)annotation {
    
    view.image = nil;
    
    UIImageView *avatarImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 48, 48)];
    avatarImage.layer.cornerRadius = 24;
    avatarImage.layer.masksToBounds = YES;
    if(![annotation.userObject.car.avatar isEqualToString:@""]) [avatarImage setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@images/%@", api_domain, annotation.userObject.car.avatar]] placeholderImage:[UIImage imageNamed:@"avatar_placeholder"]];
    else [avatarImage setImage:[UIImage imageNamed:@"avatar_placeholder"]];
    [view addSubview:avatarImage];
    
    view.frame = avatarImage.frame;
    
}

- (YMKCalloutView *)mapView:(YMKMapView *)mapView calloutViewForAnnotation:(id<YMKAnnotation>)annotation {
    
    if([annotation isKindOfClass:[MAUserAnnotation class]])  {
        
        NSString * calloutViewIdentifier = @"calloutView";
        YMKCalloutView * calloutView = [mapView dequeueReusableCalloutViewWithIdentifier:calloutViewIdentifier];
        
        calloutView = [[YMKCalloutView alloc] initWithReuseIdentifier:calloutViewIdentifier];
        MAMapCalloutContent *content = [[[MAMapCalloutContent alloc] init] installWithAnnotation:annotation];
        content.delegate = self;
        calloutView.contentView = content;
        
        return calloutView;
        
    } else return nil;
    
}

-(void)mapView:(YMKMapView *)mapView annotationViewCalloutTapped:(YMKAnnotationView *)view{
    
    if([view.annotation isKindOfClass:[MAUserAnnotation class]]) {
        
        MAUserAnnotation *annotation = (MAUserAnnotation *)view.annotation;
     
        MAProfileController *profileController = [MAProfileController new];
        profileController.user_id = annotation.userObject.id;
        
        profileController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:profileController animated:YES];
        
    } else [self.tabBarController setSelectedIndex:4];
    
}

-(void)userReturn:(MAUserAnnotation *)userAnnotation {
    
    MASmokeController *smokeController = [MASmokeController new];
    [smokeController setSmokeUser:userAnnotation.userObject];
    smokeController.title = @"Спалить!";
    
    smokeController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:smokeController animated:YES];
    
}

-(void)makeShadow:(UIButton *)button{
    
    button.layer.shadowColor = [[UIColor blackColor] CGColor];
    button.layer.shadowOffset = CGSizeMake(1, 1);
    button.layer.shadowOpacity = .2;
    button.layer.shadowRadius = 3.0;
    
}

-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    MANavigationBar *bar = (MANavigationBar *)self.navigationController.navigationBar;
    [bar updateTranslucent:NO];

}

@end
