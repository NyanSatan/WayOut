//
//  iOS6DetailCell.h
//  WayOut
//
//  Created on 31/08/2017.
//
//

#import "iOS6TableViewCell.h"

@interface iOS6DetailCell : iOS6TableViewCell

typedef NS_ENUM(NSInteger, iOS6DetailCellType) {
    
    iOS6DetailCellTypeType,
    iOS6DetailCellTypeVersion
};

- (instancetype)initForPosition:(iOS6TableViewCellPosition)position withTableViewWidth:(CGFloat)width withType:(iOS6DetailCellType)type forSection:(NSInteger)section;

@end
