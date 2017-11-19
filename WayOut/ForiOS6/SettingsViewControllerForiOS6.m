//
//  SettingsViewControllerForiOS6.m
//  WayOut
//
//  Created on 20/08/2017.
//
//

#import "SettingsViewControllerForiOS6.h"

@interface SettingsViewControllerForiOS6 () {
    
    UIImage *linen;
    
    int iOSVersion;
    
    SettingsTableViewSingleton *cells;
}

@end

@implementation SettingsViewControllerForiOS6

- (instancetype)initWithLinenImage:(UIImage*)image {
    
    self = [super initWithStyle:UITableViewStyleGrouped];
    
    linen = image;

    return self;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    
    iOSVersion = [[[UIDevice currentDevice] systemVersion] intValue];
    
    [self.view setFrame:screenRect];
    
    UIImageView *backgroundImage = [[UIImageView alloc] initWithFrame:screenRect];
    [backgroundImage setImage:linen];
    

    self.tableView.frame = CGRectMake(0, 0, screenRect.size.width, screenRect.size.height-20);
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.backgroundView = backgroundImage;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.separatorColor = [[UIColor blackColor] colorWithAlphaComponent:0.25];
  
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStyleDone target:self action:@selector(saveButtonAction)];
    self.navigationItem.title = @"Settings";
    self.navigationItem.rightBarButtonItem = saveButton;
    
    cells = [[SettingsTableViewSingleton alloc] initWithTableWidth:screenRect.size.width delegate:self];
    
}

- (void)saveButtonAction {
    
    [self dismissModalViewControllerAnimated:YES];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return cells.sectionCount;
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [cells getRowCountForSection:section];
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
        [self.tableView insertSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationFade];
    } else {
        cells.sectionCount += -1;
        [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationFade];
    }
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end