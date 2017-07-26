//
//  ImageValidation.m
//  WayOut
//
//  Created on 24.10.16.
//  All rights reserved.
//

#import "ImageValidation.h"

@implementation ImageValidation : NSObject

+ (BOOL)isConfigValid {

    NSString *image1 = [[NSUserDefaults standardUserDefaults] valueForKey:@"Image 1"];
    NSString *image2 = [[NSUserDefaults standardUserDefaults] valueForKey:@"Image 2"];
    BOOL multi_kloader = [[[NSUserDefaults standardUserDefaults] objectForKey:@"multi_kloader"] boolValue];
    
    if (image1 != nil && image2 != nil && multi_kloader == YES | multi_kloader == NO) {
        
        return  YES;
    } else {
        return NO;
    }
}

+ (BOOL)isMultiKloaderNeeded {
    
    return [[[NSUserDefaults standardUserDefaults] objectForKey:@"multi_kloader"] boolValue];
}

+ (BOOL)isImageExistAtPath:(NSString*)path {
    
    BOOL result = '\0';
    
    
        NSFileHandle *fd = [NSFileHandle fileHandleForReadingAtPath:path];
        
        if (fd != nil) {
            result = YES;
        } else {
            result = NO;
        }
    
    return result;
}


+ (BOOL)isARMImageValidAtPath:(NSString*)path {
    
    BOOL result = '\0';
    
    NSFileHandle *fd = [NSFileHandle fileHandleForReadingAtPath:path];
    NSData *imageHeader = [fd readDataOfLength:4];
    uint8_t ARMMagic[] = {0x0e, 0x00, 0x00, 0xea};
        
    if ([imageHeader isEqualToData:[NSData dataWithBytes:ARMMagic length:sizeof(ARMMagic)]]) {
            
        [fd closeFile];
        result = YES;
    } else {
        result = NO;
    }
    
    return result;
}

+ (BOOL)isIMG3ImageValidAtPath:(NSString*)path {
 
    BOOL result = '\0';
    uint8_t IMG3Magic[] = {0x33, 0x67, 0x6d, 0x49};
    
    NSFileHandle *fd = [NSFileHandle fileHandleForReadingAtPath:path];
    NSData *imageHeader = [fd readDataOfLength:4];
   
    if ([imageHeader isEqualToData:[NSData dataWithBytes:IMG3Magic length:sizeof(IMG3Magic)]]) {
            
        [fd closeFile];
        result = YES;
    } else {
        result = NO;
    }
    
    return result;
}

+ (void)bootX {
    
    
    if (![[[NSUserDefaults standardUserDefaults] objectForKey:@"multi_kloader"] boolValue]) {
        
        system([[NSString stringWithFormat:@"%@ %@", [[NSBundle mainBundle] pathForResource:@"kloader" ofType:nil], [[NSUserDefaults standardUserDefaults] valueForKey:@"Image 1"]] cStringUsingEncoding:NSASCIIStringEncoding]);
        
    } else {
        
        system([[NSString stringWithFormat:@"%@ %@ %@", [[NSBundle mainBundle] pathForResource:@"multi_kloader" ofType:nil], [[NSUserDefaults standardUserDefaults] valueForKey:@"Image 1"], [[NSUserDefaults standardUserDefaults] valueForKey:@"Image 2"]] cStringUsingEncoding:NSASCIIStringEncoding]);
        
    }
    
}

#define TYPELENGTH 0x40
#define VERSIONLENGTH 0x20
#define OFFSET 0x200
#define IMG3OFFSET 0x240
#define TYPEOFFSET 0x0
#define VERSIONOFFSET 0x80

+ (NSString*)getiBootTypeAtPath:(NSString*)path isIMG3:(BOOL)isIMG3 {
    
    int fd = open([path cStringUsingEncoding:NSASCIIStringEncoding], O_RDONLY, 0);
    char buffer[TYPELENGTH];
    
    if (!isIMG3) {
        pread(fd, buffer, TYPELENGTH, OFFSET+TYPEOFFSET);
    } else {
        pread(fd, buffer, TYPELENGTH, IMG3OFFSET+TYPEOFFSET);
    }
    
    NSString *type = [NSString stringWithCString:buffer encoding:NSASCIIStringEncoding];
    NSRange range = [type rangeOfString:@","];
    NSString *result = [type substringWithRange:NSMakeRange(0, range.location)];
    
    return result;
}

+ (NSString*)getiBootVersionAtPath:(NSString*)path isIMG3:(BOOL)isIMG3 {
    
    int fd = open([path cStringUsingEncoding:NSASCIIStringEncoding], O_RDONLY, 0);
    char buffer[VERSIONLENGTH];
    
    if (!isIMG3) {
        pread(fd, buffer, VERSIONLENGTH, OFFSET+VERSIONOFFSET);
    } else {
        pread(fd, buffer, VERSIONLENGTH, IMG3OFFSET+VERSIONOFFSET);
    }
    
    NSString *result = [NSString stringWithCString:buffer encoding:NSASCIIStringEncoding];
    
    return result;
}

+ (void)generateDefaults {

    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:@"multi_kloader"];
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"Image 1"];
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"Image 2"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end