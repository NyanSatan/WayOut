//
//  ImageValidation.h
//  WayOut
//
//  Created on 24.10.16.
//  All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <fcntl.h>
#import <unistd.h>
#import <dlfcn.h>
#import <mach-o/loader.h>
#import <mach-o/fat.h>

@interface ImageValidation : NSObject;

typedef NS_ENUM(NSInteger, iBootInfoType) {
    iBootType,
    iBootVersion    
};

+ (BOOL)isConfigValid;
+ (BOOL)isMultiKloaderNeeded;
+ (BOOL)isImageExistAtPath:(NSString*)path;
+ (BOOL)isARMImageValidAtPath:(NSString*)path;
+ (BOOL)isIMG3ImageValidAtPath:(NSString*)path;
+ (void)executeScript;
+ (void)bootX;
+ (void)generateDefaults;
+ (BOOL)doesBelongToS5L8940Family;

+ (NSString*)getiBootInfoForImage:(NSInteger)imageNumber ofType:(iBootInfoType)infoType;
+ (NSString*)getScriptType;

@end