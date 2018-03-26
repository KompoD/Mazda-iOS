//
//  MARequests.m
//  Mazda
//
//  Created by Nikita Merkel on 20.01.17.
//  Copyright © 2017 Nikita Merkel. All rights reserved.
//

#import "MARequests.h"
#import "Catalog.h"

@implementation MARequests

+ (void)getClubs:(int)skip
           limit:(int)limit
         success:(void (^)(NSMutableArray *items))success
           error:(void (^)(NSString *message))error{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [manager.requestSerializer setTimeoutInterval:15];
    [manager.requestSerializer setValue:[[MAAuthData get] token] forHTTPHeaderField:@"X-AUTH-TOKEN"];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    [manager GET:[NSString stringWithFormat:@"%@clubs", api_domain]
      parameters:@{@"skip": @(skip), @"limit": @(limit)}
        progress:nil
         success:^(NSURLSessionDataTask *task, id response) {
             
             if ([response isKindOfClass:[NSArray class]]) {
                 
                 NSMutableArray *clubs = [NSMutableArray new];
                 
                 for (int i = 0; i < [response count]; i++) {
                     
                     MAClubObject *club = [MAClubObject new];
                     [club install:response[i]];
                     
                     [clubs addObject:club];
                     
                 }
                 
                 dispatch_async(dispatch_get_main_queue(), ^{
                     
                     success(clubs);
                     
                 });
                 
             }else dispatch_async(dispatch_get_main_queue(), ^{
                 
                 error(@"Неизвестная ошибка сервера");
                 
             });
             
         }failure:^(NSURLSessionDataTask *task, NSError *errorRequest) {
             
             dispatch_async(dispatch_get_main_queue(), ^{
                 
                 error(@"Проверьте соединение с интернетом");
                 
             });
             
         }];
    
}

//получение токена по логину и паролю (авторизация)
+ (void)getToken:(NSString *)login
        password:(NSString *)password
         success:(void (^)(NSString *token))success
           error:(void (^)(NSString *message))error{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer]
                                    requestWithMethod:@"POST"
                                    URLString:[NSString stringWithFormat:@"%@sign.in",api_domain]
                                    parameters:@{ @"login": login, @"password": password }
                                    error:nil];
    
    [manager.requestSerializer setTimeoutInterval:15];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    [[manager dataTaskWithRequest:request
                completionHandler:^(NSURLResponse *response, id responseObject, NSError *erro) {
                    
                    if ([responseObject[@"authToken"] isKindOfClass:[NSString class]]){
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            success([NSString stringWithFormat:@"%@",responseObject[@"authToken"]]);
                            
                        });
                        
                    }else if ([responseObject[@"message"] isKindOfClass:[NSString class]]){
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            error([NSString stringWithFormat:@"%@",responseObject[@"message"]]);
                            
                        });
                        
                    }else dispatch_async(dispatch_get_main_queue(), ^{
                        
                        error(@"Проверьте соединение с интернетом");
                        
                    });
                    
                }]resume];
    
}

//Выход
+ (void)signOut:(void (^)(void))success
          error:(void (^)(NSString *message))error{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST"
                                                                                 URLString:[NSString stringWithFormat:@"%@sign.out",api_domain]
                                                                                parameters:nil
                                                                                     error:nil];
    
    [manager.requestSerializer setTimeoutInterval:15];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    [[manager dataTaskWithRequest:request
                completionHandler:^(NSURLResponse *response, id responseObject, NSError *erro) {
                    
                    if ([[NSString stringWithFormat:@"%@", responseObject[@"status"]] isEqualToString:@"OK"]){
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            success();
                            
                        });
                        
                    }else if ([responseObject[@"message"] isKindOfClass:[NSString class]]){
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            error([NSString stringWithFormat:@"%@",responseObject[@"message"]]);
                            
                        });
                        
                    }else dispatch_async(dispatch_get_main_queue(), ^{
                        
                        error(@"Проверьте соединение с интернетом");
                        
                    });
                    
                }]resume];
    
}

//Регистрация
+ (void)postSignup:(MASignUpObject *)object
           success:(void (^)())success
             error:(void (^)(NSString *message))error{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer]
                                    requestWithMethod:@"POST"
                                    URLString:[NSString stringWithFormat:@"%@sign.up",api_domain]
                                    parameters:@{@"phoneNumber": object.phone,
                                                    @"nickName": object.nick_name,
                                                    @"fullName": object.full_name,
                                                      @"clubId":@(object.club.id)}
                                    error:nil];
    
    [manager.requestSerializer setTimeoutInterval:15];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    [[manager dataTaskWithRequest:request
                completionHandler:^(NSURLResponse *response, id responseObject, NSError *erro) {
                    
                    if ([[NSString stringWithFormat:@"%@", responseObject[@"status"]] isEqualToString:@"OK"]) {
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            success();
                            
                        });
                        
                    }else if ([responseObject[@"message"] isKindOfClass:[NSString class]]){
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            error([NSString stringWithFormat:@"%@", responseObject[@"message"]]);
                            
                        });
                        
                    }else dispatch_async(dispatch_get_main_queue(), ^{
                        
                        error(@"Проверьте соединение с интернетом");
                        
                    });
                    
                }]resume];
    
}

