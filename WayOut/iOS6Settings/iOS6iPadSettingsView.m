//
//  iOS6iPadSettingsView.m
//  WayOut
//
//  Created on 04/09/17.
//
//

#import "iOS6iPadSettingsView.h"

@implementation iOS6iPadSettingsView {
    
    UIView *darkLayer;
    UIView *superview;
    
    CGFloat normalYPosition;
    CGFloat shadowOffset;
    
    UITableView *table;
    int sectionCount;
    CellsInitialization *cells;
    
}


- (instancetype)init {
    
    self = [super init];
    
    superview = [[[[[UIApplication sharedApplication] delegate] window] rootViewController] view];
    
    normalYPosition = 1017;
    shadowOffset = 21;
    
    UIImage *linen = [UIImage imageNamed:@"LinenSettings"];
    [self setFrame:CGRectMake(93, normalYPosition, linen.size.width, linen.size.height)];
    
    CALayer *baseLayer = [CALayer layer];
    baseLayer.frame = CGRectMake(0, 0, linen.size.width, linen.size.height);
    baseLayer.backgroundColor = [UIColor clearColor].CGColor;
    baseLayer.contents = (id)linen.CGImage;
    baseLayer.shadowColor = [UIColor blackColor].CGColor;
    baseLayer.shadowRadius = 10;
    baseLayer.shadowOpacity = 1;
    baseLayer.shadowOffset = CGSizeMake(0, 0);
    baseLayer.shouldRasterize = YES;
    baseLayer.rasterizationScale = [[UIScreen mainScreen] scale];
    [self.layer addSublayer:baseLayer];
    
    darkLayer = [[UIView alloc] init];
    [darkLayer setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.6]];
    [darkLayer setFrame:[[UIScreen mainScreen] bounds]];
    
    table = [[UITableView alloc] initWithFrame:CGRectMake(shadowOffset, shadowOffset, linen.size.width-shadowOffset*2, linen.size.height-shadowOffset*2) style:UITableViewStyleGrouped];
    table.delegate = self;
    table.dataSource = self;
    table.backgroundView = nil;
    table.backgroundColor = [UIColor clearColor];
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    table.separatorColor = [[UIColor blackColor] colorWithAlphaComponent:0.25];
    table.contentInset = UIEdgeInsetsMake(49, 0, 0, 0);
    [self addSubview:table];

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
    
    
    
    if ([ImageValidation isMultiKloaderNeeded]) {
        sectionCount = 3;
    } else {
        sectionCount = 2;
    }
    
    cells = [[CellsInitialization alloc] initCellsWithTableViewWidth:table.frame.size.width delegate:self];
    
    return self;
}

- (void)show {
    
    [superview addSubview:darkLayer];
    [superview addSubview:self];
    CGRect frame = self.frame;
    frame.origin.y = 152;
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{[self setFrame:frame];} completion:nil];
    
}

- (void)dismiss {
    
    [self endEditing:YES];
    [darkLayer removeFromSuperview];
    CGRect frame = self.frame;
    frame.origin.y = normalYPosition;
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{[self setFrame:frame];} completion:nil];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{[self removeFromSuperview];});
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return sectionCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        return 1;
    } else {
        return 3;
    }
}

#pragma mark - Setting up header

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        return nil;
    }
    else if (section == 1) {
        
        return cells.image1Header;
        
    } else {
        
        return cells.image2Header;
        
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    
    if (section == 0) {
        return cells.multi_kloaderHeaderHeight;
    } else {
        return cells.image1Header.frame.size.height;
    }
    
}

#pragma mark - Setting up footer

- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    if (section == 0) {
        return cells.multi_kloaderFooter;
    }
    else {
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    if (section == 0) {
        return cells.multi_kloaderFooter.frame.size.height;
    } else {
        
        return cells.nullFooterHeight;
    }
}

#pragma mark - Setting up cells

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.section) {
        case 0:
            return cells.multi_kloaderCell;
            break;
            
        case 1:
            
            switch (indexPath.row) {
                case 0:
                    return cells.path1Cell;
                    break;
                    
                case 1:
                    return cells.type1Cell;
                    break;
                    
                case 2:
                    return cells.version1Cell;
                    break;
            }
            
        case 2:
            
            switch (indexPath.row) {
                case 0:
                    return cells.path2Cell;
                    break;
                    
                case 1:
                    return cells.type2Cell;
                    break;
                    
                case 2:
                    return cells.version2Cell;
                    break;
            }
            
            
            break;
            
            break;
    }
    
    return nil;
}

- (void)didSwitchValueChanged:(BOOL)value {
    
    [[NSUserDefaults standardUserDefaults] setBool:value forKey:@"multi_kloader"];
    
    if (value) {
        if (sectionCount == 2) {
            sectionCount += 1;
            [table insertSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationFade];
        }
    } else {
        if (sectionCount == 3) {
            sectionCount += -1;
            [table deleteSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationFade];
        }
    }
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}


@end