//
//  KloaderTableViewCell.m
//  WayOut
//
//  Created on 20/08/2017.
//
//

#import "KloaderTableViewCell.h"

@implementation KloaderTableViewCell

- (instancetype)init {
    
    self = [super initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@""];
    
    [self setSelected:NO];
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    CGFloat xPosition;
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        xPosition = 223;
    } else {
        xPosition = 421;
    }
    
    [self.textLabel setText:@"multi_kloader"];
    
    UISwitch *kloaderSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(xPosition, 9, 0, 0)];
    [kloaderSwitch setOn:[ImageValidation isMultiKloaderNeeded]];
    [kloaderSwitch addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
    [self addSubview:kloaderSwitch];

    if ([[[UIDevice currentDevice] systemVersion] intValue] < 6) {
        
        [kloaderSwitch setEnabled:NO];
        [self.textLabel setEnabled:NO];
    }

    return self;
}

- (void)switchAction:(UISwitch*)sender {
    
    [_delegate didSwitchValueChanged:sender.on];
    
}

@end