//Восстановление пароля
+ (void)passwordRecovery:(NSString *)phone
                 success:(void (^)())success
                   error:(void (^)(NSString *message))error{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST"
                                                                                 URLString:[NSString stringWithFormat:@"%@password.recovery",api_domain]
                                                                                parameters:@{@"phoneNumber": phone}
                                                                                     error:nil];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [manager.requestSerializer setTimeoutInterval:15];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    [[manager dataTaskWithRequest:request
                completionHandler:^(NSURLResponse *response, id responseObject, NSError *erro) {
                    
                    if ([[NSString stringWithFormat:@"%@", responseObject[@"status"]] isEqualToString:@"OK"]) {
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            success();
                            
                        });
                        
                    }else if ([responseObject[@"message"] isKindOfClass:[NSString class]]){
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            error([NSString stringWithFormat:@"%@", responseObject[@"message"]]);
                            
                        });
                        
                    }else dispatch_async(dispatch_get_main_queue(), ^{
                        
                        error(@"Проверьте соединение с интернетом");
                        
                    });
                    
                }]resume];
    
}

+ (void)registerDevice:(NSString *)deviceId
               success:(void (^)(void))success
                 error:(void (^)(NSString *message))error{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [manager.requestSerializer setTimeoutInterval:15];
    [manager.requestSerializer setValue:[[MAAuthData get] token] forHTTPHeaderField:@"X-AUTH-TOKEN"];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    [manager POST:[NSString stringWithFormat:@"%@device/register", api_domain]
       parameters:@{@"deviceId":deviceId}
         progress:nil
          success:^(NSURLSessionDataTask *task, id response) {
              
              if ([response[@"status"] isEqualToString:@"OK"]) {
                  
                  dispatch_async(dispatch_get_main_queue(), ^{
                      
                      success();
                      
                  });
                  
              } else dispatch_async(dispatch_get_main_queue(), ^{
                  
                  error(@"Неизвестная ошибка сервера");
                  
              });
              
          }failure:^(NSURLSessionDataTask *task, NSError *errorRequest) {
              
              NSLog(@"%@",errorRequest);
              
              dispatch_async(dispatch_get_main_queue(), ^{
                  
                  error(@"Проверьте соединение с интернетом");
                  
              });
              
          }];
    
}

/*
 + (void)getFeed:(int)ownerId
 isUser:(bool)isUser
 isFrom:(bool)isFrom
 skip:(int)skip
 limit:(int)limit
 sort:(NSString *)sort
 success:(void (^)(NSMutableArray *items))success
 error:(void (^)(NSString *message))error
 */
+ (void)getFeed:(int)ownerId
         isUser:(BOOL)isUser
         params:(NSDictionary *)params
        success:(void (^)(NSMutableArray *items))success
          error:(void (^)(NSString *message))error{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [manager.requestSerializer setTimeoutInterval:15];
    [manager.requestSerializer setValue:[[MAAuthData get] token] forHTTPHeaderField:@"X-AUTH-TOKEN"];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    [manager GET:[NSString stringWithFormat:@"%@%@/%d/wall", api_domain, isUser ? @"user" : @"club", ownerId]
      parameters:params
        progress:nil
         success:^(NSURLSessionDataTask *task, id response) {
             
             if ([response isKindOfClass:[NSArray class]]) {
                 
                 NSMutableArray *wallItems = [NSMutableArray new];
                 
                 for (NSDictionary *post in response)
                     [wallItems addObject:[[MAFeedObject new] install:post]];
                 
                 dispatch_async(dispatch_get_main_queue(), ^{
                     
                     success(wallItems);
                     
                 });
                 
             } else dispatch_async(dispatch_get_main_queue(), ^{
                 
                 error(@"Неизвестная ошибка сервера");
                 
             });
             
         }failure:^(NSURLSessionDataTask *task, NSError *errorRequest) {
             
             dispatch_async(dispatch_get_main_queue(), ^{
                 
                 error(@"Проверьте соединение с интернетом");
                 
             });
             
         }];
    
}

+ (void)likeAction:(int)ownerId
            isUser:(BOOL)isUser
              like:(BOOL)like
           success:(void (^)(void))success
             error:(void (^)(NSString *message))error{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [manager.requestSerializer setTimeoutInterval:15];
    [manager.requestSerializer setValue:[[MAAuthData get] token] forHTTPHeaderField:@"X-AUTH-TOKEN"];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    [manager POST:[NSString stringWithFormat:@"%@%@/like/%@", api_domain, isUser ? @"user" : @"smoke", like ? @"add" : @"remove"]
       parameters:@{@"id" : @(ownerId)}
         progress:nil
          success:^(NSURLSessionDataTask *task, id response) {
              
              if ([response[@"result"] boolValue] == YES) {
                  
                  dispatch_async(dispatch_get_main_queue(), ^{
                      
                      success();
                      
                  });
                  
              } else dispatch_async(dispatch_get_main_queue(), ^{
                  
                  error(@"Неизвестная ошибка сервера");
                  
              });
              
          }failure:^(NSURLSessionDataTask *task, NSError *errorRequest) {
              
              NSLog(@"%@",errorRequest);
              
              dispatch_async(dispatch_get_main_queue(), ^{
                  
                  error(@"проверьте соединение с интернетом");
                  
              });
              
          }];
    
}

