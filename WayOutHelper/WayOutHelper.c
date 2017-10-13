//
//  WayOutHelper.c
//  
//
//  Created on 11/10/17.
//
//

#include <stdio.h>
#include <sys/types.h>
#include <unistd.h>
#include <stdlib.h>
#include <string.h>
#include <fcntl.h>

int main(int argc, char *argv[]) {
    
    setuid(0);
    setgid(0);
    
    if (getuid() != 0) {
        printf("This must be run as root!\n");
        return 0;
    }

    if (strcmp(argv[1], "-s") == 0) {
        
        char *root_domain = "/private/var/root/Library/Preferences/com.nyansatan.WayOut.plist";
        
        int fd = open(root_domain, O_RDONLY);
        
        if (fd < 0) {
            return 0;
        }
        
        printf("Moving user defaults...\n");
        
        chown(root_domain, 501, 501);
        
        char *mobile_domain = "/private/var/mobile/Library/Preferences/com.nyansatan.WayOut.plist";
        
        int ret = rename(root_domain, mobile_domain);
        
        if (ret == 0) {
            printf("Done moving user defaults!\n");
        } else {
            printf("Couldn't move user defaults!\n");
        }
        
    } else {
        
        system(argv[1]);
    }
    
    return 0;
}