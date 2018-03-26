//
//  MAProfileObject.h
//  Mazda
//
//  Created by Nikita Merkel on 07.02.17.
//  Copyright © 2017 Nikita Merkel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Catalog.h"

@interface MAProfileObject : NSObject

@property(nonatomic) int id;
@property(strong,nonatomic) NSString *nickName;
@property(strong,nonatomic) NSString *fullName;
@property(strong,nonatomic) NSString *avatar;
@property(strong,nonatomic) NSMutableArray *carPhotos;
@property(nonatomic) int clubId;
@property(nonatomic) int cityId;
@property(nonatomic) int smokeTo;
@property(nonatomic) int smokeFrom;
@property(nonatomic) int liked;
@property(nonatomic) bool canLike;
@property(nonatomic) int carModel;
@property(nonatomic) int carYear;
@property(strong,nonatomic) NSString *regNumber;

-(id)install:(NSDictionary *)data;

@end
