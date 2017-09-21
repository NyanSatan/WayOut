//
//  PathTableViewCell.h
//  WayOut
//
//  Created on 20/08/2017.
//
//

#import <UIKit/UIKit.h>

@interface PathTableViewCell : UITableViewCell <UITextFieldDelegate> 

- (instancetype)initForSection:(NSInteger)section;

@end