+ (void)getSmokeComments:(int)smokeId
                    skip:(int)skip
                   limit:(int)limit
                 success:(void (^)(NSMutableArray *items))success
                   error:(void (^)(NSString *message))error{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [manager.requestSerializer setTimeoutInterval:15];
    [manager.requestSerializer setValue:[[MAAuthData get] token] forHTTPHeaderField:@"X-AUTH-TOKEN"];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    [manager GET:[NSString stringWithFormat:@"%@smoke/%d/comments", api_domain, smokeId]
      parameters:@{@"skip":@(skip), @"limit":@(limit)}
        progress:nil
         success:^(NSURLSessionDataTask *task, id response) {
             if ([response isKindOfClass:[NSArray class]]) {
                 
                 NSMutableArray *smokeComments = [NSMutableArray new];
                 
                 for (NSDictionary *comment in response)
                     [smokeComments addObject:[[MACommentObject new] install:comment]];
                 
                 dispatch_async(dispatch_get_main_queue(), ^{
                     
                     success(smokeComments);
                     
                 });
                 
             } else dispatch_async(dispatch_get_main_queue(), ^{
                 
                 error(@"Неизвестная ошибка сервера");
                 
             });
             
         }failure:^(NSURLSessionDataTask *task, NSError *errorRequest) {
             
             dispatch_async(dispatch_get_main_queue(), ^{
                 
                 error(@"Проверьте соединение с интернетом");
                 
             });
             
         }];
    
}

+ (void)addSmokeComment:(int)smokeId
                   text:(NSString *)text
                success:(void (^)(void))success
                  error:(void (^)(NSString *message))error{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [manager.requestSerializer setTimeoutInterval:15];
    [manager.requestSerializer setValue:[[MAAuthData get] token] forHTTPHeaderField:@"X-AUTH-TOKEN"];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    [manager POST:[NSString stringWithFormat:@"%@smoke/addComment", api_domain]
       parameters:@{@"smokeId":@(smokeId),
                    @"text":[NSString stringWithFormat:@"%@",text]}
         progress:nil
          success:^(NSURLSessionDataTask *task, id response) {
              
              if ([response[@"status"] isEqualToString:@"OK"]) {
                  
                  dispatch_async(dispatch_get_main_queue(), ^{
                      
                      success();
                      
                  });
                  
              } else dispatch_async(dispatch_get_main_queue(), ^{
                  
                  error(@"Неизвестная ошибка сервера");
                  
              });
              
          }failure:^(NSURLSessionDataTask *task, NSError *errorRequest) {
              
              NSLog(@"%@",errorRequest);
              
              dispatch_async(dispatch_get_main_queue(), ^{
                  
                  error(@"Проверьте соединение с интернетом");
                  
              });
              
          }];
    
}

+ (void)removeSmokeComment:(int)commentId
                   success:(void (^)(void))success
                     error:(void (^)(NSString *message))error{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [manager.requestSerializer setTimeoutInterval:15];
    [manager.requestSerializer setValue:[[MAAuthData get] token] forHTTPHeaderField:@"X-AUTH-TOKEN"];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    [manager POST:[NSString stringWithFormat:@"%@smoke/removeComment", api_domain]
       parameters:@{@"id":@(commentId)}
         progress:nil
          success:^(NSURLSessionDataTask *task, id response) {
              
              if ([response[@"status"] isEqualToString:@"OK"]) {
                  
                  dispatch_async(dispatch_get_main_queue(), ^{
                      
                      success();
                      
                  });
                  
              } else dispatch_async(dispatch_get_main_queue(), ^{
                  
                  error(@"Неизвестная ошибка сервера");
                  
              });
              
          }failure:^(NSURLSessionDataTask *task, NSError *errorRequest) {
              
              NSLog(@"%@",errorRequest);
              
              dispatch_async(dispatch_get_main_queue(), ^{
                  
                  error(@"Проверьте соединение с интернетом");
                  
              });
              
          }];
    
}

