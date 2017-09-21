//
//  iOS6LockScreenBottomBar.h
//  WayOut
//
//  Created on 13/08/2017.
//
//

#import <UIKit/UIKit.h>

@protocol iOS6LockScreenBottomBarDelegate <NSObject>
@optional
- (void)didCompleteSlide;
@end

@interface iOS6LockScreenBottomBar : UIView {
    
    id<iOS6LockScreenBottomBarDelegate> _delegate;
}

@property (nonatomic) id<iOS6LockScreenBottomBarDelegate> delegate;

- (instancetype)initWithYPosition:(CGFloat)yPosition;

- (void)setYPosition:(CGFloat)yPosition;

- (void)reset;

@end
