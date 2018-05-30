//
//  Functions.m
//  macObjC
//
//  Created by Bondar Yaroslav on 02/09/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

#include "Functions.h"

// https://developer.apple.com/library/content/qa/qa1134/_index.html
OSStatus SendAppleEventToSystemProcess(AEEventID EventToSend) {
    AEAddressDesc targetDesc;
    static const ProcessSerialNumber kPSNOfSystemProcess = { 0, kSystemProcess };
    AppleEvent eventReply = {typeNull, NULL};
    AppleEvent appleEventToSend = {typeNull, NULL};
    
    OSStatus error = noErr;
    
    error = AECreateDesc(typeProcessSerialNumber, &kPSNOfSystemProcess,
                         sizeof(kPSNOfSystemProcess), &targetDesc);
    
    if (error != noErr) {
        return(error);
    }
    
    error = AECreateAppleEvent(kCoreEventClass, EventToSend, &targetDesc,
                               kAutoGenerateReturnID, kAnyTransactionID, &appleEventToSend);
    
    AEDisposeDesc(&targetDesc);
    if (error != noErr) {
        return(error);
    }
    
    error = AESend(&appleEventToSend, &eventReply, kAENoReply,
                   kAENormalPriority, kAEDefaultTimeout, NULL, NULL);
    
    AEDisposeDesc(&appleEventToSend);
    if (error != noErr) {
        return(error);
    }
    
    AEDisposeDesc(&eventReply);
    
    return(error); 
}
