//
//  iOS6TableViewCell.m
//  table
//
//  Created on 29/08/2017.
//
//

#import "iOS6TableViewCell.h"

@implementation iOS6TableViewCell {
    
    CGFloat tableViewWidth;
}

- (instancetype)initForPosition:(iOS6TableViewCellPosition)position withTableViewWidth:(CGFloat)width {
    
    self = [super initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    
    tableViewWidth = width;
    
    [self setPosition:position];
     
    [self setBackgroundColor:[UIColor clearColor]];
    [self setBackgroundView:[self drawCell]];
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    [self.textLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:17]];
    [self.detailTextLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:17]];
    [self.detailTextLabel setTextColor:[UIColor colorWithRed:56/255.0  green:84/255.0 blue:135/255.0 alpha:1.0]];
    
    return self;
}

- (UIView*)drawCell {
    
    UIImage *image;
    
    self.cellWidth = [iOS6TableViewCellHelper calculateCellWidthFromTableViewWidth:tableViewWidth];
    self.realCellXPosition = ceilf(tableViewWidth/2-self.cellWidth/2);
 
    CGRect frame = CGRectMake(self.realCellXPosition, 0, self.cellWidth, 44);
    
    switch (self.position) {
        case iOS6TableViewCellPositionTop:
            image = [[UIImage imageNamed:@"CellTop"] resizableImageWithCapInsets:UIEdgeInsetsMake(13, 11, 1, 11)];
            frame.size.height = 45;
            frame.origin.y = -1;
            break;
            
        case iOS6TableViewCellPositionMiddle:
            image = [[UIImage imageNamed:@"CellMiddle"] resizableImageWithCapInsets:UIEdgeInsetsMake(1, 1, 1, 1)];
            break;
            
        case iOS6TableViewCellPositionBottom:
            image = [[UIImage imageNamed:@"CellBottom"] resizableImageWithCapInsets:UIEdgeInsetsMake(1, 11, 13, 11)];
            break;
        
        case iOS6TableViewCellPositionAlone:
            image = [[UIImage imageNamed:@"CellAlone"] resizableImageWithCapInsets:UIEdgeInsetsMake(11, 11, 11, 11)];
            frame.size.height = 45;
            frame.origin.y = -1;
            break;
        
    }
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableViewWidth, frame.size.height)];
    [view setBackgroundColor:[UIColor clearColor]];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
    [imageView setBackgroundColor:[UIColor clearColor]];
    [imageView setImage:image];
    [view addSubview:imageView];
    
    return view;
}

- (void)layoutSubviews {
    [super layoutSubviews];
  
    CGRect textRect = [self.textLabel frame];
    textRect.origin.x = self.realCellXPosition + 11;
    [self.textLabel setFrame:textRect];
    
    CGRect detailTextRect = [self.detailTextLabel frame];
    detailTextRect.origin.x = self.realCellXPosition + self.cellWidth - detailTextRect.size.width - 10;
    [self.detailTextLabel setFrame:detailTextRect];
    
}

@end

@implementation iOS6TableViewCellHelper

#define FOOTERFONT [UIFont fontWithName:@"HelveticaNeue" size:15]

#define FOOTERLABELOFFSET 6

+ (CGFloat)calculateCellWidthFromTableViewWidth:(CGFloat)width {
    
    switch ([[UIDevice currentDevice] userInterfaceIdiom]) {
        case UIUserInterfaceIdiomPhone:
            return ceilf(width*0.94375);
            break;
            
        default:
            return ceilf(width*0.88518);
            break;
    }
    
}

+ (UIView*)getSectionHeaderForTitle:(NSString *)title withCellWidth:(CGFloat)cellWidth cellXPosition:(CGFloat)xPosition {
    
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, cellWidth, 30)];
    [header setBackgroundColor:[UIColor clearColor]];
        
    UILabel *headerLabel = [[UILabel alloc] init];
    headerLabel.backgroundColor = [UIColor clearColor];
    headerLabel.frame = CGRectMake(xPosition+9, 0, cellWidth, 23);
    headerLabel.text = title;
    headerLabel.textColor = [UIColor whiteColor];
    headerLabel.textAlignment = NSTextAlignmentLeft;
    headerLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:17];
    headerLabel.shadowColor = [UIColor blackColor];
    headerLabel.shadowOffset = CGSizeMake(0, -1);
    [header addSubview:headerLabel];

    return header;
}

+ (UIView*)getSectionFooterForTitle:(NSString *)title withTableWidth:(CGFloat)tableWidth {

    UIView *footer = [[UIView alloc] init];
    UILabel *footerLabel = [[UILabel alloc] init];
    footerLabel.text = title;
    footerLabel.textColor = [UIColor whiteColor];
    footerLabel.font = FOOTERFONT;
    footerLabel.shadowColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    footerLabel.shadowOffset = CGSizeMake(0, -1);
    footerLabel.textAlignment = NSTextAlignmentCenter;
    footerLabel.numberOfLines = 0;

    CGRect labelRect = CGRectMake(0, FOOTERLABELOFFSET, tableWidth, [self getLabelHeightOfString:title width:tableWidth]);
    CGRect viewRect = CGRectMake(0, 0, tableWidth, [self calculateHeightForFooterForTitle:title withCellWidth:tableWidth]);
    
    [footer setFrame:viewRect];
    [footerLabel setFrame:labelRect];
    [footer addSubview:footerLabel];

    return footer;
    
}

+ (CGFloat)calculateHeightForHeaderForTitle:(NSString*)title {
    
    if (title == nil) {
        return 4.0;
    } else {
        return 30.0;
    }
    
}

+ (CGFloat)calculateHeightForFooterForTitle:(NSString*)title withCellWidth:(CGFloat)width {

    if (title == nil) {
        return 16;
    } else {
        return [self getLabelHeightOfString:title width:width]+FOOTERLABELOFFSET+23;
    }

}

+ (CGFloat)getLabelHeightOfString:(NSString*)string width:(CGFloat)width {
    
    CGRect rect = [string boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue" size:15]} context:nil];
    return ceilf(rect.size.height);
}

@end
