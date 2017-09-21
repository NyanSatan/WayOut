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
    
    int sectionCount;
    CellsInitialization *cells;
    
    CGSize screenSize;
    
}

@end

@implementation iOS6SettingsTableViewController

- (instancetype)initWithLinenImage:(UIImage*)linenImage {
    
    self = [super initWithStyle:UITableViewStyleGrouped];
    
    linen = linenImage;
    
    screenSize = [[UIScreen mainScreen] bounds].size;
    
    if (screenSize.height < 568) {
        
        scrollImage = [[UIImage imageNamed:@"UIScrollerIndicatorBlack"] resizableImageWithCapInsets:UIEdgeInsetsMake(2, 0, 2, 0)];
    }

    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImageView *backgroundImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, linen.size.width, linen.size.height)];
    [backgroundImage setImage:linen];

    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.backgroundView = backgroundImage;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.contentInset = UIEdgeInsetsMake(50, 0, 0, 0);
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(44, 0, 0, -1);
    
    if ([ImageValidation isMultiKloaderNeeded]) {
        sectionCount = 3;
    } else {
        sectionCount = 2;
    }
    
    cells = [[CellsInitialization alloc] initCellsWithTableViewWidth:self.tableView.frame.size.width delegate:self];
    
}

- (void)viewDidAppear:(BOOL)animated {
    
    self.tableView.showsVerticalScrollIndicator = NO;
    [super viewDidAppear:animated];
    self.tableView.showsVerticalScrollIndicator = YES;
    
    
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
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationMiddle];
        }
    } else {
        if (sectionCount == 3) {
            sectionCount += -1;
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationMiddle];
        }
    }
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (screenSize.height < 568) {
        for (UIImageView *i in scrollView.subviews) {
            
            if (i.autoresizingMask == UIViewAutoresizingFlexibleLeftMargin) {
                
                [i setImage:scrollImage];
            }
        }
    }
}

@end
