//
//  iOS6TableViewCell.h
//  table
//
//  Created on 29/08/2017.
//
//

#import <UIKit/UIKit.h>
#import "iOS6TableCellImageSingleton.h"

typedef NS_ENUM(NSInteger, iOS6TableViewCellPosition) {
    
    iOS6TableViewCellPositionTop,
    iOS6TableViewCellPositionMiddle,
    iOS6TableViewCellPositionBottom,
    iOS6TableViewCellPositionAlone
    
};


@interface iOS6TableViewCell : UITableViewCell

@property iOS6TableViewCellPosition position;
@property CGFloat width;
@property CGFloat cellWidth;
@property CGFloat realCellXPosition;

- (instancetype)initWithPosition:(iOS6TableViewCellPosition)position width:(CGFloat)width cellWidth:(CGFloat)cellWidth xPosition:(CGFloat)realCellXPosition;

@end


@interface iOS6TableViewCellHelper : NSObject

+ (CGFloat)calculateCellWidthFromTableViewWidth:(CGFloat)width;
+ (CGFloat)calculateCellXPostionFromTableWidth:(CGFloat)tableWidth cellWidth:(CGFloat)cellWidth;

+ (UIView*)getSectionHeaderForTitle:(NSString *)title withCellWidth:(CGFloat)cellWidth cellXPosition:(CGFloat)xPosition;
+ (UIView*)getSectionFooterForTitle:(NSString *)title withTableWidth:(CGFloat)tableWidth;

+ (CGFloat)calculateHeightForHeader:(BOOL)exist;
+ (CGFloat)calculateHeightForFooterForTitle:(NSString*)title withCellWidth:(CGFloat)cellWidth textHeight:(CGFloat)height;

@end