+ (void)getProfile:(int)userId
           success:(void (^)(MAProfileObject *profile))success
             error:(void (^)(NSString *message))error{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [manager.requestSerializer setTimeoutInterval:15];
    [manager.requestSerializer setValue:[[MAAuthData get] token] forHTTPHeaderField:@"X-AUTH-TOKEN"];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    [manager GET:(userId == 0) ? [NSString stringWithFormat:@"%@user/me", api_domain] :[NSString stringWithFormat:@"%@user/%d", api_domain, userId]
      parameters:nil
        progress:nil
         success:^(NSURLSessionDataTask *task, id response) {
             
             if ([response isKindOfClass:[NSDictionary class]]) {
                 
                 MAProfileObject *profileObject = [MAProfileObject new];
                 [profileObject install:response];
                 
                 dispatch_async(dispatch_get_main_queue(), ^{
                     
                     success(profileObject);
                     
                 });
                 
             } else dispatch_async(dispatch_get_main_queue(), ^{
                 
                 error(@"Неизвестная ошибка сервера");
                 
             });
             
         }failure:^(NSURLSessionDataTask *task, NSError *errorRequest) {
             
             dispatch_async(dispatch_get_main_queue(), ^{
                 
                 error(@"Проверьте соединение с интернетом");
                 
             });
             
         }];
    
}

+ (void)uploadImage:(UIImage *)image
         percentage:(void (^)(float value))percentage
            success:(void (^)(NSString *fileName))success
              error:(void (^)(NSString *message))error{
    
    NSData *img = UIImageJPEGRepresentation(image, 1.0);
    float compression = 1.0;
    if([img length] > 1000000) compression = 1000000.0 / [img length];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [manager.requestSerializer setTimeoutInterval:15];
    [manager.requestSerializer setValue:@"multipart/form-data" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:[[MAAuthData get] token] forHTTPHeaderField:@"X-AUTH-TOKEN"];
    
    [manager POST:[NSString stringWithFormat:@"%@image.upload", api_domain] parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:UIImageJPEGRepresentation(image, compression)
                                    name:@"image"
                                fileName:@"temp.jpeg"
                                mimeType:@"image/jpeg"];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            percentage(uploadProgress.fractionCompleted);
            
        });
        
    } success:^(NSURLSessionDataTask *task, id response) {
        
        if ([response[@"fileName"] isKindOfClass:[NSString class]]){
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                success(response[@"fileName"]);
                
            });
            
        }else dispatch_async(dispatch_get_main_queue(), ^{
            
            error(@"Неизвестная ошибка сервера");
            
        });
        
    } failure:^(NSURLSessionDataTask *task, NSError *errorRequest) {
        
        NSLog(@"%@",errorRequest);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            error(@"Проверьте соединение с интернетом");
            
        });
        
    }];
    
}

+ (void)createSmoke:(MASmokeObject *)smoke
            success:(void (^)(void))success
              error:(void (^)(NSString *message))error{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [manager.requestSerializer setTimeoutInterval:15];
    [manager.requestSerializer setValue:[[MAAuthData get] token] forHTTPHeaderField:@"X-AUTH-TOKEN"];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    [manager POST:[NSString stringWithFormat:@"%@smoke/create", api_domain]
       parameters:@{
                    @"coordinates": @{
                            @"latitude": [[NSNumber alloc] initWithDouble:smoke.coordinate.longitude],
                            @"longitude": [[NSNumber alloc] initWithDouble:smoke.coordinate.latitude]
                            },
                    @"photo": [NSString stringWithFormat:@"%@",smoke.photo],
                    @"text": [NSString stringWithFormat:@"%@",smoke.text],
                    @"whomId": [[NSNumber alloc] initWithInt:smoke.whom_id]
                    }
         progress:nil
          success:^(NSURLSessionDataTask *task, id response) {
              
              if ([response[@"status"] isEqualToString:@"OK"]) {
                  
                  dispatch_async(dispatch_get_main_queue(), ^{
                      
                      success();
                      
                  });
                  
              } else if ([response[@"status"] isEqualToString:@"ERROR"]) {
                  
                  dispatch_async(dispatch_get_main_queue(), ^{
                      
                      error(response[@"message"]);
                      
                  });
                  
              } else dispatch_async(dispatch_get_main_queue(), ^{
                  
                  error(@"Неизвестная ошибка сервера");
                  
              });
              
          }failure:^(NSURLSessionDataTask *task, NSError *errorRequest) {
              
              NSLog(@"%@",errorRequest);
              
              dispatch_async(dispatch_get_main_queue(), ^{
                  
                  error(@"Проверьте соединение с интернетом");
                  
              });
              
          }];
    
}

