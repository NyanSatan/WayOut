//
//  iOS6KloaderCell.m
//  WayOut
//
//  Created on 31/08/2017.
//
//

#import "iOS6KloaderCell.h"

@implementation iOS6KloaderCell

- (instancetype)initWithPosition:(iOS6TableViewCellPosition)position width:(CGFloat)width cellWidth:(CGFloat)cellWidth xPosition:(CGFloat)realCellXPosition {
    
    self = [super initWithPosition:(iOS6TableViewCellPosition)position width:(CGFloat)width cellWidth:(CGFloat)cellWidth xPosition:(CGFloat)realCellXPosition];
    
    [self.detailTextLabel removeFromSuperview];
    [self.textLabel setText:@"multi_kloader"];

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
