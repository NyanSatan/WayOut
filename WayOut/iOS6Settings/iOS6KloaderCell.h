//
//  iOS6KloaderCell.h
//  WayOut
//
//  Created on 31/08/2017.
//
//

#import "iOS6TableViewCell.h"
#import "ImageValidation.h"
#import "iOS6SwitchLib/iOS6Switch.h"

@protocol iOS6KloaderCellDelegate <NSObject>
@optional
- (void)didSwitchValueChanged:(BOOL)value;
@end

@interface iOS6KloaderCell : iOS6TableViewCell <iOS6SwitchDelegate>

@property (nonatomic) id<iOS6KloaderCellDelegate> delegate;

@end
