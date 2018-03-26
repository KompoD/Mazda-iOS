//
//  MAFeedTable.m
//  Mazda
//
//  Created by Nikita Merkel on 14.03.17.
//  Copyright © 2017 Nikita Merkel. All rights reserved.
//

#import "MAFeedTable.h"

@implementation MAFeedTable{
    
    UIActivityIndicatorView *spinner;
    
    UILabel *label;
    
    UIRefreshControl *refreshControl;
    
    BOOL morePosts;
    int skipPosts;
    
}

-(id)initWithUserId:(int)userId
             isFrom:(bool)isFrom {
    
    self = [super init];
    
    if (self)[self install];
    
    self.ownerId = userId;
    self.isUser = YES;
    self.isFrom = isFrom;
    
    return self;
    
}

-(id)initWithClubId:(int)clubId {
    
    self = [super init];
    
    if (self)[self install];
    
    self.ownerId = clubId;
    self.isUser = NO;
    self.isFrom = NO;
    
    return self;
    
}

-(void)install{
    
    morePosts = YES;
    self.sort = @"date";
    
    self.delegate = self;
    self.dataSource = self;
    self.backgroundColor = [UIColor colorWithRed:244/255.0f green:244/255.0f blue:244/255.0f alpha:1.0];
    
    self.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    spinner = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    spinner.frame = CGRectMake(0,0, self.frame.size.width, 50);
    [spinner startAnimating];
    
    refreshControl = [UIRefreshControl new];
    [refreshControl addTarget:self action:@selector(refreshFeed) forControlEvents:UIControlEventValueChanged];
    [self addSubview:refreshControl];
    
    label = [[UILabel alloc] initWithFrame:spinner.bounds];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:15];
    label.textColor = [UIColor grayColor];
    
    self.items = [NSMutableArray new];
    
}

-(void)requestFeed {
    
    if(self.isUser && self.ownerId == 0) self.ownerId = [[MAAuthData get] user_id];
    else if(!self.isUser && self.ownerId == 0) self.ownerId = [[MAAuthData get] club_id];
    
    if(![refreshControl isRefreshing]) self.tableFooterView = spinner;
    
    morePosts = NO;
    
    [MARequests getFeed:self.ownerId
                 isUser:self.isUser
                 params:@{@"isFrom":@(self.isFrom), @"skip":@(skipPosts), @"limit":@10, @"sort":self.sort}
                success:^(NSMutableArray *items) {
                    
                    if (items.count == 0 && skipPosts == 0) {
                        
                        label.text = @"Нет новостей";
                        self.tableFooterView = label;
                        
                    } else {
                        
                        if (items.count > 0 && skipPosts == 0) self.items = [NSMutableArray new];
                        
                        if (items.count == 10) morePosts = YES;
                        
                        for (int i = 0; i < items.count; i++) [self.items addObject:items[i]];
                        
                        self.tableFooterView = nil;
                        
                    }
                    
                    skipPosts = (int)self.items.count;
                    
                    [refreshControl endRefreshing];
                    [self reloadData];
                    
                } error:^(NSString *message) {
                    
                    morePosts = YES;
                    
                    label.text = message;
                    self.tableFooterView = label;
                    
                    [refreshControl endRefreshing];
                    [self reloadData];
                    
                }];
    
    
}

