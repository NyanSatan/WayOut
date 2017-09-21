//
//  iOS6iPadSettingsView.h
//  WayOut
//
//  Created on 04/09/17.
//
//

#import <UIKit/UIKit.h>
#import "ImageValidation.h"
#import "CellsInitialization.h"

@interface iOS6iPadSettingsView : UIView <UITableViewDelegate, UITableViewDataSource>

- (void)show;
- (void)dismiss;

@end