//
//  main.m
//  WayOut
//
//  Created on 05.06.16.
//  All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

void fixIcons(char *argv0) {

    int iOSVersion = [[[UIDevice currentDevice] systemVersion] intValue];
    
    if (iOSVersion < 7) {
        
        NSString *infoDictionaryPath = [[[NSString stringWithCString:argv0 encoding:NSASCIIStringEncoding] stringByDeletingLastPathComponent] stringByAppendingPathComponent:@"Info.plist"];
        
        NSMutableDictionary *infoDictionary = [[NSMutableDictionary alloc] initWithContentsOfFile:infoDictionaryPath];
        [[infoDictionary valueForKey:@"CFBundleIconFiles"] setObject:@"icon6" atIndex:0];
        
        if (iOSVersion < 6) {
            [infoDictionary setObject:@"icon6" forKey:@"CFBundleIconFile"];
        }
        
        if ([infoDictionary writeToFile:infoDictionaryPath atomically:NO]) {
            
            printf("Done writing Info.plist\n");
            
        } else {
            
            printf("There is something wrong with writing of plist...\n");
        }
    } else {
        
        printf("iOS version is 7.0 or newer, no need to patch icon array\n");
    }
    
}

int main(int argc, char * argv[]) {
    
    @autoreleasepool {
        
        if (argc > 1) {
            
            if (strcmp(argv[1], "--icon") == 0) {
                
                printf("%s argument detected\n", argv[1]);
                fixIcons(argv[0]);
                
                return 0;
            }
        }
        
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
        
    }
}
