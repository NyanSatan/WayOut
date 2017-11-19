//
//  iOS6DetailCell.m
//  WayOut
//
//  Created on 31/08/2017.
//
//

#import "iOS6DetailCell.h"
#import "ImageValidation.h"

@implementation iOS6DetailCell {
    
    NSInteger sectionNumber;
    iOS6DetailCellType cellType;
}

- (instancetype)initWithPosition:(iOS6TableViewCellPosition)position width:(CGFloat)width cellWidth:(CGFloat)cellWidth xPosition:(CGFloat)realCellXPosition withType:(iOS6DetailCellType)type forSection:(NSInteger)section {
    
    self = [super initWithPosition:(iOS6TableViewCellPosition)position width:(CGFloat)width cellWidth:(CGFloat)cellWidth xPosition:(CGFloat)realCellXPosition];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pathChanged) name:NSUserDefaultsDidChangeNotification object:nil];
    
    cellType = type;
    sectionNumber = section;
    
    switch (type) {
        case iOS6DetailCellTypeType:
            self.textLabel.text = @"Type";
            break;
            
        case iOS6DetailCellTypeVersion:
            self.textLabel.text = @"Version";
            break;
            
        default:
            break;
    }
    
    [self pathChanged];
    
    return self;
}

- (void)pathChanged {
    
    switch (cellType) {
        case iOS6DetailCellTypeType:
            
            if (sectionNumber != 3) {
                self.detailTextLabel.text = [ImageValidation getiBootInfoForImage:sectionNumber ofType:iBootType];
            } else {
                self.detailTextLabel.text = [ImageValidation getScriptType];
            }
            
            break;
            
        case iOS6DetailCellTypeVersion:
            self.detailTextLabel.text = [ImageValidation getiBootInfoForImage:sectionNumber ofType:iBootVersion];
            break;
            
        default:
            break;
    }
    
    
}

@end
