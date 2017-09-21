//
//  LoadingView.h
//  WayOut
//
//  Created on 16/08/2017.
//
//

#import <UIKit/UIKit.h>

@interface LoadingView : UIView

- (instancetype)initWithAlertImage:(UIImage*)alertImage dimmingImage:(UIImage*)dimmingImage;

- (void)setAlertContent:(uint8_t)type;

- (void)show;
- (void)dismiss;

@end
