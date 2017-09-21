//
//  iOS6PathCell.h
//  WayOut
//
//  Created on 31/08/2017.
//
//

#import "iOS6TableViewCell.h"

@interface iOS6PathCell : iOS6TableViewCell <UITextFieldDelegate>

- (instancetype)initForPosition:(iOS6TableViewCellPosition)position withTableViewWidth:(CGFloat)width forSection:(NSInteger)section;

@end
