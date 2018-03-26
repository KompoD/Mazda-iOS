//
//  MASliderInfo.m
//  Mazda
//
//  Created by Nikita Merkel on 20.03.17.
//  Copyright © 2017 Nikita Merkel. All rights reserved.
//

#import "MASliderInfo.h"

@implementation MASliderInfo{
    
    UIImageView *background;
    
    UIButton *likeButton;
    
    UIImageView *avatar;
    
    UILabel *nickname;
    
    UILabel *fullInfo;
    
}

-(id)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    if (self)[self install];
    
    return self;
    
}

-(void)install{
    
    background = [[UIImageView alloc] initWithFrame:self.bounds];
    background.contentMode = UIViewContentModeScaleAspectFill;
    [background.layer setMasksToBounds:YES];
    [self addSubview:background];
    
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    blurEffectView.frame = self.bounds;
    blurEffectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    blurEffectView.alpha = .95;
    [background addSubview:blurEffectView];
    
    avatar = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 128, 128)];
    avatar.clipsToBounds = YES;
    avatar.contentMode = UIViewContentModeScaleAspectFill;
    avatar.layer.cornerRadius = avatar.frame.size.height/2;
    avatar.center = blurEffectView.center;
    [blurEffectView.contentView addSubview:avatar];
    
    likeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    likeButton.frame = CGRectMake(avatar.frame.origin.x + avatar.frame.size.width - 38, avatar.frame.origin.y, 38, 38);
    [self addSubview:likeButton];
    
    nickname = [[UILabel alloc] initWithFrame:CGRectMake(20, avatar.frame.origin.y + avatar.frame.size.height + 6, self.frame.size.width - 40, 22)];
    nickname.textColor = [UIColor whiteColor];
    nickname.font = [UIFont boldSystemFontOfSize:18];
    nickname.textAlignment = NSTextAlignmentCenter;
    [blurEffectView.contentView addSubview:nickname];
    
    fullInfo = [[UILabel alloc] initWithFrame:CGRectMake(20, nickname.frame.origin.y + nickname.frame.size.height, nickname.frame.size.width, 58)];
    fullInfo.textColor = [UIColor whiteColor];
    fullInfo.font = [UIFont systemFontOfSize:15];
    fullInfo.textAlignment = NSTextAlignmentCenter;
    fullInfo.numberOfLines = 2;
    [blurEffectView.contentView addSubview:fullInfo];
    
}

-(void)setInfo:(MAProfileObject *)profile{
    
    if (profile.id != [[MAAuthData get] user_id]) {
        
        [likeButton setImage:[UIImage imageNamed:@"user_like"] forState:UIControlStateNormal];
        [likeButton setImage:[UIImage imageNamed:@"user_is_like"] forState:UIControlStateSelected];
        [likeButton setSelected:!profile.canLike];
        [likeButton setTag:profile.id];
        [likeButton addTarget:self action:@selector(userLike:) forControlEvents:UIControlEventTouchDown];
        
    }
    
    if (profile.carPhotos.count == 0) [background setImage:[UIImage imageNamed:@"background"]];
    else [background setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@images/%@",api_domain,profile.carPhotos.firstObject]] placeholderImage:[UIImage imageNamed:@"background"]];
    
    if(![profile.avatar isEqualToString:@""]) [avatar setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@images/%@",api_domain,profile.avatar]] placeholderImage:[UIImage imageNamed:@"avatar_placeholder"]];
    else [avatar setImage:[UIImage imageNamed:@"avatar_placeholder"]];
    
    nickname.text = profile.nickName;
    
    fullInfo.text = profile.fullName;
    
}

-(void)userLike:(UIButton *)sender{
    
    likeButton.selected = !likeButton.selected;
    
    [MARequests likeAction:(int)sender.tag
                    isUser:YES
                      like:likeButton.selected
                   success:^{
                       
                   }
                     error:^(NSString *message) {
                         
                     }];
    
}

@end
