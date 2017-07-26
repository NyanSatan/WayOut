//
//  SettingsView.m
//  WayOut
//
//  Created on 24.02.17.
//  All rights reserved.
//

#import "SettingsView.h"

@implementation SettingsView {
    
    CGSize screenSize;
    
    UIScrollView *scroll;
    UIImage *scrollImage;
    
    UIView *image1;
    UIView *image2;
    
    CGFloat previousOffset;
    
    UITextField *image1PathDetail;
    UITextField *image2PathDetail;
    UILabel *image1TypeDetail;
    UILabel *image1VersionDetail;
    UILabel *image2TypeDetail;
    UILabel *image2VersionDetail;
}

#pragma mark Initialization for iPhone/iPod touch

- (instancetype)initWithLinenImage:(UIImage *)linenImage {
    
    self = [super init];
    
    screenSize = [[UIScreen mainScreen] bounds].size;
    [self setFrame:CGRectMake(0, screenSize.height, screenSize.width, screenSize.height-20)];
    [self.layer setMasksToBounds:YES];
    
    UIImageView *linen = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, screenSize.width, screenSize.height)];
    [linen setImage:linenImage];
    [self addSubview:linen];

    UIImage *navigationBarBackground = [UIImage imageNamed:@"UINavigationBarBlackTranslucentBackground"];
    UINavigationBar *navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, screenSize.width, navigationBarBackground.size.height)];
    [navigationBar setBackgroundImage:navigationBarBackground forBarMetrics:UIBarMetricsDefault];
    
    UIImage *leftCornerImage = [UIImage imageNamed:@"UINavigationBarBlackTranslucentLeftCorner"];
    UIImage *rightCornerImage = [UIImage imageNamed:@"UINavigationBarBlackTranslucentRightCorner"];
    UIImageView *leftCorner = [[UIImageView alloc] initWithImage:leftCornerImage];
    leftCorner.frame = CGRectMake(0, 0, leftCornerImage.size.width, leftCornerImage.size.width);
    UIImageView *rightCorner = [[UIImageView alloc] initWithImage:rightCornerImage];
    rightCorner.frame = CGRectMake(screenSize.width-leftCornerImage.size.width, 0, leftCornerImage.size.width, leftCornerImage.size.width);
    [navigationBar addSubview:leftCorner];
    [navigationBar addSubview:rightCorner];
    
    UINavigationItem *navigationItem = [[UINavigationItem alloc] init];
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 24)];
    title.text = @"Settings";
    title.textColor = [UIColor whiteColor];
    title.textAlignment = NSTextAlignmentCenter;
    title.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:20];
    title.shadowColor = [UIColor blackColor];
    title.shadowOffset = CGSizeMake(0, -1);
    [navigationItem setTitleView:title];
    
    UIImage *saveImage = [[UIImage imageNamed:@"UINavigationBarDoneButtonDark"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 5, 0, 5)];
    UIButton *saveButtonPrototype = [UIButton buttonWithType:UIButtonTypeCustom];
    [saveButtonPrototype setFrame:CGRectMake(0, 0, 48, saveImage.size.height)];
    [saveButtonPrototype setBackgroundImage:saveImage forState:UIControlStateNormal];
    [saveButtonPrototype setTitle:@"Save" forState:UIControlStateNormal];
    [saveButtonPrototype.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:12]];
    [saveButtonPrototype.titleLabel setTextColor:[UIColor whiteColor]];
    [saveButtonPrototype setTitleShadowColor:[[UIColor blackColor] colorWithAlphaComponent:0.33] forState:UIControlStateNormal];
    [saveButtonPrototype.titleLabel setShadowOffset:CGSizeMake(0, -1)];
    [saveButtonPrototype addTarget:self action:@selector(saveAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithCustomView:saveButtonPrototype];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSpacer.width = -11;
    navigationItem.rightBarButtonItems = @[negativeSpacer, saveButton];
    navigationBar.items = @[navigationItem];

    scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, screenSize.width, self.frame.size.height)];
    [scroll setDelegate:self];
    [scroll setAlwaysBounceVertical:YES];
    [scroll setScrollIndicatorInsets:UIEdgeInsetsMake(44, 0, 0, -1)];
    [self addSubview:scroll];
    [self addSubview:navigationBar];
    
    if (screenSize.height < 568) {
        
        scrollImage = [[UIImage imageNamed:@"UIScrollerIndicatorBlack"] resizableImageWithCapInsets:UIEdgeInsetsMake(2, 0, 2, 0)];
    }
    
    UIView *multi_kloader = [self createViewWithNumberOfCellsInStyleOfSetupAssistant:1 headerTitle:nil footerTitle:@"Important note: multi_kloader may fail sometimes" withYPosition:54 foriPad:NO];
    [scroll addSubview:multi_kloader];
    
    BOOL isMultiKloaderNeeded = [ImageValidation isMultiKloaderNeeded];

    UILabel *multiKloaderLabel = [self createViewWithCellLabel:@"multi_kloader" forEntry:0 isHeaderPresent:NO];
    [multi_kloader addSubview:multiKloaderLabel];
    iOS6Switch *mSwitch = [[iOS6Switch alloc] initWithPosition:CGPointMake(214, 9) withState:isMultiKloaderNeeded];
    mSwitch.delegate = self;
    [multi_kloader addSubview:mSwitch];
    
    CGFloat spaceBetween = 17;
    
    image1 = [self createViewWithNumberOfCellsInStyleOfSetupAssistant:3 headerTitle:@"Image 1" footerTitle:nil withYPosition:multi_kloader.frame.origin.y+multi_kloader.frame.size.height+spaceBetween foriPad:NO];
    [scroll addSubview:image1];
    UILabel *image1Path = [self createViewWithCellLabel:@"Path" forEntry:0 isHeaderPresent:YES];
    [image1 addSubview:image1Path];
    UILabel *image1Type = [self createViewWithCellLabel:@"Type" forEntry:1 isHeaderPresent:YES];
    [image1 addSubview:image1Type];
    UILabel *image1Version = [self createViewWithCellLabel:@"Version" forEntry:2 isHeaderPresent:YES];
    [image1 addSubview:image1Version];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if ([[[UIDevice currentDevice] systemVersion] intValue] != 7) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        
    } else {
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardDidHideNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardDidShowNotification object:nil];
    }
    
    image1PathDetail = [self createTextFieldForEntry:0 isHeaderPresent:YES foriPad:NO];
    image1PathDetail.text = [defaults stringForKey:@"Image 1"];
    image1PathDetail.delegate = self;
    [image1PathDetail addTarget:self action:@selector(textDidChangeInImage1) forControlEvents:UIControlEventEditingChanged];
    image1PathDetail.tag = 0;
    if ([ImageValidation isImageExistAtPath:[defaults valueForKey:@"Image 1"]]) {
        
        if ([ImageValidation isARMImageValidAtPath:[defaults valueForKey:@"Image 1"]]) {
            
            image1TypeDetail = [self createViewWithCellDetailLabel:[ImageValidation getiBootTypeAtPath:[defaults  valueForKey:@"Image 1"] isIMG3:NO] forEntry:1 isHeaderPresent:YES foriPad:NO];
            image1VersionDetail = [self createViewWithCellDetailLabel:[ImageValidation getiBootVersionAtPath:[defaults  valueForKey:@"Image 1"] isIMG3:NO] forEntry:2 isHeaderPresent:YES foriPad:NO];
        } else {
            
            image1TypeDetail = [self createViewWithCellDetailLabel:@"Image not valid" forEntry:1 isHeaderPresent:YES foriPad:NO];
            image1VersionDetail = [self createViewWithCellDetailLabel:@"Image not valid" forEntry:2 isHeaderPresent:YES foriPad:NO];
        }
    } else {
        
        image1TypeDetail = [self createViewWithCellDetailLabel:@"No image exists" forEntry:1 isHeaderPresent:YES foriPad:NO];
        image1VersionDetail = [self createViewWithCellDetailLabel:@"No image exists" forEntry:2 isHeaderPresent:YES foriPad:NO];
    }
    [image1 addSubview:image1PathDetail];
    [image1 addSubview:image1TypeDetail];
    [image1 addSubview:image1VersionDetail];
    
    image2 = [self createViewWithNumberOfCellsInStyleOfSetupAssistant:3 headerTitle:@"Image 2" footerTitle:nil withYPosition:image1.frame.origin.y+image1.frame.size.height+spaceBetween foriPad:NO];
    [scroll addSubview:image2];
    UILabel *image2Path = [self createViewWithCellLabel:@"Path" forEntry:0 isHeaderPresent:YES];
    [image2 addSubview:image2Path];
    UILabel *image2Type = [self createViewWithCellLabel:@"Type" forEntry:1 isHeaderPresent:YES];
    [image2 addSubview:image2Type];
    UILabel *image2Version = [self createViewWithCellLabel:@"Version" forEntry:2 isHeaderPresent:YES];
    [image2 addSubview:image2Version];
    
    image2PathDetail = [self createTextFieldForEntry:0 isHeaderPresent:YES foriPad:NO];
    image2PathDetail.text = [defaults stringForKey:@"Image 2"];
    image2PathDetail.delegate = self;
    [image2PathDetail addTarget:self action:@selector(textDidChangeInImage2) forControlEvents:UIControlEventEditingChanged];
    image2PathDetail.tag = 1;
    if ([ImageValidation isImageExistAtPath:[[NSUserDefaults standardUserDefaults] valueForKey:@"Image 2"]]) {
        
        if ([ImageValidation isIMG3ImageValidAtPath:[defaults valueForKey:@"Image 2"]]) {
        
            image2TypeDetail = [self createViewWithCellDetailLabel:[ImageValidation getiBootTypeAtPath:[[NSUserDefaults standardUserDefaults] valueForKey:@"Image 2"] isIMG3:YES] forEntry:1 isHeaderPresent:YES foriPad:NO];
            image2VersionDetail = [self createViewWithCellDetailLabel:[ImageValidation getiBootVersionAtPath:[[NSUserDefaults standardUserDefaults] valueForKey:@"Image 2"] isIMG3:YES] forEntry:2 isHeaderPresent:YES foriPad:NO];
        } else {
            image2TypeDetail = [self createViewWithCellDetailLabel:@"Image not valid" forEntry:1 isHeaderPresent:YES foriPad:NO];
            image2VersionDetail = [self createViewWithCellDetailLabel:@"Image not valid" forEntry:2 isHeaderPresent:YES foriPad:NO];
        }
        
    } else {
        
        image2TypeDetail = [self createViewWithCellDetailLabel:@"No image exists" forEntry:1 isHeaderPresent:YES foriPad:NO];
        image2VersionDetail = [self createViewWithCellDetailLabel:@"No image exists" forEntry:2 isHeaderPresent:YES foriPad:NO];
    }
    [image2 addSubview:image2PathDetail];
    [image2 addSubview:image2TypeDetail];
    [image2 addSubview:image2VersionDetail];
    
    if (isMultiKloaderNeeded) {
        scroll.contentSize = CGSizeMake(screenSize.width, image2.frame.origin.y+image2.frame.size.height+30);
    } else {
        scroll.contentSize = CGSizeMake(screenSize.width, image2.frame.origin.y+30);
        [image2 setHidden:YES];
    }
    
    return self;
}



