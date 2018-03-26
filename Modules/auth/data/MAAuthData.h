//
//  MAAuthData.h
//  Mazda
//
//  Created by Nikita Merkel on 24.05.17.
//  Copyright © 2017 Nikita Merkel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MAProfileObject.h"

@class MAProfileObject;

@interface MAAuthData : NSObject

@property(strong,nonatomic) NSString *token;
@property(nonatomic) int club_id;
@property(nonatomic) int user_id;
@property(nonatomic) BOOL stealth;

@property(strong,nonatomic) NSString *nickname;
@property(strong,nonatomic) NSString *avatar;

+ (MAAuthData *)get;

- (NSDictionary *)data;

+ (BOOL)isAuth;

+ (void)setToken:(NSString *)token;

+ (void)setFromProfile:(MAProfileObject *)profile;

+ (void)setStealth:(BOOL)stealth;

+ (void)clear;

@end
