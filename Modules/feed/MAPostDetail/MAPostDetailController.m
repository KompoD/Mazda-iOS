//
//  MAPostDetailController.m
//  Mazda
//
//  Created by Nikita Merkel on 13.02.17.
//  Copyright © 2017 Nikita Merkel. All rights reserved.
//

#import "MAPostDetailController.h"

@interface MAPostDetailController () {
    
    NSMutableArray *comments;
    
    UIToolbar *toolbar;
    UITextView *messageTextView;
    UIButton *sendButton;
    
    UIButton *commentButton;
    UIButton *likeButton;
    
    UIActivityIndicatorView *spinner;
    UILabel *footer_label;
    
    UIRefreshControl *refreshControl;
    
    MXSegmentedPager *pagerView;
    
    BOOL moreComments;
    int skipComments;
    
}

@end

@implementation MAPostDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    moreComments = YES;
    comments = [NSMutableArray new];
    
    //self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"more"] style:UIBarButtonItemStylePlain target:self action:nil];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardLoyaltyWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardLoyaltyWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self.view action:@selector(endEditing:)]];
    
    toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-45, self.view.frame.size.width, 45)];
    toolbar.translucent = NO;
    toolbar.layer.shadowColor = [[UIColor blackColor] CGColor];
    toolbar.layer.shadowOffset = CGSizeMake(1.0, 2.0);
    toolbar.layer.shadowOpacity = .5;
    toolbar.layer.shadowRadius = 3.0;
    
    messageTextView = [[UITextView alloc] initWithFrame:CGRectMake(5, 5, toolbar.frame.size.width*0.7, 35)];
    messageTextView.font = [UIFont systemFontOfSize:15.0f];
    //textView.textContainerInset = UIEdgeInsetsMake(4.0f, 3.0f, 3.0f, 3.0f);
    messageTextView.placeholder = @"Напишите комментарий...";
    messageTextView.layer.cornerRadius = 4.0f;
    messageTextView.layer.borderColor = separator_color.CGColor;
    messageTextView.layer.borderWidth = 1.0f;
    messageTextView.delegate = self;
    [toolbar addSubview:messageTextView];
    
    sendButton = [UIButton buttonWithType:UIButtonTypeSystem];
    sendButton.frame = CGRectMake(messageTextView.frame.origin.x+messageTextView.frame.size.width, 5, toolbar.frame.size.width-messageTextView.frame.size.width-10, 35);
    [sendButton setTitle:@"Отправить" forState:UIControlStateNormal];
    [sendButton setTitleColor:messageTextView.placeholderColor forState:UIControlStateDisabled];
    [sendButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [sendButton.titleLabel setFont:[UIFont systemFontOfSize:13]];
    [sendButton addTarget:self action:@selector(addComment) forControlEvents:UIControlEventTouchDown];
    sendButton.enabled = NO;
    [toolbar addSubview:sendButton];
    
    UIView *postView = [UIView new];
    
    UIImageView *postImage = [UIImageView new];
    postImage.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.width);
    [postImage setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@images/%@", api_domain, self.feedObject.photo]] placeholderImage:[UIImage imageNamed:@"background"]];
    postImage.clipsToBounds = YES;
    postImage.userInteractionEnabled = YES;
    postImage.contentMode = UIViewContentModeScaleAspectFill;
    [postView addSubview:postImage];
    
    UIColor *topColor = [UIColor colorWithWhite:0 alpha:.5];
    UIColor *bottomColor = [UIColor clearColor];
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.colors = [NSArray arrayWithObjects: (id)topColor.CGColor, (id)bottomColor.CGColor, nil];
    gradient.frame = postImage.bounds;
    gradient.startPoint = CGPointMake(0, 0);
    gradient.endPoint = CGPointMake(0, 0.5);
    [postImage.layer insertSublayer:gradient atIndex:0];
    
    postView.frame = CGRectMake(0, 0, self.view.frame.size.width, postImage.frame.origin.y + postImage.frame.size.height);
    
    UIView *infoView = [UIView new];
    
    UILabel *date = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, self.view.frame.size.width/2 - 20, 15)];
    date.text = [self.feedObject.date timeAgoSinceNow];
    date.textAlignment = NSTextAlignmentLeft;
    date.font = [UIFont systemFontOfSize:13];
    date.textColor = [UIColor grayColor];
    [infoView addSubview:date];
    
    UILabel *geo = [[UILabel alloc] initWithFrame:CGRectMake(date.frame.origin.x + date.frame.size.width, date.frame.origin.y, date.frame.size.width, date.frame.size.height)];
    geo.text = self.feedObject.geo.placeName;
    geo.textAlignment = NSTextAlignmentRight;
    geo.font = [UIFont systemFontOfSize:13];
    geo.textColor = [UIColor grayColor];
    [infoView addSubview:geo];
    
    UIView *firstSeparator = [self separatorAdd: date.frame.origin.x y:date.frame.origin.y + date.frame.size.height + 10 width:self.view.frame.size.width - 40];
    [infoView addSubview:firstSeparator];
    
    
    UITextView *info = [[UITextView alloc] initWithFrame:CGRectMake(date.frame.origin.x, firstSeparator.frame.origin.y + firstSeparator.frame.size.height + 10, self.view.frame.size.width - 40, 18)];
    info.scrollEnabled = NO;
    info.editable = NO;
    info.textContainer.lineFragmentPadding = 0;
    info.textContainerInset = UIEdgeInsetsZero;
    info.tintColor = tint_color;
    info.delegate = self;
    
    NSString *string = [NSString stringWithFormat:@"%@ спалил %@",self.feedObject.who.name,self.feedObject.whom.name];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
    
    [attributedString addAttribute:NSLinkAttributeName
                             value:@"mazda://open.profile"
                             range:NSMakeRange(0, self.feedObject.who.name.length)];
    [attributedString addAttribute:@"tag"
                             value:[NSNumber numberWithInt:self.feedObject.who.id]
                             range:NSMakeRange(0, self.feedObject.who.name.length)];
    [attributedString addAttribute:NSLinkAttributeName
                             value:@"mazda://open.profile"
                             range:NSMakeRange(string.length - self.feedObject.whom.name.length, self.feedObject.whom.name.length)];
    [attributedString addAttribute:@"tag"
                             value:[NSNumber numberWithInt:self.feedObject.whom.id]
                             range:NSMakeRange(string.length - self.feedObject.whom.name.length, self.feedObject.whom.name.length)];
    [attributedString addAttribute:NSFontAttributeName
                             value:[UIFont systemFontOfSize:14]
                             range:NSMakeRange(0,string.length)];
    
    info.attributedText = attributedString;
    [infoView addSubview:info];
    
    UILabel *text = [[UILabel alloc] initWithFrame:CGRectMake(date.frame.origin.x, info.frame.origin.y + info.frame.size.height + 8, self.view.frame.size.width - 40, 20)];
    text.text = self.feedObject.text;
    text.font = [UIFont systemFontOfSize:12];
    text.numberOfLines = 0;
    text.lineBreakMode = NSLineBreakByWordWrapping;
    [text sizeToFit];
    [infoView addSubview:text];
    
    UIView *secondSeparator = [self separatorAdd: date.frame.origin.x y:text.frame.origin.y + text.frame.size.height + 10 width:self.view.frame.size.width - 40];
    [infoView addSubview:secondSeparator];
    
    commentButton = [[UIButton alloc] initWithFrame: CGRectMake(date.frame.origin.x, secondSeparator.frame.origin.y + secondSeparator.frame.size.height + 10, self.view.frame.size.width/4, 20)];
    commentButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [commentButton.titleLabel setFont:[UIFont systemFontOfSize:13]];
    [commentButton setTitleColor:[UIColor lightGrayColor] forState: UIControlStateNormal];
    [commentButton setImage:[UIImage imageNamed:@"comment"] forState:UIControlStateNormal];
    [commentButton setTitle: [self replaceValueCount:self.feedObject.commentsCount] forState:UIControlStateNormal];
    commentButton.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    commentButton.touchAreaInsets = UIEdgeInsetsMake(10, 10, 10, 10);
    [infoView addSubview:commentButton];
    
    likeButton = [[UIButton alloc]initWithFrame: CGRectMake(self.view.frame.size.width - commentButton.frame.origin.x - self.view.frame.size.width/4, commentButton.frame.origin.y, self.view.frame.size.width/4, 20)];
    [likeButton setSelected:!self.feedObject.canLike];
    likeButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [likeButton.titleLabel setFont:[UIFont systemFontOfSize:13]];
    [likeButton setTitleColor:[UIColor lightGrayColor] forState: UIControlStateNormal];
    likeButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
    likeButton.semanticContentAttribute = UISemanticContentAttributeForceRightToLeft;
    [likeButton setImage:[UIImage imageNamed:@"like"] forState:UIControlStateNormal];
    [likeButton setImage:[UIImage imageNamed:@"isLike"] forState:UIControlStateSelected];
    [likeButton setTitle:[self replaceValueCount:self.feedObject.likesCount] forState:UIControlStateNormal];
    [likeButton addTarget:self action:@selector(actionLike) forControlEvents:UIControlEventTouchDown];
    likeButton.touchAreaInsets = UIEdgeInsetsMake(10, 10, 10, 10);
    [infoView addSubview:likeButton];
    
    UIView *thirdSeparator = [self separatorAdd: 0 y:commentButton.frame.origin.y + commentButton.frame.size.height + 10 width:self.view.frame.size.width];
    [infoView addSubview:thirdSeparator];
    
    infoView.frame = CGRectMake(0, postView.frame.origin.y + postView.frame.size.height, self.view.frame.size.width, thirdSeparator.frame.origin.y + thirdSeparator.frame.size.height);
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-toolbar.frame.size.height)];
    [self.tableView setRowHeight:UITableViewAutomaticDimension];
    [self.tableView setEstimatedRowHeight:100.0];
    self.tableView.allowsSelection = NO;
    self.tableView.allowsMultipleSelectionDuringEditing = NO;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [postView sizeToFit];
    self.tableView.tableHeaderView = infoView;
    self.tableView.contentOffset = CGPointMake(0, 20);
    
    pagerView = [[MXSegmentedPager alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-self.navigationController.navigationBar.frame.size.height)];
    pagerView.backgroundColor = [UIColor whiteColor];
    pagerView.delegate = self;
    pagerView.dataSource = self;
    [self.view addSubview:pagerView];
    
    pagerView.parallaxHeader.view = postView;
    pagerView.parallaxHeader.mode = MXParallaxHeaderModeFill;
    pagerView.parallaxHeader.height = postView.frame.size.height;
    pagerView.parallaxHeader.minimumHeight = 70;
    pagerView.bounces = NO;
    
    spinner = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    spinner.frame = CGRectMake(0,0, self.tableView.frame.size.width, 50);
    [spinner startAnimating];
    
    footer_label = [UILabel new];
    footer_label.frame = spinner.bounds;
    footer_label.textAlignment = NSTextAlignmentCenter;
    footer_label.font = [UIFont systemFontOfSize:15];
    footer_label.textColor = [UIColor grayColor];
    
    refreshControl = [[UIRefreshControl alloc]init];
    [refreshControl addTarget:self action:@selector(refreshComments) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:refreshControl];
    
    [self.view addSubview:toolbar];
    
    [self requestComments];
    
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    MANavigationBar *bar = (MANavigationBar *)self.navigationController.navigationBar;
    
    [bar updateTranslucent:YES];
    
}

