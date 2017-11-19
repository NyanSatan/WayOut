//
//  SettingsTableViewSingleton.h
//  WayOut
//
//  Created on 07/11/17.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ImageValidation.h"

#import "iOS6TableViewCell.h"
#import "iOS6KloaderCell.h"
#import "iOS6DetailCell.h"
#import "iOS6PathCell.h"

#import "KloaderTableViewCell.h"
#import "DetailTableViewCell.h"
#import "PathTableViewCell.h"

@interface SettingsTableViewSingleton : NSObject

- (instancetype)initWithTableWidth:(CGFloat)tableWidth delegate:(id)delegate;


#pragma mark Properties

@property CGFloat _cellWidth;
@property CGFloat _cellXPosition;

#pragma mark Section count

@property uint8_t sectionCount;


#pragma mark Row count

- (uint8_t)getRowCountForSection:(NSInteger)section;


#pragma mark Header

- (NSString *)getHeaderTitleStringForSection:(NSInteger)section;
- (UIView *)getHeaderViewForSection:(NSInteger)section;
- (CGFloat)getHeaderHeightForSection:(NSInteger)section;


#pragma mark Footer

- (NSString *)getFooterTitleStringForSection:(NSInteger)section;
- (UIView *)getFooterViewForSection:(NSInteger)section;
- (CGFloat)getFooterHeightForSection:(NSInteger)section;


#pragma mark Cells

- (UITableViewCell *)getCellForIndexPath:(NSIndexPath *)indexPath tableWidth:(CGFloat)tableWidth cellWidth:(CGFloat)cellWidth xPosition:(CGFloat)realCellXPosition;

@end