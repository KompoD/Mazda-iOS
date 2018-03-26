//
//  MANavigationBar.m
//  Mazda
//
//  Created by Егор on 10.03.17.
//  Copyright © 2017 Nikita Merkel. All rights reserved.
//

#import "MANavigationBar.h"

@implementation MANavigationBar

-(id)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    if (self) [self install];
    
    return self;
    
}

-(void)install{
    
    self.translucent = NO;
    [self setBackgroundImage:[self imageFromColor:tint_color] forBarMetrics:UIBarMetricsDefault];
    self.shadowImage = [UIImage new];
    self.tintColor = [UIColor whiteColor];
    self.titleTextAttributes = @{NSFontAttributeName: [UIFont systemFontOfSize:17],
                                 NSForegroundColorAttributeName: [UIColor whiteColor]};
    
    UIBarButtonItem *navBarButtonAppearance = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[MANavigationBar class]]];
    [navBarButtonAppearance setTitleTextAttributes:@{
                                                     NSFontAttributeName:            [UIFont systemFontOfSize:0.1],
                                                     NSForegroundColorAttributeName: [UIColor clearColor] }
                                          forState:UIControlStateNormal];
    
}

-(void)updateTranslucent:(bool)translucent {
    
    if (translucent) {
        
        self.translucent = YES;
        [self setBackgroundImage:[self imageFromColor:[UIColor clearColor]] forBarMetrics:UIBarMetricsDefault];
        
    } else {
        
        self.translucent = NO;
        [self setBackgroundImage:[self imageFromColor:tint_color] forBarMetrics:UIBarMetricsDefault];
        
    }
    
}

- (UIImage *)imageFromColor:(UIColor *)color {
    
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
    
}


@end
