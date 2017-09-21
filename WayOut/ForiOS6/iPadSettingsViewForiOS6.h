//
//  iPadSettingsViewForiOS6.h
//  WayOut
//
//  Created on 26/08/2017.
//
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "KloaderTableViewCell.h"
#import "PathTableViewCell.h"
#import "DetailTableViewCell.h"
#import "ImageValidation.h"
#import <iOS6TableViewCell.h>

@interface iPadSettingsViewForiOS6 : UIView <UITableViewDelegate, UITableViewDataSource, KloaderTableViewCellDelegate>

- (void)show;
- (void)dismiss;

@end