#pragma mark <MXSegmentedPagerDelegate>

- (CGFloat)heightForSegmentedControlInSegmentedPager:(MXSegmentedPager *)segmentedPager {
    
    return 0;
    
}

#pragma mark <MXSegmentedPagerDataSource>

- (NSInteger)numberOfPagesInSegmentedPager:(MXSegmentedPager *)segmentedPager {
    
    return 1;
    
}

- (UIView *)segmentedPager:(MXSegmentedPager *)segmentedPager viewForPageAtIndex:(NSInteger)index {
    
    return @[self.tableView][index];
    
}

-(BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange{
    
    if ([URL.absoluteString isEqualToString:@"mazda://open.profile"]) {
        
        int userId = [[textView.attributedText attribute:@"tag" atIndex:characterRange.location effectiveRange:&characterRange] intValue];
        
        if(userId) {
            
            MAProfileController *profileController = [MAProfileController new];
            profileController.user_id = userId;
            [self.navigationController pushViewController:profileController animated:YES];
            
        }
        
        return NO;
        
    }
    
    return YES;
    
}

-(void)openProfile:(id)sender {
    
    int userid = 0;
    
    if([sender isKindOfClass:[UITapGestureRecognizer class]])
        userid = (int)[(UITapGestureRecognizer *)sender view].tag;
    
    MAProfileController *profile = [MAProfileController new];
    profile.user_id = userid;
    
    profile.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:profile animated:YES];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return comments.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MADetailViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MADetailViewCell"];
    
    if (cell == nil) cell = [[MADetailViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"MADetailViewCell"];
    
    MACommentObject *object = comments[indexPath.row];
    
    [cell.nick setText:object.author.name];
    
    [cell.message setText:object.text];
    
    if(![object.author.avatar isEqualToString:@""]) [cell.avatar setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@images/%@",api_domain,object.author.avatar]] placeholderImage:[UIImage imageNamed:@"avatar_placeholder"]];
    else [cell.avatar setImage:[UIImage imageNamed:@"avatar_placeholder"]];
    
    [cell.avatar setTag:object.author.id];
    
    UITapGestureRecognizer *userTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openProfile:)];
    [userTap setNumberOfTapsRequired:1];
    [cell.avatar addGestureRecognizer:userTap];
    
    [cell.lastSeen setText:[object.date timeAgoSinceNow]];
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MACommentObject *object = comments[indexPath.row];
    
    return (object.author.id == [[MAAuthData get] user_id]) ? YES : NO;
    
}

