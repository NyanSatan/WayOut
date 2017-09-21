//
//  iOS6TableViewCell.h
//  table
//
//  Created on 29/08/2017.
//
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, iOS6TableViewCellPosition) {
    
    iOS6TableViewCellPositionTop,
    iOS6TableViewCellPositionMiddle,
    iOS6TableViewCellPositionBottom,
    iOS6TableViewCellPositionAlone
    
};

@interface iOS6TableViewCell : UITableViewCell

@property iOS6TableViewCellPosition position;
@property CGFloat cellWidth;
@property CGFloat realCellXPosition;

- (instancetype)initForPosition:(iOS6TableViewCellPosition)position withTableViewWidth:(CGFloat)width;

@end

@interface iOS6TableViewCellHelper : NSObject

+ (CGFloat)calculateCellWidthFromTableViewWidth:(CGFloat)width;

+ (UIView*)getSectionHeaderForTitle:(NSString *)title withCellWidth:(CGFloat)cellWidth cellXPosition:(CGFloat)xPosition;
+ (UIView*)getSectionFooterForTitle:(NSString *)title withTableWidth:(CGFloat)tableWidth;

+ (CGFloat)calculateHeightForHeaderForTitle:(NSString*)title;
+ (CGFloat)calculateHeightForFooterForTitle:(NSString*)title withCellWidth:(CGFloat)cellWidth;

@end