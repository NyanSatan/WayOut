//
//  iOS6TableViewCell.m
//  table
//
//  Created on 29/08/2017.
//
//

#import "iOS6TableViewCell.h"

@implementation iOS6TableViewCell

- (instancetype)initWithPosition:(iOS6TableViewCellPosition)position width:(CGFloat)width cellWidth:(CGFloat)cellWidth xPosition:(CGFloat)realCellXPosition {
  
    self = [super initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];

    self.position = position;
    self.width = width;
    self.cellWidth = cellWidth;
    self.realCellXPosition = realCellXPosition;
    
    [self setBackgroundColor:[UIColor clearColor]];
    [self setBackgroundView:[self drawCell]];
    [[self.backgroundView superview].layer setMasksToBounds:NO];
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    [self.textLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:17]];
    [self.detailTextLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:17]];
    [self.detailTextLabel setTextColor:[UIColor colorWithRed:56/255.0  green:84/255.0 blue:135/255.0 alpha:1.0]];

    return self;
}

- (UIView*)drawCell {
    
    UIImage *image;

    CGRect frame = CGRectMake(self.realCellXPosition, 0, self.cellWidth, 44);
   
    iOS6TableCellImageSingleton *images = [iOS6TableCellImageSingleton sharedInstance];
   
    switch (self.position) {
        case iOS6TableViewCellPositionTop:
            image = images.cellTopImage;
            frame.size.height = 45;
            frame.origin.y = -1;
            break;
            
        case iOS6TableViewCellPositionMiddle:
            image = images.cellMiddleImage;
            break;
            
        case iOS6TableViewCellPositionBottom:
            image = images.cellBottomImage;
            break;
        
        case iOS6TableViewCellPositionAlone:
            image = images.cellAloneImage;
            frame.size.height = 45;
            frame.origin.y = -1;
            break;
        
    }
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, frame.size.height)];
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

+ (CGFloat)calculateCellXPostionFromTableWidth:(CGFloat)tableWidth cellWidth:(CGFloat)cellWidth {
    
    return ceilf(tableWidth/2-cellWidth/2);
    
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
    footerLabel.backgroundColor = [UIColor clearColor];
    footerLabel.text = title;
    footerLabel.textColor = [UIColor whiteColor];
    footerLabel.font = FOOTERFONT;
    footerLabel.shadowColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    footerLabel.shadowOffset = CGSizeMake(0, -1);
    footerLabel.textAlignment = NSTextAlignmentCenter;
    footerLabel.numberOfLines = 0;

    CGFloat footerLabelHeight;
    
    if ([[[UIDevice currentDevice] systemVersion] intValue] < 6) {
        
        if ([title isEqualToString:@"multi_kloader isn't supported on iOS 5"]) {
            footerLabelHeight = 18;
        } else {
            footerLabelHeight = 60;
        }
        
    } else {
        footerLabelHeight = [self getLabelHeightOfString:title width:tableWidth];
    }
    
    CGRect labelRect = CGRectMake(0, FOOTERLABELOFFSET, tableWidth, footerLabelHeight);
    CGRect viewRect = CGRectMake(0, 0, tableWidth, [self calculateHeightForFooterForTitle:title withCellWidth:tableWidth textHeight:footerLabelHeight]);
    
    [footer setFrame:viewRect];
    [footerLabel setFrame:labelRect];
    [footer addSubview:footerLabel];

    return footer;
    
}

+ (CGFloat)calculateHeightForHeader:(BOOL)exist {
    
    if (!exist) {
        return 4.0;
    } else {
        return 30.0;
    }
    
}

+ (CGFloat)calculateHeightForFooterForTitle:(NSString*)title withCellWidth:(CGFloat)width textHeight:(CGFloat)height {

    if (title == nil) {
        return 16;
    } else {
        return height+FOOTERLABELOFFSET+23;
    }

}

+ (CGFloat)getLabelHeightOfString:(NSString*)string width:(CGFloat)width {
    
    CGRect rect = [string boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: FOOTERFONT} context:nil];
    return ceilf(rect.size.height);
}

@end
