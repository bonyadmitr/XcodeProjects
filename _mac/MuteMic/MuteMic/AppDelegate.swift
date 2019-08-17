//
//  AppDelegate.swift
//  MuteMic
//
//  Created by Bondar Yaroslav on 8/17/19.
//  Copyright © 2019 Bondar Yaroslav. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    let statusItemManager = StatusItemManager()
    let audioManager = AudioManager()

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        statusItemManager.setup()
        audioManager.get2()
    }

    func applicationWillTerminate(_ aNotification: Notification) {}
}

import Cocoa

final class StatusItemManager {
    
    //static let shared = StatusItemManager()
    
    private let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
    
    private let statusItemMenu: NSMenu = {
        let menu = NSMenu()
        menu.addItem(withTitle: "qqq", action: nil, keyEquivalent: ",")
        return menu
    }()
    
    /// without storyboard can be create by lazy var + `_ = statusItem`.
    /// otherwise will be errors "0 is not a valid connection ID".
    /// https://habr.com/ru/post/447754/
    func setup() {
        guard let button = statusItem.button else {
            assertionFailure("system error. try statusItem.title")
            return
        }
        //button.image = NSImage(named: NSImage.Name("StatusBarButtonImage"))
        button.title = "Mic"
        button.action = #selector(clickStatusItem)
        button.target = self
        button.sendAction(on: [.leftMouseUp, .rightMouseUp])
    }
    
    @objc private func clickStatusItem() {
        guard let event = NSApp.currentEvent else {
            assertionFailure()
            return
        }
        
        if event.modifierFlags.contains([.option]) || event.type == .rightMouseUp {
            statusItem.popUpMenu(statusItemMenu)
        }
        
//        if ((event.modifierFlags.rawValue & NSControlKeyMask) || (event.type == NSRightMouseUp))
    }
    
}

final class AudioManager {
    
    var inputDeviceAddress = AudioObjectPropertyAddress(mSelector: kAudioHardwarePropertyDefaultInputDevice,
                                                        mScope: kAudioObjectPropertyScopeGlobal,
                                                        mElement: kAudioObjectPropertyElementMaster)
    
    var mutePropertyAddress = AudioObjectPropertyAddress(mSelector: kAudioDevicePropertyMute,
                                                         mScope: kAudioDevicePropertyScopeInput,
                                                         mElement: kAudioObjectPropertyElementMaster)
    
    let systemID = AudioObjectID(kAudioObjectSystemObject)
    var propertySize = UInt32(MemoryLayout<UInt32>.size)
    
    var currentID = AudioObjectID(kAudioObjectUnknown)
    
    private func setupCurrentId() {
        AudioObjectGetPropertyData(systemID, &inputDeviceAddress, 0, nil, &propertySize, &currentID).handleError()
    }
    
    func isMuted() -> Bool {
        var isMuted: DarwinBoolean = false
        AudioObjectGetPropertyData(currentID, &mutePropertyAddress, 0, nil, &propertySize, &isMuted).handleError()
        return isMuted.boolValue
    }
    
    func setMute(_ mute: Bool) {
        var toggleMute: UInt32 = mute ? 1 : 0
        AudioObjectSetPropertyData(currentID, &mutePropertyAddress, 0, nil, propertySize, &toggleMute).handleError()
    }
    
    func toogleMute() {
        assert(isMuteSettable())
        setMute(!isMuted())
    }
    
    func isMuteSettable() -> Bool {
        var isSettable: DarwinBoolean = false
        AudioObjectIsPropertySettable(currentID, &mutePropertyAddress, &isSettable).handleError()
        return isSettable.boolValue
    }
    
    func get2() {
        setupCurrentId()
        toogleMute()
    }
    
    func get() {
        
        
        var propertySize: UInt32 = 0
        
        // Get the size of the property in the kAudioObjectSystemObject so we can make space to store it
        AudioObjectGetPropertyDataSize(systemID, &inputDeviceAddress, 0, nil, &propertySize).handleError()
        
        assert(propertySize == UInt32(MemoryLayout<UInt32>.size))
        
        let numberOfDevices = Int(propertySize) / MemoryLayout<AudioDeviceID>.size
        var deviceIDs = [AudioDeviceID](repeating: AudioDeviceID(), count: numberOfDevices)
        AudioObjectGetPropertyData(systemID, &inputDeviceAddress, 0, nil, &propertySize, &deviceIDs).handleError()

        
        
    }
}


