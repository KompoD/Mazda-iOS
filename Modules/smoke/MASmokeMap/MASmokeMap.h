//
//  MASmokeMap.h
//  Mazda
//
//  Created by Egor Tikhomirov on 31.03.17.
//  Copyright © 2017 Nikita Merkel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YandexMapKit.h"
#import "MAGradientMap.h"
#import "MARequests.h"
#import "CPTrackingLocation.h"

@protocol MASmokeMapDelegate <NSObject>
@optional
-(void)didSelectPlace:(YMKMapCoordinate)coordinate address:(NSString *)address;
@end

@interface MASmokeMap : UIViewController <YMKMapViewDelegate>

@property (strong,nonatomic) YMKMapView *mapView;

@property (weak, nonatomic) id <MASmokeMapDelegate> delegate;

@property (nonatomic) YMKMapCoordinate userCoordinate;

@end
