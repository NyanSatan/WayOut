//
//  ViewControllerForiOS6.m
//  WayOut
//
//  Created on 13/08/2017.
//
//

#import "ViewControllerForiOS6.h"

@implementation ViewControllerForiOS6 {
    
    CGRect screenRect;
    
    int iOSVersion;
    
    UIImageView *leftCorner;
    UIImageView *rightCorner;
    
    UIImage *linen;
    UIImageView *logoImageView;
    UIView *slideToBootView;
    UIImage *alertImage;
    
    iOS6LockScreenBottomBar *bar;
    CGFloat normalBarY;
    CGFloat hiddenBarY;
    
    AboutView *about;
    LoadingView *loading;
    
}

#define ASSET_BY_SCREEN_HEIGHT(regular, longScreen) (([[UIScreen mainScreen] bounds].size.height <= 480.0) ? regular : longScreen

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque];
    
    screenRect = [[UIScreen mainScreen] bounds];
    
    iOSVersion = [[[UIDevice currentDevice] systemVersion] intValue];
    
#pragma mark Setting up background image
    
    UIImageView *backgroundImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, -20, screenRect.size.width, screenRect.size.height)];
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
    
    if (iOSVersion < 6) {
        
        leftCorner = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 3, 3)];
        [leftCorner setImage:[UIImage imageNamed:@"Corners_Black_Left"]];
        rightCorner = [[UIImageView alloc] initWithFrame:CGRectMake(screenRect.size.width-3, 0, 3, 3)];
        [rightCorner setImage:[UIImage imageNamed:@"Corners_Black_Right"]];
        [self.view addSubview:leftCorner];
        [self.view addSubview:rightCorner];
    }
    
#pragma mark Setting up bottom bar
    
    bar = [[iOS6LockScreenBottomBar alloc] initWithYPosition:0];
    [bar setDelegate:self];
    UIImage *infoButtonImage = [UIImage imageNamed:@"InfoButton"];
    CGFloat bottomBarHeight = bar.frame.size.height + infoButtonImage.size.height + 16;
    normalBarY = screenRect.size.height - bottomBarHeight - 20;
    hiddenBarY = screenRect.size.height + bottomBarHeight - 20;
    slideToBootView = [[UIView alloc] initWithFrame:CGRectMake(0, normalBarY, screenRect.size.width, bottomBarHeight)];
    [bar setYPosition:bottomBarHeight - bar.frame.size.height];
    [slideToBootView addSubview:bar];
    
    UIButton *infoButton = [[UIButton alloc] initWithFrame:CGRectMake(screenRect.size.width/2-ceilf(infoButtonImage.size.width/2), 0, infoButtonImage.size.width, infoButtonImage.size.height)];
    [infoButton setImage:infoButtonImage forState:UIControlStateNormal];
    [infoButton addTarget:self action:@selector(infoButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [slideToBootView addSubview:infoButton];
    
    [self.view addSubview:slideToBootView];
    
#pragma mark Setting up about view
    
    alertImage = [UIImage imageNamed:@"UIPopupAlertBackground"];
    about = [[AboutView alloc] initWithAlertImage:alertImage];
    [about setDelegate:self];
 
#pragma mark Setting up logo
    
    UIImage *logoImage = [UIImage imageNamed:@"WayOutLogo"];
    logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(ceilf(screenRect.size.width/2-logoImage.size.width/2), ceilf((screenRect.size.height-bar.frame.size.height)/2-logoImage.size.height/2)-20, logoImage.size.width, logoImage.size.height)];
    [logoImageView setImage:logoImage];
    [self.view addSubview:logoImageView];
    
}

- (void)willPresentAlertView:(UIAlertView *)alertView {
    
    [alertView setFrame:CGRectMake(alertView.frame.origin.x, alertView.frame.origin.y - 20, alertView.frame.size.width, alertView.frame.size.height)];
}

- (IBAction)infoButtonAction {

    if (about.superview == nil) {
        
        [self.view addSubview:about];
        
    } else {
        
        [about removeFromSuperview];
    }
}

- (void)slideToSetupViewAnimation:(BOOL)type {

    [UIView beginAnimations:@"HideControlView" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    [UIView setAnimationDuration:0.4];
    
    if (type) {
        
        [loading show];
        
        if (iOSVersion < 6) {
            [leftCorner setHidden:YES];
            [rightCorner setHidden:YES];
        }
        
        slideToBootView.frame = CGRectMake(slideToBootView.frame.origin.x, hiddenBarY, slideToBootView.frame.size.width, slideToBootView.frame.size.height);
        [UIView commitAnimations];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [bar reset];
        });
    }
    
    if (!type) {
        
        [loading dismiss];
        slideToBootView.frame = CGRectMake(slideToBootView.frame.origin.x, normalBarY, slideToBootView.frame.size.width, slideToBootView.frame.size.height);
        [UIView commitAnimations];
        [[[[UIApplication sharedApplication] delegate] window] setWindowLevel:UIWindowLevelNormal];
        
        if (iOSVersion < 6) {
            [leftCorner setHidden:NO];
            [rightCorner setHidden:NO];
        }

    }
    
}