+ (void)updateLocation:(MALocationObject *)location
               success:(void (^)(int count))success
                 error:(void (^)(NSString *message))error{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [manager.requestSerializer setTimeoutInterval:15];
    [manager.requestSerializer setValue:[[MAAuthData get] token] forHTTPHeaderField:@"X-AUTH-TOKEN"];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    [manager POST:[NSString stringWithFormat:@"%@updateLocation", api_domain]
       parameters:@{
                    @"deviceId":[NSString stringWithFormat:@"%@",location.deviceId],
                    @"latitude":[NSNumber numberWithDouble:location.coordinate.latitude],
                    @"longitude":[NSNumber numberWithDouble:location.coordinate.longitude],
                    @"placeName":[NSString stringWithFormat:@"%@",location.placeName]
                    }
         progress:nil
          success:^(NSURLSessionDataTask *task, id response) {
              
              if (response[@"count"]) {
                  
                  dispatch_async(dispatch_get_main_queue(), ^{
                      
                      success((int)response[@"count"]);
                      
                  });
                  
              } else dispatch_async(dispatch_get_main_queue(), ^{
                  
                  error([NSString stringWithFormat:@"%@",response[@"message"]?response[@"message"]:@"Неизвестная ошибка сервера"]);
                  
              });
              
          }failure:^(NSURLSessionDataTask *task, NSError *errorRequest) {
              
              NSLog(@"%@",errorRequest);
              
              dispatch_async(dispatch_get_main_queue(), ^{
                  
                  error(@"Проверьте соединение с интернетом");
                  
              });
              
          }];
    
}

+ (void)userGeoList:(int)radius
             coords:(YMKMapCoordinate)coords
            success:(void (^)(NSMutableArray *userGeoList))success
              error:(void (^)(NSString *message))error{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [manager.requestSerializer setTimeoutInterval:15];
    [manager.requestSerializer setValue:[[MAAuthData get] token] forHTTPHeaderField:@"X-AUTH-TOKEN"];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    [manager GET:[NSString stringWithFormat:@"%@userGeoList", api_domain]
      parameters:@{
                   @"radius":[NSNumber numberWithInt:radius],
                   @"latitude":[NSNumber numberWithDouble:coords.latitude],
                   @"longitude":[NSNumber numberWithDouble:coords.longitude]
                   }
        progress:nil
         success:^(NSURLSessionDataTask *task, id response) {
             
             if ([response isKindOfClass:[NSArray class]]) {
                 
                 NSMutableArray *userGeoList = [NSMutableArray new];
                 
                 for (NSDictionary *user in response)
                     [userGeoList addObject:[[MAUserObject new] install:user]];
                 
                 dispatch_async(dispatch_get_main_queue(), ^{
                     
                     success(userGeoList);
                     
                 });
                 
             } else dispatch_async(dispatch_get_main_queue(), ^{
                 
                 error(@"Неизвестная ошибка сервера");
                 
             });
             
         }failure:^(NSURLSessionDataTask *task, NSError *errorRequest) {
             
             NSLog(@"%@",errorRequest);
             
             dispatch_async(dispatch_get_main_queue(), ^{
                 
                 error(@"Проверьте соединение с интернетом");
                 
             });
             
         }];
    
}

+ (void)addressByCoords:(YMKMapCoordinate)coords
                success:(void (^)(NSString *address))success
                  error:(void (^)(NSString *message))error{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [manager.requestSerializer setTimeoutInterval:15];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    [manager GET:[NSString stringWithFormat:@"%@", yandex_geo_domain]
      parameters:@{
                   @"geocode":[NSString stringWithFormat:@"%f,%f", coords.longitude, coords.latitude],
                   @"format":@"json",
                   @"results":@1
                   }
        progress:nil
         success:^(NSURLSessionDataTask *task, id response) {
             
             if ([response valueForKeyPath:@"response.GeoObjectCollection.featureMember.GeoObject"]){
                 
                 NSString *address = @"";
                 
                 for (NSDictionary* object in [response valueForKeyPath:@"response.GeoObjectCollection.featureMember.GeoObject"]){
                     
                     address = [NSString stringWithFormat:@"%@", object[@"name"]];
                     
                     //address = [NSString stringWithFormat:@"%@",[object valueForKeyPath:@"metaDataProperty.GeocoderMetaData.text"]];
                     
                 }
                 
                 if(![address isEqualToString:@""]) {
                     
                     dispatch_async(dispatch_get_main_queue(), ^{
                         
                         success(address);
                         
                     });
                     
                 } else {
                     
                     dispatch_async(dispatch_get_main_queue(), ^{
                         
                         error(@"Неизвестное местоположение");
                         
                     });
                     
                 }
                 
             } else dispatch_async(dispatch_get_main_queue(), ^{
                 
                 error(@"Неизвестная ошибка сервера");
                 
             });
             
         }failure:^(NSURLSessionDataTask *task, NSError *errorRequest) {
             
             NSLog(@"%@",errorRequest);
             
             dispatch_async(dispatch_get_main_queue(), ^{
                 
                 error(@"Проверьте соединение с интернетом");
                 
             });
             
         }];
    
}

