//
//  SettingsTableViewSingleton.m
//  WayOut
//
//  Created on 07/11/17.
//
//

#import "SettingsTableViewSingleton.h"

@implementation SettingsTableViewSingleton {
    
    int iOSVersion;
    
    CGFloat _tableWidth;
    
    UIView *image1Header;
    UIView *image2Header;
    UIView *scriptHeader;
    
    CGFloat cellWidth;
    CGFloat cellXPosition;
    
    CGFloat headerHeight;
    CGFloat nullHeaderHeight;
    
    UIView *multi_kloaderFooter;
    UIView *scriptFooter;
    
    CGFloat multi_kloaderFooterHeight;
    CGFloat scriptFooterHeight;
    
    NSString *kloaderWarning;
    NSString *scriptWarning;
    
    iOS6KloaderCell *kloaderCell;
    iOS6PathCell *path1Cell;
    iOS6DetailCell *type1Cell;
    iOS6DetailCell *version1Cell;
    iOS6PathCell *path2Cell;
    iOS6DetailCell *type2Cell;
    iOS6DetailCell *version2Cell;
    iOS6PathCell *scriptCell;
    iOS6DetailCell *typeScriptCell;
    
    KloaderTableViewCell *kloaderCell6;
    PathTableViewCell *path1Cell6;
    DetailTableViewCell *type1Cell6;
    DetailTableViewCell *version1Cell6;
    PathTableViewCell *path2Cell6;
    DetailTableViewCell *type2Cell6;
    DetailTableViewCell *version2Cell6;
    PathTableViewCell *scriptCell6;
    DetailTableViewCell *typeScriptCell6;
}

- (instancetype)initWithTableWidth:(CGFloat)tableWidth delegate:(id)delegate {
    
    self = [super init];
   
    iOSVersion = [[[UIDevice currentDevice] systemVersion] intValue];
    
    _tableWidth = tableWidth;
    
    scriptWarning = @"Script will be executed between image validation and image executuion\nScript won't be validated";
    
    if (iOSVersion == 5) {
        kloaderWarning = @"multi_kloader isn't supported on iOS 5";
    } else {
        kloaderWarning = @"Important note: multi_kloader may fail sometimes";
    }
    
    if (iOSVersion != 6) {
        cellWidth = [iOS6TableViewCellHelper calculateCellWidthFromTableViewWidth:tableWidth];
        cellXPosition = [iOS6TableViewCellHelper calculateCellXPostionFromTableWidth:tableWidth cellWidth:cellWidth];
        
        self._cellWidth = cellWidth;
        self._cellXPosition = cellXPosition;
    }
    
    if (iOSVersion > 6) {
        
        kloaderCell = [[iOS6KloaderCell alloc] initWithPosition:iOS6TableViewCellPositionAlone width:tableWidth cellWidth:cellWidth xPosition:cellXPosition];
        [kloaderCell setDelegate:delegate];
        path1Cell = [[iOS6PathCell alloc] initWithPosition:iOS6TableViewCellPositionTop width:tableWidth cellWidth:cellWidth xPosition:cellXPosition forSection:1];
        type1Cell = [[iOS6DetailCell alloc] initWithPosition:iOS6TableViewCellPositionMiddle width:tableWidth cellWidth:cellWidth xPosition:cellXPosition withType:iOS6DetailCellTypeType forSection:1];
        version1Cell = [[iOS6DetailCell alloc] initWithPosition:iOS6TableViewCellPositionBottom width:tableWidth cellWidth:cellWidth xPosition:cellXPosition withType:iOS6DetailCellTypeVersion forSection:1];
        path2Cell = [[iOS6PathCell alloc] initWithPosition:iOS6TableViewCellPositionTop width:tableWidth cellWidth:cellWidth xPosition:cellXPosition forSection:2];
        type2Cell = [[iOS6DetailCell alloc] initWithPosition:iOS6TableViewCellPositionMiddle width:tableWidth cellWidth:cellWidth xPosition:cellXPosition withType:iOS6DetailCellTypeType forSection:2];
        version2Cell = [[iOS6DetailCell alloc] initWithPosition:iOS6TableViewCellPositionBottom width:tableWidth cellWidth:cellWidth xPosition:cellXPosition withType:iOS6DetailCellTypeVersion forSection:2];
        scriptCell = [[iOS6PathCell alloc] initWithPosition:iOS6TableViewCellPositionTop width:tableWidth cellWidth:cellWidth xPosition:cellXPosition forSection:3];
        typeScriptCell = [[iOS6DetailCell alloc] initWithPosition:iOS6TableViewCellPositionBottom width:tableWidth cellWidth:cellWidth xPosition:cellXPosition withType:iOS6DetailCellTypeType forSection:3];
        
    } else {
        
        kloaderCell6 = [[KloaderTableViewCell alloc] init];
        [kloaderCell6 setDelegate:delegate];
        path1Cell6 = [[PathTableViewCell alloc] initForSection:1];
        type1Cell6 = [[DetailTableViewCell alloc] initWithType:DetailTableViewCellTypeType forSection:1];
        version1Cell6 = [[DetailTableViewCell alloc] initWithType:DetailTableViewCellTypeVersion forSection:1];
        path2Cell6 = [[PathTableViewCell alloc] initForSection:2];
        type2Cell6 = [[DetailTableViewCell alloc] initWithType:DetailTableViewCellTypeType forSection:2];
        version2Cell6 = [[DetailTableViewCell alloc] initWithType:DetailTableViewCellTypeVersion forSection:2];
        scriptCell6 = [[PathTableViewCell alloc] initForSection:3];
        typeScriptCell6 = [[DetailTableViewCell alloc] initWithType:DetailTableViewCellTypeType forSection:3];
    }
    
    headerHeight = [iOS6TableViewCellHelper calculateHeightForHeader:YES];
    nullHeaderHeight = [iOS6TableViewCellHelper calculateHeightForHeader:NO];
    
    if (iOSVersion == 5 || iOSVersion > 6) {
        
        multi_kloaderFooter = [iOS6TableViewCellHelper getSectionFooterForTitle:kloaderWarning withTableWidth:_tableWidth];
        multi_kloaderFooterHeight = multi_kloaderFooter.frame.size.height;
        
        scriptFooter = [iOS6TableViewCellHelper getSectionFooterForTitle:scriptWarning withTableWidth:_tableWidth];
        scriptFooterHeight = scriptFooter.frame.size.height;
    }
    
    if ([ImageValidation isMultiKloaderNeeded]) {
        self.sectionCount = 4;
    } else {
        self.sectionCount = 3;
    }
    
    return self;
}


