//
//  MASignUpController.m
//  Mazda
//
//  Created by Nikita Merkel on 29.12.16.
//  Copyright © 2016 Nikita Merkel. All rights reserved.
//

#import "MASignUpController.h"

@interface MASignUpController () <MAClubDelegate>{
    
    SHSPhoneTextField *numField;
    UITextField * nickField;
    UITextField * nameField;
    UIButton * clubButton;
    UIImageView * arrowButton;
    UIButton * regButton;
    UIButton * licenseButton;
    
    MASignUpObject *object;
    
}

@end

@implementation MASignUpController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
    
    object = [MASignUpObject new];
    
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
    [numField.formatter setDefaultOutputPattern:@"+# (###) ###-##-##"];
    numField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Номер телефона" attributes:@{NSForegroundColorAttributeName: light_text_color}];
    numField.tintColor = [UIColor whiteColor];
    numField.textColor = [UIColor whiteColor];
    numField.font = [UIFont systemFontOfSize:13];
    [mainScroll addSubview:numField];
    
    UIView * firstSeparator = [self separatorAdd:numField.frame.origin.x sepY:numField.frame.origin.y + numField.frame.size.height + 10 sepHeight:0.5];
    [mainScroll addSubview:firstSeparator];
    
    nickField = [UITextField new];
    nickField.frame = CGRectMake(numField.frame.origin.x, firstSeparator.frame.origin.y + firstSeparator.frame.size.height + 10, numField.frame.size.width, 30);
    nickField.delegate = self;
    nickField.backgroundColor = [UIColor clearColor];
    nickField.autocorrectionType = UITextAutocorrectionTypeYes;
    nickField.keyboardType = UIKeyboardTypeDefault;
    nickField.keyboardAppearance = UIKeyboardAppearanceDark;
    nickField.clearButtonMode = UITextFieldViewModeWhileEditing;
    nickField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Никнейм" attributes:@{NSForegroundColorAttributeName: light_text_color}];
    nickField.tintColor = [UIColor whiteColor];
    nickField.textColor = [UIColor whiteColor];
    nickField.font = [UIFont systemFontOfSize:13];
    [mainScroll addSubview:nickField];
    
    UIView * secondSeparator = [self separatorAdd:numField.frame.origin.x sepY:nickField.frame.origin.y + nickField.frame.size.height + 10 sepHeight:0.5];
    [mainScroll addSubview:secondSeparator];
    
    nameField = [UITextField new];
    nameField.frame = CGRectMake(numField.frame.origin.x, secondSeparator.frame.origin.y + secondSeparator.frame.size.height + 10, numField.frame.size.width, 30);
    nameField.delegate = self;
    nameField.backgroundColor = [UIColor clearColor];
    nameField.autocorrectionType = UITextAutocorrectionTypeYes;
    nameField.keyboardType = UIKeyboardTypeDefault;
    nameField.keyboardAppearance = UIKeyboardAppearanceDark;
    nameField.clearButtonMode = UITextFieldViewModeWhileEditing;
    nameField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Имя и фамилия" attributes:@{NSForegroundColorAttributeName: light_text_color}];
    nameField.tintColor = [UIColor whiteColor];
    nameField.textColor = [UIColor whiteColor];
    nameField.font = [UIFont systemFontOfSize:13];
    [mainScroll addSubview:nameField];
    
    UIView * thirdSeparator = [self separatorAdd:numField.frame.origin.x sepY:nameField.frame.origin.y + nameField.frame.size.height + 10 sepHeight:0.5];
    [mainScroll addSubview:thirdSeparator];
    
    clubButton = [UIButton buttonWithType:UIButtonTypeCustom];
    clubButton.frame = CGRectMake(70, thirdSeparator.frame.origin.y + thirdSeparator.frame.size.height + 10, numField.frame.size.width, 30);
    [clubButton setTitle:@"Выберите клуб" forState:UIControlStateNormal];
    [clubButton setTitleColor:[UIColor colorWithRed:225/225.0f green:225/225.0f blue:225/225.0f alpha:0.5] forState:UIControlStateNormal];
    clubButton.titleLabel.font = [UIFont systemFontOfSize:13];
    clubButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [clubButton addTarget:self action:@selector(openClub) forControlEvents:UIControlEventTouchUpInside];
    regButton.layer.masksToBounds = YES;
    [mainScroll addSubview:clubButton];
    
    arrowButton = [UIImageView new];
    arrowButton.frame = CGRectMake(thirdSeparator.frame.origin.x + thirdSeparator.frame.size.width - 10, clubButton.frame.origin.y + (clubButton.frame.size.height/2-5), 10, 10);
    arrowButton.image = [UIImage imageNamed:@"arrow_right"];
    [self.view addSubview:arrowButton];
    
    UIView * fourSeparator = [self separatorAdd:numField.frame.origin.x sepY:clubButton.frame.origin.y + clubButton.frame.size.height + 10 sepHeight:0.5];
    [mainScroll addSubview:fourSeparator];
    
    regButton = [UIButton buttonWithType:UIButtonTypeCustom];
    regButton.frame = CGRectMake(56, fourSeparator.frame.origin.y + fourSeparator.frame.size.height + 30, self.view.frame.size.width-112, 48);
    [regButton setBackgroundImage:[self imageFromColor:tint_color] forState:UIControlStateNormal];
    [regButton setBackgroundImage:[self imageFromColor:[UIColor colorWithWhite:1 alpha:.5]] forState:UIControlStateDisabled];
    [regButton setTitle:@"СОЗДАТЬ АККАУНТ" forState:UIControlStateNormal];
    [regButton setTitleColor: [UIColor colorWithRed:225/225.0f green:225/225.0f blue:225/225.0f alpha:0.8] forState:UIControlStateNormal];
    [regButton addTarget:self action:@selector(signUp) forControlEvents:UIControlEventTouchUpInside];
    regButton.titleLabel.font = [UIFont systemFontOfSize:13];
    regButton.layer.cornerRadius = 25;
    regButton.layer.masksToBounds = YES;
    regButton.enabled = NO;
    [mainScroll addSubview:regButton];
    
    licenseButton = [UIButton buttonWithType:UIButtonTypeCustom];
    licenseButton.frame = CGRectMake(75, self.view.frame.size.height - 40, self.view.frame.size.width-150, 48);
    [licenseButton setTitle:@"Пользовательское соглашение" forState:UIControlStateNormal];
    [licenseButton setTitleColor: [UIColor colorWithRed:225/225.0f green:225/225.0f blue:225/225.0f alpha:0.8] forState:UIControlStateNormal];
    licenseButton.titleLabel.font = [UIFont systemFontOfSize:11];
    [mainScroll addSubview:licenseButton];
}

