//
//  MAProfileSettingsController.m
//  Mazda
//
//  Created by Nikita Merkel on 31.03.17.
//  Copyright © 2017 Nikita Merkel. All rights reserved.
//

#import "MAProfileSettingsController.h"
#import "AppDelegate.h"

@interface MAProfileSettingsController (){
    
    AppDelegate *appDelegate;
    
    MAImagePicker *imagePicker;
    
    UIImageView *avatar;
    
    UIButton *avatarChange;
    
    UITableView *table;
    
    NSString *cityTitle;
    
    MACarPhotos *carPhotos;
    
    NSMutableArray *items;
    
}

@end

@implementation MAProfileSettingsController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = light_background_color;
    
    self.carObj = [MAUserCarObject new];
    cityTitle = @"";
    
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    scrollView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:scrollView];
    
    avatar = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2 - 62, 15, 124, 124)];
    [avatar setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@images/%@",api_domain,self.profileObj.avatar]] placeholderImage:[UIImage imageNamed:@"avatar_placeholder"]];
    avatar.contentMode = UIViewContentModeScaleAspectFill;
    avatar.layer.cornerRadius = avatar.frame.size.width/2;
    avatar.layer.masksToBounds = YES;
    
    CALayer* containerLayer = [CALayer layer];
    containerLayer.shadowColor = [UIColor blackColor].CGColor;
    containerLayer.shadowRadius = 3;
    containerLayer.shadowOffset = CGSizeMake(1, 1);
    containerLayer.shadowOpacity = .2;
    [containerLayer addSublayer:avatar.layer];
    [scrollView.layer addSublayer:containerLayer];
    
    avatarChange = [UIButton buttonWithType:UIButtonTypeCustom];
    avatarChange.frame = CGRectMake(avatar.frame.origin.x + avatar.frame.size.width - 45, avatar.frame.origin.y + avatar.frame.size.height - 45, 45, 45);
    [avatarChange setImage:[UIImage imageNamed:@"avatar_change"] forState:UIControlStateNormal];
    [avatarChange addTarget:self action:@selector(addPhoto) forControlEvents:UIControlEventTouchDown];
    [scrollView addSubview:avatarChange];
    
    table = [[UITableView alloc] initWithFrame:CGRectMake(0, avatar.frame.origin.y + avatar.frame.size.height + 15, self.view.frame.size.width, 47*7)];
    table.backgroundColor = [UIColor whiteColor];
    table.delegate = self;
    table.dataSource = self;
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    table.scrollEnabled = NO;
    table.showsVerticalScrollIndicator = NO;
    table.layer.borderWidth = 1;
    table.layer.borderColor = [[UIColor colorWithRed:202/225.0f green:202/225.0f blue:202/225.0f alpha:1] CGColor];
    [scrollView addSubview:table];
    
    [self getCity];
    [self getCar];
    
    carPhotos = [[MACarPhotos alloc] initWithFrame:CGRectMake(0, table.frame.origin.y + table.frame.size.height + 10,
                                                              self.view.frame.size.width, 100)
                              collectionViewLayout:[UICollectionViewLayout new]];
    [carPhotos update:self.profileObj.carPhotos];
    carPhotos.photosDelegate = self;
    [scrollView addSubview:carPhotos];
    
    UIButton *exit = [UIButton buttonWithType:UIButtonTypeCustom];
    exit.frame = CGRectMake(self.view.frame.size.width/6, carPhotos.frame.origin.y + carPhotos.frame.size.height + 20, self.view.frame.size.width/1.5, 40);
    [exit setBackgroundImage:[self imageFromColor:tint_color] forState:UIControlStateNormal];
    [exit setTitle:@"ВЫЙТИ" forState:UIControlStateNormal];
    [exit setTitleColor: [UIColor whiteColor] forState:UIControlStateNormal];
    [exit addTarget:self action:@selector(exitAccount) forControlEvents:UIControlEventTouchUpInside];
    exit.titleLabel.font = [UIFont systemFontOfSize:17];
    exit.layer.cornerRadius = exit.frame.size.height/2;
    exit.layer.masksToBounds = YES;
    [scrollView addSubview:exit];
    
    //Надо сделать нормально
    scrollView.contentSize = CGSizeMake(self.view.frame.size.width, exit.frame.origin.y + exit.frame.size.height + 80);
    
}