#pragma mark Row count

- (uint8_t)getRowCountForSection:(NSInteger)section {
    
    if (section == 0) {
        return 1;
    }
    
    if (section == 1) {
        return 3;
    }
    
    if (section == 2) {
        
        if ([ImageValidation isMultiKloaderNeeded]) {
            return 3;
        } else {
            return 2;
        }
        
    }
    
    if (section == 3) {
        return 2;
    }
    
    return 0;
}


#pragma mark Header

- (NSString *)getHeaderTitleStringForSection:(NSInteger)section {
    
    if (iOSVersion == 6) {
        
        switch (section) {
            case 0:
                return @"";
                break;
                
            case 1:
                return @"Image 1";
                break;
                
            case 2:
                if ([ImageValidation isMultiKloaderNeeded]) {
                    return @"Image 2";
                } else {
                    return @"Pre-boot script";
                }
                break;
                
            case 3:
                return @"Pre-boot script";
                break;
                
            default:
                return @"";
                break;
        }

    } else {
        return nil;
    }
    
}

- (UIView *)getHeaderViewForSection:(NSInteger)section {
    
    if (iOSVersion == 5 || iOSVersion > 6) {
        
        switch (section) {
            case 1:
                if (image1Header == NULL) {
                    image1Header = [iOS6TableViewCellHelper getSectionHeaderForTitle:@"Image 1" withCellWidth:cellWidth cellXPosition:cellXPosition];
                }
                
                return image1Header;
                break;
                
            case 2:
                
                if ([ImageValidation isMultiKloaderNeeded]) {
                    if (image2Header == NULL) {
                        image2Header = [iOS6TableViewCellHelper getSectionHeaderForTitle:@"Image 2" withCellWidth:cellWidth cellXPosition:cellXPosition];
                    }
                    return image2Header;
                    
                } else {
                    if (scriptHeader == NULL) {
                        scriptHeader = [iOS6TableViewCellHelper getSectionHeaderForTitle:@"Pre-boot script" withCellWidth:cellWidth cellXPosition:cellXPosition];
                    }
                    
                    return scriptHeader;
                }
                
                break;
                
            case 3:
                if (scriptHeader == NULL) {
                    scriptHeader = [iOS6TableViewCellHelper getSectionHeaderForTitle:@"Pre-boot script" withCellWidth:cellWidth cellXPosition:cellXPosition];
                }
                return scriptHeader;
                break;
                
            default:
                return nil;
                break;
        }
        
    } else {
        
        return nil;
        
    }
    
}

