//
//  MACarPhotos.m
//  Mazda
//
//  Created by Nikita Merkel on 19.04.17.
//  Copyright © 2017 Nikita Merkel. All rights reserved.
//

#import "MACarPhotos.h"

@implementation MACarPhotosCell

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        CGRect frame = self.contentView.frame;
        frame = CGRectMake(5, 5, frame.size.width-10, frame.size.height-10);
        
        self.image_view = [[UIImageView alloc] initWithFrame:frame];
        self.image_view.contentMode = UIViewContentModeScaleAspectFit;
        self.image_view.clipsToBounds = YES;
        self.image_view.layer.cornerRadius = frame.size.width*.05;
        [self.contentView addSubview:self.image_view];
        
        self.delete_button = [[UIButton alloc] initWithFrame:CGRectMake(self.image_view.frame.size.width - 25, self.image_view.frame.size.height - 25, 25, 25)];
        self.delete_button.backgroundColor = [UIColor whiteColor];
        self.delete_button.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
        self.delete_button.layer.cornerRadius = self.delete_button.frame.size.height/2;
        [self.delete_button setImage:[UIImage imageNamed:@"deletePhoto"] forState:UIControlStateNormal];
        [self.contentView addSubview:self.delete_button];
        
    }
    
    return self;
}

@end

@implementation MACarPhotos

-(id)initWithFrame:(CGRect)frame collectionViewLayout:(nonnull UICollectionViewLayout *)layout{
    
    self = [super initWithFrame:frame collectionViewLayout:layout];
    
    if (self)[self install];
    
    return self;
    
}

-(void)install{
    
    self.backgroundColor = [UIColor clearColor];
    self.delegate = self;
    self.dataSource = self;
    self.showsHorizontalScrollIndicator = NO;
    self.clipsToBounds = NO;
    self.contentInset = UIEdgeInsetsMake(0, 12, 0, 00);
    
    UICollectionViewFlowLayout *layout =  [UICollectionViewFlowLayout new];
    layout.sectionInset = UIEdgeInsetsMake(14, 12, 14, 12);
    layout.minimumLineSpacing = 12;
    layout.minimumInteritemSpacing = 12;
    layout.itemSize = CGSizeMake(self.frame.size.height, self.frame.size.height);
    layout.headerReferenceSize = CGSizeMake(self.frame.size.height/3, self.frame.size.height/3);
    [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    
    [self setCollectionViewLayout:layout];
    [self registerClass:[MACarPhotosCell class] forCellWithReuseIdentifier:@"MACarPhotosCell"];
    [self registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"MAHeaderView"];
    
}

-(void)update:(NSMutableArray *)images{
    
    self.items = images;
    
    [self reloadData];
    
}

-(void)insertPhoto:(NSString *)imageName{
    
    [self performBatchUpdates:^{
        
        [self.items insertObject:imageName atIndex:0];
        [self insertItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:0 inSection:0]]];
        
    } completion:nil];
    
}

#pragma mark <UICollectionViewDataSource>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.items.count;
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    MACarPhotosCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MACarPhotosCell" forIndexPath:indexPath];
    
    NSString *imageName = [self.items objectAtIndex:indexPath.row];
    
    cell.layer.shouldRasterize = YES;
    cell.layer.rasterizationScale = [UIScreen mainScreen].scale;
    
    [cell.image_view setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@images/%@",api_domain,imageName]]];
    
    cell.delete_button.tag = indexPath.row;
    [cell.delete_button addTarget:self action:@selector(deletePhoto:) forControlEvents:UIControlEventTouchDown];
    
    return cell;
}

- (void)deletePhoto:(id)sender {
    
    if([sender isKindOfClass:[UIButton class]]) {
        
        UIButton *button = (UIButton *)sender;
        
        int index = (int)button.tag;
        
        NSString *imageName = [self.items objectAtIndex:index];
        
        [SVProgressHUD show];
        
        [MARequests editUserPhotos:imageName
                            remove:YES
                           success:^{
                               
                               [SVProgressHUD dismiss];
                               
                               [self performBatchUpdates:^{
                                   
                                   [self deleteItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]]];
                                   [self.items removeObjectAtIndex:index];
                                   
                               } completion:nil];
                               
                           } error:^(NSString *message) {
                               
                               [SVProgressHUD showErrorWithStatus:message];
                               
                           }];
        
    }
    
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    if (kind == UICollectionElementKindSectionHeader) {
        
        UICollectionReusableView *reusableview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"MAHeaderView" forIndexPath:indexPath];
        
        if (reusableview == nil) {
            reusableview = [[UICollectionReusableView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.height/3, self.frame.size.height/3)];
        }
        
        UIButton *add = [[UIButton alloc] initWithFrame:CGRectMake(0, self.frame.size.height/3, self.frame.size.height/3, self.frame.size.height/3)];
        add.backgroundColor = [UIColor whiteColor];
        add.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
        add.layer.cornerRadius = add.frame.size.height/2;
        add.layer.borderWidth = 1.0;
        add.layer.borderColor = [[UIColor colorWithRed:202/225.0f green:202/225.0f blue:202/225.0f alpha:1] CGColor];
        [add setImage:[UIImage imageNamed:@"addPhoto"] forState:UIControlStateNormal];
        [add addTarget:self action:@selector(selectPhoto) forControlEvents:UIControlEventTouchDown];
        [reusableview addSubview:add];
        
        return reusableview;
        
    }
    
    return nil;
    
}

-(void)selectPhoto {
    
    if ([self.photosDelegate respondsToSelector:@selector(addCarPhoto)]){
        
        [self.photosDelegate addCarPhoto];
        
    }
    
}

@end
