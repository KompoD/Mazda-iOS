//
//  MACarPhotos.h
//  Mazda
//
//  Created by Nikita Merkel on 19.04.17.
//  Copyright © 2017 Nikita Merkel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Catalog.h"
#import "MARequests.h"

@protocol MACarPhotosDelegate <NSObject>
@optional
-(void)addCarPhoto;
@end

@interface MACarPhotos : UICollectionView <UICollectionViewDelegate, UICollectionViewDataSource, UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property(strong,nonatomic) NSMutableArray *items;
@property(weak,nonatomic) id <MACarPhotosDelegate> photosDelegate;

-(void)update:(NSMutableArray *)images;
-(void)insertPhoto:(NSString *)imageName;

@end


@interface MACarPhotosCell : UICollectionViewCell

@property(strong,nonatomic) UIImageView *image_view;
@property(strong,nonatomic) UIButton *delete_button;

@end

