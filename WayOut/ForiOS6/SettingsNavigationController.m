//
//  SettingsNavigationController.m
//  WayOut
//
//  Created on 21/08/2017.
//
//

#import "SettingsNavigationController.h"

@interface SettingsNavigationController ()

@end

@implementation SettingsNavigationController

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController {
    
    self = [super initWithRootViewController:rootViewController];
    
    [self.navigationBar setBarStyle:UIBarStyleBlackTranslucent];

    return self;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
