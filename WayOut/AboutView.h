//
//  AboutView.h
//  WayOut
//
//  Created on 03.02.17.
//  All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AboutViewDelegate <NSObject>
@optional
- (void)didSettingsButtonPressed;
@end

@interface AboutView : UIView {
    
    id<AboutViewDelegate> _delegate;
}

@property (nonatomic) id<AboutViewDelegate> delegate;

- (instancetype)initWithAlertImage:(UIImage*)alertImage;

@end
