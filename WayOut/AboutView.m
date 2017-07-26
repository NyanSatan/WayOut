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
    float height = 261;
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    
    if (screenSize.height < 568) {
        self.frame = CGRectMake(screenSize.width/2-width/2, screenSize.height*0.1464, width, height);
    } else {
        self.frame = CGRectMake(screenSize.width/2-width/2, (screenSize.height/2-height/2)-20, width, height);
    }
    
    UIImageView *alertView = [[UIImageView alloc] initWithImage:[alertImage resizableImageWithCapInsets:UIEdgeInsetsMake(43, 0, 19, 0)]];
    alertView.frame = CGRectMake(0, 0, width, height);
    alertView.userInteractionEnabled = YES;
    
    UILabel *title = [[UILabel alloc] init];
    title.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:18];
    title.textColor = [UIColor whiteColor];
    title.shadowOffset = CGSizeMake(0, -0.75);
    title.shadowColor = [UIColor blackColor];
    title.text = [NSString stringWithFormat:@"Way Out %@ (%@)", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"], [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey]];
    title.textAlignment = NSTextAlignmentCenter;
    title.frame = CGRectMake(20, 15, 244, ceilf(title.intrinsicContentSize.height));
    title.backgroundColor = [UIColor blueColor];
    [alertView addSubview:title];
    
    UILabel *message = [[UILabel alloc] init];
    message.frame = CGRectMake(11, 41+5, 262, 139);
    message.textColor = [UIColor whiteColor];
    message.shadowColor = [UIColor blackColor];
    message.shadowOffset = CGSizeMake(0, -0.5);
    message.numberOfLines = 0;
    NSMutableAttributedString *messageContent = [[NSMutableAttributedString alloc] initWithString:@"Way Out - GUI in the spirit of classical Setup.app for untethered dualboots to iOS 6. Developed by @nyan_satan\n\nThanks to:\n@winocm, @xerub, @JonathanSeals"];
    [messageContent addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue" size:16] range:NSMakeRange(0, [messageContent length])];
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    [style setLineSpacing:1.4];
    [style setAlignment:NSTextAlignmentCenter];
    [messageContent addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, [messageContent length])];
    message.attributedText = messageContent;

    NSLog(@"%d", [self getLabelHeightOfAttributedString:messageContent width:262]);
    
    
    message.backgroundColor = [UIColor orangeColor];
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

- (int)getLabelHeightOfAttributedString:(NSAttributedString*)string width:(CGFloat)width {
    
    CGRect rect = [string boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil];
    
    return (int)ceilf(rect.size.height);
}

- (void)sendAction {
    [_delegate didSettingsButtonPressed];
}

@end