#pragma mark Initialization for iPad

- (instancetype)initForiPad {
    
    self = [super init];
    
    [self setFrame:CGRectMake(114, 1038, 540, 620)];
    
    CALayer *baseLayer = [CALayer layer];
    baseLayer.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    baseLayer.backgroundColor = [UIColor clearColor].CGColor;
    baseLayer.contents = (id)[UIImage imageNamed:@"LinenSettings"].CGImage;
    baseLayer.shadowColor = [UIColor blackColor].CGColor;
    baseLayer.shadowRadius = 10;
    baseLayer.shadowOpacity = 1;
    baseLayer.shadowOffset = CGSizeMake(0, 0);
    baseLayer.shouldRasterize = YES;
    baseLayer.rasterizationScale = [[UIScreen mainScreen] scale];
    
    [self.layer addSublayer:baseLayer];

    UIImage *navigationBarBackground = [UIImage imageNamed:@"UINavigationBarBlackTranslucentBackground"];
    UINavigationBar *navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, navigationBarBackground.size.height)];
    [navigationBar setBackgroundImage:navigationBarBackground forBarMetrics:UIBarMetricsDefault];
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:navigationBar.bounds byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerTopRight) cornerRadii:CGSizeMake(5.0, 5.0)];
    CAShapeLayer *navigationBarMask = [[CAShapeLayer alloc] init];
    navigationBarMask.frame = navigationBar.bounds;
    navigationBarMask.path  = maskPath.CGPath;
    
    navigationBar.layer.mask = navigationBarMask;
    navigationBar.layer.masksToBounds = YES;
    
    UINavigationItem *navigationItem = [[UINavigationItem alloc] init];
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 24)];
    title.text = @"Settings";
    title.textColor = [UIColor whiteColor];
    title.textAlignment = NSTextAlignmentCenter;
    title.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:20];
    title.shadowColor = [UIColor blackColor];
    title.shadowOffset = CGSizeMake(0, -1);
    [navigationItem setTitleView:title];
    
    UIImage *saveImage = [[UIImage imageNamed:@"UINavigationBarDoneButtonDark"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 5, 0, 5)];
    UIButton *saveButtonPrototype = [UIButton buttonWithType:UIButtonTypeCustom];
    [saveButtonPrototype setFrame:CGRectMake(0, 0, 48, saveImage.size.height)];
    [saveButtonPrototype setBackgroundImage:saveImage forState:UIControlStateNormal];
    [saveButtonPrototype setTitle:@"Save" forState:UIControlStateNormal];
    [saveButtonPrototype.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:12]];
    [saveButtonPrototype.titleLabel setTextColor:[UIColor whiteColor]];
    [saveButtonPrototype setTitleShadowColor:[[UIColor blackColor] colorWithAlphaComponent:0.33] forState:UIControlStateNormal];
    [saveButtonPrototype.titleLabel setShadowOffset:CGSizeMake(0, -1)];
    [saveButtonPrototype addTarget:self action:@selector(saveAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithCustomView:saveButtonPrototype];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSpacer.width = -11;
    navigationItem.rightBarButtonItems = @[negativeSpacer, saveButton];
    navigationBar.items = @[navigationItem];
    
    [self addSubview:navigationBar];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    UIView *multi_kloader = [self createViewWithNumberOfCellsInStyleOfSetupAssistant:1 headerTitle:nil footerTitle:@"Important note: multi_kloader may fail sometimes" withYPosition:54 foriPad:YES];
    [self addSubview:multi_kloader];
    BOOL isMultiKloaderNeeded = [ImageValidation isMultiKloaderNeeded];
    UILabel *multiKloaderLabel = [self createViewWithCellLabel:@"multi_kloader" forEntry:0 isHeaderPresent:NO];
    [multi_kloader addSubview:multiKloaderLabel];
    iOS6Switch *mSwitch = [[iOS6Switch alloc] initWithPosition:CGPointMake(391, 9) withState:isMultiKloaderNeeded];
    mSwitch.delegate = self;
    [multi_kloader addSubview:mSwitch];
    
    CGFloat spaceBetween = 17;
   
    image1 = [self createViewWithNumberOfCellsInStyleOfSetupAssistant:3 headerTitle:@"Image 1" footerTitle:nil withYPosition:multi_kloader.frame.origin.y+multi_kloader.frame.size.height+spaceBetween foriPad:YES];
    [self addSubview:image1];
    UILabel *image1Path = [self createViewWithCellLabel:@"Path" forEntry:0 isHeaderPresent:YES];
    [image1 addSubview:image1Path];
    UILabel *image1Type = [self createViewWithCellLabel:@"Type" forEntry:1 isHeaderPresent:YES];
    [image1 addSubview:image1Type];
    UILabel *image1Version = [self createViewWithCellLabel:@"Version" forEntry:2 isHeaderPresent:YES];
    [image1 addSubview:image1Version];
    
    image1PathDetail = [self createTextFieldForEntry:0 isHeaderPresent:YES foriPad:YES];
    image1PathDetail.text = [defaults stringForKey:@"Image 1"];
    image1PathDetail.delegate = self;
    [image1PathDetail addTarget:self action:@selector(textDidChangeInImage1) forControlEvents:UIControlEventEditingChanged];
    image1PathDetail.tag = 0;
    if ([ImageValidation isImageExistAtPath:[defaults valueForKey:@"Image 1"]]) {
        
        if ([ImageValidation isARMImageValidAtPath:[defaults valueForKey:@"Image 1"]]) {
            
            image1TypeDetail = [self createViewWithCellDetailLabel:[ImageValidation getiBootTypeAtPath:[defaults  valueForKey:@"Image 1"] isIMG3:NO] forEntry:1 isHeaderPresent:YES foriPad:YES];
            image1VersionDetail = [self createViewWithCellDetailLabel:[ImageValidation getiBootVersionAtPath:[defaults  valueForKey:@"Image 1"] isIMG3:NO] forEntry:2 isHeaderPresent:YES foriPad:YES];
        } else {
            
            image1TypeDetail = [self createViewWithCellDetailLabel:@"Image not valid" forEntry:1 isHeaderPresent:YES foriPad:YES];
            image1VersionDetail = [self createViewWithCellDetailLabel:@"Image not valid" forEntry:2 isHeaderPresent:YES foriPad:YES];
        }
    } else {
        
        image1TypeDetail = [self createViewWithCellDetailLabel:@"No image exists" forEntry:1 isHeaderPresent:YES foriPad:YES];
        image1VersionDetail = [self createViewWithCellDetailLabel:@"No image exists" forEntry:2 isHeaderPresent:YES foriPad:YES];
    }
    [image1 addSubview:image1PathDetail];
    [image1 addSubview:image1TypeDetail];
    [image1 addSubview:image1VersionDetail];
    
    
    image2 = [self createViewWithNumberOfCellsInStyleOfSetupAssistant:3 headerTitle:@"Image 2" footerTitle:nil withYPosition:image1.frame.origin.y+image1.frame.size.height+spaceBetween foriPad:YES];
    [self addSubview:image2];
    UILabel *image2Path = [self createViewWithCellLabel:@"Path" forEntry:0 isHeaderPresent:YES];
    [image2 addSubview:image2Path];
    UILabel *image2Type = [self createViewWithCellLabel:@"Type" forEntry:1 isHeaderPresent:YES];
    [image2 addSubview:image2Type];
    UILabel *image2Version = [self createViewWithCellLabel:@"Version" forEntry:2 isHeaderPresent:YES];
    [image2 addSubview:image2Version];
    
    image2PathDetail = [self createTextFieldForEntry:0 isHeaderPresent:YES foriPad:YES];
    image2PathDetail.text = [defaults stringForKey:@"Image 2"];
    image2PathDetail.delegate = self;
    [image2PathDetail addTarget:self action:@selector(textDidChangeInImage2) forControlEvents:UIControlEventEditingChanged];
    image2PathDetail.tag = 1;
    if ([ImageValidation isImageExistAtPath:[[NSUserDefaults standardUserDefaults] valueForKey:@"Image 2"]]) {
        
        if ([ImageValidation isIMG3ImageValidAtPath:[defaults valueForKey:@"Image 2"]]) {
            
            image2TypeDetail = [self createViewWithCellDetailLabel:[ImageValidation getiBootTypeAtPath:[[NSUserDefaults standardUserDefaults] valueForKey:@"Image 2"] isIMG3:YES] forEntry:1 isHeaderPresent:YES foriPad:YES];
            image2VersionDetail = [self createViewWithCellDetailLabel:[ImageValidation getiBootVersionAtPath:[[NSUserDefaults standardUserDefaults] valueForKey:@"Image 2"] isIMG3:YES] forEntry:2 isHeaderPresent:YES foriPad:YES];
        } else {
            image2TypeDetail = [self createViewWithCellDetailLabel:@"Image not valid" forEntry:1 isHeaderPresent:YES foriPad:YES];
            image2VersionDetail = [self createViewWithCellDetailLabel:@"Image not valid" forEntry:2 isHeaderPresent:YES foriPad:YES];
        }
        
    } else {
        
        image2TypeDetail = [self createViewWithCellDetailLabel:@"No image exists" forEntry:1 isHeaderPresent:YES foriPad:YES];
        image2VersionDetail = [self createViewWithCellDetailLabel:@"No image exists" forEntry:2 isHeaderPresent:YES foriPad:YES];
    }
    [image2 addSubview:image2PathDetail];
    [image2 addSubview:image2TypeDetail];
    [image2 addSubview:image2VersionDetail];

    if (!isMultiKloaderNeeded) {
        [image2 setHidden:YES];
    }
    
    return self;
}

