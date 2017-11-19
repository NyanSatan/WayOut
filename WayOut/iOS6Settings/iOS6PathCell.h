//
//  iOS6PathCell.h
//  WayOut
//
//  Created on 31/08/2017.
//
//

#import "iOS6TableViewCell.h"

@interface iOS6PathCell : iOS6TableViewCell <UITextFieldDelegate>

- (instancetype)initWithPosition:(iOS6TableViewCellPosition)position width:(CGFloat)width cellWidth:(CGFloat)cellWidth xPosition:(CGFloat)realCellXPosition forSection:(NSInteger)section;

@end