+ (void)getRating:(BOOL)isCommon
             skip:(int)skip
            limit:(int)limit
          success:(void (^)(NSMutableArray *peoples))success
            error:(void (^)(NSString *message))error{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [manager.requestSerializer setTimeoutInterval:15];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    [manager GET:[NSString stringWithFormat:@"%@/rating/%@", api_domain, isCommon ? @"common" : @"club"]
      parameters:@{@"skip":@(skip),@"limit":@(limit)}
        progress:nil
         success:^(NSURLSessionDataTask *task, id response) {
             
             if ([response isKindOfClass:[NSArray class]]) {
                 
                 NSMutableArray *peoples = [NSMutableArray new];
                 
                 for (int i = 0; i < [response count]; i++) {
                     
                     MARatingObject *people = [MARatingObject new];
                     [people install:response[i]];
                     
                     [peoples addObject:people];
                     
                 }
                 
                 dispatch_async(dispatch_get_main_queue(), ^{
                     
                     success(peoples);
                     
                 });
                 
             } else dispatch_async(dispatch_get_main_queue(), ^{
                 
                 error(@"Неизвестная ошибка сервера");
                 
             });
             
         }failure:^(NSURLSessionDataTask *task, NSError *errorRequest) {
             
             dispatch_async(dispatch_get_main_queue(), ^{
                 
                 error(@"Проверьте соединение с интернетом");
                 
             });
             
         }];
    
}

+ (void)updateAvatar:(NSString *)fileName
             success:(void (^)(void))success
               error:(void (^)(NSString *message))error{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [manager.requestSerializer setTimeoutInterval:15];
    [manager.requestSerializer setValue:[[MAAuthData get] token] forHTTPHeaderField:@"X-AUTH-TOKEN"];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    [manager POST:[NSString stringWithFormat:@"%@user/updateAvatar", api_domain]
       parameters:@{@"fileName":fileName}
         progress:nil
          success:^(NSURLSessionDataTask *task, id response) {
              
              if ([response[@"status"] isEqualToString:@"OK"]) {
                  
                  dispatch_async(dispatch_get_main_queue(), ^{
                      
                      success();
                      
                  });
                  
              } else dispatch_async(dispatch_get_main_queue(), ^{
                  
                  error(@"Неизвестная ошибка сервера");
                  
              });
              
          }failure:^(NSURLSessionDataTask *task, NSError *errorRequest) {
              
              NSLog(@"%@",errorRequest);
              
              dispatch_async(dispatch_get_main_queue(), ^{
                  
                  error(@"Проверьте соединение с интернетом");
                  
              });
              
          }];
    
}

+ (void)editUser:(int)cityId
        nickName:(NSString *)nickName
        fullName:(NSString *)fullName
         success:(void (^)(void))success
           error:(void (^)(NSString *message))error{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [manager.requestSerializer setTimeoutInterval:15];
    [manager.requestSerializer setValue:[[MAAuthData get] token] forHTTPHeaderField:@"X-AUTH-TOKEN"];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    [manager POST:[NSString stringWithFormat:@"%@user/editUser", api_domain]
       parameters:@{
                    @"cityId":[NSNumber numberWithInt:cityId],
                    @"nickName":[NSString stringWithFormat:@"%@",nickName],
                    @"fullName":[NSString stringWithFormat:@"%@",fullName]
                    }
         progress:nil
          success:^(NSURLSessionDataTask *task, id response) {
              
              if ([response[@"status"] isEqualToString:@"OK"]) {
                  
                  dispatch_async(dispatch_get_main_queue(), ^{
                      
                      success();
                      
                  });
                  
              } else dispatch_async(dispatch_get_main_queue(), ^{
                  
                  error(@"Неизвестная ошибка сервера");
                  
              });
              
          }failure:^(NSURLSessionDataTask *task, NSError *errorRequest) {
              
              NSLog(@"%@",errorRequest);
              
              dispatch_async(dispatch_get_main_queue(), ^{
                  
                  error(@"Проверьте соединение с интернетом");
                  
              });
              
          }];
    
}

+ (void)editCar:(int)carModelId
      modelYear:(int)modelYear
      regNumber:(NSString *)regNumber
        success:(void (^)(void))success
          error:(void (^)(NSString *message))error{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [manager.requestSerializer setTimeoutInterval:15];
    [manager.requestSerializer setValue:[[MAAuthData get] token] forHTTPHeaderField:@"X-AUTH-TOKEN"];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    [manager POST:[NSString stringWithFormat:@"%@user/editCar", api_domain]
       parameters:@{
                    @"carModelId":[NSNumber numberWithInt:carModelId],
                    @"modelYear":[NSNumber numberWithInt:modelYear],
                    @"regNumber":[NSString stringWithFormat:@"%@",regNumber]
                    }
         progress:nil
          success:^(NSURLSessionDataTask *task, id response) {
              
              if ([response[@"status"] isEqualToString:@"OK"]) {
                  
                  dispatch_async(dispatch_get_main_queue(), ^{
                      
                      success();
                      
                  });
                  
              } else dispatch_async(dispatch_get_main_queue(), ^{
                  
                  error(@"Неизвестная ошибка сервера");
                  
              });
              
          }failure:^(NSURLSessionDataTask *task, NSError *errorRequest) {
              
              NSLog(@"%@",errorRequest);
              
              dispatch_async(dispatch_get_main_queue(), ^{
                  
                  error(@"Проверьте соединение с интернетом");
                  
              });
              
          }];
    
}

