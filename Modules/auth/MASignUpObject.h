//
//  MASignUpObject.h
//  Mazda
//
//  Created by Nikita Merkel on 07.02.17.
//  Copyright © 2017 Nikita Merkel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MAClubObject.h"

@interface MASignUpObject : NSObject

@property(strong,nonatomic) NSString *phone;
@property(strong,nonatomic) NSString *nick_name;
@property(strong,nonatomic) NSString *full_name;
@property(strong,nonatomic) MAClubObject *club;

@end
