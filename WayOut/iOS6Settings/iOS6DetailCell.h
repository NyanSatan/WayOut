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

- (instancetype)initWithPosition:(iOS6TableViewCellPosition)position width:(CGFloat)width cellWidth:(CGFloat)cellWidth xPosition:(CGFloat)realCellXPosition withType:(iOS6DetailCellType)type forSection:(NSInteger)section;

@end
