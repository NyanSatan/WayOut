//
//  ViewController.m
//  WayOut
//
//  Created on 05.06.16.
//  All rights reserved.
//

#import "ViewController.h"

@interface ViewController () {
    
    CGRect screenRect;
    
    UIView *statusBarBackground;
    UIImageView *leftCorner;
    UIImageView *rightCorner;
    
    UIImage *linen;
    UISlider *slider;
    UIView *label;
    UIImageView *logoImageView;
    UIView *slideToBootView;
    
    CABasicAnimation *shimmering;
    CALayer *shimmerImage;
    CALayer *darkLayer;
    
    UIImage *alertImage;
    UIImage *dimmingImage;
    
    UIImageView *kloaderView;
    UIImageView *alertKloaderView;
    
    iOS6AlertView *aboutView;
    SettingsView *settings;
}

@end

@implementation ViewController

#define ASSET_BY_SCREEN_HEIGHT(regular, longScreen) (([[UIScreen mainScreen] bounds].size.height <= 480.0) ? regular : longScreen

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    screenRect = [[UIScreen mainScreen] bounds];
    
    
#pragma mark Setting up background image
    
    UIImageView *backgroundImage = [[UIImageView alloc] initWithFrame:screenRect];
    switch (UI_USER_INTERFACE_IDIOM()) {
        case UIUserInterfaceIdiomPhone:
            linen = [UIImage imageNamed:ASSET_BY_SCREEN_HEIGHT(@"Linen", @"Linen-568h"))];
            break;
            
        case UIUserInterfaceIdiomPad:
            linen = [UIImage imageNamed:@"Linen"];
            break;
    }

    [backgroundImage setImage:linen];
    [self.view addSubview:backgroundImage];
    
    
#pragma mark Setting up status bar and rounded corners
    
    statusBarBackground = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenRect.size.width, 20)];
    [statusBarBackground setBackgroundColor:[UIColor blackColor]];
    [self.view addSubview:statusBarBackground];
    
    leftCorner = [[UIImageView alloc] initWithFrame:CGRectMake(0, 20, 3, 3)];
    [leftCorner setImage:[UIImage imageNamed:@"Corners_Black_Left"]];
    rightCorner = [[UIImageView alloc] initWithFrame:CGRectMake(screenRect.size.width-3, 20, 3, 3)];
    [rightCorner setImage:[UIImage imageNamed:@"Corners_Black_Right"]];
    [self.view addSubview:leftCorner];
    [self.view addSubview:rightCorner];
    
    
#pragma mark Setting up bottom bar
    
    UIImage *bottomBarBackgroundImage = [UIImage imageNamed:@"bottombarbkgnd"];
    UIImage *infoButtonImage = [UIImage imageNamed:@"InfoButton"];
    CGFloat bottomBarHeight = bottomBarBackgroundImage.size.height + infoButtonImage.size.height + 16;
    slideToBootView = [[UIView alloc] initWithFrame:CGRectMake(0, screenRect.size.height - bottomBarHeight, screenRect.size.width, bottomBarHeight)];
    UIImageView *bottomBarBackgroundView = [[UIImageView alloc] initWithFrame:CGRectMake(0, bottomBarHeight - bottomBarBackgroundImage.size.height, screenRect.size.width, bottomBarBackgroundImage.size.height)];
    [bottomBarBackgroundView setUserInteractionEnabled:YES];
    [bottomBarBackgroundView setImage:[bottomBarBackgroundImage resizableImageWithCapInsets:UIEdgeInsetsMake(0, 39, 0, 39)]];

    UIImageView *wellLock;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        
        UIImage *wellLockImage = [UIImage imageNamed:@"WellLock"]; wellLock = [[UIImageView alloc] initWithFrame:CGRectMake(256, 38, 256, wellLockImage.size.height)];
        [wellLock setUserInteractionEnabled:YES];
        [wellLock setImage:[wellLockImage resizableImageWithCapInsets:UIEdgeInsetsMake(0, 13, 0, 13)]];
        [bottomBarBackgroundView addSubview:wellLock];
        
    }
    
    
