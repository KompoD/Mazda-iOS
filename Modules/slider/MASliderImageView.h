//
//  MASliderImageView.h
//  Mazda
//
//  Created by Nikita Merkel on 20.03.17.
//  Copyright © 2017 Nikita Merkel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Catalog.h"
#import "MARequests.h"
#import "MAProfileObject.h"
#import "MASliderInfo.h"

@protocol MASliderImageDelegateProtocol <NSObject>
@optional
-(void)selectedFromSlider:(int)index;
@end

@interface MASliderImageView : UIView <UIScrollViewDelegate>

@property (weak, nonatomic) id <MASliderImageDelegateProtocol> delegate;

@property (strong, nonatomic) UIScrollView *scrollView;

@property (strong, nonatomic) UIPageControl *pageIndicator;

-(void)setWebImages:(MAProfileObject *)profileObject
        placeholder:(UIImage *)placeholder
         isGradient:(BOOL)isGradient;


@end
