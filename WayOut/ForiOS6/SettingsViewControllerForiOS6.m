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
    
    int sectionCount;
    
    int iOSVersion;
    
    UIView *image1Header;
    CGFloat image1HeaderHeight;
    
    UILabel *multi_kloaderFooter;
    CGFloat multi_kloaderFooterHeight;
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
    
    if ([ImageValidation isMultiKloaderNeeded]) {
        sectionCount = 3;
    } else {
        sectionCount = 2;
    }
    
    if (iOSVersion < 6) {
        
        NSString *image1Text = @"Image 1";
        NSString *iOS5WarningText = @"multi_kloader isn't supported on iOS 5";
        
        image1Header = [iOS6TableViewCellHelper getSectionHeaderForTitle:image1Text withCellWidth:300 cellXPosition:9];
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
    
    
    
}

- (void)saveButtonAction {
    
    [self dismissModalViewControllerAnimated:YES];
    [[NSUserDefaults standardUserDefaults] synchronize];
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
        [self.tableView insertSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationFade];
    } else {
        sectionCount += -1;
        [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationFade];
    }
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end