-(void)exitAccount{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Вы действительно хотите выйти из аккаунта?"
                                                                             message:nil
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"Да"
                                                 style:UIAlertActionStyleDestructive
                                               handler:^(UIAlertAction * action){
                                                   
                                                   [SVProgressHUD show];
                                                   [MARequests signOut:^{
                                                       
                                                       [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:[[NSBundle mainBundle] bundleIdentifier]];
                                                       [appDelegate showLoginScreen];
                                                       [SVProgressHUD dismiss];
                                                       
                                                   } error:^(NSString *message) {
                                                       
                                                       [SVProgressHUD showErrorWithStatus:message];
                                                       
                                                   }];
                                                   
                                               }];
    [ok setValue:tint_color forKey:@"titleTextColor"];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Отмена"
                                                     style:UIAlertActionStyleCancel
                                                   handler:^(UIAlertAction * _Nonnull action) {
                                                       
                                                       [self dismissViewControllerAnimated:YES completion:nil];
                                                       
                                                   }];
    [cancel setValue:tint_color forKey:@"titleTextColor"];
    
    [alertController addAction:ok];
    [alertController addAction:cancel];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
}

-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    MANavigationBar *bar = (MANavigationBar *)self.navigationController.navigationBar;
    [bar updateTranslucent:NO];
    
}