#pragma mark - Creating table-view

- (UIView*)createViewWithNumberOfCellsInStyleOfSetupAssistant:(uint8_t)number headerTitle:(NSString*)header footerTitle:(NSString*)footer withYPosition:(CGFloat)yPosition foriPad:(BOOL)isiPad {
    
#pragma mark Setting up cells
    
    CGFloat shadowRadius = 1;
    CGFloat cellHeight = 43;
    CGFloat cellWidth;
    
    if (isiPad) {
        cellWidth = 478;
    } else if (!isiPad) {
        cellWidth = 300;
    }

    CGFloat separatorWidth = 2;
    CGRect cellRect = CGRectMake(shadowRadius, shadowRadius, cellWidth, (cellHeight*number)+(shadowRadius*(number-1)));
    CGRect cellBaseRect = CGRectMake(0, 0, cellRect.size.width+shadowRadius*2, cellRect.size.height+shadowRadius*2);
    
    UIView *cellBase = [[UIView alloc] initWithFrame:cellBaseRect];
    [cellBase setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.25]];
    [cellBase.layer setCornerRadius:9];
    
    CALayer *cells = [CALayer layer];
    [cells setFrame:cellRect];
    [cells setBackgroundColor:[UIColor colorWithRed:0xF6/255.0 green:0xF6/255.0 blue:0xF6/255.0 alpha:1.0].CGColor];
    [cells setCornerRadius:8];
    
    if (number > 1) {
        
        for (uint8_t c = 1; c < number; c++) {
            
            UIImageView *separator = [[UIImageView alloc] initWithFrame:CGRectMake(0, cellHeight*c+(c-1), cellWidth, separatorWidth)];
            [separator setImage:[UIImage imageNamed:@"CellSeparator"]];
            [cells addSublayer:separator.layer];
        }
    }
    
    [cellBase.layer addSublayer:cells];