-(void)refreshFeed {
    
    [self setContentOffset:CGPointZero];
    
    morePosts = YES;
    skipPosts = 0;
    
    if(!refreshControl.isRefreshing) {
        [self.items removeAllObjects];
        [self reloadData];
    }
    
    [self requestFeed];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return (145 + self.frame.size.width);
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.items.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MAFeedTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MAFeedTableCell"];
    
    if (cell == nil) cell = [[MAFeedTableCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"MAFeedTableCell"];
    
    MAFeedObject *item = self.items[indexPath.row];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.tag = indexPath.row;
    
    [cell.postText setText:item.text];
    
    [cell.postGeo setText:item.geo.placeName];
    
    [cell.postDate setText:[item.date timeAgoSinceNow]];
    
    
    NSString *string = [NSString stringWithFormat:@"%@ спалил %@",item.who.name,item.whom.name];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
    
    [attributedString addAttribute:NSLinkAttributeName
                             value:@"mazda://open.profile"
                             range:NSMakeRange(0, item.who.name.length)];
    [attributedString addAttribute:@"tag"
                             value:[NSNumber numberWithInt:item.who.id]
                             range:NSMakeRange(0, item.who.name.length)];
    [attributedString addAttribute:NSLinkAttributeName
                             value:@"mazda://open.profile"
                             range:NSMakeRange(string.length - item.whom.name.length, item.whom.name.length)];
    [attributedString addAttribute:@"tag"
                             value:[NSNumber numberWithInt:item.whom.id]
                             range:NSMakeRange(string.length - item.whom.name.length, item.whom.name.length)];
    [attributedString addAttribute:NSFontAttributeName
                             value:[UIFont systemFontOfSize:14]
                             range:NSMakeRange(0,string.length)];
    
    [cell.postInfo setAttributedText:attributedString];
    cell.postInfo.delegate = self;
    
    cell.postImage.image = nil;
    cell.postImage.tag = indexPath.row;
    [cell.activityIndicator setHidden:NO];
    [cell.activityIndicator startAnimating];
    __weak MAFeedTableCell *wcell = cell;
    [cell.postImage setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@images/%@", api_domain,item.photo]]] placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        [wcell.activityIndicator setHidden:YES];
        [wcell.activityIndicator stopAnimating];
        wcell.postImage.image = image;
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        [wcell.activityIndicator setHidden:YES];
        [wcell.activityIndicator stopAnimating];
    }];
    
    [cell.commentButton setTitle: [self replaceValueCount:item.commentsCount] forState:UIControlStateNormal];
    cell.commentButton.tag = indexPath.row;
    [cell.commentButton addTarget:self action:@selector(openDetail: row:) forControlEvents:UIControlEventTouchDown];
    
    [cell.likeButton setTitle:[self replaceValueCount:item.likesCount] forState:UIControlStateNormal];
    cell.likeButton.tag = indexPath.row;
    cell.likeButton.selected = !item.canLike;
    [cell.likeButton addTarget:self action:@selector(postLikeAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [cell.cellTap addTarget:self action:@selector(postOpenAction:)];
    [cell.likeTap addTarget:self action:@selector(postLikeAction:)];
    
    if ((indexPath.row == self.items.count-1 && self.items.count > 0) && morePosts)
        [self requestFeed];
    
    return cell;
    
}

-(void)postOpenAction:(id)sender {
    
    if([sender isKindOfClass:[UIGestureRecognizer class]]) {
        
        UIGestureRecognizer *gesture = (UIGestureRecognizer *)sender;
        
        int index = (int)gesture.view.tag;
        
        [self openDetail:nil row:index];
        
    }
    
}

-(void)postLikeAction:(id)sender {
    
    int index;
    
    if([sender isKindOfClass:[UIButton class]]) {
        
        UIButton *button = (UIButton *)sender;
        
        index = (int)button.tag;
        
    } else if([sender isKindOfClass:[UIGestureRecognizer class]]) {
        
        UIGestureRecognizer *gesture = (UIGestureRecognizer *)sender;
        
        index = (int)gesture.view.tag;
        
        if([self.items[index] canLike]) [SVProgressHUD showImage:[UIImage imageNamed:@"likeAlert"] status:@"Нравится"];
        
    } else return;
    
    [self submitLike:index];
    
}

-(void)submitLike:(int)index{
    
    MAFeedObject *item = [self.items objectAtIndex:index];
    
    item.likesCount = item.likesCount + (item.canLike ? 1 : - 1);
    
    item.canLike = !item.canLike;
    
    [self reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]]
                withRowAnimation:UITableViewRowAnimationNone];
    
    [MARequests likeAction:item.id
                    isUser:NO
                      like:!item.canLike
                   success:^{
                       
                   }
                     error:^(NSString *message) {
                         
                     }];
    
}

-(BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange{
    
    if ([URL.absoluteString isEqualToString:@"mazda://open.profile"]) {
        
        int userId = [[textView.attributedText attribute:@"tag" atIndex:characterRange.location effectiveRange:&characterRange] intValue];
        
        if(userId) {
            
            if (self.feedDelegate && [self.feedDelegate respondsToSelector:@selector(didSelectProfile:)]) {
                [self.feedDelegate didSelectProfile:userId];
            }
            
        }
        
        return NO;
        
    }
    
    return YES;
    
}

-(void)openDetail:(UIButton *)sender row:(int)row{
    
    if (sender) row = (int)sender.tag;
    
    if (self.feedDelegate && [self.feedDelegate respondsToSelector:@selector(didSelectPost:)]) {
        [self.feedDelegate didSelectPost:self.items[row]];
    }
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    if (self.isUser && scrollView.contentOffset.y < -60 && ![refreshControl isRefreshing]) {
        
        [refreshControl beginRefreshing];
        [self refreshFeed];
        
    }
    
}

-(NSString *)replaceValueCount:(int)count{
    
    return count > 0 ? [NSString stringWithFormat:@"%d",count] : nil;
    
}

@end


@implementation MAFeedTableCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        self.postDate = [UILabel new];
        [self addSubview:self.postDate];
        
        self.postGeo = [UILabel new];
        [self addSubview:self.postGeo];
        
        self.postImage = [UIImageView new];
        self.postImage.userInteractionEnabled = YES;
        [self addSubview:self.postImage];
        
        self.postInfo = [UITextView new];
        [self addSubview:self.postInfo];
        
        self.postText = [UILabel new];
        [self addSubview:self.postText];
        
        self.commentButton = [UIButton new];
        [self addSubview:self.commentButton];
        
        self.likeButton = [UIButton new];
        [self addSubview:self.likeButton];
        
        self.separatorLine = [UIView new];
        [self addSubview:self.separatorLine];
        
        self.activityIndicator = [UIActivityIndicatorView new];
        [self addSubview:self.activityIndicator];
        
        self.likeTap = [[UITapGestureRecognizer alloc] init];
        self.likeTap.numberOfTapsRequired = 2;
        [self.postImage addGestureRecognizer:self.likeTap];
        
        self.cellTap = [[UITapGestureRecognizer alloc] init];
        [self.cellTap requireGestureRecognizerToFail:self.likeTap];
        [self addGestureRecognizer:self.cellTap];
        
    }
    
    return self;
}