#pragma mark Setting up label
    
    label = [[UIView alloc] init];
    label.layer.backgroundColor = [[UIColor colorWithRed:0.295f green:0.295f blue:0.295f alpha:1.0f] CGColor];
    label.layer.masksToBounds = YES;
    
    switch (UI_USER_INTERFACE_IDIOM()) {
        case UIUserInterfaceIdiomPhone:
            [label setFrame:CGRectMake(107, 35, 158, 25)];
            [bottomBarBackgroundView addSubview:label];
            break;
            
        case UIUserInterfaceIdiomPad:
            [label setFrame:CGRectMake(74, 13, 158, 25)];
            [wellLock addSubview:label];
            break;
    }
    

    
    CATextLayer *textLayer = [CATextLayer layer];
    textLayer.backgroundColor = [UIColor clearColor].CGColor;
    textLayer.string = @"slide to boot";
    textLayer.font = (__bridge CFTypeRef)@"Helvetica-Neue";
    textLayer.fontSize = 28;
    textLayer.contentsScale = [[UIScreen mainScreen] scale];
    textLayer.frame = CGRectMake(0, -5, label.frame.size.width, 30);
    textLayer.alignmentMode = kCAAlignmentCenter;
    [label.layer addSublayer:textLayer];
    label.layer.mask = textLayer;

    
    shimmerImage = [CALayer layer];
    shimmerImage.frame = CGRectMake(-80, 0, 80, 32);
    shimmerImage.backgroundColor = [UIColor clearColor].CGColor;
    shimmerImage.contents = (id)[UIImage imageNamed:@"bottombarlocktextmask"].CGImage;
    [label.layer addSublayer:shimmerImage];
    
    shimmering = [CABasicAnimation animation];
    shimmering.keyPath = @"position.x";
    shimmering.fromValue =  @(shimmerImage.frame.origin.x);
    shimmering.toValue = @(label.frame.size.width + shimmerImage.frame.size.width);
    shimmering.duration = 2.2;
    shimmering.repeatCount = HUGE_VALF;
    shimmering.removedOnCompletion = NO;
    
    [self shimmering:0];
    
    
#pragma mark Setting up slider

    slider = [[UISlider alloc] init];
    [slider setContinuous:YES];
    [slider setMinimumTrackImage:[UIImage alloc] forState:UIControlStateNormal];
    [slider setMaximumTrackImage:[UIImage alloc] forState:UIControlStateNormal];
    [slider setThumbImage:[UIImage imageNamed:@"bottombarknobgray"] forState:UIControlStateNormal];
    [slider addTarget:self
               action:@selector(sliderUp:)
     forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside];
    [slider addTarget:self
               action:@selector(sliderChanged:)
     forControlEvents:UIControlEventValueChanged];
    
    switch (UI_USER_INTERFACE_IDIOM()) {
        case UIUserInterfaceIdiomPhone:
            [slider setFrame:CGRectMake(23, 34, 274, 31)];
            [bottomBarBackgroundView addSubview:slider];
            break;
            
        case UIUserInterfaceIdiomPad:
            [slider setFrame:CGRectMake(3, 12, 250, 31)];
            [wellLock addSubview:slider];
            break;
    }
 
    