#pragma mark Setting up header
    
    CGRect headerRect = CGRectNull;
    UILabel *headerLabel;
    
    if (header != nil) {
        
        CGFloat headerOffset = 10;
        headerRect = CGRectMake(headerOffset, 0, cellWidth-headerOffset*2, 23);
        
        headerLabel = [[UILabel alloc] initWithFrame:headerRect];
        headerLabel.text = header;
        headerLabel.textColor = [UIColor whiteColor];
        headerLabel.textAlignment = NSTextAlignmentLeft;
        headerLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:17];
        headerLabel.shadowColor = [UIColor blackColor];
        headerLabel.shadowOffset = CGSizeMake(0, -1);

    }
    
#pragma mark Setting up footer
    
    CGRect footerRect = CGRectNull;
    UILabel *footerLabel;
    
    if (footer != nil) {
        
        footerLabel = [[UILabel alloc] init];
        footerLabel.text = footer;
        footerLabel.textColor = [UIColor whiteColor];
        footerLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:15];
        footerLabel.shadowColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        footerLabel.shadowOffset = CGSizeMake(0, -1);
        footerLabel.textAlignment = NSTextAlignmentCenter;
        footerLabel.numberOfLines = 0;
        
        CGFloat lines = footerLabel.intrinsicContentSize.width/cellWidth+1;
        CGFloat height = ceilf(lines*footerLabel.intrinsicContentSize.height);
        
        footerRect = CGRectMake(shadowRadius, 0, cellWidth, height);
        footerLabel.frame = footerRect;
    }
    
