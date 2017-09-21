//
//  iOS6SettingsNavigationController.m
//  WayOut
//
//  Created on 31/08/2017.
//
//

#import "iOS6SettingsNavigationController.h"

@interface iOS6SettingsNavigationController ()

@end

@implementation iOS6SettingsNavigationController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    [self setNavigationBarHidden:YES];
    
    UIView *sb = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenSize.width, 20)];
    [sb setBackgroundColor:[UIColor blackColor]];
    [self.view addSubview:sb];
    
    UIImage *navigationBarBackground = [UIImage imageNamed:@"UINavigationBarBlackTranslucentBackground"];
    UINavigationBar *navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 20, screenSize.width, navigationBarBackground.size.height)];
    [navigationBar setBackgroundImage:navigationBarBackground forBarMetrics:UIBarMetricsDefault];
    [navigationBar setShadowImage:[UIImage imageNamed:@"UINavigationBarShadow"]];
    
    UIImage *leftCornerImage = [UIImage imageNamed:@"UINavigationBarBlackTranslucentLeftCorner"];
    UIImage *rightCornerImage = [UIImage imageNamed:@"UINavigationBarBlackTranslucentRightCorner"];
    UIImageView *leftCorner = [[UIImageView alloc] initWithImage:leftCornerImage];
    leftCorner.frame = CGRectMake(0, 0, leftCornerImage.size.width, leftCornerImage.size.width);
    UIImageView *rightCorner = [[UIImageView alloc] initWithImage:rightCornerImage];
    rightCorner.frame = CGRectMake(screenSize.width-leftCornerImage.size.width, 0, leftCornerImage.size.width, leftCornerImage.size.width);
    [navigationBar addSubview:leftCorner];
    [navigationBar addSubview:rightCorner];
    
    UINavigationItem *navigationItem = [[UINavigationItem alloc] init];
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 24)];
    title.text = @"Settings";
    title.textColor = [UIColor whiteColor];
    title.textAlignment = NSTextAlignmentCenter;
    title.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:20];
    title.shadowColor = [UIColor blackColor];
    title.shadowOffset = CGSizeMake(0, -1);
    [navigationItem setTitleView:title];
    
    UIImage *saveImage = [[UIImage imageNamed:@"UINavigationBarDoneButtonDark"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 5, 0, 5)];
    UIButton *saveButtonPrototype = [UIButton buttonWithType:UIButtonTypeCustom];
    [saveButtonPrototype setFrame:CGRectMake(0, 0, 48, saveImage.size.height)];
    [saveButtonPrototype setBackgroundImage:saveImage forState:UIControlStateNormal];
    [saveButtonPrototype setTitle:@"Save" forState:UIControlStateNormal];
    [saveButtonPrototype.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:12]];
    [saveButtonPrototype.titleLabel setTextColor:[UIColor whiteColor]];
    [saveButtonPrototype setTitleShadowColor:[[UIColor blackColor] colorWithAlphaComponent:0.33] forState:UIControlStateNormal];
    [saveButtonPrototype.titleLabel setShadowOffset:CGSizeMake(0, -1)];
    [saveButtonPrototype addTarget:self action:@selector(saveButtonAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithCustomView:saveButtonPrototype];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSpacer.width = -11;
    navigationItem.rightBarButtonItems = @[negativeSpacer, saveButton];
    navigationBar.items = @[navigationItem];
    [self.view addSubview:navigationBar];
    
}

- (void)saveButtonAction {
    
    [self dismissModalViewControllerAnimated:YES];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