+ (void)getCities:(NSString *)title
             skip:(int)skip
            limit:(int)limit
          success:(void (^)(NSMutableArray *items))success
            error:(void (^)(NSString *message))error{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [manager.requestSerializer setTimeoutInterval:15];
    [manager.requestSerializer setValue:[[MAAuthData get] token] forHTTPHeaderField:@"X-AUTH-TOKEN"];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary:@{@"skip": @(skip), @"limit": @(limit)}];
    if(![title isEqualToString:@""]) [params setValue:title forKey:@"title"];
    
    [manager GET:[NSString stringWithFormat:@"%@cities", api_domain]
      parameters:params
        progress:nil
         success:^(NSURLSessionDataTask *task, id response) {
             
             if ([response isKindOfClass:[NSArray class]]) {
                 
                 NSMutableArray *cities = [NSMutableArray new];
                 
                 for (int i = 0; i < [response count]; i++) {
                     
                     MACityObject *city = [MACityObject new];
                     [city install:response[i]];
                     
                     [cities addObject:city];
                     
                 }
                 
                 dispatch_async(dispatch_get_main_queue(), ^{
                     
                     success(cities);
                     
                 });
                 
             }else dispatch_async(dispatch_get_main_queue(), ^{
                 
                 error(@"Неизвестная ошибка сервера");
                 
             });
             
         }failure:^(NSURLSessionDataTask *task, NSError *errorRequest) {
             
             dispatch_async(dispatch_get_main_queue(), ^{
                 
                 error(@"Проверьте соединение с интернетом");
                 
             });
             
         }];
    
}

//Получение города по id
+ (void)getCity:(int)cityId
        success:(void (^)(MACityObject *city))success
          error:(void (^)(NSString *message))error{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [manager.requestSerializer setTimeoutInterval:15];
    [manager.requestSerializer setValue:[[MAAuthData get] token] forHTTPHeaderField:@"X-AUTH-TOKEN"];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    [manager GET:[NSString stringWithFormat:@"%@city/%d", api_domain, cityId]
      parameters:nil
        progress:nil
         success:^(NSURLSessionDataTask *task, id response) {
             
             if ([response isKindOfClass:[NSDictionary class]]) {
                 
                 MACityObject *city = [MACityObject new];
                 [city install:response];
                 
                 dispatch_async(dispatch_get_main_queue(), ^{
                     
                     success(city);
                     
                 });
                 
                 
             }else dispatch_async(dispatch_get_main_queue(), ^{
                 
                 error(@"Неизвестная ошибка сервера");
                 
             });
             
         }failure:^(NSURLSessionDataTask *task, NSError *errorRequest) {
             
             dispatch_async(dispatch_get_main_queue(), ^{
                 
                 error(@"Проверьте соединение с интернетом");
                 
             });
             
         }];
    
}

+ (void)getCarMarks:(NSString *)title
               skip:(int)skip
              limit:(int)limit
            success:(void (^)(NSMutableArray *items))success
              error:(void (^)(NSString *message))error{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [manager.requestSerializer setTimeoutInterval:15];
    [manager.requestSerializer setValue:[[MAAuthData get] token] forHTTPHeaderField:@"X-AUTH-TOKEN"];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary:@{@"skip": @(skip), @"limit": @(limit)}];
    if(![title isEqualToString:@""]) [params setValue:title forKey:@"title"];
    
    [manager GET:[NSString stringWithFormat:@"%@carMarks", api_domain]
      parameters:params
        progress:nil
         success:^(NSURLSessionDataTask *task, id response) {
             
             if ([response isKindOfClass:[NSArray class]]) {
                 
                 NSMutableArray *cars = [NSMutableArray new];
                 
                 for (int i = 0; i < [response count]; i++) {
                     
                     MACarObject *car = [MACarObject new];
                     [car install:response[i]];
                     
                     [cars addObject:car];
                     
                 }
                 
                 dispatch_async(dispatch_get_main_queue(), ^{
                     
                     success(cars);
                     
                 });
                 
             }else dispatch_async(dispatch_get_main_queue(), ^{
                 
                 error(@"Неизвестная ошибка сервера");
                 
             });
             
         }failure:^(NSURLSessionDataTask *task, NSError *errorRequest) {
             
             dispatch_async(dispatch_get_main_queue(), ^{
                 
                 error(@"Проверьте соединение с интернетом");
                 
             });
             
         }];
    
}

