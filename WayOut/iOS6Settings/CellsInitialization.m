//
//  CellsInitialization.m
//  WayOut
//
//  Created on 08/09/17.
//
//

#import "CellsInitialization.h"

@implementation CellsInitialization {
    

}

- (instancetype)initCellsWithTableViewWidth:(CGFloat)tableWidth delegate:(id)delegate {
    
    self = [super init];

    self.multi_kloaderCell = [[iOS6KloaderCell alloc] initForPosition:iOS6TableViewCellPositionAlone withTableViewWidth:tableWidth];
    [self.multi_kloaderCell setDelegate:delegate];
    self.multi_kloaderCell.textLabel.text = @"multi_kloader";
    
    self.path1Cell = [[iOS6PathCell alloc] initForPosition:iOS6TableViewCellPositionTop withTableViewWidth:tableWidth forSection:1];
    self.path1Cell.textLabel.text = @"Path";
    self.type1Cell = [[iOS6DetailCell alloc] initForPosition:iOS6TableViewCellPositionMiddle withTableViewWidth:tableWidth withType:iOS6DetailCellTypeType forSection:1];
    self.version1Cell = [[iOS6DetailCell alloc] initForPosition:iOS6TableViewCellPositionBottom withTableViewWidth:tableWidth withType:iOS6DetailCellTypeVersion forSection:1];
    
    self.path2Cell = [[iOS6PathCell alloc] initForPosition:iOS6TableViewCellPositionTop withTableViewWidth:tableWidth forSection:2];
    self.path2Cell.textLabel.text = @"Path";
    self.type2Cell = [[iOS6DetailCell alloc] initForPosition:iOS6TableViewCellPositionMiddle withTableViewWidth:tableWidth withType:iOS6DetailCellTypeType forSection:2];
    self.version2Cell = [[iOS6DetailCell alloc] initForPosition:iOS6TableViewCellPositionBottom withTableViewWidth:tableWidth withType:iOS6DetailCellTypeVersion forSection:2];
    
    
    self.multi_kloaderHeaderHeight = [iOS6TableViewCellHelper calculateHeightForHeaderForTitle:nil];
    
    self.image1Header = [iOS6TableViewCellHelper getSectionHeaderForTitle:@"Image 1" withCellWidth:[iOS6TableViewCellHelper calculateCellWidthFromTableViewWidth:tableWidth] cellXPosition:self.multi_kloaderCell.realCellXPosition];
    
    self.image2Header = [iOS6TableViewCellHelper getSectionHeaderForTitle:@"Image 2" withCellWidth:[iOS6TableViewCellHelper calculateCellWidthFromTableViewWidth:tableWidth] cellXPosition:self.multi_kloaderCell.realCellXPosition];
    
    self.multi_kloaderFooter = [iOS6TableViewCellHelper getSectionFooterForTitle:@"Important note: multi_kloader may fail sometimes" withTableWidth:tableWidth];
    self.nullFooterHeight = [iOS6TableViewCellHelper calculateHeightForFooterForTitle:nil withCellWidth:0];
    
    

    return self;
}

@end
