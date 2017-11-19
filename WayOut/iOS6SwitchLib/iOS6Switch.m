//
//  iOS6Switch.m
//  iOS6Switch
//
//  Created on 23.02.17.
//  All rights reserved.
//

#import "iOS6Switch.h"

#define DISABLED 0
#define ENABLED 1
#define ONTHEWAY 2

@implementation iOS6Switch {
    
    UIView *track;
    UISlider *slider;
    CAGradientLayer *bluePart;
    uint8_t currentState;
}

- (instancetype)initWithPosition:(CGPoint)position withState:(BOOL)state {
    self = [super init];
    
    UIImage *baseImage = [UIImage imageNamed:@"UISwitchShapeShadow"];
    UIImage *maskImage = [UIImage imageNamed:@"UISwitchShapeMask"];
    UIImage *thumbImage = [UIImage imageNamed:@"UISwitchThumb"];
    UIImage *thumbImagePressed = [UIImage imageNamed:@"UISwitchThumbPressed"];
    
    self.frame = CGRectMake(position.x, position.y, baseImage.size.width-2, baseImage.size.height);
    
    UIView *trackBase = [[UIView alloc] init];
    trackBase.frame = CGRectMake(0, 0, baseImage.size.width, baseImage.size.height);
    [self addSubview:trackBase];
    
    UILabel *onLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 6, 24, 16)];
    onLabel.backgroundColor = [UIColor clearColor];
    onLabel.text = @"ON";
    onLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:16];
    onLabel.textAlignment = NSTextAlignmentCenter;
    onLabel.textColor = [UIColor whiteColor];
    onLabel.shadowOffset = CGSizeMake(0, -1);
    onLabel.shadowColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
    [self addSubview:onLabel];
    
    UILabel *offLabel = [[UILabel alloc] initWithFrame:CGRectMake(87, 6, 32, 16)];
    offLabel.backgroundColor = [UIColor clearColor];
    offLabel.text = @"OFF";
    offLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:16];
    offLabel.textAlignment = NSTextAlignmentCenter;
    offLabel.textColor = [UIColor colorWithRed:0.46 green:0.46 blue:0.46 alpha:1.0];
    [self addSubview:offLabel];
    
    track = [[UIView alloc] init];
    track.frame = CGRectMake(0, 0, baseImage.size.width*2, baseImage.size.height);
    track.backgroundColor = [UIColor colorWithRed:0.9353 green:0.935 blue:0.935 alpha:1.0];
    bluePart = [CAGradientLayer layer];
    bluePart.startPoint = CGPointMake(0.95, 0);
    bluePart.endPoint = CGPointMake(1, 0);
    bluePart.frame = CGRectMake(0, 0, baseImage.size.width-15, baseImage.size.height);
    bluePart.colors = @[(id)[UIColor colorWithRed:0.02 green:0.498 blue:0.918 alpha:1.0].CGColor, (id)[UIColor colorWithRed:0.9353 green:0.935 blue:0.935 alpha:1.0].CGColor];
    [track.layer addSublayer:bluePart];
    [track.layer addSublayer:onLabel.layer];
    [track.layer addSublayer:offLabel.layer];
    [trackBase addSubview:track];
    
    CALayer *mask = [CALayer layer];
    mask.frame = CGRectMake(0, 0, maskImage.size.width-2, maskImage.size.height);
    mask.contents = (id)maskImage.CGImage;
    trackBase.layer.mask = mask;
    
    CALayer *switchBase = [CALayer layer];
    switchBase.frame = CGRectMake(0, 0, baseImage.size.width-2, baseImage.size.height);
    switchBase.contents = (id)baseImage.CGImage;
    [self.layer addSublayer:switchBase];
    
    currentState = state;
    
    slider = [[UISlider alloc] initWithFrame:CGRectMake(-1, 0, baseImage.size.width, baseImage.size.height)];
    [slider setMinimumTrackImage:[UIImage alloc] forState:UIControlStateNormal];
    [slider setMaximumTrackImage:[UIImage alloc] forState:UIControlStateNormal];
    [slider setThumbImage:thumbImage forState:UIControlStateNormal];
    [slider setThumbImage:thumbImagePressed forState:UIControlStateHighlighted];
    [slider setMaximumValue:0];
    [slider setMinimumValue:-53];
    
    if (currentState == ENABLED) {
        [slider setValue:slider.maximumValue];
    } else {
        [slider setValue:slider.minimumValue];
        [track setFrame:CGRectMake(slider.minimumValue, 0, 158, 27)];
        [bluePart setHidden:YES];
    }
    
    [slider addTarget:self action:@selector(sliderChanged:) forControlEvents:UIControlEventValueChanged];
    [slider addTarget:self action:@selector(sliderUp:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside];
    [self addSubview:slider];

    return self;
}

- (void)sliderChanged:(UISlider *)sender {
    
    track.frame = CGRectMake(slider.value, 0, 158, 27);
    
    if (slider.value > -53) {
        [bluePart setHidden:NO];
    }
}

- (void)sliderUp:(UISlider *)sender {
    
    if (slider.value > -2.0) {
        
        if (currentState != ENABLED) {
            
            currentState = ENABLED;
            [_delegate switchStateChanged:YES];
        } else {
            [self disable];
        }
        
    }
    
    if (slider.value < -51) {
        if (currentState != DISABLED) {
            
            currentState = DISABLED;
            [_delegate switchStateChanged:NO];
            [bluePart setHidden:YES];
            
        } else {
            currentState = DISABLED;
            [self enable];
            
        }
    }
    
    if (slider.value < 0 && slider.value > -53) {
        
        currentState = ONTHEWAY;
        
        if (slider.value > -53/2) {
            
            [self enable];
        } else {
           
            [self disable];
        }
    }
}

- (void)enable {
    
    [bluePart setHidden:NO];
    [UIView animateWithDuration:0.15f animations:^{
        
        [slider setValue:0 animated:YES];
        track.frame = CGRectMake(0, 0, 158, 27);
        
    }];
    
    if (currentState != ENABLED) {

        currentState = ENABLED;
        [_delegate switchStateChanged:YES];
    }
}

- (void)disable {
    
    [UIView animateWithDuration:0.15f animations:^{
        
        [slider setValue:-53 animated:YES];
        track.frame = CGRectMake(-53, 0, 158, 27);
    }];
    
    if (currentState == ONTHEWAY) {
        
        currentState = DISABLED;
        [_delegate switchStateChanged:NO];
        [bluePart setHidden:YES];
    }
}

@end