-(void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    [MAAuthData setFromProfile:self.profileObj];
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return items.count;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 47;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MAProfileSettingsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MAProfileSettingsCell"];
    
    if (cell == nil) cell = [[MAProfileSettingsCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"MAProfileSettingsCell"];
    
    cell.label.text = items[indexPath.row][@"title"];
    cell.text.text = items[indexPath.row][@"sub"];
    
    if (indexPath.row == 6) {
        
        cell.arrow = nil;
        UISwitch *stealth = [[UISwitch alloc] initWithFrame:CGRectZero];
        stealth.onTintColor = tint_color;
        [stealth setOn:[[MAAuthData get] stealth]];
        [stealth addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
        cell.accessoryView = stealth;
        cell.separatorLine = nil;
        
    }
    
    return cell;
    
}

-(NSMutableArray *)get{
    
    NSMutableArray *objects = [NSMutableArray new];
    
    [objects addObject:@{@"title":@"Никнейм",@"sub":self.profileObj.nickName}];
    [objects addObject:@{@"title":@"Имя и фамилия",@"sub":self.profileObj.fullName}];
    [objects addObject:@{@"title":@"Город",@"sub":cityTitle}];
    
    NSString *car = @"";
    
    if (self.carObj.carModel.id && self.carObj.carMark.id){
        
        car = [NSString stringWithFormat:@"%@ %@", self.carObj.carMark.title, self.carObj.carModel.title];
        
    }
    
    [objects addObject:@{@"title":@"Машина",@"sub":car}];
    
    NSString *year = @"";
    
    if(self.carObj.modelYear > 0){
        
        year = [NSString stringWithFormat:@"%d", self.carObj.modelYear];
        
    }
    
    [objects addObject:@{@"title":@"Год выпуска",@"sub":year}];
    
    NSString *number = @"";
    
    if(![self.carObj.regNumber isEqual: @""]){
        
        number = [NSString stringWithFormat:@"%@", self.carObj.regNumber];
        
    }
    
    [objects addObject:@{@"title":@"Гос. номер",@"sub":number}];
    [objects addObject:@{@"title":@"Невидимка",@"sub":@""}];
    
    return objects;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MACitySelect *citiesController = [MACitySelect new];
    MACarSelectTableController *carsController = [MACarSelectTableController new];
    MACarYearController *yearController = [MACarYearController new];
    
    switch (indexPath.row){
        case 0:
            [self alert:@"Никнейм"
          textFieldText:self.profileObj.nickName
         textFieldPlace:@"Введите Ваш никнейм"
                   type: UIKeyboardTypeDefault
              objectPar:0];
            
            break;
            
        case 1:
            [self alert:@"Имя и фамилия"
          textFieldText:self.profileObj.fullName
         textFieldPlace:@"Введите Вашe имя и фамилию"
                   type: UIKeyboardTypeDefault
              objectPar:1];
            break;
            
        case 2:
            citiesController.title = @"Выберите город";
            citiesController.delegate = self;
            [self.navigationController pushViewController:citiesController animated:YES];
            break;
            
        case 3:
            carsController.title = @"Выберите марку";
            carsController.delegate = self;
            [self.navigationController pushViewController:carsController animated:YES];
            break;
            
        case 4:
            yearController.title = @"Год выпуска машины";
            yearController.delegate = self;
            [self.navigationController pushViewController:yearController animated:YES];
            break;
            
        case 5:
            [self alert:@"Гос. номер"
          textFieldText:self.carObj.regNumber
         textFieldPlace:@"Введите номер Вашей машины"
                   type: UIKeyboardTypeDefault
              objectPar:3];
            break;
            
        default:
            break;
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

-(void)getCity{
    
    [MARequests getCity:self.profileObj.cityId
                success:^(MACityObject *city){
                    
                    cityTitle = city.title;
                    
                    items = [self get];
                    
                    [table reloadData];
                    
                }error:^(NSString *message){
                    
                    NSLog(@"getCity - error: %@", message);
                    
                }];
    
}

-(void)getCar{
    
    [MARequests getUserCar:self.profileObj.id
                   success:^(MAUserCarObject *carObject) {
                       
                       self.carObj = carObject;
                       
                       items = [self get];
                       
                       [table reloadData];
                       
                   } error:^(NSString *message) {
                       
                       NSLog(@"getCar - error: %@", message);
                       
                   }];
    
}

-(void)addPhoto{
    
    [self pickerSelector:1];
    
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    UIImage *image = info[@"UIImagePickerControllerEditedImage"] ? info[@"UIImagePickerControllerEditedImage"] : info[@"UIImagePickerControllerOriginalImage"];
    
    [imagePicker dismissViewControllerAnimated:YES completion:nil];
    
    [SVProgressHUD show];
    
    [MARequests uploadImage:image
                 percentage:^(float value) {
                     
                     [SVProgressHUD showProgress:value];
                     
                 } success:^(NSString *fileName) {
                     
                     if(picker.view.tag == 1) {
                         
                         avatar.image = image;
                         self.profileObj.avatar = fileName;
                         
                         [MARequests updateAvatar: self.profileObj.avatar
                                          success:^{
                                              
                                              [SVProgressHUD showSuccessWithStatus:@"Ваш аватар обновлён!"];
                                              
                                          } error:^(NSString *message) {
                                              
                                              [SVProgressHUD showErrorWithStatus:message];
                                              
                                          }];
                         
                     } else if (picker.view.tag == 2) {
                         
                         [MARequests editUserPhotos:fileName
                                             remove:NO success:^{
                                                 
                                                 [SVProgressHUD dismiss];
                                                 
                                                 [carPhotos insertPhoto:fileName];
                                                 
                                             } error:^(NSString *message) {
                                                 
                                                 [SVProgressHUD showErrorWithStatus:message];
                                                 
                                             }];
                         
                     }
                     
                 } error:^(NSString *message) {
                     
                     [SVProgressHUD showErrorWithStatus:message];
                     
                 }];
    
}

-(void)editUser{
    
    [MARequests editUser:self.profileObj.cityId
                nickName:self.profileObj.nickName
                fullName:self.profileObj.fullName
                 success:^{
                     
                     NSLog(@"editUser - success!");
                     
                 } error:^(NSString *message) {
                     
                     NSLog(@"editUser - error: %@", message);
                     
                 }];
    
}

-(void)editCar{
    
    [MARequests editCar:self.carObj.carModel.id
              modelYear:self.carObj.modelYear
              regNumber:self.carObj.regNumber
                success:^{
                    
                    NSLog(@"editCar - success");
                    
                } error:^(NSString *message) {
                    
                    NSLog(@"editCar - error: %@", message);
                    
                    [SVProgressHUD showErrorWithStatus:message];
                    
                    [self getCar];
                    
                }];
    
}

-(void)didSelectCity:(MACityObject *)city{
    
    self.profileObj.cityId = city.id;
    
    [self getCity];
    
}

-(void)didSelectMark:(MACarObject *)carObject {
    
    self.carObj.carMark = carObject;
    self.carObj.carModel = nil;
    
    MACarSelectTableController *modelSelect = [MACarSelectTableController new];
    modelSelect.title = @"Выберите модель";
    modelSelect.delegate = self;
    modelSelect.markId = carObject.id;
    
    [self.navigationController pushViewController:modelSelect animated:YES];
    
}

-(void)didSelectModel:(MACarObject *)carObject {
    
    self.carObj.carModel = carObject;
    
    items = [self get];
    
    [table reloadData];
    
    MACarYearController *yearController = [MACarYearController new];
    yearController.title = @"Год выпуска машины";
    yearController.delegate = self;
    yearController.carYear.text = [NSString stringWithFormat:@"%d", carObject.id];
    
    [self.navigationController pushViewController:yearController animated:YES];
    
}

-(void)didEnterYear:(int)carYear {
    
    self.carObj.modelYear = carYear;
    
    items = [self get];
    
    [table reloadData];
    
    [self editCar];
    
    NSMutableArray *allViewControllers = [NSMutableArray arrayWithArray:[self.navigationController viewControllers]];
    for (UIViewController *aViewController in allViewControllers) {
        if ([aViewController isKindOfClass:[MAProfileSettingsController class]]) {
            [self.navigationController popToViewController:aViewController animated:YES];
        }
    }
    
}

- (void)switchChanged:(UISwitch *)sender {
    
    [MAAuthData setStealth:sender.on];
    if(sender.on) [[CPTrackingLocation sharedManager] stopMonitoringLocation];
    else [[CPTrackingLocation sharedManager] startMonitoringLocation];
    
}

//Алерт для изменения данных пользователя
-(UIAlertController*)alert:(NSString *)title
             textFieldText:(NSString *)textFieldText
            textFieldPlace:(NSString *)textFieldPlace
                      type:(UIKeyboardType)type
                 objectPar:(int)objectPar {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title
                                                                             message:nil
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        
        textField.placeholder = textFieldPlace;
        textField.text = textFieldText;
        textField.tintColor = tint_color;
        textField.keyboardType = type;
        
    }];
    
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"Сохранить"
                                                 style:UIAlertActionStyleDefault
                                               handler:^(UIAlertAction * _Nonnull action) {
                                                   
                                                   if (alertController.textFields.count > 0) {
                                                       
                                                       UITextField *textField = [alertController.textFields firstObject];
                                                       
                                                       switch (objectPar){
                                                           case 0:
                                                               self.profileObj.nickName = textField.text;
                                                               [self editUser];
                                                               break;
                                                               
                                                           case 1:
                                                               self.profileObj.fullName = textField.text;
                                                               [self editUser];
                                                               break;
                                                               
                                                           case 3:
                                                               self.carObj.regNumber = textField.text;
                                                               [self editCar];
                                                               break;
                                                               
                                                           default:
                                                               break;
                                                       }
                                                       
                                                       [table reloadData];
                                                       
                                                   }
                                                   
                                               }];
    [ok setValue:tint_color forKey:@"titleTextColor"];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Отмена"
                                                     style:UIAlertActionStyleCancel
                                                   handler:^(UIAlertAction * _Nonnull action) {
                                                       
                                                       [self dismissViewControllerAnimated:YES completion:nil];
                                                       
                                                   }];
    [cancel setValue:tint_color forKey:@"titleTextColor"];
    
    [alertController addAction:ok];
    [alertController addAction:cancel];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
    return alertController;
    
}

-(void)addCarPhoto {
    
    [self pickerSelector:2];
    
}

-(void)pickerSelector:(int)type {
    
    UIAlertController *choice = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    choice.popoverPresentationController.sourceView = self.view;
    choice.popoverPresentationController.sourceRect = self.view.bounds;
    
    imagePicker = [MAImagePicker new];
    imagePicker.delegate = self;
    imagePicker.view.tag = type;
    
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
    
    if(![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) [camera setEnabled:NO];
    if(![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) [gallery setEnabled:NO];
    
    [choice addAction:camera];
    [choice addAction:gallery];
    [choice addAction:cancel];
    
    [self presentViewController:choice animated:YES completion:nil];
    
}

-(UIView*)separatorAdd:(float)sepX sepY:(float)sepY width:(float)width{
    
    UIView * separatorLine = [UIView new];
    separatorLine.frame = CGRectMake(sepX, sepY, width, 1);
    separatorLine.backgroundColor = [UIColor colorWithRed:202/225.0f green:202/225.0f blue:202/225.0f alpha:1];
    
    return separatorLine;
    
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
