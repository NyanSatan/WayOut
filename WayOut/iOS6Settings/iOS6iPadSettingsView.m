//
//  iOS6iPadSettingsView.m
//  WayOut
//
//  Created on 04/09/17.
//
//

#import "iOS6iPadSettingsView.h"

@implementation iOS6iPadSettingsView {
    
    CGSize screenSize;
    
    UIView *darkLayer;
    UIView *superview;
    
    CGFloat normalYPosition;
    CGFloat shadowOffset;
    
    UITableView *table;
    UIImage *scrollImage;
    
    SettingsTableViewSingleton *cells;
}


- (instancetype)init {
    
    self = [super init];
    
    int iOSVersion = [[[UIDevice currentDevice] systemVersion] intValue];
    
    screenSize = [[UIScreen mainScreen] bounds].size;
    
    superview = [[[[[UIApplication sharedApplication] delegate] window] rootViewController] view];
    
    normalYPosition = 1017;
    shadowOffset = 21;
    
    UIImage *linen = [UIImage imageNamed:@"LinenSettings"];
    [self setFrame:CGRectMake(93, normalYPosition, linen.size.width, linen.size.height)];
    
    CALayer *baseLayer = [CALayer layer];
    baseLayer.frame = CGRectMake(0, 0, linen.size.width, linen.size.height);
    baseLayer.backgroundColor = [UIColor clearColor].CGColor;
    baseLayer.contents = (id)linen.CGImage;
    [self.layer addSublayer:baseLayer];
    
    darkLayer = [[UIView alloc] init];
    [darkLayer setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.5]];
    [darkLayer setFrame:[[UIScreen mainScreen] bounds]];
    
    table = [[UITableView alloc] initWithFrame:CGRectMake(shadowOffset, shadowOffset, linen.size.width-shadowOffset*2, linen.size.height-shadowOffset*2) style:UITableViewStyleGrouped];
    table.delegate = self;
    table.dataSource = self;
    table.backgroundView = nil;
    table.backgroundColor = [UIColor clearColor];
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    table.separatorColor = [[UIColor blackColor] colorWithAlphaComponent:0.25];
    table.contentInset = UIEdgeInsetsMake(49, 0, 0, 0);
    table.scrollIndicatorInsets = UIEdgeInsetsMake(44, 0, 0, iOSVersion > 7 ? -2 : -1);
    [self addSubview:table];
    
    scrollImage = [[UIImage imageNamed:@"UIScrollerIndicatorDefault"] resizableImageWithCapInsets:UIEdgeInsetsMake(3, 0, 3, 0)];

    UIImage *navigationBarBackground = [UIImage imageNamed:@"UINavigationBarBlackTranslucentBackground"];
    UINavigationBar *navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(shadowOffset, shadowOffset, table.frame.size.width, navigationBarBackground.size.height)];
    [navigationBar setBackgroundImage:navigationBarBackground forBarMetrics:UIBarMetricsDefault];
    [navigationBar setShadowImage:[UIImage imageNamed:@"UINavigationBarShadow"]];
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:navigationBar.bounds byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerTopRight) cornerRadii:CGSizeMake(5.0, 5.0)];
    CAShapeLayer *navigationBarMask = [[CAShapeLayer alloc] init];
    navigationBarMask.frame = navigationBar.bounds;
    navigationBarMask.path  = maskPath.CGPath;
    
    navigationBar.layer.mask = navigationBarMask;
    navigationBar.layer.masksToBounds = YES;
    
    UINavigationItem *navigationItem = [[UINavigationItem alloc] init];
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 24)];
    title.text = @"Settings";
    title.textColor = [UIColor whiteColor];
    title.textAlignment = NSTextAlignmentCenter;
    title.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:20];
    title.shadowColor = [UIColor blackColor];
    title.shadowOffset = CGSizeMake(0, -1);
    [navigationItem setTitleView:title];
    
    UIImage *saveImage = [[UIImage imageNamed:@"UINavigationBarDoneButtonDark"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 5, 0, 5)];
    UIButton *saveButtonPrototype = [UIButton buttonWithType:UIButtonTypeCustom];
    [saveButtonPrototype setFrame:CGRectMake(0, 0, 48, saveImage.size.height)];
    [saveButtonPrototype setBackgroundImage:saveImage forState:UIControlStateNormal];
    [saveButtonPrototype setTitle:@"Save" forState:UIControlStateNormal];
    [saveButtonPrototype.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:12]];
    [saveButtonPrototype.titleLabel setTextColor:[UIColor whiteColor]];
    [saveButtonPrototype setTitleShadowColor:[[UIColor blackColor] colorWithAlphaComponent:0.33] forState:UIControlStateNormal];
    [saveButtonPrototype.titleLabel setShadowOffset:CGSizeMake(0, -1)];
    [saveButtonPrototype addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithCustomView:saveButtonPrototype];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSpacer.width = -11;
    navigationItem.rightBarButtonItems = @[negativeSpacer, saveButton];
    navigationBar.items = @[navigationItem];
    
    [self addSubview:navigationBar];

    
    cells = [[SettingsTableViewSingleton alloc] initWithTableWidth:table.frame.size.width delegate:self];
    
    return self;
}

- (void)show {
    
    [superview addSubview:darkLayer];
    [superview addSubview:self];
    CGRect frame = self.frame;
    frame.origin.y = 152;
    [UIView animateWithDuration:0.35 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{[self setFrame:frame];} completion:nil];
    
}

- (void)dismiss {
    
    [self endEditing:YES];
    [darkLayer removeFromSuperview];
    CGRect frame = self.frame;
    frame.origin.y = normalYPosition;
    [UIView animateWithDuration:0.35 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{[self setFrame:frame];} completion:nil];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.35 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{[self removeFromSuperview];});
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return cells.sectionCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [cells getRowCountForSection:section];
}

#pragma mark - Setting up header

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    return [cells getHeaderViewForSection:section];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return [cells getHeaderHeightForSection:section];
}

#pragma mark - Setting up footer

- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    return [cells getFooterViewForSection:section];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return [cells getFooterHeightForSection:section];
}

#pragma mark - Setting up cells

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return [cells getCellForIndexPath:indexPath tableWidth:tableView.frame.size.width cellWidth:cells._cellWidth xPosition:cells._cellXPosition];
}

- (void)didSwitchValueChanged:(BOOL)value {
    
    [[NSUserDefaults standardUserDefaults] setBool:value forKey:@"multi_kloader"];
    
    if (value) {
        if (cells.sectionCount == 3) {
            cells.sectionCount += 1;
            [table insertSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationFade];
        }
    } else {
        if (cells.sectionCount == 4) {
            cells.sectionCount += -1;
            [table deleteSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationFade];
        }
    }
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    for (UIImageView *i in scrollView.subviews) {
        
        if (i.autoresizingMask == UIViewAutoresizingFlexibleLeftMargin) {
            
            [i setImage:scrollImage];
        }
    }
    
}

@end