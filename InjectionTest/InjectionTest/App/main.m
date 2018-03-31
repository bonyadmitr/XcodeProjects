//
//  main.m
//  InjectionTest
//
//  Created by Bondar Yaroslav on 10/04/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

#import <Foundation/Foundation.h>

// From here to end of file added by Injection Plugin //

#ifdef DEBUG
#define INJECTION_PORT 31452
static char _inMainFilePath[] = __FILE__;
static const char *_inIPAddresses[] = {"192.168.0.7", "127.0.0.1", 0};

#define INJECTION_ENABLED
#import "/tmp/injectionforxcode/BundleInjection.h"
#endif
