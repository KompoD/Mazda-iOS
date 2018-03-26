//
//  MASmokeMap.m
//  Mazda
//
//  Created by Egor Tikhomirov on 31.03.17.
//  Copyright © 2017 Nikita Merkel. All rights reserved.
//

#import "MASmokeMap.h"

@interface MASmokeMap () {
    
    UIView *mainView;
    
    UILabel *address_label;
    
    UIButton *select_button;
    
}

@end

@implementation MASmokeMap

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CPTrackingLocation *tracker = [CPTrackingLocation sharedManager];
    if(!tracker.anotherLocationManager) [tracker startMonitoringLocation];
    
    self.mapView = [[YMKMapView alloc] initWithFrame:self.view.frame];
    self.mapView.delegate = self;
    self.mapView.showTraffic = NO;
    [self.mapView setCenterCoordinate: (!YMKMapCoordinateIsZero(self.userCoordinate)) ? self.userCoordinate : YMKMapCoordinateMake(tracker.anotherLocationManager.location.coordinate.latitude, tracker.anotherLocationManager.location.coordinate.longitude) atZoomLevel:16 animated:YES];
    [self.view addSubview:self.mapView];
    
    mainView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    mainView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:mainView];
    [mainView setUserInteractionEnabled:NO];
    
    address_label = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width*0.05,
                                                              self.view.frame.size.height/6,
                                                              self.view.frame.size.width*0.9,0)];
    address_label.textAlignment = NSTextAlignmentCenter;
    address_label.font = [UIFont systemFontOfSize:30.0 weight:UIFontWeightLight];
    address_label.numberOfLines = 4;
    [mainView addSubview:address_label];
    
    UIImageView *pin = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"smoke_pin"]];
    pin.frame = CGRectMake(self.view.frame.size.width/2-18, self.view.frame.size.height/2-72, 36, 36);
    pin.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:pin];
    
    select_button = [UIButton buttonWithType:UIButtonTypeCustom];
    [select_button setFrame:CGRectMake(0,self.view.frame.size.height-140,mainView.frame.size.width,32)];
    [select_button setEnabled:NO];
    [select_button setTitle:@"Выбрать" forState:UIControlStateNormal];
    [select_button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [select_button setTitleColor:[UIColor colorWithWhite:0.7 alpha:0.3] forState:UIControlStateDisabled];
    [select_button.titleLabel setFont:address_label.font];
    [select_button addTarget:self action:@selector(selectAddress) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:select_button];
    
    MAGradientMap *gradientLayer = [MAGradientMap new];
    gradientLayer.frame = self.view.bounds;
    [self.mapView.layer addSublayer:gradientLayer];
    
}

#pragma mark - YMKMapViewDelegate

- (void)mapView:(YMKMapView *)mapView regionDidChangeAnimated:(BOOL)animated{
    
    [self setAddressOfGeo:mapView.centerCoordinate];
    
    
}

- (void)mapView:(YMKMapView *)mapView regionWillChangeAnimated:(BOOL)animated{
    
    [self hideInterface:YES];
    
}

#pragma mark - Interface

-(void)hideInterface:(BOOL)hidden{
    
    [UIView animateWithDuration:.3 animations:^{
        
        mainView.alpha = hidden?.0:1.0;
        select_button.enabled = hidden?NO:YES;
        
    } completion:nil];
    
}

#pragma mark - Requests

-(void)setAddressOfGeo:(YMKMapCoordinate)location{
    
    [MARequests addressByCoords:location
                        success:^(NSString *address) {
                            
                            address_label.text = address;
                            [address_label sizeToFit];
                            address_label.frame = CGRectMake(self.view.frame.size.width*0.05,
                                                             self.view.frame.size.height/10-address_label.frame.size.height/4,
                                                             self.view.frame.size.width*0.9,
                                                             address_label.frame.size.height);
                            [self hideInterface:NO];
                            
                        } error:^(NSString *message) {
                            
                            //[self hideInterface:NO];
                            //[SVProgressHUD showErrorWithStatus:@"Не удалось определить адрес"];
                            
                        }];
    
}

#pragma mark - Delegate

-(void)selectAddress {
    
    if ([self.delegate respondsToSelector:@selector(didSelectPlace:address:)]){
        
        [self.delegate didSelectPlace:self.mapView.centerCoordinate address:address_label.text];
        
        [self.navigationController popViewControllerAnimated:YES];
        
    }
    
}

@end