//import AudioToolbox
import CoreAudio

/// big app https://github.com/kyleneideck/BackgroundMusic
/// app https://github.com/mattingalls/Soundflower
/// depricated volume https://github.com/drudge/MacDroidNotifier/blob/master/SoundVolume.m
/// swift sample https://stackoverflow.com/a/38982906/5893286
/// mute micro https://github.com/pixel-point/mute-me/blob/master/Mute%20Me%20Now/AppDelegate.m
func getInputDevices() throws -> [AudioDeviceID] {
    
    var inputDevices: [AudioDeviceID] = []
    
    // Construct the address of the property which holds all available devices
    var devicesPropertyAddress = AudioObjectPropertyAddress(mSelector: kAudioHardwarePropertyDevices, mScope: kAudioObjectPropertyScopeGlobal, mElement: kAudioObjectPropertyElementMaster)
    var propertySize = UInt32(0)
    
    // Get the size of the property in the kAudioObjectSystemObject so we can make space to store it
    try handle(AudioObjectGetPropertyDataSize(AudioObjectID(kAudioObjectSystemObject), &devicesPropertyAddress, 0, nil, &propertySize))
    
    // Get the number of devices by dividing the property address by the size of AudioDeviceIDs
    
    let numberOfDevices = Int(propertySize) / MemoryLayout<AudioDeviceID>.size//sizeof(AudioDeviceID.self)
    
    // Create space to store the values
    var deviceIDs: [AudioDeviceID] = []
    for _ in 0 ..< numberOfDevices {
        deviceIDs.append(AudioDeviceID())
    }
    
    // Get the available devices
    try handle(AudioObjectGetPropertyData(AudioObjectID(kAudioObjectSystemObject), &devicesPropertyAddress, 0, nil, &propertySize, &deviceIDs))
    
    // Iterate
    for id in deviceIDs {
        
        // Get the device name for fun
        var name: CFString = "" as CFString
        var propertySize = UInt32(MemoryLayout<AudioDeviceID>.size)// sizeof(CFString.self))
        var deviceNamePropertyAddress = AudioObjectPropertyAddress(mSelector: kAudioDevicePropertyDeviceNameCFString, mScope: kAudioObjectPropertyScopeGlobal, mElement: kAudioObjectPropertyElementMaster)
        try handle(AudioObjectGetPropertyData(id, &deviceNamePropertyAddress, 0, nil, &propertySize, &name))
        
        // Check the input scope of the device for any channels. That would mean it's an input device
        
        // Get the stream configuration of the device. It's a list of audio buffers.
        var streamConfigAddress = AudioObjectPropertyAddress(mSelector: kAudioDevicePropertyStreamConfiguration, mScope: kAudioDevicePropertyScopeInput, mElement: 0)
        
        // Get the size so we can make room again
        try handle(AudioObjectGetPropertyDataSize(id, &streamConfigAddress, 0, nil, &propertySize))
        
        // Create a buffer list with the property size we just got and let core audio fill it
        let audioBufferList = AudioBufferList.allocate(maximumBuffers: Int(propertySize))
        try handle(AudioObjectGetPropertyData(id, &streamConfigAddress, 0, nil, &propertySize, audioBufferList.unsafeMutablePointer))
        
        // Get the number of channels in all the audio buffers in the audio buffer list
        var channelCount = 0
        for i in 0 ..< Int(audioBufferList.unsafeMutablePointer.pointee.mNumberBuffers) {
            channelCount = channelCount + Int(audioBufferList[i].mNumberChannels)
        }
        
        free(audioBufferList.unsafeMutablePointer)
        
        // If there are channels, it's an input device
        if channelCount > 0 {
            Swift.print("Found input device '\(name)' with \(channelCount) channels")
            inputDevices.append(id)
        }
    }
    
    return inputDevices
}

func handle(_ errorCode: OSStatus) throws {
    if errorCode != kAudioHardwareNoError {
        //let error = NSError(domain: NSOSStatusErrorDomain, code: Int(errorCode), userInfo: [NSLocalizedDescriptionKey : "CAError: \(errorCode)" ])
        print("- error code:", errorCode)
        //NSApplication.shared.presentError(error)
        //throw error
    }
}

extension OSStatus {
    func handleError() {
        assert(self == kAudioHardwareNoError, "reason: \(self)")
    }
}
