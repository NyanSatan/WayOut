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
+ (void)bootX;
+ (void)generateDefaults;
+ (BOOL)doesBelongToS5L8940Family;

+ (NSString*)getiBootInfoForImage:(NSInteger)imageNumber ofType:(iBootInfoType)infoType;
+ (NSString*)getiBootTypeAtPath:(NSString*)path isIMG3:(BOOL)isIMG3;
+ (NSString*)getiBootVersionAtPath:(NSString*)path isIMG3:(BOOL)isIMG3;

@end