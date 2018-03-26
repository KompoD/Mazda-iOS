//
//  MACarYearController.m
//  Mazda
//
//  Created by Nikita Merkel on 26.04.17.
//  Copyright © 2017 Nikita Merkel. All rights reserved.
//

#import "MACarYearController.h"

@interface MACarYearController (){
    
    UIButton *done;
    
}

@end

@implementation MACarYearController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self.view action:@selector(endEditing:)]];
    
    self.carYear = [[UITextField alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2 - ((self.view.frame.size.width - 40)/2) , self.view.frame.size.height/2 - 54, self.view.frame.size.width - 40, 20)];
    self.carYear.textAlignment = NSTextAlignmentCenter;
    self.carYear.placeholder = @"Введите год выпуска машины";
    self.carYear.delegate = self;
    self.carYear.font = [UIFont systemFontOfSize:18];
    self.carYear.keyboardType = UIKeyboardTypeNumberPad;
    self.carYear.tintColor = tint_color;
    [self.carYear becomeFirstResponder];
    [self.view addSubview:self.carYear];
    
    done = [UIButton buttonWithType:UIButtonTypeCustom];
    done.frame = CGRectMake(self.view.frame.size.width/2 - 50, self.carYear.frame.origin.y + self.carYear.frame.size.height + 20, 100, 20);
    done.enabled = NO;
    [done setTitle:@"Сохранить" forState:UIControlStateNormal];
    done.titleLabel.font = [UIFont systemFontOfSize:17];
    [done setTitleColor:light_tint_color forState:UIControlStateDisabled];
    [done setTitleColor:tint_color forState:UIControlStateNormal];
    [done addTarget:self action:@selector(done) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:done];
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, .2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        
        if (self.carYear.text.length == 4) done.enabled = YES;
        else done.enabled = NO;
        
    });
    
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    return newLength <= 4;
    
    //return YES;
    
    /*if(range.length + range.location > textField.text.length) return NO;
     
     NSUInteger newLength = [textField.text length] + [string length] - range.length;
     return newLength <= 4;*/
    
}

- (void)done{
    
    if ([self.delegate respondsToSelector:@selector(didEnterYear:)]){
        
        [self.delegate didEnterYear:[[NSString stringWithFormat:@"%@", self.carYear.text] intValue]];
        
    }
    
}

@end