#pragma mark Setting up info button
    
    UIButton *infoButton = [[UIButton alloc] initWithFrame:CGRectMake(screenRect.size.width/2-ceilf( infoButtonImage.size.width/2), 0, infoButtonImage.size.width, infoButtonImage.size.height)];
    [infoButton setImage:infoButtonImage forState:UIControlStateNormal];
    [infoButton addTarget:self action:@selector(infoButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [slideToBootView addSubview:infoButton];
    [slideToBootView addSubview:bottomBarBackgroundView];
    [self.view addSubview:slideToBootView];
    
#pragma mark Setting up logo image
    
    UIImage *logoImage = [UIImage imageNamed:@"WayOutLogo"];
    logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(ceilf( screenRect.size.width/2-logoImage.size.width/2), ceilf((screenRect.size.height-bottomBarBackgroundImage.size.height)/2-logoImage.size.height/2), logoImage.size.width, logoImage.size.height)];
    [logoImageView setImage:logoImage];
    [self.view addSubview:logoImageView];
    
#pragma mark Setting up kloader view
    
    alertImage = [UIImage imageNamed:@"UIPopupAlertBackground"];
    dimmingImage = [UIImage imageNamed:@"UIAlertViewDimming"];
    
    kloaderView = [[UIImageView alloc] initWithFrame:screenRect];
    [kloaderView setImage:dimmingImage];
    alertKloaderView = [[UIImageView alloc] initWithFrame:CGRectMake(screenRect.size.width/2-alertImage.size.width/2, screenRect.size.height/2-alertImage.size.height/2, alertImage.size.width, alertImage.size.height)];
    [alertKloaderView setImage:alertImage];
    [kloaderView addSubview:alertKloaderView];
    [kloaderView setHidden:YES];
    [self.view addSubview:kloaderView];

#pragma mark Setting up About view
    
    aboutView = [[iOS6AlertView alloc] initWithTitle:[NSString stringWithFormat:@"Way Out %@ (%@)", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"], [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey]] message:@"Way Out - GUI in the spirit of classical Setup.app for untethered dualboots to iOS 6. Developed by @nyan_satan\n\nThanks to:\n@winocm, @xerub, @JonathanSeals" delegate:self cancelButtonTitle:nil otherButtonTitle:@"Settings" backgroundImage:alertImage dimmingImage:dimmingImage position:CGPointMake(0, screenRect.size.height == 568.0 ? 134 : (screenRect.size.height == 480.0 ? ceilf(screenRect.size.height*0.1464) : 328)) animated:NO];
   
#pragma mark Setting up dark layer for iPad's settings
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {

        darkLayer = [CALayer layer];
        darkLayer.frame = self.view.frame;
        [self.view.layer addSublayer:darkLayer];

    }
    
}

- (void)hideStatusBar {

    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
    [statusBarBackground setHidden:YES];
    [leftCorner setHidden:YES];
    [rightCorner setHidden:YES];
}

- (void)showStatusBar {
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    [statusBarBackground setHidden:NO];
    [leftCorner setHidden:NO];
    [rightCorner setHidden:NO];
}

- (void)sliderUp:(UISlider *)sender {
    
    if ((slider.value == 1)) {
        
        [self bootXPreparations];
        
        } else {
        
        CGFloat fValue = slider.value;
        [UIView animateWithDuration:0.2f animations:^{
            if( fValue < 1.0f ) {
         
                [slider setValue:0 animated:YES];
                label.alpha = MAX(0.0, 1.0 - (slider.value * 3.5));
            }
        }];
        
        if (slider.value == 0) {
            
            [self shimmering:0];
        }
    }
}

- (void)sliderChanged:(UISlider *)sender {
    
    label.alpha = MAX(0.0, 1.0 - (slider.value * 3.5));
    [self shimmering:1];
}

- (void)shimmering:(uint8_t)command {
    
    if (command == 0) {
        [shimmerImage addAnimation:shimmering forKey:@"Shimmering"];
    }
    
    if (command == 1) {
        [shimmerImage removeAllAnimations];
    }
}


- (void)slideToSetupViewAnimation:(BOOL)type {
    
    CGFloat normalY = screenRect.size.height-slideToBootView.frame.size.height;
    CGFloat hiddenY = screenRect.size.height+slideToBootView.frame.size.height;
    
    [UIView beginAnimations:@"HideControlView" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    [UIView setAnimationDuration:0.4];

    if (type) {
        
        [kloaderView setHidden:NO];
        [self hideStatusBar];
        slideToBootView.frame = CGRectMake(slideToBootView.frame.origin.x, hiddenY, slideToBootView.frame.size.width, slideToBootView.frame.size.height);
        [UIView commitAnimations];
    }
    
    if (!type) {
        
        [kloaderView setHidden:YES];
        slider.value = 0;
        label.alpha = 1.0;
        slideToBootView.frame = CGRectMake(slideToBootView.frame.origin.x, normalY, slideToBootView.frame.size.width, slideToBootView.frame.size.height);
        [UIView commitAnimations];
        [self showStatusBar];
        [self shimmering:0];
    }

}

- (void)setAlertContent:(uint8_t)type {
    
    if ([[alertKloaderView subviews] count] > 0) {
        [alertKloaderView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    
    UILabel *statusLabel = [[UILabel alloc] init];
    statusLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:17];
    statusLabel.textColor = [UIColor whiteColor];
    statusLabel.shadowOffset = CGSizeMake(0, -1);
    statusLabel.shadowColor = [UIColor blackColor];
    statusLabel.adjustsFontSizeToFitWidth = YES;
    switch (type) {
        case 0:
            statusLabel.text = @"Executing kloader...";
            break;
        case 1:
            statusLabel.text = @"Executing multi_kloader...";
            break;
        case 2:
            statusLabel.text = @"Validating image...";
            break;
        case 3:
            statusLabel.text = @"Validating images...";
            break;
        default:
            break;
    }
    
    CGFloat positionY = 17;
    CGFloat indicatorWidth = 20;
    CGFloat space = 8;
    CGFloat alertWidth = alertKloaderView.frame.size.width;
    CGFloat labelWidth = ceilf(statusLabel.intrinsicContentSize.width);
    CGFloat labelHeight = ceilf(statusLabel.intrinsicContentSize.height);
    CGFloat width = indicatorWidth + space + labelWidth;
    CGFloat offset = ceilf((alertWidth - width)/2);
    CGFloat positionX = offset - 2.0;
    
    statusLabel.frame = CGRectMake(positionX + space + indicatorWidth, positionY - 2, labelWidth, labelHeight);
    
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] init];
    indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
    indicator.frame = CGRectMake(positionX, positionY, indicatorWidth, indicatorWidth);
    [indicator startAnimating];
    
    [alertKloaderView addSubview:indicator];
    [alertKloaderView addSubview:statusLabel];

}

- (void)bootXPreparations {
    
    [self slideToSetupViewAnimation:YES];
    [aboutView dismiss];
    
    if ([ImageValidation isConfigValid]) {
            
        if ([ImageValidation isMultiKloaderNeeded]) {
                
            [self setAlertContent:3];
                
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.75 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
            if ([ImageValidation isImageExistAtPath:[[NSUserDefaults standardUserDefaults] valueForKey:@"Image 1"]]) {
                    
                if ([ImageValidation isImageExistAtPath:[[NSUserDefaults standardUserDefaults] valueForKey:@"Image 2"]]) {
                        
                    if ([ImageValidation isARMImageValidAtPath:[[NSUserDefaults standardUserDefaults] valueForKey:@"Image 1"]]) {
                            
                        if ([ImageValidation isIMG3ImageValidAtPath:[[NSUserDefaults standardUserDefaults] valueForKey:@"Image 2"]]) {
                                
                            [self setAlertContent:1];

                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                    
                                [ImageValidation bootX];
                            });
                                
                        } else {
                                
                            iOS6AlertView *invalidiBECAlert = [[iOS6AlertView alloc] initWithTitle:@"iBEC doesn't seem like an IMG3 container" message:@"iBEC image must be packaged into IMG3\nCheck your settings and retry" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitle:@"Settings" backgroundImage:alertImage dimmingImage:dimmingImage position:CGPointZero animated:YES];
                            [invalidiBECAlert show];
                            [kloaderView setHidden:YES];
                        }
                            
                    } else {
                            
                        iOS6AlertView *invalidiBSSAlert = [[iOS6AlertView alloc] initWithTitle:@"iBSS doesn't seem like an ARM image" message:@"iBSS image must be decrypted and unpacked\nCheck your settings and retry" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitle:@"Settings" backgroundImage:alertImage dimmingImage:dimmingImage position:CGPointZero animated:YES];
                        [invalidiBSSAlert show];
                        [kloaderView setHidden:YES];
                    }
                        
                } else {
                        
                    iOS6AlertView *noiBECAlert = [[iOS6AlertView alloc] initWithTitle:@"iBEC image not found" message:@"Check your settings and retry" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitle:@"Settings" backgroundImage:alertImage dimmingImage:dimmingImage position:CGPointZero animated:YES];
                    [noiBECAlert show];
                    [kloaderView setHidden:YES];
                }
                
            } else {
                    
                iOS6AlertView *noiBSSAlert = [[iOS6AlertView alloc] initWithTitle:@"iBSS image not found" message:@"Check your settings and retry" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitle:@"Settings" backgroundImage:alertImage dimmingImage:dimmingImage position:CGPointZero animated:YES];
                [noiBSSAlert show];
                [kloaderView setHidden:YES];
            }
                
            });
                
        } else {
                
            [self setAlertContent:2];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.75 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if ([ImageValidation isImageExistAtPath:[[NSUserDefaults standardUserDefaults] valueForKey:@"Image 1"]]) {
                    
                if ([ImageValidation isARMImageValidAtPath:[[NSUserDefaults standardUserDefaults] valueForKey:@"Image 1"]]) {
                        
                    [self setAlertContent:0];
                        
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            
                        [ImageValidation bootX];
                    });
                        
                } else {
                        
                    iOS6AlertView *invalidImageAlert = [[iOS6AlertView alloc] initWithTitle:@"This doesn't seem like an ARM image" message:@"Image must be decrypted and unpacked\nCheck your settings and retry" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitle:@"Settings" backgroundImage:alertImage dimmingImage:dimmingImage position:CGPointZero animated:YES];
                    [invalidImageAlert show];
                    [kloaderView setHidden:YES];
                }
                    
            } else {

                iOS6AlertView *noImageAlert = [[iOS6AlertView alloc] initWithTitle:@"No image was found" message:@"Check your settings and retry" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitle:@"Settings" backgroundImage:alertImage dimmingImage:dimmingImage position:CGPointZero animated:YES];
                [noImageAlert show];
                [kloaderView setHidden:YES];
            }
            });
            
        }
        
    } else {
            
        [ImageValidation generateDefaults];
        [self bootXPreparations];
        [kloaderView setHidden:YES];
    }

}


