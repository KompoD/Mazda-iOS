//
//  MASliderImageView.m
//  Mazda
//
//  Created by Nikita Merkel on 20.03.17.
//  Copyright © 2017 Nikita Merkel. All rights reserved.
//

#import "MASliderImageView.h"


@implementation MASliderImageView {
    
    int count;
    
}

-(id)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, 320)];
    
    if (self){
        self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,0, frame.size.width, 320)];
        self.scrollView.pagingEnabled = YES;
        self.scrollView.bounces = NO;
        self.scrollView.delegate = self;
        self.scrollView.backgroundColor = [UIColor clearColor];
        self.scrollView.showsHorizontalScrollIndicator = NO;
        [self addSubview:self.scrollView];
        
        self.pageIndicator = [[UIPageControl  alloc] initWithFrame:CGRectMake(0, 21, frame.size.width, 40)];
        self.pageIndicator.backgroundColor = [UIColor clearColor];
        [self addSubview:self.pageIndicator];
        
    }return self;
}

-(void)setWebImages:(MAProfileObject *)profileObject
        placeholder:(UIImage *)placeholder
         isGradient:(BOOL)isGradient{
    
    NSArray *images = profileObject.carPhotos;
    
    [self.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    CGFloat xPos = self.frame.size.width;
    count = (int)images.count;
    
    MASliderInfo *firstSlide = [[MASliderInfo alloc] initWithFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, 320)];
    [firstSlide setInfo:profileObject];
    [self.scrollView addSubview:firstSlide];
    
    for (int i = 0; i < images.count; i++) {
        
        UIImageView *imageView = [UIImageView new];
        
        imageView.frame = CGRectMake(xPos, 0, self.frame.size.width, 320);
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        [imageView.layer setMasksToBounds:YES];
        imageView.tag = i;
        imageView.userInteractionEnabled = YES;
        
        [imageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@images/%@",api_domain,images[i]]] placeholderImage:placeholder];
        
        if (isGradient) {
            
            CAGradientLayer *gradient = [CAGradientLayer layer];
            gradient.frame = imageView.bounds;
            gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor colorWithWhite:0 alpha:.5] CGColor],(id)[[UIColor clearColor] CGColor], nil];
            [imageView.layer insertSublayer:gradient atIndex:0];
            
        }
        
        [self.scrollView addSubview:imageView];
        
        xPos += imageView.frame.size.width;
        
    }
    
    self.pageIndicator.numberOfPages = images.count + 1;
    self.pageIndicator.currentPage = 0;
    self.scrollView.contentSize = CGSizeMake(xPos,320);
    [self.scrollView setContentOffset:CGPointZero animated:YES];
    
    if(images.count<=0){
        
        if (!self.pageIndicator.hidden)self.pageIndicator.hidden=YES;
        
    } else if (self.pageIndicator.hidden)self.pageIndicator.hidden=NO;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat pageWidth = self.frame.size.width;
    
    float fractionalPage = self.scrollView.contentOffset.x / pageWidth;
    NSInteger page = lround(fractionalPage);
    self.pageIndicator.currentPage = page;
    
}

@end
