//
//  MARatingObject.h
//  Mazda
//
//  Created by Nikita Merkel on 25.03.17.
//  Copyright © 2017 Nikita Merkel. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MARatingObject : NSObject

@property (strong, nonatomic) NSString *avatar;
@property (strong, nonatomic) NSString *nickName;
@property (nonatomic) int position;
@property (nonatomic) int shift;
@property (nonatomic) int smokeFrom;
@property (nonatomic) int userId;

-(id)install:(NSDictionary *)data;

@end
