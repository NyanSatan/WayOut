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

    [fd closeFile];
    
    return result;
}


+ (BOOL)isARMImageValidAtPath:(NSString*)path {
    
    BOOL result = '\0';
    
    NSFileHandle *fd = [NSFileHandle fileHandleForReadingAtPath:path];
    NSData *imageHeader = [fd readDataOfLength:4];
    uint8_t ARMMagic[] = {0x0e, 0x00, 0x00, 0xea};
        
    if ([imageHeader isEqualToData:[NSData dataWithBytes:ARMMagic length:sizeof(ARMMagic)]]) {
        result = YES;
    } else {
        result = NO;
    }
    
    [fd closeFile];
    
    return result;
}

+ (BOOL)isIMG3ImageValidAtPath:(NSString*)path {
 
    BOOL result = '\0';
    uint8_t IMG3Magic[] = {0x33, 0x67, 0x6d, 0x49};
    
    NSFileHandle *fd = [NSFileHandle fileHandleForReadingAtPath:path];
    NSData *imageHeader = [fd readDataOfLength:4];
   
    if ([imageHeader isEqualToData:[NSData dataWithBytes:IMG3Magic length:sizeof(IMG3Magic)]]) {
        result = YES;
    } else {
        result = NO;
    }
    
    [fd closeFile];
    
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
            
            int image_fd = open([image cStringUsingEncoding:NSASCIIStringEncoding], O_RDONLY);
            if (image_fd < 0) {
                close(image_fd);
                return @"Couldn't open the image";
            }
        
            uint32_t magic = 0;
            
            if (pread(image_fd, &magic, 4, 0) < 0) {
                close(image_fd);
                return @"Couldn't read the image";
            }
            
            
            uint16_t offset = 0x300;
            
            if (magic == 0x496d6733) {
                offset += 0x40;
            }
            
            uint32_t iboot_str_ref;
            
            
        read:
            
            if (pread(image_fd, &iboot_str_ref, 4, offset + ((infoType == iBootVersion) ? 0x8 : 0x0)) < 0) {
                close(image_fd);
                return @"Couldn't read the image";
            }
            
            if (iboot_str_ref == 'diuu') {
                offset += 0x20;
                goto read;
            }
            
            if (iboot_str_ref == 0x0) {
                offset += 0x20;
                goto read;
            }
            
            
            
            iboot_str_ref = iboot_str_ref << 16 >> 16;
            
            if (iboot_str_ref > 0x2ff) {
                return @"String is out of range";
            }
            
            if (magic == 0x496d6733) {
                iboot_str_ref += 0x40;
            }
            
            
            uint16_t max_length = (infoType == iBootType) ? 64 : 32;
            
            char *string = malloc(max_length);
            *(string + max_length - 1) = 0x0;
            
            if (pread(image_fd, string, max_length, iboot_str_ref) < 0) {
                close(image_fd);
                return @"Couldn't read the image";
            }
            
            if (infoType == iBootType) {
                char *first_comma = strstr(string, ",");
                
                if (first_comma) {
                    *first_comma = 0x0;
                }
                
            }
            
            close(image_fd);
            
            return [NSString stringWithCString:string encoding:NSASCIIStringEncoding];
            
            
        } else {
            return @"Image not valid";
        }
        
    } else {
        return @"Image not exists";
    }
    
    return nil;
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
