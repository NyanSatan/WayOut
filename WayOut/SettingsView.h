//
//  SettingsView.h
//  WayOut
//
//  Created on 24.02.17.
//  All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iOS6Switch.h"
#import "ImageValidation.h"

@protocol SettingsViewDelegate <NSObject>
@optional
- (void)saveButtonPressed;
@end

@interface SettingsView : UIView <iOS6SwitchDelegate, UITextFieldDelegate, UIScrollViewDelegate> {
    
    id<SettingsViewDelegate> _delegate;
}

@property (nonatomic) id<SettingsViewDelegate> delegate;

- (instancetype)initWithLinenImage:(UIImage*)linenImage;
- (instancetype)initForiPad;

@end
