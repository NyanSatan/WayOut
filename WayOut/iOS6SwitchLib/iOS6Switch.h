//
//  iOS6Switch.h
//  iOS6Switch
//
//  Created on 23.02.17.
//  All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@protocol iOS6SwitchDelegate <NSObject>
@optional
- (void)switchStateChanged:(BOOL)state;

@end

@interface iOS6Switch : UIView <UIGestureRecognizerDelegate> {
    
    id<iOS6SwitchDelegate> _delegate;
}

@property (nonatomic)id <iOS6SwitchDelegate> delegate;

- (instancetype)initWithPosition:(CGPoint)position withState:(BOOL)state;

@end
