//
//  PathTableViewCell.m
//  WayOut
//
//  Created on 20/08/2017.
//
//

#import "PathTableViewCell.h"

@implementation PathTableViewCell {
    
    NSInteger sectionNumber;
    NSString *key;
}

- (instancetype)initForSection:(NSInteger)section {
    
    self = [super initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@""];
    
    CGFloat width;
    CGFloat xPosition;
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        width = 210;
        xPosition = 90;
    } else {
        width = 410;
        xPosition = 89;
    }
    
    [self.textLabel setText:@"Path"];
    
    sectionNumber = section;
    
    if (sectionNumber == 3) {
        key = @"Pre-boot script";
    } else {
        key = [NSString stringWithFormat:@"Image %ld", (long)sectionNumber];
    }
    
    [self setSelected:NO];
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    UITextField *field = [[UITextField alloc] initWithFrame:CGRectMake(xPosition, 12, width, 22)];
    field.delegate = self;
    field.textColor = [self.detailTextLabel textColor];
    field.font = [UIFont fontWithName:@"HelveticaNeue" size:17];
    field.textAlignment = NSTextAlignmentRight;
    field.text = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    field.placeholder = @"Path";
    field.keyboardType = UIKeyboardTypeASCIICapable;
    field.keyboardAppearance = UIKeyboardAppearanceDark;
    field.autocapitalizationType = UITextAutocapitalizationTypeNone;
    field.autocorrectionType = UITextAutocorrectionTypeNo;
    field.spellCheckingType = UITextSpellCheckingTypeNo;
    field.returnKeyType = UIReturnKeyDone;
    field.clearButtonMode = UITextFieldViewModeWhileEditing;
    [field addTarget:self action:@selector(textChanged:) forControlEvents:UIControlEventEditingChanged];
    [self addSubview:field];
    
    return self;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    return YES;
}

- (void)textChanged:(UITextField*)sender {
    
    [[NSUserDefaults standardUserDefaults] setObject:sender.text forKey:key];
}



@end
