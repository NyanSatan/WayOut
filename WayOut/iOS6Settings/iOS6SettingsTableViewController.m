//
//  iOS6SettingsTableViewController.m
//  WayOut
//
//  Created on 31/08/2017.
//
//

#import "iOS6SettingsTableViewController.h"

@interface iOS6SettingsTableViewController () {
    
    UIImage *linen;
    UIImage *scrollImage;
    
    SettingsTableViewSingleton *cells;
    
    CGSize screenSize;
}

@end

@implementation iOS6SettingsTableViewController

- (instancetype)initWithLinenImage:(UIImage*)linenImage {
    
    self = [super initWithStyle:UITableViewStyleGrouped];
    
    linen = linenImage;
    
    screenSize = [[UIScreen mainScreen] bounds].size;
    scrollImage = [[UIImage imageNamed:@"UIScrollerIndicatorDefault"] resizableImageWithCapInsets:UIEdgeInsetsMake(3, 0, 3, 0)];
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImageView *backgroundImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, linen.size.width, linen.size.height)];
    [backgroundImage setImage:linen];

    int iOSVersion = [[[UIDevice currentDevice] systemVersion] intValue];
    
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.backgroundView = backgroundImage;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.contentInset = UIEdgeInsetsMake(50, 0, 0, 0);
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(44, 0, 0, iOSVersion > 7 ? -2 : -1);
    
    cells = [[SettingsTableViewSingleton alloc] initWithTableWidth:linen.size.width delegate:self];
   
}

- (void)viewDidAppear:(BOOL)animated {
    
    self.tableView.showsVerticalScrollIndicator = NO;
    [super viewDidAppear:animated];
    self.tableView.showsVerticalScrollIndicator = YES;
    
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
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationFade];
        }
    } else {
        if (cells.sectionCount == 4) {
            cells.sectionCount += -1;
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationFade];
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
