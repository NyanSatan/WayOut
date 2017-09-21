//
//  LoadingView.m
//  WayOut
//
//  Created on 16/08/2017.
//
//

#import "LoadingView.h"

@implementation LoadingView {
    
    int iOSVersion;
    CGRect screenRect;
    
    UIImageView *alertView;
}

- (instancetype)initWithAlertImage:(UIImage*)alertImage dimmingImage:(UIImage*)dimmingImage {
    
    self = [super init];

    screenRect = [[UIScreen mainScreen] bounds];
    
    iOSVersion = [[[UIDevice currentDevice] systemVersion] intValue];
    
    [self setFrame:CGRectMake(0, iOSVersion < 7 ? -20 : 0, screenRect.size.width, screenRect.size.height)];
    
    UIImageView *dimmingView = [[UIImageView alloc] initWithFrame:screenRect];
    [dimmingView setImage:dimmingImage];
    [self addSubview:dimmingView];
    
    alertView = [[UIImageView alloc] initWithImage:alertImage];
    [alertView setFrame:CGRectMake(screenRect.size.width/2-alertImage.size.width/2, screenRect.size.height/2-alertImage.size.height/2, alertImage.size.width, alertImage.size.height)];
    [dimmingView addSubview:alertView];
    
    return self;
    
}

- (void)setAlertContent:(uint8_t)type {
    
    if ([[alertView subviews] count] > 0) {
        [alertView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    
    UILabel *statusLabel = [[UILabel alloc] init];
    statusLabel.backgroundColor = [UIColor clearColor];
    statusLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:17];
    statusLabel.textColor = [UIColor whiteColor];
    statusLabel.shadowOffset = CGSizeMake(0, -1);
    statusLabel.shadowColor = [UIColor blackColor];
    statusLabel.adjustsFontSizeToFitWidth = YES;
    
    CGFloat labelWidth;
    CGFloat labelHeight = 22;
    
    switch (type) {
        case 0:
            statusLabel.text = @"Executing kloader...";
            labelWidth = 159;
            break;
        case 1:
            statusLabel.text = @"Executing multi_kloader...";
            labelWidth = 208;
            break;
        case 2:
            statusLabel.text = @"Validating image...";
            labelWidth = 148;
            break;
        case 3:
            statusLabel.text = @"Validating images...";
            labelWidth = 158;
            break;
        default:
            break;
    }
    
    CGFloat positionY = 17;
    CGFloat indicatorWidth = 20;
    CGFloat space = 8;
    CGFloat alertWidth = alertView.frame.size.width;
    CGFloat width = indicatorWidth + space + labelWidth;
    CGFloat offset = ceilf((alertWidth - width)/2);
    CGFloat positionX = offset - 2.0;
    
    statusLabel.frame = CGRectMake(positionX + space + indicatorWidth, positionY - 2, labelWidth, labelHeight);
    
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] init];
    indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
    indicator.frame = CGRectMake(positionX, positionY, indicatorWidth, indicatorWidth);
    [indicator startAnimating];
    
    [alertView addSubview:indicator];
    [alertView addSubview:statusLabel];
    
}

- (void)show {
    
    [[[[[[UIApplication sharedApplication] delegate] window] rootViewController] view] addSubview:self];
    
    if (iOSVersion < 7) {
        
        [[[[UIApplication sharedApplication] delegate] window] setWindowLevel:UIWindowLevelStatusBar+1];
    }
    
}

- (void)dismiss {
    
    [self removeFromSuperview];
    
}

@end