+ (void)getCarModels:(long)carMarkId
               title:(NSString *)title
                skip:(int)skip
               limit:(int)limit
             success:(void (^)(NSMutableArray *items))success
               error:(void (^)(NSString *message))error{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [manager.requestSerializer setTimeoutInterval:15];
    [manager.requestSerializer setValue:[[MAAuthData get] token] forHTTPHeaderField:@"X-AUTH-TOKEN"];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary:@{@"carMarkId": @(carMarkId), @"skip": @(skip), @"limit": @(limit)}];
    if(![title isEqualToString:@""]) [params setValue:title forKey:@"title"];
    
    [manager GET:[NSString stringWithFormat:@"%@carModels", api_domain]
      parameters:params
        progress:nil
         success:^(NSURLSessionDataTask *task, id response) {
             
             if ([response isKindOfClass:[NSArray class]]) {
                 
                 NSMutableArray *cars = [NSMutableArray new];
                 
                 for (int i = 0; i < [response count]; i++) {
                     
                     MACarObject *car = [MACarObject new];
                     [car install:response[i]];
                     
                     [cars addObject:car];
                     
                 }
                 
                 dispatch_async(dispatch_get_main_queue(), ^{
                     
                     success(cars);
                     
                 });
                 
             }else dispatch_async(dispatch_get_main_queue(), ^{
                 
                 error(@"Неизвестная ошибка сервера");
                 
             });
             
         }failure:^(NSURLSessionDataTask *task, NSError *errorRequest) {
             
             dispatch_async(dispatch_get_main_queue(), ^{
                 
                 error(@"Проверьте соединение с интернетом");
                 
             });
             
         }];
    
}

+ (void)getUserCar:(int)userId
           success:(void (^)(MAUserCarObject *carObject))success
             error:(void (^)(NSString *message))error{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [manager.requestSerializer setTimeoutInterval:15];
    [manager.requestSerializer setValue:[[MAAuthData get] token] forHTTPHeaderField:@"X-AUTH-TOKEN"];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    [manager GET:[NSString stringWithFormat:@"%@user/%d/car", api_domain, userId]
      parameters:nil
        progress:nil
         success:^(NSURLSessionDataTask *task, id response) {
             
             if ([response isKindOfClass:[NSDictionary class]]) {
                 
                 MAUserCarObject *car = [MAUserCarObject new];
                 [car install:response];
                 
                 dispatch_async(dispatch_get_main_queue(), ^{
                     
                     success(car);
                     
                 });
                 
             }else dispatch_async(dispatch_get_main_queue(), ^{
                 
                 error(@"Неизвестная ошибка сервера");
                 
             });
             
         }failure:^(NSURLSessionDataTask *task, NSError *errorRequest) {
             
             dispatch_async(dispatch_get_main_queue(), ^{
                 
                 error(@"Проверьте соединение с интернетом");
                 
             });
             
         }];
    
}

+ (void)userSearch:(NSString *)search
              skip:(int)skip
             limit:(int)limit
           success:(void (^)(NSMutableArray *users))success
             error:(void (^)(NSString *message))error{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [manager.requestSerializer setTimeoutInterval:15];
    [manager.requestSerializer setValue:[[MAAuthData get] token] forHTTPHeaderField:@"X-AUTH-TOKEN"];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    [manager GET:[NSString stringWithFormat:@"%@user/search", api_domain]
      parameters:@{
                   @"search":[NSString stringWithFormat:@"%@", search],
                   @"skip":@(skip),
                   @"limit":@(limit)
                   }
        progress:nil
         success:^(NSURLSessionDataTask *task, id response) {
             
             if ([response isKindOfClass:[NSArray class]]) {
                 
                 NSMutableArray *userList = [NSMutableArray new];
                 
                 for (NSDictionary *user in response)
                     [userList addObject:[[MAUserObject new] install:user]];
                 
                 dispatch_async(dispatch_get_main_queue(), ^{
                     
                     success(userList);
                     
                 });
                 
             } else dispatch_async(dispatch_get_main_queue(), ^{
                 
                 error(@"Неизвестная ошибка сервера");
                 
             });
             
         }failure:^(NSURLSessionDataTask *task, NSError *errorRequest) {
             
             NSLog(@"%@",errorRequest);
             
             dispatch_async(dispatch_get_main_queue(), ^{
                 
                 error(@"Проверьте соединение с интернетом");
                 
             });
             
         }];
    
}

+ (void)editUserPhotos:(NSString *)fileName
                remove:(BOOL)remove
               success:(void (^)(void))success
                 error:(void (^)(NSString *message))error{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [manager.requestSerializer setTimeoutInterval:15];
    [manager.requestSerializer setValue:[[MAAuthData get] token] forHTTPHeaderField:@"X-AUTH-TOKEN"];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    [manager POST:[NSString stringWithFormat:@"%@user/%@", api_domain, remove ? @"removePhoto" : @"addPhoto"]
       parameters:@{@"fileName":fileName}
         progress:nil
          success:^(NSURLSessionDataTask *task, id response) {
              
              if ([response[@"status"] isEqualToString:@"OK"]) {
                  
                  dispatch_async(dispatch_get_main_queue(), ^{
                      
                      success();
                      
                  });
                  
              } else dispatch_async(dispatch_get_main_queue(), ^{
                  
                  error(@"Неизвестная ошибка сервера");
                  
              });
              
          }failure:^(NSURLSessionDataTask *task, NSError *errorRequest) {
              
              NSLog(@"%@",errorRequest);
              
              dispatch_async(dispatch_get_main_queue(), ^{
                  
                  error(@"Проверьте соединение с интернетом");
                  
              });
              
          }];
    
}

@end
