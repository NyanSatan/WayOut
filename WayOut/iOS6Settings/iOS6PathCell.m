//
//  iOS6PathCell.m
//  WayOut
//
//  Created on 31/08/2017.
//
//

#import "iOS6PathCell.h"

@implementation iOS6PathCell {
    
    NSInteger sectionNumber;
    NSString *key;
}

- (instancetype)initWithPosition:(iOS6TableViewCellPosition)position width:(CGFloat)width cellWidth:(CGFloat)cellWidth xPosition:(CGFloat)realCellXPosition forSection:(NSInteger)section {
    
    self = [super initWithPosition:(iOS6TableViewCellPosition)position width:(CGFloat)width cellWidth:(CGFloat)cellWidth xPosition:(CGFloat)realCellXPosition];
    
    [self.textLabel setText:@"Path"];
    
    sectionNumber = section;
    key = [NSString stringWithFormat:@"Image %ld", (long)sectionNumber];
    if (sectionNumber == 3) {
        key = @"Pre-boot script";
    }
    
    CGFloat xPosition;
    CGFloat fieldWidth;
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        fieldWidth = 210;
    } else {
        fieldWidth = 410;
    }

    xPosition = self.realCellXPosition + self.cellWidth - fieldWidth - 10;
    
    UITextField *field = [[UITextField alloc] initWithFrame:CGRectMake(xPosition, 11, fieldWidth, 22)];
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
