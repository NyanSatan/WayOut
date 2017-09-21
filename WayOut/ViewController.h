//
//  ViewController.h
//  WayOut
//
//  Created on 05.06.16.
//  All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "ImageValidation.h"
#import "iOS6AlertView.h"
#import "iOS6LockScreenBottomBar.h"
#import "LoadingView.h"
#import "iOS6SettingsNavigationController.h"
#import "iOS6SettingsTableViewController.h"
#import "iOS6iPadSettingsView.h"

@interface ViewController : UIViewController <UIAlertViewDelegate, iOS6AlertViewDelegate, iOS6LockScreenBottomBarDelegate>


@end