#pragma mark Building result
    
    UIView *base = [[UIView alloc] init];
    
    CGFloat headerHeight = headerRect.size.height;
    CGFloat spaceBelowHeader = 0;
    if (headerHeight != 0) {
        spaceBelowHeader = 6;
    }
    CGFloat cellsHeight = cellBaseRect.size.height;
    CGFloat footerHeight = footerRect.size.height;
    CGFloat spaceAboveFooter = 0;
    if (footerHeight != 0) {
        spaceAboveFooter = 5;
    }
    
    CGFloat xPosition;
    
    if (isiPad) {
        xPosition = 30;
    } else if (!isiPad) {
        xPosition = 9;
    }
    
    CGRect baseRect = CGRectMake(xPosition, yPosition, cellBaseRect.size.width, headerHeight+spaceBelowHeader+cellsHeight+footerHeight+spaceAboveFooter);
    [base setFrame:baseRect];
    
    [base addSubview:headerLabel];
    
    cellBaseRect.origin.y = headerHeight+spaceBelowHeader;
    [cellBase setFrame:cellBaseRect];
    [base addSubview:cellBase];
    
    footerRect.origin.y = cellBaseRect.origin.y+cellBaseRect.size.height+spaceAboveFooter;
    [footerLabel setFrame:footerRect];
    [base addSubview:footerLabel];

    return base;
}

