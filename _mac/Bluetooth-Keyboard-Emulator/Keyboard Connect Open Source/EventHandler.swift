import AppKit

protocol EventHandlerDelegate: class {
    func send(keyCode: UInt8, modifier: UInt8)
    func quite()
}

/// modifierFlags switch https://stackoverflow.com/a/32447474/5893286
final class EventHandler {
    
    weak var delegate: EventHandlerDelegate?
    
    func start() {
        
        let cgEventCallback: CGEventTapCallBack = { _, eventType, cgEvent, rawPointer in
            
            guard NSApp.isActive else {
                
                /// https://stackoverflow.com/a/5785895
                /// 0x0b is the virtual keycode for "b"
                /// 0x09 is the virtual keycode for "v"
                //if cgEvent.getIntegerValueField(.keyboardEventKeycode) == 0x0B {
                //    cgEvent.setIntegerValueField(.keyboardEventKeycode, value: 0x09)
                //}
                
                return Unmanaged.passUnretained(cgEvent)
            }
            
            guard let rawPointer = rawPointer, let event = NSEvent(cgEvent: cgEvent) else {
                assertionFailure()
                return nil
            }
            
            let eventHandler = Unmanaged<EventHandler>.fromOpaque(rawPointer).takeUnretainedValue()
            eventHandler.logKey(eventType: eventType, cgEvent: cgEvent)
            
            switch eventType {
            case .keyUp:
                eventHandler.sendKey(vkeyCode: -1, event.modifierFlags)
            case .keyDown:
                eventHandler.sendKey(vkeyCode: Int(event.keyCode), event.modifierFlags)
            default:
                assertionFailure("possible eventType set in 'let eventMask: CGEventMask'. this: \(eventType.rawValue)")
                //break
            }
            
            /// call after all
            eventHandler.handleQuite(eventType: eventType, cgEvent: cgEvent)
            
            /// to remove error sound pass nil
            return nil
            //return Unmanaged.passUnretained(cgEvent)
        }
        
        /// https://stackoverflow.com/a/31898592
        let eventMask: CGEventMask = (1 << CGEventType.keyUp.rawValue) | (1 << CGEventType.keyDown.rawValue)// | (1 << CGEventType.flagsChanged.rawValue)
        
        let selfPointer = Unmanaged.passUnretained(self).toOpaque()
        
        guard let eventTap = CGEvent.tapCreate(tap: .cgSessionEventTap,
                                               place: .headInsertEventTap,
                                               options: .defaultTap,
                                               eventsOfInterest: eventMask,
                                               callback: cgEventCallback,
                                               userInfo: selfPointer)
            else {
                assertionFailure("called without Accessibility permission. search AXIsProcessTrustedWithOptions")
                return
        }
        
        
        let runLoopSource = CFMachPortCreateRunLoopSource(kCFAllocatorDefault, eventTap, 0)
        CFRunLoopAddSource(CFRunLoopGetCurrent(), runLoopSource, .commonModes)
        CGEvent.tapEnable(tap: eventTap, enable: true)
        //CFRunLoopRun()
        
    }
    
    private func sendKey(vkeyCode: Int, _ modifierFlags: NSEvent.ModifierFlags) {
        var modifier: UInt8 = 0
        
        if modifierFlags.contains(.command) {
            modifier |= (1 << 3)
        }
        if modifierFlags.contains(.option) {
            modifier |= (1 << 2)
        }
        if modifierFlags.contains(.shift) {
            modifier |= (1 << 1)
        }
        if modifierFlags.contains(.control) {
            modifier |= 1
        }
        
        let keyCode = UInt8(virtualKeyCodeToHIDKeyCode(vKeyCode: vkeyCode))
        delegate?.send(keyCode: keyCode, modifier: modifier)
    }
    
    private func handleQuite(eventType: CGEventType, cgEvent: CGEvent) {
        guard eventType == .keyDown, cgEvent.flags.contains(.maskCommand) else {
            return
        }
        var char = UniChar()
        var length = 0
        cgEvent.keyboardGetUnicodeString(maxStringLength: 1, actualStringLength: &length, unicodeString: &char)
        
        /// 113 = q or cmd+q
        if char == 113 {
            delegate?.quite()
        }
    }
    
    private func logKey(eventType: CGEventType, cgEvent: CGEvent) {
        
        /// https://stackoverflow.com/a/44507450
        if eventType == .keyDown {
            let flags = cgEvent.flags
            var msg = ""
            
            if flags.contains(.maskAlphaShift) {
                msg+="caps+"
            }
            if flags.contains(.maskShift) {
                msg+="shift+"
            }
            if flags.contains(.maskControl) {
                msg+="control+"
            }
            if flags.contains(.maskAlternate) {
                msg+="option+"
            }
            if flags.contains(.maskCommand) {
                msg += "command+"
            }
            if flags.contains(.maskSecondaryFn) {
                msg += "function+"
            }
            
            assert(eventType != .flagsChanged, "NSEvent.charactersIgnoringModifiers will crash on .flagsChanged")
            if let event = NSEvent(cgEvent: cgEvent), let chars = event.charactersIgnoringModifiers {
                msg += chars
                print(msg)
            }
        }
    }
}
