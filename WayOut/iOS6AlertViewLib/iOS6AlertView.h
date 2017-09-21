//
//  iOS6AlertView.h
//  iOS6AlertView
//
//  Created on 19/05/17.
//
//

#import <UIKit/UIKit.h>

@protocol iOS6AlertViewDelegate <NSObject>
@optional
- (void)clickedAlertButtonWithTitle:(NSString*)title;
@end

@interface iOS6AlertView : UIView {
    
    id<iOS6AlertViewDelegate> _delegate;
}

@property (nonatomic) id<iOS6AlertViewDelegate> delegate;


- (instancetype)initWithTitle:(NSString*)title message:(NSString *)message delegate:(id)delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitle:(NSString *)otherButtonTitle backgroundImage:(UIImage*)backgroundImage dimmingImage:(UIImage*)dimmingImage position:(CGPoint)position animated:(BOOL)animated;

- (void)show;

- (void)dismiss;

@end