#pragma mark Creating labels, details and text-fields

- (UILabel*)createViewWithCellLabel:(NSString*)label forEntry:(uint8_t)entry isHeaderPresent:(BOOL)isPresent {
    
    CGRect rect = CGRectMake(11, 0, 280, 43);
    
    if (isPresent) {
        rect.origin.y = 29+1+rect.size.height*entry+entry;
        
    } else {
        rect.origin.y = 1+rect.size.height*entry+entry;
    }
    
    UILabel *base = [[UILabel alloc] initWithFrame:rect];
    base.text = label;
    base.textColor = [UIColor blackColor];
    base.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:17];
    base.textAlignment = NSTextAlignmentLeft;

    return base;
}

- (UILabel*)createViewWithCellDetailLabel:(NSString*)label forEntry:(uint8_t)entry isHeaderPresent:(BOOL)isPresent foriPad:(BOOL)isiPad {
 
    CGFloat xPosition;
    CGFloat height;
    
    if (isiPad) {
        xPosition = 139;
        height = 330;
    } else if (!isiPad) {
        xPosition = 81;
        height = 210;
    }
    
    
    CGRect rect = CGRectMake(xPosition, 0, height, 21);
    
    if (isPresent) {
        rect.origin.y = 29+1+rect.size.height*entry+entry+11+(11*entry*2);
        
    } else {
        rect.origin.y = 1+rect.size.height*entry+entry;
    }
    
    UILabel *base = [[UILabel alloc] initWithFrame:rect];
    base.text = label;
    base.textColor = [UIColor colorWithRed:56/255.0  green:84/255.0 blue:135/255.0 alpha:1.0];
    base.font = [UIFont fontWithName:@"HelveticaNeue" size:17];
    base.textAlignment = NSTextAlignmentRight;

    return base;
}