-(UIView*)separatorAdd:(float)sepX sepY:(float)sepY sepHeight:(float)sepHeight {
    
    UIView * separatorLine = [UIView new];
    separatorLine.frame = CGRectMake(sepX, sepY, self.view.frame.size.width - 140, sepHeight);
    separatorLine.backgroundColor = [UIColor colorWithRed:225/225.0f green:225/225.0f blue:225/225.0f alpha:0.5];
    
    return separatorLine;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, .2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        
        object.phone = [NSString stringWithFormat:@"+%@", numField.phoneNumber];
        object.nick_name = nickField.text;
        object.full_name = nameField.text;
        
        if (object.phone.length >= 12 && object.nick_name.length > 0 && object.full_name.length > 0 && object.club) regButton.enabled = YES;
        else regButton.enabled = NO;
        
    });
    
    return YES;
    
}

-(void)signUp{
    
    [self.view endEditing:YES];
    
    [SVProgressHUD show];
    
    [MARequests postSignup:object
                   success:^{
                       
                       NSString *message = [NSString stringWithFormat:@"%@, ваш аккаунт успешно зарегистрирован!\n Пароль отправлен в виде СМС на номер\n%@.",object.nick_name,numField.text];
                       
                       [SVProgressHUD showSuccessWithStatus:message];
                       
                       [self.navigationController popViewControllerAnimated:YES];
                       
                   }error:^(NSString *message) {
                       
                       [SVProgressHUD showErrorWithStatus:message];
                       
                   }];
    
}

-(void)openClub{
    
    MAClubsController *clubsController = [MAClubsController new];
    clubsController.delegate = self;
    
    [self.navigationController pushViewController:clubsController animated:YES];
}

-(void)clubReturn:(MAClubObject *)club{
    
    if (club) object.club = club;
    
    [clubButton setTitle:club.title forState:UIControlStateNormal];
    [clubButton setTitleColor: [UIColor whiteColor] forState:UIControlStateNormal];
    
    if (object.phone.length >= 12 && object.nick_name.length > 0 && object.full_name.length > 0 && object.club) regButton.enabled = YES;
    else regButton.enabled = NO;
    
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
