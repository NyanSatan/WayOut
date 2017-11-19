//
//  SettingsViewControllerForiOS6.h
//  WayOut
//
//  Created on 20/08/2017.
//
//

#import <UIKit/UIKit.h>
#import "KloaderTableViewCell.h"
#import "PathTableViewCell.h"
#import "DetailTableViewCell.h"
#import "ImageValidation.h"
#import "SettingsTableViewSingleton.h"

@interface SettingsViewControllerForiOS6 : UITableViewController <KloaderTableViewCellDelegate>

- (instancetype)initWithLinenImage:(UIImage*)image;

@end