-(void)layoutSubviews{
    
    [super layoutSubviews];
    
    self.backgroundColor = [UIColor whiteColor];
    
    self.postDate.frame = CGRectMake(20, 15, self.frame.size.width/2 - 20, 15);
    self.postDate.textAlignment = NSTextAlignmentLeft;
    self.postDate.font = [UIFont systemFontOfSize:13];
    self.postDate.textColor = [UIColor grayColor];
    
    self.postGeo.frame = CGRectMake(self.postDate.frame.origin.x + self.postDate.frame.size.width, self.postDate.frame.origin.y, self.postDate.frame.size.width, self.postDate.frame.size.height);
    self.postGeo.textAlignment = NSTextAlignmentRight;
    self.postGeo.font = [UIFont systemFontOfSize:13];
    self.postGeo.textColor = [UIColor grayColor];
    
    self.postImage.frame = CGRectMake(0, self.postGeo.frame.origin.y + self.postGeo.frame.size.height + 13,
                                      self.frame.size.width, self.frame.size.width);
    self.postImage.clipsToBounds = YES;
    self.postImage.contentMode = UIViewContentModeScaleAspectFill;
    self.postImage.backgroundColor = fill_color;
    
    self.postInfo.frame = CGRectMake(self.postDate.frame.origin.x, self.postImage.frame.origin.y + self.postImage.frame.size.height + 15, self.frame.size.width - 40,18);
    self.postInfo.scrollEnabled = NO;
    self.postInfo.editable = NO;
    self.postInfo.textContainer.lineFragmentPadding = 0;
    self.postInfo.textContainerInset = UIEdgeInsetsZero;
    self.postInfo.tintColor = tint_color;
    
    self.postText.frame = CGRectMake(self.postDate.frame.origin.x, self.postInfo.frame.origin.y + self.postInfo.frame.size.height + 10, self.frame.size.width - 40, 15);
    self.postText.font = [UIFont systemFontOfSize:13];
    self.postText.textColor = [UIColor blackColor];
    self.postText.numberOfLines = 1;
    self.postText.lineBreakMode = NSLineBreakByWordWrapping;
    
    self.commentButton.frame = CGRectMake(self.postDate.frame.origin.x, self.postText.frame.origin.y + self.postText.frame.size.height + 10, self.frame.size.width/4, 20);
    self.commentButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self.commentButton.titleLabel setFont:[UIFont systemFontOfSize:13]];
    [self.commentButton setTitleColor:[UIColor lightGrayColor] forState: UIControlStateNormal];
    [self.commentButton setImage:[UIImage imageNamed:@"comment"] forState:UIControlStateNormal];
    self.commentButton.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    self.commentButton.touchAreaInsets = UIEdgeInsetsMake(10, 10, 10, 10);
    
    self.likeButton.frame = CGRectMake(self.frame.size.width - self.postDate.frame.origin.x - self.frame.size.width/4, self.postText.frame.origin.y + self.postText.frame.size.height + 10, self.frame.size.width/4, 20);
    self.likeButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [self.likeButton.titleLabel setFont:[UIFont systemFontOfSize:13]];
    [self.likeButton setTitleColor:[UIColor lightGrayColor] forState: UIControlStateNormal];
    self.likeButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
    self.likeButton.semanticContentAttribute = UISemanticContentAttributeForceRightToLeft;
    [self.likeButton setImage:[UIImage imageNamed:@"like"] forState:UIControlStateNormal];
    [self.likeButton setImage:[UIImage imageNamed:@"isLike"] forState:UIControlStateSelected];
    self.likeButton.touchAreaInsets = UIEdgeInsetsMake(10, 10, 10, 10);
    
    self.separatorLine.frame = CGRectMake(0, self.commentButton.frame.origin.y + self.commentButton.frame.size.height + 10, self.frame.size.width, 7);
    self.separatorLine.backgroundColor = [UIColor colorWithRed:244/255.0f green:244/255.0f blue:244/255.0f alpha:1.0];
    
    self.activityIndicator.frame = self.postImage.frame;
    self.activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
    self.activityIndicator.transform = CGAffineTransformMakeScale(2.0f, 2.0f);
    
}

@end
