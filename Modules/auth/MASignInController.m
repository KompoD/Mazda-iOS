//
//  MASignInController.m
//  Mazda
//
//  Created by Nikita Merkel on 27.12.16.
//  Copyright © 2016 Nikita Merkel. All rights reserved.
//

#import "MASignInController.h"
#import "MASignUpController.h"
#import "AppDelegate.h"
#import "Catalog.h"

@interface MASignInController (){
    
    AppDelegate *appDelegate;
    
    SHSPhoneTextField *numField;
    UITextField * passField;
    UIButton * forgotPass;
    UIButton * loginButton;
    UIButton * regButton;
    UIButton * vkButton;
    UIButton * fbButton;
    UIButton * licenseButton;
    
}

@end

@implementation MASignInController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
    
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    UIImageView * backImg = [UIImageView new];
    backImg.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    backImg.image = [UIImage imageNamed:@"background"];
    backImg.userInteractionEnabled = YES;
    [self.view addSubview:backImg];
    
    TPKeyboardAvoidingScrollView * mainScroll = [TPKeyboardAvoidingScrollView new];
    mainScroll.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    mainScroll.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height);
    mainScroll.showsVerticalScrollIndicator = NO;
    [self.view addSubview:mainScroll];
    
    UIImageView * mainLogo = [UIImageView new];
    mainLogo.frame = CGRectMake(self.view.frame.size.width/2-70, 42, 140, 130);
    mainLogo.image = [UIImage imageNamed:@"fire"];
    [mainScroll addSubview:mainLogo];
    
    UILabel * mainLabel = [UILabel new];
    mainLabel.frame = CGRectMake(self.view.frame.size.width/2-75, mainLogo.frame.origin.y + mainLogo.frame.size.height + 11, 150, 32);
    mainLabel.text = @"SMOKE";
    mainLabel.textAlignment = NSTextAlignmentCenter;
    mainLabel.font = [UIFont systemFontOfSize:30];
    mainLabel.textColor = [UIColor colorWithRed:220/255.0f green:213/255.0f blue:213/255.0f alpha:1.0];
    [mainScroll addSubview:mainLabel];
    
    numField = [SHSPhoneTextField new];
    numField.frame = CGRectMake(70, mainLabel.frame.origin.y + mainLabel.frame.size.height + 25, self.view.frame.size.width - 140, 30);
    numField.delegate = self;
    numField.backgroundColor = [UIColor clearColor];
    numField.autocorrectionType = UITextAutocorrectionTypeYes;
    numField.keyboardAppearance = UIKeyboardAppearanceDark;
    numField.clearButtonMode = UITextFieldViewModeWhileEditing;
    numField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Номер телефона" attributes:@{NSForegroundColorAttributeName: light_text_color}];
    [numField.formatter setDefaultOutputPattern:@"+# (###) ###-##-##"];
    numField.tintColor = [UIColor whiteColor];
    numField.textColor = [UIColor whiteColor];
    numField.font = [UIFont systemFontOfSize:13];
    [mainScroll addSubview:numField];
    
    UIView * firstSeparator = [self separatorAdd:numField.frame.origin.x sepY:numField.frame.origin.y + numField.frame.size.height + 10 sepHeight:0.5];
    [mainScroll addSubview:firstSeparator];
    
    passField = [UITextField new];
    passField.frame = CGRectMake(numField.frame.origin.x, firstSeparator.frame.origin.y + firstSeparator.frame.size.height + 10, numField.frame.size.width, 30);
    passField.delegate = self;
    passField.backgroundColor = [UIColor clearColor];
    passField.autocorrectionType = UITextAutocorrectionTypeYes;
    passField.keyboardType = UIKeyboardTypeDefault;
    passField.keyboardAppearance = UIKeyboardAppearanceDark;
    passField.secureTextEntry = YES;
    passField.clearButtonMode = UITextFieldViewModeWhileEditing;
    passField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Пароль" attributes:@{NSForegroundColorAttributeName: light_text_color}];
    passField.tintColor = [UIColor whiteColor];
    passField.textColor = [UIColor whiteColor];
    passField.font = [UIFont systemFontOfSize:13];
    [mainScroll addSubview:passField];
    
    UIView * secondSeparator = [self separatorAdd:numField.frame.origin.x sepY:passField.frame.origin.y + numField.frame.size.height + 10 sepHeight:0.5];
    [mainScroll addSubview:secondSeparator];
    
    forgotPass = [UIButton buttonWithType:UIButtonTypeCustom];
    forgotPass.frame = CGRectMake(numField.frame.origin.x, secondSeparator.frame.origin.y + 7, numField.frame.size.width, 14);
    [forgotPass setTitle:@"Забыли пароль?" forState:UIControlStateNormal];
    [forgotPass setTitleColor: [UIColor colorWithRed:225/225.0f green:225/225.0f blue:225/225.0f alpha:0.7] forState:UIControlStateNormal];
    [forgotPass addTarget:self action:@selector(passRecovery) forControlEvents:UIControlEventTouchUpInside];
    forgotPass.titleLabel.font = [UIFont systemFontOfSize:12];
    [mainScroll addSubview:forgotPass];
    
    loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    loginButton.frame = CGRectMake(56, forgotPass.frame.origin.y + forgotPass.frame.size.height + 10, self.view.frame.size.width-112, 50);
    [loginButton setBackgroundImage:[self imageFromColor:tint_color] forState:UIControlStateNormal];
    [loginButton setBackgroundImage:[self imageFromColor:[UIColor colorWithWhite:1 alpha:.5]] forState:UIControlStateDisabled];
    [loginButton setTitle:@"ВОЙТИ" forState:UIControlStateNormal];
    [loginButton setTitleColor: [UIColor colorWithRed:225/225.0f green:225/225.0f blue:225/225.0f alpha:0.8] forState:UIControlStateNormal];
    [loginButton addTarget:self action:@selector(singin) forControlEvents:UIControlEventTouchUpInside];
    loginButton.titleLabel.font = [UIFont systemFontOfSize:13];
    loginButton.layer.cornerRadius = 25;
    loginButton.layer.masksToBounds = YES;
    loginButton.enabled = NO;
    [mainScroll addSubview:loginButton];
    
    vkButton = [UIButton buttonWithType:UIButtonTypeCustom];
    vkButton.frame = CGRectMake(self.view.frame.size.width/2 - 24, loginButton.frame.origin.y + loginButton.frame.size.height + 15, 48, 48);
    vkButton.alpha = 0.5;
    [vkButton setBackgroundImage: [UIImage imageNamed:@"logo_vk"] forState:UIControlStateNormal];
    [mainScroll addSubview:vkButton];
    
    regButton = [UIButton buttonWithType:UIButtonTypeCustom];
    regButton.frame = CGRectMake(vkButton.frame.origin.x - vkButton.frame.size.width - 10, loginButton.frame.origin.y + loginButton.frame.size.height + 15, 48, 48);
    [regButton setImage: [UIImage imageNamed:@"register"] forState:UIControlStateNormal];
    [regButton addTarget:self action:@selector(singup) forControlEvents:UIControlEventTouchUpInside];
    [mainScroll addSubview:regButton];
    
    fbButton = [UIButton buttonWithType:UIButtonTypeCustom];
    fbButton.frame = CGRectMake(vkButton.frame.origin.x + vkButton.frame.size.width + 10, loginButton.frame.origin.y + loginButton.frame.size.height + 15, 48, 48);
    fbButton.alpha = 0.5;
    [fbButton setBackgroundImage: [UIImage imageNamed:@"logo_fb"] forState:UIControlStateNormal];
    [mainScroll addSubview:fbButton];
    
    licenseButton = [UIButton buttonWithType:UIButtonTypeCustom];
    licenseButton.frame = CGRectMake(75, self.view.frame.size.height - 40, self.view.frame.size.width-150, 48);
   // [licenseButton setTitle:@"Пользовательское соглашение" forState:UIControlStateNormal];
    [licenseButton setTitleColor: [UIColor colorWithRed:225/225.0f green:225/225.0f blue:225/225.0f alpha:0.8] forState:UIControlStateNormal];
    licenseButton.titleLabel.font = [UIFont systemFontOfSize:11];
    [mainScroll addSubview:licenseButton];
    
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [(MANavigationBar *)self.navigationController.navigationBar updateTranslucent:YES];
    
}

