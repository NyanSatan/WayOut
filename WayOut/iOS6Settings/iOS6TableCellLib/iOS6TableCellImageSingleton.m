//
//  iOS6TableCellImageSingleton.m
//  table_init
//
//  Created on 15/11/17.
//
//

#import "iOS6TableCellImageSingleton.h"

@implementation iOS6TableCellImageSingleton

- (instancetype)init {
    
    self = [super init];
    
    self.cellTopImage = [[UIImage imageNamed:@"CellTop"] resizableImageWithCapInsets:UIEdgeInsetsMake(13, 11, 1, 11)];
    self.cellMiddleImage = [[UIImage imageNamed:@"CellMiddle"] resizableImageWithCapInsets:UIEdgeInsetsMake(1, 1, 1, 1)];
    self.cellBottomImage = [[UIImage imageNamed:@"CellBottom"] resizableImageWithCapInsets:UIEdgeInsetsMake(1, 11, 13, 11)];
    self.cellAloneImage = [[UIImage imageNamed:@"CellAlone"] resizableImageWithCapInsets:UIEdgeInsetsMake(11, 11, 11, 11)];
    
    return self;
}

+ (instancetype)sharedInstance {
   
    static iOS6TableCellImageSingleton *sharedInstance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        sharedInstance = [[iOS6TableCellImageSingleton alloc] init];
    });
    
    return sharedInstance;
}

@end
