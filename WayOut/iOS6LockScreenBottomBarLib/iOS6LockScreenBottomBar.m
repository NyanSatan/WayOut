//
//  iOS6LockScreenBottomBar.m
//  WayOut
//
//  Created on 13/08/2017.
//
//

#import "iOS6LockScreenBottomBar.h"

@implementation iOS6LockScreenBottomBar {
    
    CGRect screenRect;
    
    int iOSVersion;
    
    UISlider *slider;
    UIView *label;
    CABasicAnimation *shimmering;
    CALayer *shimmerImage;
    CALayer *darkLayer;
    
    UIButton *infoButton;
}

- (instancetype)initWithYPosition:(CGFloat)yPosition {
    
    self = [super init];
    
    screenRect = [[UIScreen mainScreen] bounds];
    
    iOSVersion = [[[UIDevice currentDevice] systemVersion] intValue];
    
    UIImage *bottomBarBackgroundImage = [UIImage imageNamed:@"bottombarbkgnd"];
    UIImageView *bottomBarBackgroundView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, screenRect.size.width, bottomBarBackgroundImage.size.height)];
    [bottomBarBackgroundView setUserInteractionEnabled:YES];
    [bottomBarBackgroundView setImage:[bottomBarBackgroundImage resizableImageWithCapInsets:UIEdgeInsetsMake(0, 39, 0, 39)]];
    
    UIImageView *wellLock;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        
        UIImage *wellLockImage = [UIImage imageNamed:@"WellLock"]; wellLock = [[UIImageView alloc] initWithFrame:CGRectMake(256, 38, 256, wellLockImage.size.height)];
        [wellLock setUserInteractionEnabled:YES];
        [wellLock setImage:[wellLockImage resizableImageWithCapInsets:UIEdgeInsetsMake(0, 13, 0, 13)]];
        [bottomBarBackgroundView addSubview:wellLock];
        
    }
    
    
#pragma mark Setting up label
    
    label = [[UIView alloc] init];
    label.layer.backgroundColor = [[UIColor colorWithRed:0.295f green:0.295f blue:0.295f alpha:1.0f] CGColor];
    label.layer.masksToBounds = YES;
    
    switch (UI_USER_INTERFACE_IDIOM()) {
        case UIUserInterfaceIdiomPhone:
            [label setFrame:CGRectMake(107, 35, 158, 25)];
            [bottomBarBackgroundView addSubview:label];
            break;
            
        case UIUserInterfaceIdiomPad:
            [label setFrame:CGRectMake(78, 13, 158, 25)];
            [wellLock addSubview:label];
            break;
    }
    
    CATextLayer *textLayer = [CATextLayer layer];
    textLayer.backgroundColor = [UIColor clearColor].CGColor;
    textLayer.string = @"slide to boot";
    textLayer.font = (__bridge CFTypeRef)@"Helvetica-Neue";
    textLayer.fontSize = 28;
    textLayer.contentsScale = [[UIScreen mainScreen] scale];
    textLayer.frame = CGRectMake(0, iOSVersion < 6 ? 0 : -5, label.frame.size.width, 30);
    textLayer.alignmentMode = kCAAlignmentCenter;
    [label.layer addSublayer:textLayer];
    label.layer.mask = textLayer;
    
    
    shimmerImage = [CALayer layer];
    shimmerImage.frame = CGRectMake(-80, 0, 80, 32);
    shimmerImage.backgroundColor = [UIColor clearColor].CGColor;
    shimmerImage.contents = (id)[UIImage imageNamed:@"bottombarlocktextmask"].CGImage;
    [label.layer addSublayer:shimmerImage];
    
    shimmering = [CABasicAnimation animation];
    shimmering.keyPath = @"position.x";
    shimmering.fromValue =  @(shimmerImage.frame.origin.x);
    shimmering.toValue = @(label.frame.size.width + shimmerImage.frame.size.width);
    shimmering.duration = 2.2;
    shimmering.repeatCount = HUGE_VALF;
    shimmering.removedOnCompletion = NO;
    
    [self shimmering:0];
    
    
#pragma mark Setting up slider
    
    slider = [[UISlider alloc] init];
    [slider setContinuous:YES];
    [slider setMinimumTrackImage:[UIImage alloc] forState:UIControlStateNormal];
    [slider setMaximumTrackImage:[UIImage alloc] forState:UIControlStateNormal];
    [slider setThumbImage:[UIImage imageNamed:@"bottombarknobgray"] forState:UIControlStateNormal];
    [slider addTarget:self
               action:@selector(sliderUp:)
     forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside];
    [slider addTarget:self
               action:@selector(sliderChanged:)
     forControlEvents:UIControlEventValueChanged];
    
    switch (UI_USER_INTERFACE_IDIOM()) {
        case UIUserInterfaceIdiomPhone:
            [slider setFrame:CGRectMake(23, 34, 274, 31)];
            [bottomBarBackgroundView addSubview:slider];
            break;
            
        case UIUserInterfaceIdiomPad:
            [slider setFrame:CGRectMake(3, 12, 250, 31)];
            [wellLock addSubview:slider];
            break;
    }
    
    [self setFrame:CGRectMake(0, yPosition, screenRect.size.width, bottomBarBackgroundImage.size.height)];
    [self addSubview:bottomBarBackgroundView];
    
    return self;
}

- (void)sliderUp:(UISlider *)sender {
    
    if ((slider.value == 1)) {
        
        [_delegate didCompleteSlide];
        
    } else {
        
        CGFloat fValue = slider.value;
        [UIView animateWithDuration:0.2f animations:^{
            if( fValue < 1.0f ) {
                
                [slider setValue:0 animated:iOSVersion < 7 ? NO : YES];
                label.alpha = MAX(0.0, 1.0 - (slider.value * 3.5));
                infoButton.alpha = MAX(0.0, 1.0 - (slider.value * 3.5));
            }
        }];
        
        if (slider.value == 0) {
            
            [self shimmering:0];
        }
    }
}

- (void)sliderChanged:(UISlider *)sender {
    
    label.alpha = MAX(0.0, 1.0 - (slider.value * 3.5));
    [self shimmering:1];
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        infoButton = [[[self superview] subviews] objectAtIndex:1];
    });
    [infoButton setAlpha:MAX(0.0, 1.0 - (slider.value * 3.5))];
    
}

- (void)shimmering:(uint8_t)command {
    
    if (command == 0) {
        [shimmerImage addAnimation:shimmering forKey:@"Shimmering"];
    }
    
    if (command == 1) {
        [shimmerImage removeAllAnimations];
    }
}

- (void)setYPosition:(CGFloat)yPosition {
    
    CGRect rect = self.frame;
    rect.origin.y = yPosition;
    [self setFrame:rect];
}

- (void)reset {
    
    [slider setValue:0];
    [label setAlpha:1.0];
    [infoButton setAlpha:1.0];
    [self shimmering:0];
}


@end