- (void)bootXPreparations {
    
    [self slideToSetupViewAnimation:YES];
    [about removeFromSuperview];
    
    if ([ImageValidation isConfigValid]) {
        
        if ([ImageValidation isMultiKloaderNeeded]) {
            
            [loading setAlertContent:3];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.75 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                if ([ImageValidation isImageExistAtPath:[[NSUserDefaults standardUserDefaults] valueForKey:@"Image 1"]]) {
                    
                    if ([ImageValidation isImageExistAtPath:[[NSUserDefaults standardUserDefaults] valueForKey:@"Image 2"]]) {
                        
                        if ([ImageValidation isARMImageValidAtPath:[[NSUserDefaults standardUserDefaults] valueForKey:@"Image 1"]]) {
                            
                            if ([ImageValidation isIMG3ImageValidAtPath:[[NSUserDefaults standardUserDefaults] valueForKey:@"Image 2"]]) {
                                
                                if ([ImageValidation isImageExistAtPath:[[NSUserDefaults standardUserDefaults] valueForKey:@"Pre-boot script"]]) {
                                    
                                    [loading setAlertContent:4];
                                    
                                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                        
                                        [ImageValidation executeScript];
                                        
                                        [loading setAlertContent:1];
                                        
                                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                            
                                            [self.view removeFromSuperview];
                                            [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
                                            
                                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                                
                                                [ImageValidation bootX];
                                            });
                                        });
                                    });
                                    
                                } else {
                                    
                                    [loading setAlertContent:1];
                                    
                                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                        
                                        [self.view removeFromSuperview];
                                        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
                                        
                                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                            
                                            [ImageValidation bootX];
                                        });
                                    });
                                    
                                }
                                
                            } else {

                                UIAlertView *invalidiBECAlert = [[UIAlertView alloc] initWithTitle:@"iBEC doesn't seem like an IMG3 container" message:@"iBEC image must be packaged into IMG3\nCheck your settings and retry" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Settings", nil];
                                [invalidiBECAlert setDelegate:self];
                                [invalidiBECAlert show];
                                [loading dismiss];
                            }
                            
                        } else {
                            
                            UIAlertView *invalidiBSSAlert = [[UIAlertView alloc] initWithTitle:@"iBSS doesn't seem like an ARM image" message:@"iBSS image must be decrypted and unpacked\nCheck your settings and retry" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Settings", nil];
                            [invalidiBSSAlert setDelegate:self];
                            [invalidiBSSAlert show];
                            [loading dismiss];
                        }
                        
                    } else {
                        
                        UIAlertView *noiBECAlert = [[UIAlertView alloc] initWithTitle:@"iBEC image not found" message:@"Check your settings and retry" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Settings", nil];
                        [noiBECAlert setDelegate:self];
                        [noiBECAlert show];
                        [loading dismiss];
                    }
                    
                } else {
                    
                    UIAlertView *noiBSSAlert = [[UIAlertView alloc] initWithTitle:@"iBSS image not found" message:@"Check your settings and retry" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Settings", nil];
                    [noiBSSAlert setDelegate:self];
                    [noiBSSAlert show];
                    [loading dismiss];
                }
                
            });
            
        } else {
            
            [loading setAlertContent:2];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.75 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                if ([ImageValidation isImageExistAtPath:[[NSUserDefaults standardUserDefaults] valueForKey:@"Image 1"]]) {
                    
                    if ([ImageValidation isARMImageValidAtPath:[[NSUserDefaults standardUserDefaults] valueForKey:@"Image 1"]]) {
                        
                        if ([ImageValidation isImageExistAtPath:[[NSUserDefaults standardUserDefaults] valueForKey:@"Pre-boot script"]]) {
                            
                            [loading setAlertContent:4];
                            
                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                
                                [ImageValidation executeScript];
                                
                                [loading setAlertContent:0];
                                
                                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                    
                                    [self.view removeFromSuperview];
                                    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
                                    
                                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                        
                                        [ImageValidation bootX];
                                    });
                                });
                            });
                            
                        } else {
                            
                            [loading setAlertContent:0];
                            
                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                
                                [self.view removeFromSuperview];
                                [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
                                
                                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                    
                                    [ImageValidation bootX];
                                });
                            });
                            
                        }
                    } else {
                        
                        UIAlertView *invalidImageAlert = [[UIAlertView alloc] initWithTitle:@"This doesn't seem like an ARM image" message:@"Image must be decrypted and unpacked\nCheck your settings and retry" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Settings", nil];
                        [invalidImageAlert setDelegate:self];
                        [invalidImageAlert show];
                        [loading dismiss];
                    }
                    
                } else {
                    
                    UIAlertView *noImageAlert = [[UIAlertView alloc] initWithTitle:@"No image was found" message:@"Check your settings and retry" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Settings", nil];
                    [noImageAlert setDelegate:self];
                    [noImageAlert show];
                    [loading dismiss];
                }
            });
            
        }
        
    } else {
        
        [ImageValidation generateDefaults];
        [self bootXPreparations];
    }
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    [self slideToSetupViewAnimation:NO];
    
    NSString *button = [alertView buttonTitleAtIndex:buttonIndex];

    if ([button isEqualToString:@"Settings"]) {
        [self didSettingsButtonPressed];
    }
}

- (void)didSettingsButtonPressed {
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        
        SettingsViewControllerForiOS6 *settings = [[SettingsViewControllerForiOS6 alloc] initWithLinenImage:linen];
        [about removeFromSuperview];
        
        SettingsNavigationController *navController = [[SettingsNavigationController alloc] initWithRootViewController:settings];
        [self presentModalViewController:navController animated:YES];
        
    } else {
     
        iPadSettingsViewForiOS6 *settings = [[iPadSettingsViewForiOS6 alloc] init];
        [settings show];
        [about removeFromSuperview];
    }
}

- (void)didCompleteSlide {
    
    loading = [[LoadingView alloc] initWithAlertImage:alertImage dimmingImage:[UIImage imageNamed:@"UIAlertViewDimming"]];
    [self slideToSetupViewAnimation:YES];
    [self bootXPreparations];

}

@end
