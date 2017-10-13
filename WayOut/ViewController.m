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
    UIImageView *logoImageView;
    UIView *slideToBootView;
    
    iOS6LockScreenBottomBar *bar;
    CGFloat normalBarY;
    CGFloat hiddenBarY;
    
    LoadingView *loading;
    UIImage *alertImage;
    UIImage *dimmingImage;
    
    iOS6AlertView *aboutView;
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
    
    UIImage *infoButtonImage = [UIImage imageNamed:@"InfoButton"];
    bar = [[iOS6LockScreenBottomBar alloc] initWithYPosition:0];
    [bar setDelegate:self];
    CGFloat bottomBarHeight = bar.frame.size.height + infoButtonImage.size.height + 16;
    normalBarY = screenRect.size.height - bottomBarHeight;
    hiddenBarY = screenRect.size.height + bottomBarHeight;
    slideToBootView = [[UIView alloc] initWithFrame:CGRectMake(0, normalBarY, screenRect.size.width, bottomBarHeight)];
    [bar setYPosition:bottomBarHeight - bar.frame.size.height];
    [slideToBootView addSubview:bar];
    
    [self.view addSubview:slideToBootView];
    
#pragma mark Setting up info button
    
    UIButton *infoButton = [[UIButton alloc] initWithFrame:CGRectMake(screenRect.size.width/2-ceilf(infoButtonImage.size.width/2), 0, infoButtonImage.size.width, infoButtonImage.size.height)];
    [infoButton setImage:infoButtonImage forState:UIControlStateNormal];
    [infoButton addTarget:self action:@selector(infoButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [slideToBootView addSubview:infoButton];
    
#pragma mark Setting up logo image
    
    UIImage *logoImage = [UIImage imageNamed:@"WayOutLogo"];
    logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(ceilf( screenRect.size.width/2-logoImage.size.width/2), ceilf((screenRect.size.height-bar.frame.size.height)/2-logoImage.size.height/2), logoImage.size.width, logoImage.size.height)];
    [logoImageView setImage:logoImage];
    [self.view addSubview:logoImageView];

#pragma mark Setting up About view
    
    alertImage = [UIImage imageNamed:@"UIPopupAlertBackground"];
    dimmingImage = [UIImage imageNamed:@"UIAlertViewDimming"];
    
    aboutView = [[iOS6AlertView alloc] initWithTitle:[NSString stringWithFormat:@"Way Out %@ (%@)", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"], [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey]] message:@"Way Out - GUI for kloader in the spirit of classical Setup.app. Developed by @nyan_satan\n\nThanks to:\n@winocm, @xerub, @JonathanSeals, @axi0mX" delegate:self cancelButtonTitle:nil otherButtonTitle:@"Settings" backgroundImage:alertImage dimmingImage:dimmingImage position:CGPointMake(0, screenRect.size.height == 568.0 ? 114 : (screenRect.size.height == 480.0 ? 70 : 328)) animated:NO];
    
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

- (void)slideToSetupViewAnimation:(BOOL)type {
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    [UIView setAnimationDuration:0.4];
    
    if (type) {
        
        [self hideStatusBar];
        [loading show];
        slideToBootView.frame = CGRectMake(slideToBootView.frame.origin.x, hiddenBarY, slideToBootView.frame.size.width, slideToBootView.frame.size.height);
        [UIView commitAnimations];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [bar reset];
        });
    }
    
    if (!type) {
        
        [self showStatusBar];
        [loading dismiss];
        slideToBootView.frame = CGRectMake(slideToBootView.frame.origin.x, normalBarY, slideToBootView.frame.size.width, slideToBootView.frame.size.height);
        [UIView commitAnimations];
    }

}

- (void)didCompleteSlide {
    
    loading = [[LoadingView alloc] initWithAlertImage:alertImage dimmingImage:dimmingImage];
    [self slideToSetupViewAnimation:YES];
    [self bootXPreparations];
}

- (void)bootXPreparations {
    
    [aboutView dismiss];
    
    if ([ImageValidation isConfigValid]) {
            
        if ([ImageValidation isMultiKloaderNeeded]) {
                
            [loading setAlertContent:3];
                
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.75 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
            if ([ImageValidation isImageExistAtPath:[[NSUserDefaults standardUserDefaults] valueForKey:@"Image 1"]]) {
                    
                if ([ImageValidation isImageExistAtPath:[[NSUserDefaults standardUserDefaults] valueForKey:@"Image 2"]]) {
                        
                    if ([ImageValidation isARMImageValidAtPath:[[NSUserDefaults standardUserDefaults] valueForKey:@"Image 1"]]) {
                            
                        if ([ImageValidation isIMG3ImageValidAtPath:[[NSUserDefaults standardUserDefaults] valueForKey:@"Image 2"]]) {
                                
                            [loading setAlertContent:1];

                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                
                                [self.view removeFromSuperview];
                                
                                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                    
                                    [ImageValidation bootX];
                                 });
                            });
                                
                        } else {
                                
                            iOS6AlertView *invalidiBECAlert = [[iOS6AlertView alloc] initWithTitle:@"iBEC doesn't seem like an IMG3 container" message:@"iBEC image must be packaged into IMG3\nCheck your settings and retry" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitle:@"Settings" backgroundImage:alertImage dimmingImage:dimmingImage position:CGPointZero animated:YES];
                            [invalidiBECAlert show];
                            [loading dismiss];
                        }
                            
                    } else {
                            
                        iOS6AlertView *invalidiBSSAlert = [[iOS6AlertView alloc] initWithTitle:@"iBSS doesn't seem like an ARM image" message:@"iBSS image must be decrypted and unpacked\nCheck your settings and retry" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitle:@"Settings" backgroundImage:alertImage dimmingImage:dimmingImage position:CGPointZero animated:YES];
                        [invalidiBSSAlert show];
                        [loading dismiss];
                    }
                        
                } else {
                        
                    iOS6AlertView *noiBECAlert = [[iOS6AlertView alloc] initWithTitle:@"iBEC image not found" message:@"Check your settings and retry" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitle:@"Settings" backgroundImage:alertImage dimmingImage:dimmingImage position:CGPointZero animated:YES];
                    [noiBECAlert show];
                    [loading dismiss];
                }
                
            } else {
                    
                iOS6AlertView *noiBSSAlert = [[iOS6AlertView alloc] initWithTitle:@"iBSS image not found" message:@"Check your settings and retry" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitle:@"Settings" backgroundImage:alertImage dimmingImage:dimmingImage position:CGPointZero animated:YES];
                [noiBSSAlert show];
                [loading dismiss];
            }
                
            });
                
        } else {
                
            [loading setAlertContent:2];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.75 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if ([ImageValidation isImageExistAtPath:[[NSUserDefaults standardUserDefaults] valueForKey:@"Image 1"]]) {
                    
                if ([ImageValidation isARMImageValidAtPath:[[NSUserDefaults standardUserDefaults] valueForKey:@"Image 1"]]) {
                        
                    [loading setAlertContent:0];
                        
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        
                        [self.view removeFromSuperview];
                        
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            
                            [ImageValidation bootX];
                        });
                    });
                        
                } else {
                        
                    iOS6AlertView *invalidImageAlert = [[iOS6AlertView alloc] initWithTitle:@"This doesn't seem like an ARM image" message:@"Image must be decrypted and unpacked\nCheck your settings and retry" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitle:@"Settings" backgroundImage:alertImage dimmingImage:dimmingImage position:CGPointZero animated:YES];
                    [invalidImageAlert show];
                    [loading dismiss];
                }
                    
            } else {

                iOS6AlertView *noImageAlert = [[iOS6AlertView alloc] initWithTitle:@"No image was found" message:@"Check your settings and retry" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitle:@"Settings" backgroundImage:alertImage dimmingImage:dimmingImage position:CGPointZero animated:YES];
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


- (IBAction)infoButtonAction {
    
    if (aboutView.superview == nil) {
            
        [aboutView show];
            
    } else {
            
        [aboutView dismiss];
    }
    
}

- (void)clickedAlertButtonWithTitle:(NSString*)title {
    
    [self slideToSetupViewAnimation:NO];
    
    if ([title isEqualToString:@"Settings"]) {
        [self didSettingsButtonPressed];
    }

}

- (void)didSettingsButtonPressed {

    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
     
        iOS6SettingsTableViewController *settings = [[iOS6SettingsTableViewController alloc] initWithLinenImage:linen];
        iOS6SettingsNavigationController *navController = [[iOS6SettingsNavigationController alloc] initWithRootViewController:settings];
        [navController setModalPresentationStyle:UIModalPresentationFullScreen];
        [self presentModalViewController:navController animated:YES];
        
    } else {
        
        iOS6iPadSettingsView *settings = [[iOS6iPadSettingsView alloc] init];
        [settings show];
        
    }
    
    [aboutView dismiss];
}

@end