//
//  iOS6SettingsTableViewController.h
//  WayOut
//
//  Created on 31/08/2017.
//
//

#import <UIKit/UIKit.h>
#import "ImageValidation.h"
#import "SettingsTableViewSingleton.h"

@interface iOS6SettingsTableViewController : UITableViewController <iOS6KloaderCellDelegate>

- (instancetype)initWithLinenImage:(UIImage*)linenImage;

@end
