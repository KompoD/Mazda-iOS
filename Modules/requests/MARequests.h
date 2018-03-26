//
//  MARequests.h
//  Mazda
//
//  Created by Nikita Merkel on 20.01.17.
//  Copyright © 2017 Nikita Merkel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "NSValue+YMKMapCoordinate.h"
#import "MASignupObject.h"
#import "MAProfileObject.h"
#import "MAFeedObject.h"
#import "MASmokeObject.h"
#import "MACommentObject.h"
#import "MAProfileObject.h"
#import "MALocationObject.h"
#import "MARatingObject.h"
#import "MACityObject.h"
#import "MACarObject.h"
#import "MAUserObject.h"

@interface MARequests : NSObject

//получение списка клубов
+ (void)getClubs:(int)skip
           limit:(int)limit
         success:(void (^)(NSMutableArray *items))success
           error:(void (^)(NSString *message))error;

//получение токена по логину и паролю (авторизация)
+ (void)getToken:(NSString *)login
        password:(NSString *)password
         success:(void (^)(NSString *token))success
           error:(void (^)(NSString *message))error;

//выход
+ (void)signOut:(void (^)(void))success
          error:(void (^)(NSString *message))error;

//запрос регистрации нового пользователя
+ (void)postSignup:(MASignUpObject *)object
           success:(void (^)())success
             error:(void (^)(NSString *message))error;

//запрос на восстановление пароля
+ (void)passwordRecovery:(NSString *)phone
                 success:(void (^)())success
                   error:(void (^)(NSString *message))error;

//регистрация устройства
+ (void)registerDevice:(NSString *)deviceId
               success:(void (^)(void))success
                 error:(void (^)(NSString *message))error;

//получение новостей
+ (void)getFeed:(int)ownerId
         isUser:(BOOL)isUser
         params:(NSDictionary *)params
        success:(void (^)(NSMutableArray *items))success
          error:(void (^)(NSString *message))error;

//установка лайка
+ (void)likeAction:(int)ownerId
            isUser:(BOOL)isUser
              like:(BOOL)like
           success:(void (^)(void))success
             error:(void (^)(NSString *message))error;

//получение списка комментариев
+ (void)getSmokeComments:(int)smokeId
                    skip:(int)skip
                   limit:(int)limit
                 success:(void (^)(NSMutableArray *items))success
                   error:(void (^)(NSString *message))error;

//добавление комментария
+ (void)addSmokeComment:(int)smokeId
                   text:(NSString *)text
                success:(void (^)(void))success
                  error:(void (^)(NSString *message))error;

//удаление комментариев
+ (void)removeSmokeComment:(int)commentId
                   success:(void (^)(void))success
                     error:(void (^)(NSString *message))error;

//получение пользователя по id
+ (void)getProfile:(int)userId
           success:(void (^)(MAProfileObject *profile))success
             error:(void (^)(NSString *message))error;

//Загрузка изображения
+ (void)uploadImage:(UIImage *)image
         percentage:(void (^)(float value))percentage
            success:(void (^)(NSString *fileName))success
              error:(void (^)(NSString *message))error;

//Палево
+ (void)createSmoke:(MASmokeObject *)smoke
            success:(void (^)(void))success
              error:(void (^)(NSString *message))error;

//Обновление геопозиции
+ (void)updateLocation:(MALocationObject *)location
               success:(void (^)(int count))success
                 error:(void (^)(NSString *message))error;

//Получение геопозиций
+ (void)userGeoList:(int)radius
             coords:(YMKMapCoordinate)coords
            success:(void (^)(NSMutableArray *userGeoList))success
              error:(void (^)(NSString *message))error;

//Получение адреса
+ (void)addressByCoords:(YMKMapCoordinate)coords
                success:(void (^)(NSString *address))success
                  error:(void (^)(NSString *message))error;

//Получение рейтинга
+ (void)getRating:(BOOL)isCommon
             skip:(int)skip
            limit:(int)limit
          success:(void (^)(NSMutableArray *peoples))success
            error:(void (^)(NSString *message))error;

//Изменение аватара
+ (void)updateAvatar:(NSString *)fileName
             success:(void (^)(void))success
               error:(void (^)(NSString *message))error;

//Изменение информации о пользователе
+ (void)editUser:(int)cityId
        nickName:(NSString *)nickName
        fullName:(NSString *)fullName
         success:(void (^)(void))success
           error:(void (^)(NSString *message))error;

//Изменение информации о машине
+ (void)editCar:(int)carModelId
      modelYear:(int)modelYear
      regNumber:(NSString *)regNumber
        success:(void (^)(void))success
          error:(void (^)(NSString *message))error;

//Поиск и получение списка городов
+ (void)getCities:(NSString *)title
             skip:(int)skip
            limit:(int)limit
          success:(void (^)(NSMutableArray *items))success
            error:(void (^)(NSString *message))error;

//Получение города по id
+ (void)getCity:(int)cityId
        success:(void (^)(MACityObject *city))success
          error:(void (^)(NSString *message))error;

//Получение списка марок автомобилей
+ (void)getCarMarks:(NSString *)title
               skip:(int)skip
              limit:(int)limit
            success:(void (^)(NSMutableArray *items))success
              error:(void (^)(NSString *message))error;

//Получение списка моделей автомобилей
+ (void)getCarModels:(long)carMarkId
               title:(NSString *)title
                skip:(int)skip
               limit:(int)limit
             success:(void (^)(NSMutableArray *items))success
               error:(void (^)(NSString *message))error;

//Получения машины пользователя
+ (void)getUserCar:(int)userId
           success:(void (^)(MAUserCarObject *carObject))success
             error:(void (^)(NSString *message))error;

//Поиск пользователей
+ (void)userSearch:(NSString *)search
              skip:(int)skip
             limit:(int)limit
           success:(void (^)(NSMutableArray *users))success
             error:(void (^)(NSString *message))error;

//Изменение фотографий профиля
+ (void)editUserPhotos:(NSString *)fileName
                remove:(BOOL)remove
               success:(void (^)(void))success
                 error:(void (^)(NSString *message))error;

@end
