//
//  Functions.h
//  macObjC
//
//  Created by Bondar Yaroslav on 02/09/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

#ifndef Functions_h
#define Functions_h

#include <Carbon/Carbon.h>

/**
 *    kAERestart        will cause system to restart
 *    kAEShutDown       will cause system to shutdown
 *    kAEReallyLogout   will cause system to logout
 *    kAESleep          will cause system to sleep
 */
OSStatus SendAppleEventToSystemProcess(AEEventID EventToSend);

#endif /* Functions_h */
