//
//  MAMapCalloutContent.h
//  Mazda
//
//  Created by Egor Tikhomirov on 02.04.17.
//  Copyright © 2017 Nikita Merkel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Catalog.h"
#import "YandexMapKit.h"
#import "MAUserAnnotation.h"

@protocol MAMapCalloutDelegate <NSObject>
@optional

-(void)userReturn:(MAUserAnnotation *)userAnnotation;

@end

@interface MAMapCalloutContent : UIView <YMKCalloutContentView>

@property MAUserAnnotation *annotation;
@property (weak, nonatomic) id <MAMapCalloutDelegate> delegate;

-(id)installWithAnnotation:(MAUserAnnotation *)annotation;

@end
