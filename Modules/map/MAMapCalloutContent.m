//
//  MAMapCalloutContent.m
//  Mazda
//
//  Created by Egor Tikhomirov on 02.04.17.
//  Copyright © 2017 Nikita Merkel. All rights reserved.
//

#import "MAMapCalloutContent.h"

@interface MAMapCalloutContent ()

@end

@implementation MAMapCalloutContent

-(id)installWithAnnotation:(MAUserAnnotation *)annotation {
    
    self.annotation = annotation;
    
    UILabel *nickName = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 17)];
    nickName.numberOfLines = 1;
    nickName.textAlignment = NSTextAlignmentCenter;
    nickName.font = [UIFont boldSystemFontOfSize:15];
    nickName.text = annotation.userObject.nickName;
    [self addSubview:nickName];
    
    UILabel *carName = [[UILabel alloc] initWithFrame:CGRectMake(0, nickName.frame.origin.y + nickName.frame.size.height, 150, 0)];
    carName.numberOfLines = 2;
    carName.lineBreakMode = NSLineBreakByWordWrapping;
    carName.textAlignment = NSTextAlignmentCenter;
    carName.font = [UIFont systemFontOfSize:15];
    carName.text = annotation.userObject.car.name;
    [carName sizeToFit];
    carName.frame = CGRectMake(0, nickName.frame.origin.y + nickName.frame.size.height, 150, carName.frame.size.height);
    [self addSubview:carName];
    
    UILabel *regNumber = [[UILabel alloc] initWithFrame:CGRectMake(0, carName.frame.origin.y + carName.frame.size.height, 150, 17)];
    regNumber.numberOfLines = 1;
    regNumber.textAlignment = NSTextAlignmentCenter;
    regNumber.font = [UIFont systemFontOfSize:15];
    regNumber.text = annotation.userObject.car.regNumber;
    [regNumber sizeToFit];
    regNumber.frame = CGRectMake(0, carName.frame.origin.y + carName.frame.size.height, 150, regNumber.frame.size.height);
    [self addSubview:regNumber];
    
    UIButton *smokeButton = [[UIButton alloc] initWithFrame:CGRectMake(0, regNumber.frame.origin.y + regNumber.frame.size.height + 10, 150, 25)];
    smokeButton.layer.cornerRadius = 5;
    [smokeButton setTitle:@"Спалить" forState:UIControlStateNormal];
    [smokeButton setBackgroundColor:tint_color];
    [smokeButton addTarget:self action:@selector(openSmoke) forControlEvents:UIControlEventTouchDown];
    [self addSubview:smokeButton];
    
    self.frame = CGRectMake(0, 0, 150, smokeButton.frame.origin.y + smokeButton.frame.size.height);
    
    return self;
    
}

-(void)openSmoke {
    
    if ([self.delegate respondsToSelector:@selector(userReturn:)]){
        
        [self.delegate userReturn:self.annotation];
        
    }
    
}

@end
