//
//  iOS6AlertView.m
//  iOS6AlertView
//
//  Created on 19/05/17.
//
//

#import "iOS6AlertView.h"

UIImageView *alertView;
BOOL isAnimated;
CGFloat contentWidth;

CABasicAnimation *alpha;
CABasicAnimation *stretch;
CABasicAnimation *squeeze;
CABasicAnimation *back;

@implementation iOS6AlertView

- (instancetype)initWithTitle:(NSString*)title message:(NSString *)message delegate:(id)delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitle:(NSString *)otherButtonTitle backgroundImage:(UIImage*)backgroundImage dimmingImage:(UIImage*)dimmingImage position:(CGPoint)position animated:(BOOL)animated {
    
    self = [super init];
    [self setDelegate:delegate];
    [self setUserInteractionEnabled:YES];
    isAnimated = animated;
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGSize screenSize = screenRect.size;
    
    [self setFrame:screenRect];
    
#pragma mark Setting up dimming and animations
    
    if (animated) {
        
        UIImageView *dimming = [[UIImageView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        [dimming setImage:dimmingImage];
        [self addSubview:dimming];
        
        alpha = [CABasicAnimation animation];
        [alpha setKeyPath:@"opacity"];
        [alpha setFromValue:[NSNumber numberWithFloat:0.1]];
        [alpha setToValue:[NSNumber numberWithFloat:1.0]];
        [alpha setDuration:0.3];
        [alpha setRepeatCount:1];
        
        stretch = [CABasicAnimation animation];
        [stretch setKeyPath:@"transform.scale"];
        [stretch setFromValue:@(0.1)];
        [stretch setToValue:@(1.1)];
        [stretch setDuration:0.2];
        [stretch setRepeatCount:1];
        [stretch setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
        
        squeeze = [CABasicAnimation animation];
        [squeeze setKeyPath:@"transform.scale"];
        [squeeze setFromValue:@(1.1)];
        [squeeze setToValue:@(0.9)];
        [squeeze setDuration:0.11];
        [squeeze setRepeatCount:1];
        [squeeze setRemovedOnCompletion:NO];
        [squeeze setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
        
        back = [CABasicAnimation animation];
        [back setKeyPath:@"transform.scale"];
        [back setFromValue:@(0.9)];
        [back setToValue:@(1.0)];
        [back setDuration:0.15];
        [back setRepeatCount:1];
        [back setRemovedOnCompletion:NO];
        [back setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
    }
    
#pragma mark Setting up background   

    UIImage *resizableBackground = [backgroundImage resizableImageWithCapInsets:UIEdgeInsetsMake(43, 0, 19, 0)];
    alertView = [[UIImageView alloc] initWithImage:resizableBackground];
    alertView.userInteractionEnabled = YES;
    
#pragma mark Setting up labels
    
    contentWidth = 262.0;
    CGFloat contentOffset = 15.0;
    CGFloat xPosition = 11.0;
    CGFloat spaceBetweenContentAndButtons = 0;
    
    UILabel *titleLabel = [[UILabel alloc] init];
    UIFont *titleFont = [UIFont fontWithName:@"HelveticaNeue-Bold" size:18];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = titleFont;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.shadowOffset = CGSizeMake(0, -0.75);
    titleLabel.shadowColor = [UIColor blackColor];
    titleLabel.numberOfLines = 2;
    titleLabel.text = title;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.frame = CGRectMake(xPosition, contentOffset, contentWidth, [self getLabelHeightOfString:title font:titleFont width:contentWidth]);
    
    UILabel *messageLabel = [[UILabel alloc] init];
    messageLabel.backgroundColor = [UIColor clearColor];
    messageLabel.textColor = [UIColor whiteColor];
    messageLabel.shadowColor = [UIColor blackColor];
    messageLabel.shadowOffset = CGSizeMake(0, -0.5);
    messageLabel.numberOfLines = 0;
    
    if (message != nil) {
        
        NSMutableAttributedString *messageContent = [[NSMutableAttributedString alloc] initWithString:message];
        [messageContent addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue" size:16] range:NSMakeRange(0, [messageContent length])];
        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
        [style setLineSpacing:1.4];
        [style setAlignment:NSTextAlignmentCenter];
        [messageContent addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, [messageContent length])];
        messageLabel.attributedText = messageContent;
    }

    messageLabel.frame = CGRectMake(xPosition, titleLabel.frame.size.height + titleLabel.frame.origin.y + 8, contentWidth, [self getLabelHeightOfAttributedString:messageLabel.attributedText width:contentWidth]);
    
#pragma mark Setting up buttons
    
    UILabel *cancelButtonLabel = [[UILabel alloc] init];
    cancelButtonLabel.text = cancelButtonTitle;
    cancelButtonLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:18];
    cancelButtonLabel.textColor = [UIColor whiteColor];
    cancelButtonLabel.shadowColor = [UIColor blackColor];
    cancelButtonLabel.shadowOffset = CGSizeMake(0, -1);
    cancelButtonLabel.numberOfLines = 1;
    
    UILabel *otherButtonLabel = [[UILabel alloc] init];
    otherButtonLabel.text = otherButtonTitle;
    otherButtonLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:18];
    otherButtonLabel.textColor = [UIColor whiteColor];
    otherButtonLabel.shadowColor = [UIColor blackColor];
    otherButtonLabel.shadowOffset = CGSizeMake(0, -1);
    otherButtonLabel.numberOfLines = 1;

    UIButton *cancelButton;
    UIButton *otherButton;
    
    BOOL useButtons = NO;
    BOOL useTwoButtons = NO;
    BOOL useLongButtons = NO;
    
    if (cancelButtonTitle != nil | otherButtonTitle != nil) {
        
        useButtons = YES;
    }
    
    if (useButtons) {
        
        spaceBetweenContentAndButtons = 17;
        
        if (cancelButtonTitle != nil && otherButtonTitle != nil) {
            
            useTwoButtons = YES;
        }
        
        if (!useTwoButtons) {
            
            useLongButtons = YES;
            
            if (cancelButtonTitle != nil) {
                
                cancelButton = [self createAlertButtonWithTitle:cancelButtonLabel type:0 isLong:useLongButtons];
                CGRect rect = cancelButton.frame;
                rect.origin.y = messageLabel.frame.origin.y + messageLabel.frame.size.height + spaceBetweenContentAndButtons;
                [cancelButton setFrame:rect];
                [alertView addSubview:cancelButton];
                
            }
            
            if (otherButtonTitle != nil) {
                
                otherButton = [self createAlertButtonWithTitle:otherButtonLabel type:1 isLong:useLongButtons];
                CGRect rect = otherButton.frame;
                rect.origin.y = messageLabel.frame.origin.y + messageLabel.frame.size.height + spaceBetweenContentAndButtons;
                [otherButton setFrame:rect];
                [alertView addSubview:otherButton];
                
            }
            
        } else {
            
            cancelButton = [self createAlertButtonWithTitle:cancelButtonLabel type:0 isLong:useLongButtons];
            CGRect rectCancel = cancelButton.frame;
            rectCancel.origin.y = messageLabel.frame.origin.y + messageLabel.frame.size.height + spaceBetweenContentAndButtons;
            [cancelButton setFrame:rectCancel];
            [alertView addSubview:cancelButton];
            
            otherButton = [self createAlertButtonWithTitle:otherButtonLabel type:1 isLong:useLongButtons];
            CGRect rectOther = otherButton.frame;
            rectOther.origin.x = 146;
            rectOther.origin.y = messageLabel.frame.origin.y + messageLabel.frame.size.height + spaceBetweenContentAndButtons;
            [otherButton setFrame:rectOther];
            [alertView addSubview:otherButton];
        }
        
    }
    
    
    CGFloat alertHeight = backgroundImage.size.height + (titleLabel.frame.size.height > 22.0 ? titleLabel.frame.size.height/2 : 0) + messageLabel.frame.size.height + spaceBetweenContentAndButtons-1 + (useButtons ? 43 : 5);
    
    if (CGPointEqualToPoint(position, CGPointZero)) {
        
        [alertView setFrame:CGRectMake(screenSize.width/2-backgroundImage.size.width/2, ceilf(screenSize.height/2-alertHeight/2), backgroundImage.size.width, alertHeight)];
        
    } else {
        
        [alertView setFrame:CGRectMake(screenSize.width/2-backgroundImage.size.width/2, position.y, backgroundImage.size.width, alertHeight)];
    }
    
    if (!animated) {
        
        CGRect rect = alertView.frame;
        [self setFrame:rect];
        
        rect.origin.x = 0;
        rect.origin.y = 0;
        [alertView setFrame:rect];
    }
    
    [alertView addSubview:titleLabel];
    [alertView addSubview:messageLabel];
    [self addSubview:alertView];

    return self;
}

- (UIButton*)createAlertButtonWithTitle:(UILabel*)title type:(uint8_t)type isLong:(BOOL)isLong {
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    UIImage *backgroundImage;
    
    if (type == 0) {
        
        backgroundImage = [[UIImage imageNamed:@"UIPopupAlertSheetDefaultButton"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 5, 0, 5)];
        
    } else {
        
        backgroundImage = [[UIImage imageNamed:@"UIPopupAlertSheetButton"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 5, 0, 5)];
    }
    
    UIImage *backgroundImagePressed = [[UIImage imageNamed:@"UIPopupAlertSheetButtonPress"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 5, 0, 5)];
    
    [button setFrame:CGRectMake(11, 0, isLong ? contentWidth : 127, 43)];
    [button setBackgroundImage:backgroundImage forState:UIControlStateNormal];
    [button setBackgroundImage:backgroundImagePressed forState:UIControlStateHighlighted];
    [button setTitle:title.text forState:UIControlStateNormal];
    [button setTitleColor:title.textColor forState:UIControlStateNormal];
    [button.titleLabel setFont:title.font];
    [button.titleLabel setShadowOffset:CGSizeMake(0, -1)];
    [button setTitleShadowColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(sendButtonActionWithTitle:) forControlEvents:UIControlEventTouchUpInside];

    return button;
}

- (CGFloat)getLabelHeightOfString:(NSString*)string font:(UIFont*)font width:(CGFloat)width {
    
    CGRect rect = [string boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : font} context:nil];
    return ceilf(rect.size.height);
}

- (CGFloat)getLabelHeightOfAttributedString:(NSAttributedString*)string width:(CGFloat)width {
    
    CGRect rect = [string boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil];
    return ceilf(rect.size.height);
}

- (void)sendButtonActionWithTitle:(UIButton*)sender {
    
    [_delegate clickedAlertButtonWithTitle:sender.titleLabel.text];
    [self dismiss];
}

- (void)show {
    
    [[[[[[UIApplication sharedApplication] delegate] window] rootViewController] view] addSubview:self];
    
    if (isAnimated) {
        
        CGFloat totalDuration = 0;
        
        [alertView.layer addAnimation:alpha forKey:@"alpha"];
        
        [stretch setBeginTime:CACurrentMediaTime()];
        [alertView.layer addAnimation:stretch forKey:@"stretch"];
        
        totalDuration += stretch.duration;
        
        [squeeze setBeginTime:CACurrentMediaTime()+totalDuration];
        [alertView.layer addAnimation:squeeze forKey:@"squeeze"];
        
        totalDuration += squeeze.duration;
        
        [back setBeginTime:CACurrentMediaTime()+totalDuration];
        [alertView.layer addAnimation:back forKey:@"back"];

    }
 
}

- (void)dismiss {
    
    [self removeFromSuperview];
}

@end
