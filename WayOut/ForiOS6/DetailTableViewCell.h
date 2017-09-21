//
//  DetailTableViewCell.h
//  WayOut
//
//  Created on 22/08/2017.
//
//

#import <UIKit/UIKit.h>
#import "ImageValidation.h"

@interface DetailTableViewCell : UITableViewCell

typedef NS_ENUM(NSInteger, DetailTableViewCellType) {
    
    DetailTableViewCellTypeType,
    DetailTableViewCellTypeVersion
};

- (instancetype)initWithType:(DetailTableViewCellType)type forSection:(NSInteger)section;

@end