-(UIView*)separatorAdd:(float)sepX sepY:(float)sepY sepHeight:(float)sepHeight {
    
    UIView * separatorLine = [UIView new];
    separatorLine.frame = CGRectMake(sepX, sepY, self.view.frame.size.width - 140, sepHeight);
    separatorLine.backgroundColor = [UIColor colorWithRed:225/225.0f green:225/225.0f blue:225/225.0f alpha:0.5];
    
    return separatorLine;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, .2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        
        if (numField.phoneNumber.length >= 11 && passField.text.length > 0) loginButton.enabled = YES;
        else loginButton.enabled = NO;
        
    });
    
    return YES;
    
}

-(void)singin{
    
    [self.view endEditing:YES];
    
    [SVProgressHUD show];
    
    [MARequests getToken:[NSString stringWithFormat:@"+%@",numField.phoneNumber]
                password:passField.text
                 success:^(NSString *token) {
                     
                     [MAAuthData setToken:token];
                     
                     [appDelegate registerDevice];
                     
                     [MARequests getProfile:0 success:^(MAProfileObject *profile) {
                         
                         [MAAuthData setFromProfile:profile];
                         
                         [SVProgressHUD dismiss];
                         
                         [appDelegate installApplication];
                         
                     } error:^(NSString *message) {
                         
                         [SVProgressHUD showErrorWithStatus:message];
                         
                     }];
                     
                 }error:^(NSString *message) {
                     
                     [SVProgressHUD showErrorWithStatus:message];
                     
                 }];
    
}

-(void)passRecovery{
    
    [self.view endEditing:YES];
    
    if (numField.phoneNumber.length == 0) [SVProgressHUD showInfoWithStatus:@"Необходимо указать номер"];
    
    else if (numField.phoneNumber.length == 11) {
        
        [SVProgressHUD show];
        
        [MARequests passwordRecovery:[NSString stringWithFormat:@"+%@", numField.phoneNumber]
                             success:^{
                                 
                                 [SVProgressHUD showSuccessWithStatus:[NSString stringWithFormat:@"Пароль повторно отправлен в виде СМС на номер\n%@.",numField.text]];
                                 
                             } error:^(NSString *message) {
                                 
                                 [SVProgressHUD showErrorWithStatus:message];
                                 
                             }];
        
    } else [SVProgressHUD showErrorWithStatus:@"Указан неверный номер"];
    
}

-(void)singup{
    
    [self.navigationController pushViewController:[MASignUpController new] animated:YES];
    
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

-(UIStatusBarStyle)preferredStatusBarStyle {
    
    return UIStatusBarStyleLightContent;
    
}

@end
