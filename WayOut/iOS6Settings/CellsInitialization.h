//
//  CellsInitialization.h
//  WayOut
//
//  Created on 08/09/17.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "iOS6KloaderCell.h"
#import "iOS6DetailCell.h"
#import "iOS6PathCell.h"

@interface CellsInitialization : NSObject

@property CGFloat multi_kloaderHeaderHeight;

@property UIView *image1Header;

@property UIView *image2Header;

@property UIView *multi_kloaderFooter;
@property CGFloat nullFooterHeight;

@property iOS6KloaderCell *multi_kloaderCell;

@property iOS6PathCell *path1Cell;
@property iOS6DetailCell *type1Cell;
@property iOS6DetailCell *version1Cell;

@property iOS6PathCell *path2Cell;
@property iOS6DetailCell *type2Cell;
@property iOS6DetailCell *version2Cell;

- (instancetype)initCellsWithTableViewWidth:(CGFloat)tableWidth delegate:(id)delegate;

@end
