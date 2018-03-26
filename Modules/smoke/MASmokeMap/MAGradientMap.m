//
//  MAGradientMap.h
//  Mazda
//
//  Created by Egor Tikhomirov on 31.03.17.
//  Copyright © 2017 Nikita Merkel. All rights reserved.
//

#import "MAGradientMap.h"

@implementation MAGradientMap

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setNeedsDisplay];
    }
    return self;
}

- (void)drawInContext:(CGContextRef)ctx
{
    
    size_t gradLocationsNum = 2;
    CGFloat gradLocations[2] = {0.0f, 1.0f};
    CGFloat gradColors[8] = {255.0f / 255.0f, 255.0f / 255.0f, 255.0f / 255.0f, 0.0f, 255.0f / 255.0f, 255.0f / 255.0f, 255.0f / 255.0f, 0.9f};
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace, gradColors, gradLocations, gradLocationsNum);
    CGColorSpaceRelease(colorSpace);
    
    CGPoint gradCenter= CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    float gradRadius = MIN(self.bounds.size.width , self.bounds.size.height) ;
    
    CGContextDrawRadialGradient (ctx, gradient, gradCenter, 0, gradCenter, gradRadius, kCGGradientDrawsAfterEndLocation);
    
    CGGradientRelease(gradient);
    
}
@end
