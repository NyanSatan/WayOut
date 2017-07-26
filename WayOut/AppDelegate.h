//
//  AppDelegate.h
//  WayOut
//
//  Created on 05.06.16.
//  All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"
#import "NoSupportViewController.h"


@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) ViewController *ViewController;
@property (strong, nonatomic) NoSupportViewController *NoSupportViewController;


@end