-(NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal
                                                                            title:@"Удалить"
                                                                          handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
                                                                              
                                                                              [self removeComment:indexPath];
                                                                              
                                                                          }];
    
    deleteAction.backgroundColor = tint_color;
    
    return @[deleteAction];
    
}

- (void)scrollViewDidScroll:(UIScrollView *)aScrollView{
    
    CGPoint offset = aScrollView.contentOffset;
    CGRect bounds = aScrollView.bounds;
    CGSize size = aScrollView.contentSize;
    UIEdgeInsets inset = aScrollView.contentInset;
    float y = offset.y + bounds.size.height - inset.bottom;
    float h = size.height;
    float reload_distance = 10;
    if((y > h + reload_distance) && (moreComments & (comments.count>0))) {
        
        skipComments = (int)comments.count;
        [self requestComments];
        
    }
    
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, .2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        
        if (messageTextView.text.length >= 1) sendButton.enabled = YES;
        else sendButton.enabled = NO;
        
    });
    
    return YES;
    
}

- (void)keyboardLoyaltyWillShow:(NSNotification *)notification {
    
    CGSize kbSize = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    pagerView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-self.navigationController.navigationBar.frame.size.height-kbSize.height);
    
    toolbar.frame = CGRectMake(0, self.view.frame.size.height-kbSize.height-45, self.view.frame.size.width, 45);
    
}