- (UITextField*)createTextFieldForEntry:(uint8_t)entry isHeaderPresent:(BOOL)isPresent foriPad:(BOOL)isiPad {
    
    CGFloat xPosition;
    CGFloat height;
    
    if (isiPad) {
        xPosition = 139;
        height = 330;
    } else if (!isiPad) {
        xPosition = 81;
        height = 210;
    }
    
    CGRect rect = CGRectMake(xPosition, 0, height, 21);
    
    if (isPresent) {
        rect.origin.y = 29+1+rect.size.height*entry+entry+11+(11*entry*2);
        
    } else {
        rect.origin.y = 1+rect.size.height*entry+entry;
    }
    
    UITextField *field = [[UITextField alloc] initWithFrame:rect];
    field.textColor = [UIColor colorWithRed:56/255.0  green:84/255.0 blue:135/255.0 alpha:1.0];
    field.font = [UIFont fontWithName:@"HelveticaNeue" size:17];
    field.textAlignment = NSTextAlignmentRight;
    field.placeholder = @"Path";
    field.keyboardType = UIKeyboardTypeASCIICapable;
    field.keyboardAppearance = UIKeyboardAppearanceDark;
    field.autocapitalizationType = UITextAutocapitalizationTypeNone;
    field.autocorrectionType = UITextAutocorrectionTypeNo;
    field.spellCheckingType = UITextSpellCheckingTypeNo;
    field.returnKeyType = UIReturnKeyDone;
    field.clearButtonMode = UITextFieldViewModeWhileEditing;

    return field;
}

#pragma mark - Delegates

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (screenSize.height < 568) {
        [[[scroll subviews] objectAtIndex:4] setImage:scrollImage];
    }
}

