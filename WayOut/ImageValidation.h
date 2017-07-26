//
//  ImageValidation.h
//  WayOut
//
//  Created on 24.10.16.
//  All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageValidation : NSObject;

+ (BOOL)isConfigValid;
+ (BOOL)isMultiKloaderNeeded;
+ (BOOL)isImageExistAtPath:(NSString*)path;
+ (BOOL)isARMImageValidAtPath:(NSString*)path;
+ (BOOL)isIMG3ImageValidAtPath:(NSString*)path;
+ (void)bootX;
+ (void)generateDefaults;

+ (NSString*)getiBootTypeAtPath:(NSString*)path isIMG3:(BOOL)isIMG3;
+ (NSString*)getiBootVersionAtPath:(NSString*)path isIMG3:(BOOL)isIMG3;

@end