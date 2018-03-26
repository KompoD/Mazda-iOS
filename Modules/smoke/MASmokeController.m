//
//  MASmokeController.m
//  Mazda
//
//  Created by Егор on 08.03.17.
//  Copyright © 2017 Nikita Merkel. All rights reserved.
//

#import "MASmokeController.h"
#import "UITextView+Placeholder.h"
#import "MARequests.h"

@interface MASmokeController () {
    
    TPKeyboardAvoidingScrollView *mainScroll;
    UIImageView *smokePhoto;
    UITextView *descriptionText;
    UIImagePickerController *imagePicker;
    UIImageView *fromAvatar;
    UILabel *fromNickname;
    UIImageView *toAvatar;
    UIButton *toNickname;
    UIButton *placeButton;
    UIButton *smokeButton;
    
    MASmokeObject *smoke;
    
}

@end

@implementation MASmokeController

- (id)init {
    
    if ((self = [super init])){
        
        self.view.backgroundColor = [UIColor colorWithRed:244/255.0f green:244/255.0f blue:244/255.0f alpha:1.0];
        //self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"more"] style:UIBarButtonItemStylePlain target:self action:nil];
        
        smoke = [MASmokeObject new];
        
        mainScroll = [TPKeyboardAvoidingScrollView new];
        mainScroll.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        mainScroll.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height);
        mainScroll.showsVerticalScrollIndicator = NO;
        [self.view addSubview:mainScroll];
        
        UIView *postView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 0)];
        postView.backgroundColor = [UIColor whiteColor];
        [mainScroll addSubview:postView];
        
        smokePhoto = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 128, 128)];
        smokePhoto.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"smoke_placeholder"]];
        smokePhoto.userInteractionEnabled = YES;
        UITapGestureRecognizer *photoTap =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addPhoto)];
        [photoTap setNumberOfTapsRequired:1];
        [smokePhoto addGestureRecognizer:photoTap];
        [postView addSubview:smokePhoto];
        
        descriptionText = [[UITextView alloc] initWithFrame:CGRectMake(smokePhoto.frame.origin.x + smokePhoto.frame.size.width + 5, smokePhoto.frame.origin.y, postView.frame.size.width - smokePhoto.frame.size.width - smokePhoto.frame.origin.x - 10, smokePhoto.frame.size.height)];
        descriptionText.delegate = self;
        descriptionText.font = [UIFont systemFontOfSize:12];
        descriptionText.placeholder = @"Подпись к фотографии...";
        [postView addSubview:descriptionText];
        
        postView.frame = CGRectMake(postView.frame.origin.x, postView.frame.origin.y, postView.frame.size.width, smokePhoto.frame.origin.y*2 + smokePhoto.frame.size.height);
        
        UIView *usersView = [[UIView alloc] initWithFrame:CGRectMake(0, postView.frame.origin.y + postView.frame.size.height + 5, postView.frame.size.width, 0)];
        usersView.backgroundColor = [UIColor whiteColor];
        [mainScroll addSubview:usersView];
        
        fromAvatar = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"avatar_placeholder"]];
        fromAvatar.frame = CGRectMake(10, 5, 32, 32);
        fromAvatar.contentMode = UIViewContentModeScaleAspectFill;
        fromAvatar.layer.cornerRadius = fromAvatar.frame.size.height/2;
        fromAvatar.clipsToBounds = YES;
        [usersView addSubview:fromAvatar];
        
        fromNickname = [[UILabel alloc] initWithFrame:CGRectMake(fromAvatar.frame.origin.x + fromAvatar.frame.size.width + 20,
                                                                 fromAvatar.frame.origin.y,
                                                                 usersView.frame.size.width - fromAvatar.frame.origin.x * 3 - fromAvatar.frame.size.width - 20,
                                                                 fromAvatar.frame.size.height)];
        [fromNickname setFont:[UIFont systemFontOfSize:15]];
        [usersView addSubview:fromNickname];
        
        UIView *usersSeparator = [[UIView alloc] initWithFrame:CGRectMake(fromNickname.frame.origin.x, fromAvatar.frame.origin.y + fromAvatar.frame.size.height + 5, usersView.frame.size.width - fromNickname.frame.origin.x, 1)];
        usersSeparator.backgroundColor = separator_color;
        [usersView addSubview:usersSeparator];
        
        toAvatar = [UIImageView new];
        toAvatar.frame = CGRectMake(fromAvatar.frame.origin.x, usersSeparator.frame.origin.y + 5, fromAvatar.frame.size.width, fromAvatar.frame.size.height);
        toAvatar.contentMode = UIViewContentModeScaleAspectFill;
        toAvatar.layer.cornerRadius = fromAvatar.frame.size.height/2;
        toAvatar.clipsToBounds = YES;
        [usersView addSubview:toAvatar];
        
        toNickname = [[UIButton alloc] initWithFrame:CGRectMake(toAvatar.frame.origin.x + toAvatar.frame.size.width + 20, usersSeparator.frame.origin.y + 5, fromNickname.frame.size.width, fromNickname.frame.size.height)];
        [toNickname.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [toNickname setTitle:@"Добавить пользователя..." forState:UIControlStateNormal];
        [toNickname setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [toNickname setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
        [toNickname setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [toNickname addTarget:self action:@selector(selectUser) forControlEvents:UIControlEventTouchDown];
        [usersView addSubview:toNickname];
        
        usersView.frame = CGRectMake(usersView.frame.origin.x, usersView.frame.origin.y, usersView.frame.size.width, toNickname.frame.origin.y + toNickname.frame.size.height + 5);
        
        
        UIView *placeView = [[UIView alloc] initWithFrame:CGRectMake(usersView.frame.origin.x, usersView.frame.origin.y + usersView.frame.size.height + 5, usersView.frame.size.width, 42)];
        placeView.backgroundColor = [UIColor whiteColor];
        [mainScroll addSubview:placeView];
        
        UIImageView *placeMarker = [[UIImageView alloc] initWithFrame:CGRectMake(fromAvatar.frame.origin.x, 5, 32, 32)];
        placeMarker.image = [UIImage imageNamed:@"smoke_marker"];
        placeMarker.contentMode = UIViewContentModeScaleAspectFit;
        [placeView addSubview:placeMarker];
        
        placeButton = [[UIButton alloc] initWithFrame:CGRectMake(fromNickname.frame.origin.x, placeMarker.frame.origin.y, fromNickname.frame.size.width, placeMarker.frame.size.height)];
        [placeButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [placeButton setTitle:@"Выберите место" forState:UIControlStateNormal];
        [placeButton setTitle:@"Загрузка..." forState:UIControlStateDisabled];
        [placeButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [placeButton setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
        [placeButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [placeButton addTarget:self action:@selector(selectPlace) forControlEvents:UIControlEventTouchDown];
        [placeView addSubview:placeButton];
        
        
        smokeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        smokeButton.frame = CGRectMake(self.view.frame.size.width/6, self.view.frame.size.height - 170, self.view.frame.size.width/1.5, 40);
        [smokeButton setBackgroundImage:[self imageFromColor:tint_color] forState:UIControlStateNormal];
        [smokeButton setBackgroundImage:[self imageFromColor:[UIColor colorWithWhite:0.5 alpha:.5]] forState:UIControlStateDisabled];
        [smokeButton setTitle:@"СПАЛИТЬ" forState:UIControlStateNormal];
        [smokeButton setImage:[UIImage imageNamed:@"button_smoke"] forState:UIControlStateNormal];
        [smokeButton setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
        [smokeButton setTitleColor: [UIColor whiteColor] forState:UIControlStateNormal];
        [smokeButton setTitleColor: [[UIColor whiteColor] colorWithAlphaComponent:0.8] forState:UIControlStateDisabled];
        [smokeButton addTarget:self action:@selector(smokeAction) forControlEvents:UIControlEventTouchUpInside];
        smokeButton.titleLabel.font = [UIFont systemFontOfSize:17];
        smokeButton.layer.cornerRadius = smokeButton.frame.size.height/2;
        smokeButton.layer.masksToBounds = YES;
        smokeButton.enabled = NO;
        [mainScroll addSubview:smokeButton];
        
    }
    
    return self;
    
}

-(void)resetSmoke {
    
    smoke = [MASmokeObject new];
    
    toAvatar.image = nil;
    [toNickname setSelected:NO];
    [placeButton setSelected:NO];
    smokePhoto.image = nil;
    descriptionText.text = @"";
    
    [self checkFields];
    
}

-(void)addPhoto{
    
    UIAlertController *choice = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    choice.popoverPresentationController.sourceView = smokePhoto;
    choice.popoverPresentationController.sourceRect = smokePhoto.bounds;
    
    imagePicker = [MAImagePicker new];
    imagePicker.delegate = self;
    
    UIAlertAction *camera = [UIAlertAction actionWithTitle:@"Камера"
                                                     style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction * action) {
                                                       
                                                       imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
                                                       
                                                       [self.navigationController presentViewController:imagePicker animated:YES completion:nil];
                                                       
                                                   }];
    [camera setValue:tint_color forKey:@"titleTextColor"];
    
    UIAlertAction *gallery = [UIAlertAction actionWithTitle:@"Галерея"
                                                      style:UIAlertActionStyleDefault
                                                    handler:^(UIAlertAction * action) {
                                                        
                                                        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                                                        
                                                        [self.navigationController presentViewController:imagePicker animated:YES completion:nil];
                                                        
                                                    }];
    [gallery setValue:tint_color forKey:@"titleTextColor"];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Отмена"
                                                     style:UIAlertActionStyleCancel
                                                   handler:^(UIAlertAction * action) {
                                                       
                                                       [choice dismissViewControllerAnimated:YES completion:nil];
                                                       
                                                   }];
    [cancel setValue:tint_color forKey:@"titleTextColor"];
    
    [camera setEnabled:[UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]];
    [gallery setEnabled:[UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]];
    
    [choice addAction:camera];
    [choice addAction:gallery];
    [choice addAction:cancel];
    
    [self presentViewController:choice animated:YES completion:nil];
    
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    UIImage *selectedImage = info[@"UIImagePickerControllerEditedImage"] ? info[@"UIImagePickerControllerEditedImage"] : info[@"UIImagePickerControllerOriginalImage"];
    
    smokePhoto.image = selectedImage;
    
    [imagePicker dismissViewControllerAnimated:YES completion:nil];
    
    [SVProgressHUD show];
    
    [MARequests uploadImage:selectedImage
                 percentage:^(float value) {
                     
                     [SVProgressHUD showProgress:value];
                     
                 } success:^(NSString *fileName) {
                     
                     smoke.photo = fileName;
                     
                     [SVProgressHUD dismiss];
                     
                     [self checkFields];
                     
                 } error:^(NSString *message) {
                     
                     smokePhoto.image = nil;
                     
                     smoke.photo = nil;
                     
                     [SVProgressHUD showErrorWithStatus:message];
                     
                     [self checkFields];
                     
                 }];
    
}

-(void)selectUser {
    
    MAUsersController *usersController = [MAUsersController new];
    usersController.title = @"Выберите пользователя";
    usersController.delegate = self;
    
    usersController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:usersController animated:YES];
    
}

-(void)didSelectUser:(MAUserObject *)userObject{
    
    [self setSmokeUser:userObject];
    
}

-(void)selectPlace {
    
    MASmokeMap *mapController = [MASmokeMap new];
    mapController.title = @"Выберите местоположение";
    mapController.delegate = self;
    
    if(!YMKMapCoordinateIsZero(smoke.coordinate)) mapController.userCoordinate = smoke.coordinate;
    
    mapController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:mapController animated:YES];
    
}

-(void)didSelectPlace:(YMKMapCoordinate)coordinate
              address:(NSString *)address{
    
    smoke.coordinate = coordinate;
    
    [placeButton setTitle:address forState:UIControlStateSelected];
    [placeButton setSelected:YES];
    
    [self checkFields];
    
}

-(void)setSmokeUser:(MAUserObject *)userObject {
    
    smoke.whom_id = userObject.id;
    
    [toNickname setTitle:userObject.nickName forState:UIControlStateSelected];
    [toNickname setSelected:YES];
    
    if(userObject.car.avatar) [toAvatar setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@images/%@", api_domain, userObject.car.avatar]] placeholderImage:[UIImage imageNamed:@"avatar_placeholder"]];
    else [toAvatar setImage:[UIImage imageNamed:@"avatar_placeholder"]];
    
    [self setPlaceAddress:userObject.geo.coordinate];
    
    [self checkFields];
    
}

-(void)smokeAction {
    
    [self.view endEditing:YES];
    
    [SVProgressHUD show];
    
    smoke.text = descriptionText.text;
    
    [MARequests createSmoke:smoke success:^{
        
        [SVProgressHUD showSuccessWithStatus:[NSString stringWithFormat:@"Вы спалили пользователя %@", toNickname.titleLabel.text]];
        
        if(self.hidesBottomBarWhenPushed) [self.navigationController popViewControllerAnimated:YES];
        else [self resetSmoke];
        
    } error:^(NSString *message) {
        
        [SVProgressHUD showErrorWithStatus:message];
        
    }];
    
}

/*
 Автопереход к ленте после палева
 -(void)moveToFeed {
 
 [self.tabBarController setSelectedIndex:0];
 MAFeedController *feedController = (MAFeedController *)[[[self.tabBarController.viewControllers objectAtIndex:0] childViewControllers] objectAtIndex:0];
 feedController.tableView.sort = @"date";
 [feedController.tableView refreshFeed];
 
 }*/

-(void)setPlaceAddress:(YMKMapCoordinate)coord {
    
    smoke.coordinate = YMKMapCoordinateInvalid;
    [placeButton setSelected:NO];
    
    if(!YMKMapCoordinateIsZero(coord)) {
        
        [placeButton setEnabled:NO];
        
        [MARequests addressByCoords:coord
                            success:^(NSString *address) {
                                
                                [placeButton setEnabled:YES];
                                if(![address isEqualToString:@""]) {
                                    
                                    smoke.coordinate = coord;
                                    
                                    [placeButton setTitle:address forState:UIControlStateSelected];
                                    [placeButton setSelected:YES];
                                    
                                }
                                
                            } error:^(NSString *message) {
                                
                                [placeButton setEnabled:YES];
                                [placeButton setTitle:@"Неизвестное местоположение" forState:UIControlStateSelected];
                                [placeButton setSelected:YES];
                                
                            }];
        
    }
    
}

-(void)checkFields {
    
    if(smoke.whom_id &&
       smoke.photo &&
       smoke.text.length > 0 &&
       !YMKMapCoordinateIsZero(smoke.coordinate)) smokeButton.enabled = YES;
    
    else smokeButton.enabled = NO;
    
}

-(void)textViewDidChangeSelection:(UITextView *)textView{
    
    smoke.text = textView.text;
    
    [self checkFields];
    
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

-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    if(![[[MAAuthData get] avatar] isEqualToString:@""]) [fromAvatar setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@images/%@", api_domain, [[MAAuthData get] avatar]]]];
    
    [fromNickname setText:[[MAAuthData get] nickname]];
    
}

@end
