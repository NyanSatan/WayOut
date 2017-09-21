//
//  AboutView.m
//  WayOut
//
//  Created on 03.02.17.
//  All rights reserved.
//

#import "AboutView.h"

@implementation AboutView

- (instancetype)initWithAlertImage:(UIImage *)alertImage {
    self = [super init];
    
    float width = alertImage.size.width;
    float height = 262;
    float yPosition = 0;
    
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    
    switch ((int)screenSize.height) {
        case 568:
            yPosition = 94;
            break;
        case 480:
            yPosition = 50;
            break;
        case 1024:
            yPosition = 308;
            break;
        default:
            break;
    }
  
    self.frame = CGRectMake(screenSize.width/2-width/2, yPosition, width, height);
    
    UIImageView *alertView = [[UIImageView alloc] initWithImage:[alertImage resizableImageWithCapInsets:UIEdgeInsetsMake(43, 0, 19, 0)]];
    alertView.frame = CGRectMake(0, 0, width, height);
    alertView.userInteractionEnabled = YES;
    
    UILabel *title = [[UILabel alloc] init];
    title.backgroundColor = [UIColor clearColor];
    title.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:18];
    title.textColor = [UIColor whiteColor];
    title.shadowOffset = CGSizeMake(0, -0.75);
    title.shadowColor = [UIColor blackColor];
    title.text = [NSString stringWithFormat:@"Way Out %@ (%@)", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"], [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey]];
    title.textAlignment = NSTextAlignmentCenter;
    title.frame = CGRectMake(19, 14, 244, 23);
    [alertView addSubview:title];
    
    UILabel *message = [[UILabel alloc] init];
    message.backgroundColor = [UIColor clearColor];
    message.font = [UIFont fontWithName:@"HelveticaNeue" size:16];
    message.frame = CGRectMake(11, 45, 262, 145);
    message.textColor = [UIColor whiteColor];
    message.shadowColor = [UIColor blackColor];
    message.shadowOffset = CGSizeMake(0, -0.5);
    message.numberOfLines = 0;
    message.textAlignment = NSTextAlignmentCenter;
    message.text = @"Way Out - GUI for kloader in the spirit of classical Setup.app. Developed by @nyan_satan\n\nThanks to:\n@winocm, @xerub, @JonathanSeals, @axi0mX";
    [alertView addSubview:message];
    [self addSubview:alertView];
    
    UIImage *buttonImage = [[UIImage imageNamed:@"UIPopupAlertSheetButton"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 5, 0, 5)];
    UIImage *buttonImagePressed = [[UIImage imageNamed:@"UIPopupAlertSheetButtonPress"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 5, 0, 5)];
    UIButton *settingsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [settingsButton setFrame:CGRectMake(11, self.frame.size.height-buttonImage.size.height-16, 262, buttonImage.size.height)];
    [settingsButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [settingsButton setBackgroundImage:buttonImagePressed forState:UIControlStateHighlighted];
    [settingsButton setTitle:@"Settings" forState:UIControlStateNormal];
    [settingsButton setTitleShadowColor:[UIColor blackColor] forState:UIControlStateNormal];
    settingsButton.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:18];
    settingsButton.titleLabel.shadowOffset = CGSizeMake(0, -1);
    [settingsButton setContentVerticalAlignment:UIControlContentVerticalAlignmentFill];
    [settingsButton addTarget:self action:@selector(sendAction) forControlEvents:UIControlEventTouchUpInside];
    [alertView addSubview:settingsButton];

    return self;
}


- (void)sendAction {
    [_delegate didSettingsButtonPressed];
}

@end