- (void)keyboardLoyaltyWillHide:(NSNotification *)notification {
    
    pagerView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-self.navigationController.navigationBar.frame.size.height);
    
    toolbar.frame = CGRectMake(0, self.view.frame.size.height-45, self.view.frame.size.width, 45);
    
}

-(void)requestComments {
    
    moreComments = NO;
    
    self.tableView.tableFooterView = spinner;
    
    [MARequests getSmokeComments:self.feedObject.id
                            skip:skipComments
                           limit:10
                         success:^(NSMutableArray *items) {
                             
                             if (items.count == 0 && skipComments == 0) {
                                 
                                 footer_label.text = @"Нет комментариев";
                                 self.tableView.tableFooterView = footer_label;
                                 
                             } else {
                                 
                                 if(items.count == 10) moreComments = YES;
                                 
                                 for (int i = 0; i < items.count; i++) [comments addObject:items[i]];
                                 
                                 self.tableView.tableFooterView = nil;
                                 [self.tableView reloadData];
                                 
                             }
                             
                             skipComments = (int)comments.count;
                             
                             [refreshControl endRefreshing];
                             
                         } error:^(NSString *message) {
                             
                             moreComments = YES;
                             
                             footer_label.text = message;
                             self.tableView.tableFooterView = footer_label;
                             
                             [comments removeAllObjects];
                             [refreshControl endRefreshing];
                             [self.tableView reloadData];
                             
                         }];
    
}

-(void)refreshComments {
    
    moreComments = YES;
    skipComments = 0;
    
    if(comments.count > 0) [comments removeAllObjects];
    
    [self requestComments];
    
}

-(void)addComment{
    
    [self.view endEditing:YES];
    
    [SVProgressHUD show];
    
    [MARequests addSmokeComment:self.feedObject.id
                           text:[NSString stringWithFormat:@"%@",messageTextView.text]
                        success:^{
                            
                            [messageTextView setText:@""];
                            
                            sendButton.enabled = NO;
                            
                            [self refreshComments];
                            
                            self.feedObject.commentsCount++;
                            [commentButton setTitle:[self replaceValueCount:self.feedObject.commentsCount] forState:UIControlStateNormal];
                            
                            [SVProgressHUD dismiss];
                            
                        } error:^(NSString *message) {
                            
                            [SVProgressHUD showErrorWithStatus:message];
                            
                        }];
    
}