- (void)switchStateChanged:(BOOL)state {
    
    if (state) {
        [image2 setHidden:NO];
        scroll.contentSize = CGSizeMake(screenSize.width, image2.frame.origin.y+image2.frame.size.height+30);
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"multi_kloader"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    if (!state) {
        [image2 setHidden:YES];
        scroll.contentSize = CGSizeMake(screenSize.width, image2.frame.origin.y+30);
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"multi_kloader"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (void)keyboardWillShow:(NSNotification *)notification {
    
    if (([image1PathDetail isFirstResponder])) {
        if (screenSize.height < 568) {
            
            CGFloat kbHeight = [[[notification userInfo] objectForKey:@"UIKeyboardFrameEndUserInfoKey"] CGRectValue].size.height;
            CGRect rect = scroll.frame;
            CGFloat yPosition = -(rect.size.height-kbHeight)+image1.frame.size.height-15;
            rect.origin.y = yPosition;
            rect.size.height = scroll.contentSize.height;
            previousOffset = scroll.contentOffset.y;
            [UIView animateWithDuration:0.22 animations:^{
                [scroll setFrame:rect];
            }];
        }
    }
    
    if ([image2PathDetail isFirstResponder]) {
        
        CGFloat kbHeight = [[[notification userInfo] objectForKey:@"UIKeyboardFrameEndUserInfoKey"] CGRectValue].size.height;
        CGRect rect = scroll.frame;
        CGFloat yPosition;
        if (screenSize.height == 568) {
            yPosition = -(kbHeight-25);
        } else {
            rect.size.height = scroll.contentSize.height;
            yPosition = -(scroll.contentSize.height-kbHeight-39);
        }
        rect.origin.y = yPosition;
        previousOffset = scroll.contentOffset.y;
        [UIView animateWithDuration:0.22 animations:^{
            [scroll setFrame:rect];
        }];
        
    }
    
}

- (void)keyboardWillHide:(NSNotification *)notification {
    
    CGRect rect = scroll.frame;
    CGFloat yPosition = 0;
    rect.origin.y = yPosition;
    [UIView animateWithDuration:0.22 animations:^{
        [scroll setFrame:rect];
        [scroll setContentOffset:CGPointMake(scroll.contentOffset.x, previousOffset)];
    } completion:^(BOOL finished){
        if (screenSize.height < 568) {
            CGRect rect = scroll.frame;
            rect.size.height = self.frame.size.height;
            [scroll setFrame:rect];
        }
        
    }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    [[NSUserDefaults standardUserDefaults] synchronize];
    return YES;
}

- (void)textDidChangeInImage1 {
    [self updateImage1];
}

- (void)textDidChangeInImage2 {
    [self updateImage2];
}

#pragma mark - Saving

- (void)updateImage1 {
    
    NSString *path = image1PathDetail.text;

    if ([ImageValidation isImageExistAtPath:path]) {
        
        if ([ImageValidation isARMImageValidAtPath:path]) {
            
            image1TypeDetail.text = [ImageValidation getiBootTypeAtPath:path isIMG3:NO];
            image1VersionDetail.text = [ImageValidation getiBootVersionAtPath:path isIMG3:NO];
            [[NSUserDefaults standardUserDefaults] setObject:path forKey:@"Image 1"];
            
        } else {
            
            image1TypeDetail.text = @"Image not valid";
            image1VersionDetail.text = @"Image not valid";
            [[NSUserDefaults standardUserDefaults] setObject:path forKey:@"Image 1"];
        }
        
    } else {
        
        image1TypeDetail.text = @"No image exists";
        image1VersionDetail.text = @"No image exists";
        [[NSUserDefaults standardUserDefaults] setObject:path forKey:@"Image 1"];
    }
    
}

- (void)updateImage2 {
    
    NSString *path = image2PathDetail.text;
    
    if ([ImageValidation isImageExistAtPath:path]) {
        
        if ([ImageValidation isIMG3ImageValidAtPath:path]) {
            
            image2TypeDetail.text = [ImageValidation getiBootTypeAtPath:path isIMG3:YES];
            image2VersionDetail.text = [ImageValidation getiBootVersionAtPath:path isIMG3:YES];
            [[NSUserDefaults standardUserDefaults] setObject:path forKey:@"Image 2"];
            
        } else {
            
            image2TypeDetail.text = @"Image not valid";
            image2VersionDetail.text = @"Image not valid";
            [[NSUserDefaults standardUserDefaults] setObject:path forKey:@"Image 2"];
        }
        
    } else {
        
        image2TypeDetail.text = @"No image exists";
        image2VersionDetail.text = @"No image exists";
        [[NSUserDefaults standardUserDefaults] setObject:path forKey:@"Image 2"];
    }
    
}

- (void)saveAction {
    
    [image1PathDetail resignFirstResponder];
    [image2PathDetail resignFirstResponder];
    [_delegate saveButtonPressed];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end