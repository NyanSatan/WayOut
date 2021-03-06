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
    
    if ([[[UIDevice currentDevice] systemVersion] intValue] < 6) {
        
        return NO;
        
    } else {
        
        return [[[NSUserDefaults standardUserDefaults] objectForKey:@"multi_kloader"] boolValue];
    }
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

+ (BOOL)doesBelongToS5L8940Family {
    
    void *handle = dlopen("/usr/lib/libMobileGestalt.dylib", RTLD_LAZY);
    CFPropertyListRef (*MGCopyAnswer)(CFStringRef property);
    MGCopyAnswer = dlsym(handle, "MGCopyAnswer");
    NSString *platform = [(__bridge NSDictionary*)MGCopyAnswer(CFSTR("HardwarePlatform")) description];
    dlclose(handle);
    
    if ([platform isEqualToString:@"s5l8940x"] || [platform isEqualToString:@"s5l8942x"] || [platform isEqualToString:@"s5l8945x"]) {
        
        return YES;
        
    } else {
        
        return NO;
    }
    
}

+ (void)bootX {
    
    NSString *kloader;
    
    if (![[[NSUserDefaults standardUserDefaults] objectForKey:@"multi_kloader"] boolValue]) {
        
        kloader = [[NSBundle mainBundle] pathForResource:[[[UIDevice currentDevice] systemVersion] intValue] > 5 ? @"kloader" : @"kloader_ios5" ofType:nil];
        
    } else {
        
        if ([self doesBelongToS5L8940Family]) {
            
            kloader = [[NSBundle mainBundle] pathForResource:@"4smulti_kloader" ofType:nil];
            
        } else {
            
            kloader = [[NSBundle mainBundle] pathForResource:@"multi_kloader" ofType:nil];

        }
    }
    
    system([[NSString stringWithFormat:@"%@ -b \"%@ %@ %@\"", [[NSBundle mainBundle] pathForResource:@"WayOutHelper" ofType:nil], kloader, [[NSUserDefaults standardUserDefaults] valueForKey:@"Image 1"], [self isMultiKloaderNeeded] ? [[NSUserDefaults standardUserDefaults] valueForKey:@"Image 2"] : @""] cStringUsingEncoding:NSASCIIStringEncoding]);
    
}

+ (void)executeScript {
    
    system([[NSString stringWithFormat:@"%@ -s %@", [[NSBundle mainBundle] pathForResource:@"WayOutHelper" ofType:nil], [[NSUserDefaults standardUserDefaults] valueForKey:@"Pre-boot script"]] cStringUsingEncoding:NSASCIIStringEncoding]);
    
}

+ (NSString*)getiBootInfoForImage:(NSInteger)imageNumber ofType:(iBootInfoType)infoType {
    
    NSString* image = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"Image %ld", (long)imageNumber]];
    
    if ([self isImageExistAtPath:image]) {
        
        if (imageNumber == 1 ? [self isARMImageValidAtPath:image] : [self isIMG3ImageValidAtPath:image]) {
            
            if (infoType == iBootType) {
                return [self getiBootTypeAtPath:image isIMG3:(imageNumber-1)];
            } else {
                return [self getiBootVersionAtPath:image isIMG3:(imageNumber-1)];
            }
            
        } else {
            return @"Image not valid";
        }
        
    } else {
        return @"Image not exists";
    }
    
    return nil;
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
    
    close(fd);
    
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
    
    close(fd);
    
    return result;
}

+ (NSString*)getScriptType {
    
    NSString *script = [[NSUserDefaults standardUserDefaults] objectForKey:@"Pre-boot script"];
    
    if ([self isImageExistAtPath:script]) {
        
        int fd = open([script cStringUsingEncoding:NSASCIIStringEncoding], O_RDONLY, 0);
        char buffer[100];
        pread(fd, buffer, 100, 0);
        close(fd);
        
        uint32_t magic = *(uint32_t*)buffer;
        if (magic == MH_MAGIC || magic == MH_MAGIC_64 || magic == MH_CIGAM || magic == MH_CIGAM_64 || magic == FAT_MAGIC || magic == FAT_CIGAM) {
            return @"Mach-O";
        }
        
        char *hashbang = strstr(buffer, "#!");
        if (hashbang != NULL) {
            char *nextLine = strstr(hashbang, "\x0A");
            if (nextLine != NULL) {
                hashbang[nextLine - hashbang] = 0x0;
                hashbang = hashbang + 2;
                return [[NSString stringWithUTF8String:hashbang] lastPathComponent];
            }
        }
        
        return @"Unknown";
        
    } else {
        
        return @"Script not exists";
    }
    
}

+ (void)generateDefaults {

    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:[[[UIDevice currentDevice] systemVersion] intValue] < 6 ? NO : YES] forKey:@"multi_kloader"];
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"Image 1"];
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"Image 2"];
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"Pre-boot script"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
