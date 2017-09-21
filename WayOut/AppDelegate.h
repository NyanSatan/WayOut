//
//  AppDelegate.h
//  WayOut
//
//  Created on 05.06.16.
//  All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"
#import "ViewControllerForiOS6.h"
#import "NoSupportViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) ViewController *ViewController;
@property (strong, nonatomic) ViewControllerForiOS6 *ViewControllerForiOS6;
@property (strong, nonatomic) NoSupportViewController *NoSupportViewController;

@end