- (IBAction)infoButtonAction {
    
    if (aboutView.superview == nil) {
            
        [aboutView show];
            
    } else {
            
        [aboutView dismiss];
    }
    
}

- (void)clickedAlertButtonWithTitle:(NSString*)title {
    
    if ([title isEqualToString:@"Settings"]) {
        
        [self showSettingsView:NO];
        
        if (slideToBootView.frame.origin.y != screenRect.size.height-slideToBootView.frame.size.height) {
            
            [self slideToSetupViewAnimation:NO];
        }
        
    }
    
    if ([title isEqualToString:@"Cancel"]) {
        
        [self slideToSetupViewAnimation:NO];
        
    }
}

- (void)didSettingsButtonPressed {
    
    [self showSettingsView:NO];
    [aboutView dismiss];
}

- (void)showSettingsView:(BOOL)onlyInit {
    
    if (settings == nil) {
       
        switch (UI_USER_INTERFACE_IDIOM()) {
            case UIUserInterfaceIdiomPhone:
                settings = [[SettingsView alloc] initWithLinenImage:linen];
                break;
            case UIUserInterfaceIdiomPad:
                settings = [[SettingsView alloc] initForiPad];
                break;
            default:
                break;
        }
        
        [settings setDelegate:self];
        [self.view addSubview:settings];
    }
    
    if (!onlyInit) {
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.3];
        switch (UI_USER_INTERFACE_IDIOM()) {
            case UIUserInterfaceIdiomPhone:
                settings.frame = CGRectMake(0, 20, settings.frame.size.width, settings.frame.size.height);
                [UIView commitAnimations];
                break;
            case UIUserInterfaceIdiomPad:
                settings.frame = CGRectMake(settings.frame.origin.x, 192, settings.frame.size.width, settings.frame.size.height);
                [UIView commitAnimations];
                
                [darkLayer setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.6].CGColor];
                [slideToBootView setUserInteractionEnabled:NO];
                break;
            default:
                break;
       }
    }
}

- (void)saveButtonPressed {
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    switch (UI_USER_INTERFACE_IDIOM()) {
        case UIUserInterfaceIdiomPhone:
            [settings setFrame:CGRectMake(0, screenRect.size.height, settings.frame.size.width, settings.frame.size.height)];
            [UIView commitAnimations];
            break;
            
        case UIUserInterfaceIdiomPad:
            [settings setFrame:CGRectMake(114, screenRect.size.height+15, settings.frame.size.width, settings.frame.size.height)];
            [UIView commitAnimations];
            
            [darkLayer setBackgroundColor:[UIColor clearColor].CGColor];
            [slideToBootView setUserInteractionEnabled:YES];
            break;
        default:
            break;
    }
}

@end