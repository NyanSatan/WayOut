//
//  DetailTableViewCell.m
//  WayOut
//
//  Created on 22/08/2017.
//
//

#import "DetailTableViewCell.h"

@implementation DetailTableViewCell {
    
    NSInteger sectionNumber;
    DetailTableViewCellType cellType;
}

- (instancetype)initWithType:(DetailTableViewCellType)type forSection:(NSInteger)section {
    
    self = [super initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@""];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pathChanged) name:NSUserDefaultsDidChangeNotification object:nil];
    
    cellType = type;
    sectionNumber = section;
    
    [self setSelected:NO];
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    switch (type) {
        case DetailTableViewCellTypeType:
            self.textLabel.text = @"Type";
            break;
        
        case DetailTableViewCellTypeVersion:
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
        case DetailTableViewCellTypeType:
            
            if (sectionNumber != 3) {
                self.detailTextLabel.text = [ImageValidation getiBootInfoForImage:sectionNumber ofType:iBootType];
            } else {
                self.detailTextLabel.text = [ImageValidation getScriptType];
            }
            
            break;
            
        case DetailTableViewCellTypeVersion:
            self.detailTextLabel.text = [ImageValidation getiBootInfoForImage:sectionNumber ofType:iBootVersion];
            break;
            
        default:
            break;
    }
    

}

@end
