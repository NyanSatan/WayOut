//
//  KloaderTableViewCell.h
//  WayOut
//
//  Created on 20/08/2017.
//
//

#import <UIKit/UIKit.h>
#import "ImageValidation.h"

@protocol KloaderTableViewCellDelegate <NSObject>
@optional
- (void)didSwitchValueChanged:(BOOL)value;
@end

@interface KloaderTableViewCell : UITableViewCell {
    id<KloaderTableViewCellDelegate> _delegate;
}

@property (nonatomic) id<KloaderTableViewCellDelegate> delegate;

@end
