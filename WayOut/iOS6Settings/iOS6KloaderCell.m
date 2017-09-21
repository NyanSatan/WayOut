//
//  iOS6KloaderCell.m
//  WayOut
//
//  Created on 31/08/2017.
//
//

#import "iOS6KloaderCell.h"

@implementation iOS6KloaderCell

- (instancetype)initForPosition:(iOS6TableViewCellPosition)position withTableViewWidth:(CGFloat)width {
    
    self = [super initForPosition:position withTableViewWidth:width];
    
    [self.detailTextLabel removeFromSuperview];
    
    CGFloat xPosition = self.realCellXPosition + self.cellWidth - 88;
    
    iOS6Switch *kloaderSwitch = [[iOS6Switch alloc] initWithPosition:CGPointMake(xPosition, 9) withState:[ImageValidation isMultiKloaderNeeded]];
    [kloaderSwitch setDelegate:self];
    [self addSubview:kloaderSwitch];
    
    return self;
}

- (void)switchStateChanged:(BOOL)state {
    
    [_delegate didSwitchValueChanged:state];

}

@end
