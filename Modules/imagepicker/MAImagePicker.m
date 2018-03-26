//
//  MAImagePicker.m
//  Mazda
//
//  Created by Egor Tikhomirov on 01.04.17.
//  Copyright © 2017 Nikita Merkel. All rights reserved.
//

#import "MAImagePicker.h"

@interface MAImagePicker ()

@end

@implementation MAImagePicker

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.modalPresentationStyle = UIModalPresentationFullScreen;
    self.navigationBar.barTintColor = tint_color;
    self.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationBar.translucent = NO;
    self.allowsEditing = YES;
    self.navigationBar.titleTextAttributes = @{NSFontAttributeName: [UIFont systemFontOfSize:17], NSForegroundColorAttributeName: [UIColor whiteColor]};
    self.view.backgroundColor = [UIColor whiteColor];
    
}

-(UIStatusBarStyle)preferredStatusBarStyle {
    
    return UIStatusBarStyleLightContent;
    
}

@end
