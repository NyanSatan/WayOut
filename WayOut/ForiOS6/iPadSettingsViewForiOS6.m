//
//  iPadSettingsViewForiOS6.m
//  WayOut
//
//  Created on 26/08/2017.
//
//

#import "iPadSettingsViewForiOS6.h"

@implementation iPadSettingsViewForiOS6 {
    
    UIView *darkLayer;
    UIView *superview;
    
    CGFloat normalYPosition;
    CGFloat shadowOffset;
    
    UITableView *table;
    
    int iOSVersion;
    
    SettingsTableViewSingleton *cells;
}

- (instancetype)init {
    
    self = [super init];
    
    superview = [[[[[UIApplication sharedApplication] delegate] window] rootViewController] view];
    
    normalYPosition = 997;
    shadowOffset = 21;
    
    iOSVersion = [[[UIDevice currentDevice] systemVersion] intValue];
    
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
    table.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    table.separatorColor = [[UIColor blackColor] colorWithAlphaComponent:0.25];
    table.contentInset = UIEdgeInsetsMake(24, 0, 0, 0);
    table.scrollIndicatorInsets = UIEdgeInsetsMake(44, 0, 0, 0);
    [self addSubview:table];
    
    UINavigationBar *navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(shadowOffset, shadowOffset, table.frame.size.width, 44)];
    navBar.barStyle = UIBarStyleBlackTranslucent;
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:navBar.bounds byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerTopRight) cornerRadii:CGSizeMake(5.0, 5.0)];
    CAShapeLayer *navigationBarMask = [[CAShapeLayer alloc] init];
    navigationBarMask.frame = navBar.bounds;
    navigationBarMask.path  = maskPath.CGPath;
    navBar.layer.mask = navigationBarMask;
    navBar.layer.masksToBounds = YES;
    UINavigationItem *navItem = [[UINavigationItem alloc] initWithTitle:@"Settings"];
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStyleDone target:self action:@selector(dismiss)];
    navItem.rightBarButtonItem = saveButton;
    navBar.items = @[navItem];
    [self addSubview:navBar];
    
    cells = [[SettingsTableViewSingleton alloc] initWithTableWidth:linen.size.width delegate:self];
    
    return self;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return cells.sectionCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [cells getRowCountForSection:section];
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {

    return [cells getHeaderViewForSection:section];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return [cells getHeaderHeightForSection:section];
}

- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {

    return [cells getFooterViewForSection:section];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return [cells getFooterHeightForSection:section];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    return [cells getHeaderTitleStringForSection:section];
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {

    return [cells getFooterTitleStringForSection:section];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return [cells getCellForIndexPath:indexPath tableWidth:tableView.frame.size.width cellWidth:cells._cellWidth xPosition:cells._cellXPosition];
}

- (void)didSwitchValueChanged:(BOOL)value {
    
    [[NSUserDefaults standardUserDefaults] setBool:value forKey:@"multi_kloader"];
    
    if (value) {
        cells.sectionCount += 1;
        [table insertSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationFade];
    } else {
        cells.sectionCount += -1;
        [table deleteSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationFade];
    }
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}


- (void)show {
    
    [superview addSubview:darkLayer];
    [superview addSubview:self];
    CGRect frame = self.frame;
    frame.origin.y = 172;
    [UIView animateWithDuration:0.35 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{[self setFrame:frame];} completion:nil];
    
}

- (void)dismiss {
    
    [self endEditing:YES];
    [darkLayer removeFromSuperview];
    CGRect frame = self.frame;
    frame.origin.y = normalYPosition;
    [UIView animateWithDuration:0.35 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{[self setFrame:frame];} completion:nil];
}

@end