- (CGFloat)getHeaderHeightForSection:(NSInteger)section {
    
    if (iOSVersion == 5 || iOSVersion > 6) {
        
        switch (section) {
            case 0:
                return nullHeaderHeight;
                break;
                
            default:
                return headerHeight;
                break;
        }
        
        
    } else {
        
        return -1;
    }
}


#pragma mark Footer

- (NSString*)getFooterTitleStringForSection:(NSInteger)section {
    
    if (iOSVersion == 6) {
    
        switch (section) {
            case 0:
                return kloaderWarning;
                break;
            
            case 2:
                if (![ImageValidation isMultiKloaderNeeded]) {
                    return scriptWarning;
                } else {
                    return @"";
                }
                
                break;
                
            case 3:
                return scriptWarning;
                break;
            
            default:
                return @"";
                break;
        }
        
    } else {
        
        return nil;
    }
}

- (UIView*)getFooterViewForSection:(NSInteger)section {
    
    if (iOSVersion == 5 || iOSVersion > 6) {
        
        switch (section) {
            case 0:
                return multi_kloaderFooter;
                break;
             
            case 2:
                if (![ImageValidation isMultiKloaderNeeded]) {
                    return scriptFooter;
                } else {
                    return nil;
                }
                
                break;
                
            case 3:
                return scriptFooter;
                break;
                
            default:
                return nil;
                break;
        }
        
    } else {
        
        return nil;
    }
    
}

- (CGFloat)getFooterHeightForSection:(NSInteger)section {
    
    if (iOSVersion == 5 || iOSVersion > 6) {
        
        switch (section) {
            case 0:
                return multi_kloaderFooterHeight;
                break;
                
            case 2:
                if (![ImageValidation isMultiKloaderNeeded]) {
                    return scriptFooterHeight;
                } else {
                    return 0;
                }
                
                break;
                
            case 3:
                return scriptFooterHeight;
                break;
                
            default:
                return 0;
                break;
        }
        
    } else {
        
        return -1;
    }
}


#pragma mark Cells

- (UITableViewCell *)getCellForIndexPath:(NSIndexPath *)indexPath tableWidth:(CGFloat)tableWidth cellWidth:(CGFloat)cellWidth xPosition:(CGFloat)realCellXPosition {
    
    if (iOSVersion > 6) {
        
        switch (indexPath.section) {
            case 0:
                return kloaderCell;
                break;
                
            case 1:
                
                switch (indexPath.row) {
                    case 0:
                        return path1Cell;
                        break;
                        
                    case 1:
                        return type1Cell;
                        break;
                        
                    case 2:
                        return version1Cell;
                        break;
                }
                
            case 2:
                
                if ([ImageValidation isMultiKloaderNeeded]) {
                    
                    switch (indexPath.row) {
                        case 0:
                            return path2Cell;
                            break;
                            
                        case 1:
                            return type2Cell;
                            break;
                            
                        case 2:
                            return version2Cell;
                            break;
                    }
                } else {
                    switch (indexPath.row) {
                        case 0:
                            return scriptCell;
                            break;
                            
                        case 1:
                            return typeScriptCell;
                            break;
                            
                    }
                }
                
                
                
            case 3:
                switch (indexPath.row) {
                    case 0:
                        return scriptCell;
                        break;
                        
                    case 1:
                        return typeScriptCell;
                        break;
                        
                }
                break;
        }
        
        
    } else {
        
        switch (indexPath.section) {
            case 0:
                return kloaderCell6;
                break;
                
            case 1:
                
                switch (indexPath.row) {
                    case 0:
                        return path1Cell6;
                        break;
                        
                    case 1:
                        return type1Cell6;
                        break;
                        
                    case 2:
                        return version1Cell6;
                        break;
                }
                
            case 2:
                if ([ImageValidation isMultiKloaderNeeded]) {
                    
                    switch (indexPath.row) {
                        case 0:
                            return path2Cell6;
                            break;
                            
                        case 1:
                            return type2Cell6;
                            break;
                            
                        case 2:
                            return version2Cell6;
                            break;
                    }
                } else {
                    switch (indexPath.row) {
                        case 0:
                            return scriptCell6;
                            break;
                            
                        case 1:
                            return typeScriptCell6;
                            break;
                            
                    }
                }
            case 3:
                switch (indexPath.row) {
                    case 0:
                        return scriptCell6;
                        break;
                        
                    case 1:
                        return typeScriptCell6;
                        break;
                        
                }
                break;
                
        }

        
    }
    
    return nil;
}

@end