-(void)removeComment:(NSIndexPath *)indexPath{
    
    [SVProgressHUD show];
    
    MACommentObject *comment = comments[indexPath.row];
    
    [MARequests removeSmokeComment:comment.id
                           success:^{
                               
                               [comments removeObjectAtIndex:indexPath.row];
                               [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
                               
                               [self refreshComments];
                               
                               self.feedObject.commentsCount--;
                               [commentButton setTitle:[self replaceValueCount:self.feedObject.commentsCount] forState:UIControlStateNormal];
                               
                               [SVProgressHUD dismiss];
                               
                           } error:^(NSString *message) {
                               
                               [SVProgressHUD showErrorWithStatus:message];
                               
                           }];
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
    
}

-(void)actionLike{
    
    self.feedObject.likesCount = self.feedObject.likesCount + (self.feedObject.canLike ? 1 : - 1);
    
    likeButton.selected = self.feedObject.canLike;
    
    self.feedObject.canLike = !likeButton.selected;
    
    [likeButton setTitle:[self replaceValueCount:self.feedObject.likesCount] forState:UIControlStateNormal];
    
    [MARequests likeAction:self.feedObject.id
                    isUser:NO
                      like:likeButton.selected
                   success:^{
                       
                       NSLog(@"likeAction - success");
                       
                   }
                     error:^(NSString *message) {
                         
                         NSLog(@"likeAction - error (%@)",message);
                         
                     }];
    
}

-(UIView*)separatorAdd:(float)x
                     y:(float)y
                 width:(float)width {
    
    UIView *separatorLine = [UIView new];
    separatorLine.frame = CGRectMake(x, y, width, 0.5);
    separatorLine.backgroundColor = separator_color;
    
    return separatorLine;
}

-(NSString *)replaceValueCount:(int)count{
    
    return count > 0 ? [NSString stringWithFormat:@"%d",count] : nil;
    
}

@end


@implementation MADetailViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self){
        
        self.backgroundColor = [UIColor whiteColor];
        
        self.avatar = [UIImageView new];
        [self.avatar setTranslatesAutoresizingMaskIntoConstraints:NO];
        self.avatar.clipsToBounds = YES;
        self.avatar.contentMode = UIViewContentModeScaleAspectFill;
        self.avatar.layer.cornerRadius = 25;
        self.avatar.userInteractionEnabled = YES;
        [self addSubview:self.avatar];
        
        self.nick = [UILabel new];
        [self.nick setTranslatesAutoresizingMaskIntoConstraints:NO];
        self.nick.textAlignment = NSTextAlignmentLeft;
        self.nick.font = [UIFont boldSystemFontOfSize:13];
        self.nick.textColor = [UIColor blackColor];
        [self addSubview:self.nick];
        
        self.message = [UILabel new];
        [self.message setTranslatesAutoresizingMaskIntoConstraints:NO];
        self.message.textAlignment = NSTextAlignmentLeft;
        self.message.font = [UIFont systemFontOfSize:13];
        self.message.numberOfLines = 0;
        self.message.lineBreakMode = NSLineBreakByWordWrapping;
        [self.message sizeToFit];
        [self addSubview:self.message];
        
        self.lastSeen = [UILabel new];
        [self.lastSeen setTranslatesAutoresizingMaskIntoConstraints:NO];
        self.lastSeen.textAlignment = NSTextAlignmentLeft;
        self.lastSeen.font = [UIFont systemFontOfSize:13];
        self.lastSeen.textColor = [UIColor lightGrayColor];
        [self addSubview:self.lastSeen];
        
        self.separatorLine = [UIView new];
        [self.separatorLine setTranslatesAutoresizingMaskIntoConstraints:NO];
        self.separatorLine.backgroundColor = separator_color;
        [self addSubview:self.separatorLine];
        
        NSDictionary *viewsDictionary = @{@"avatar":self.avatar,
                                          @"nick":self.nick,
                                          @"message":self.message,
                                          @"lastSeen":self.lastSeen,
                                          @"separator":self.separatorLine};
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(10)-[avatar(50)]-[nick]-(10)-|" options:0 metrics:nil views:viewsDictionary]];
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[avatar]-[message]-(10)-|" options:0 metrics:nil views:viewsDictionary]];
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[avatar]-[lastSeen]-(10)-|" options:0 metrics:nil views:viewsDictionary]];
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[avatar]-[separator]|" options:0 metrics:nil views:viewsDictionary]];
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(5)-[avatar(==50)]-(>=5)-|" options:0 metrics:nil views:viewsDictionary]];
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(5)-[nick]-(2)-[message(>=20)]-(2)-[lastSeen]-(5)-[separator(==1)]|" options:0 metrics:nil views:viewsDictionary]];
        
    }
    
    return self;
}

@end
