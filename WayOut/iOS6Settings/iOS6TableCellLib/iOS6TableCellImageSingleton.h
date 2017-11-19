//
//  iOS6TableCellImageSingleton.h
//  table_init
//
//  Created on 15/11/17.
//  
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface iOS6TableCellImageSingleton : NSObject

@property UIImage *cellAloneImage;
@property UIImage *cellTopImage;
@property UIImage *cellMiddleImage;
@property UIImage *cellBottomImage;

+ (instancetype)sharedInstance;

@end
