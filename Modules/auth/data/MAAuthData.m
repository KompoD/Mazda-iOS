//
//  MAAuthData.m
//  Mazda
//
//  Created by Nikita Merkel on 24.05.17.
//  Copyright © 2017 Nikita Merkel. All rights reserved.
//

#import "MAAuthData.h"

@implementation MAAuthData

-(id)init{
    
    self = [super init];
    
    if (self) {
        
        self.token = @"";
        
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"data:token"] isKindOfClass:[NSString class]]) {
            
            self.token = [[NSUserDefaults standardUserDefaults] objectForKey:@"data:token"];
            
        }
        
        if ([[NSUserDefaults standardUserDefaults] integerForKey:@"data:club_id"]) {
            
            self.club_id = (int)[[NSUserDefaults standardUserDefaults] integerForKey:@"data:club_id"];
            
        }
        
        if ([[NSUserDefaults standardUserDefaults] integerForKey:@"data:user_id"]) {
            
            self.user_id = (int)[[NSUserDefaults standardUserDefaults] integerForKey:@"data:user_id"];
            
        }
        
        self.nickname = @"";
        
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"data:nickname"] isKindOfClass:[NSString class]]) {
            
            self.nickname = [[NSUserDefaults standardUserDefaults] objectForKey:@"data:nickname"];
            
        }
        
        self.avatar = @"";
        
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"data:avatar"] isKindOfClass:[NSString class]]) {
            
            self.avatar = [[NSUserDefaults standardUserDefaults] objectForKey:@"data:avatar"];
            
        }
        
        self.stealth = [[NSUserDefaults standardUserDefaults] boolForKey:@"data:stealth"];
        
    }
    
    return self;
    
}

- (NSDictionary *)data{
    
    return @{@"token":self.token,@"club_id":@(self.club_id)};
    
}

+ (MAAuthData *)get{
    
    MAAuthData *data = [MAAuthData new];
    
    return data;
    
}

+ (BOOL)isAuth{
    
    BOOL isAuth = [[NSUserDefaults standardUserDefaults] objectForKey:@"data:token"] ? YES : NO;
    
    return isAuth;
    
}

+ (void)setToken:(NSString *)token{
    
    if (token.length > 0) [[NSUserDefaults standardUserDefaults] setObject:token forKey:@"data:token"];
    
}

+ (void)setFromProfile:(MAProfileObject *)profile{
    
    if (profile.clubId) [[NSUserDefaults standardUserDefaults] setInteger:profile.clubId forKey:@"data:club_id"];
    
    if (profile.id) [[NSUserDefaults standardUserDefaults] setInteger:profile.id forKey:@"data:user_id"];
    
    if (profile.avatar.length > 0) [[NSUserDefaults standardUserDefaults] setObject:profile.avatar forKey:@"data:avatar"];
    
    if (profile.nickName.length > 0) [[NSUserDefaults standardUserDefaults] setObject:profile.nickName forKey:@"data:nickname"];
    
}

+ (void)setStealth:(BOOL)stealth{
    
    [[NSUserDefaults standardUserDefaults] setBool:stealth forKey:@"data:stealth"];
    
}

+ (void)clear {
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"data:token"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"data:club_id"];
    
}

@end
