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
    int sectionCount;
    
    int iOSVersion;
    
    UIView *image1Header;
    CGFloat image1HeaderHeight;
    
    UILabel *multi_kloaderFooter;
    CGFloat multi_kloaderFooterHeight;
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
    table.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    table.separatorColor = [[UIColor blackColor] colorWithAlphaComponent:0.25];
    table.contentInset = UIEdgeInsetsMake(24, 0, 0, 0);
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
    
    if ([ImageValidation isMultiKloaderNeeded]) {
        sectionCount = 3;
    } else {
        sectionCount = 2;
    }
    
    if (iOSVersion < 6) {
        
        NSString *image1Text = @"Image 1";
        NSString *iOS5WarningText = @"multi_kloader isn't supported on iOS 5";
        
        image1Header = [iOS6TableViewCellHelper getSectionHeaderForTitle:image1Text withCellWidth:480 cellXPosition:31];
        image1HeaderHeight = [iOS6TableViewCellHelper calculateHeightForHeaderForTitle:image1Text];
        
        multi_kloaderFooterHeight = 35;
        multi_kloaderFooter = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, multi_kloaderFooterHeight)];
        multi_kloaderFooter.backgroundColor = [UIColor clearColor];
        multi_kloaderFooter.text = iOS5WarningText;
        multi_kloaderFooter.textColor = [UIColor whiteColor];
        multi_kloaderFooter.font = [UIFont fontWithName:@"HelveticaNeue" size:15];
        multi_kloaderFooter.shadowColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        multi_kloaderFooter.shadowOffset = CGSizeMake(0, -1);
        multi_kloaderFooter.textAlignment = NSTextAlignmentCenter;
        multi_kloaderFooter.numberOfLines = 1;
        
    }
    
    return self;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return sectionCount;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (iOSVersion < 6) {
        
        if (section == 1) {
            return image1Header;
        }
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (iOSVersion < 6) {
        
        if (section == 1) {
            return  image1HeaderHeight;
        }
    }
    
    return -1;
}

- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    if (iOSVersion < 6) {
        
        if (section == 0) {
            return multi_kloaderFooter;
        }
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    if (iOSVersion < 6) {
        
        if (section == 0) {
            return multi_kloaderFooterHeight;
        }
    }
    
    return -1;
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    switch (section) {
        case 0:
            return 1;
            break;
            
        default:
            return 3;
            break;
    }
    
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    switch (section) {
        case 0:
            return @"";
            break;
            
        case 1:
            return @"Image 1";
            break;
            
        case 2:
            return @"Image 2";
            break;
            
        default:
            return nil;
            break;
    }
    
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    
    switch (section) {
        case 0:
            return @"Important note: multi_kloader may fail sometimes";
            break;
            
        default:
            return @"";
            break;
    }
    
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        KloaderTableViewCell *cell = [[KloaderTableViewCell alloc] init];
        [cell setDelegate:self];
        cell.textLabel.text = @"multi_kloader";
        
        return cell;
        
    }
    
    if (indexPath.section != 0) {
        
        if (indexPath.row == 0) {
            
            PathTableViewCell *cell = [[PathTableViewCell alloc] initForSection:indexPath.section];
            cell.textLabel.text = @"Path";
            
            return cell;
            
        }
        
        if (indexPath.row > 0) {
            
            DetailTableViewCell *cell;
            
            if (indexPath.row == 1) {
                cell = [[DetailTableViewCell alloc] initWithType:DetailTableViewCellTypeType forSection:indexPath.section];
            }
            
            if (indexPath.row == 2) {
                cell = [[DetailTableViewCell alloc] initWithType:DetailTableViewCellTypeVersion forSection:indexPath.section];
            }
            
            return cell;
            
        } else {
            
            return nil;
        }
        
    } else {
        
        return nil;
    }
    
}

- (void)didSwitchValueChanged:(BOOL)value {
    
    [[NSUserDefaults standardUserDefaults] setBool:value forKey:@"multi_kloader"];
    
    if (value) {
        sectionCount += 1;
        [table insertSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationFade];
    } else {
        sectionCount += -1;
        [table deleteSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationFade];
    }
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}


- (void)show {
    
    [superview addSubview:darkLayer];
    [superview addSubview:self];
    CGRect frame = self.frame;
    frame.origin.y = 172;
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{[self setFrame:frame];} completion:nil];
    
}

- (void)dismiss {
    
    [self endEditing:YES];
    [darkLayer removeFromSuperview];
    CGRect frame = self.frame;
    frame.origin.y = normalYPosition;
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{[self setFrame:frame];} completion:nil];
}

@end
