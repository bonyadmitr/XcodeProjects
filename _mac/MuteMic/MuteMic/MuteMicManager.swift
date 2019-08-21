import CoreAudio

/// can be handled in system "Audio MIDI Setup.app"
/// mute touchBar https://github.com/CocoaHeadsBrasil/MuteUnmuteMic
/// mute https://github.com/pixel-point/mute-me
/// swift Audio https://github.com/Sunnyyoung/Suohai
final class MuteMicManager {
    
    static let shared = MuteMicManager()
    
    /// called in background twice!!
    var didChange: ((_ isMuted: Bool) -> Void)?
    
    private var defaultInputDevicePropertyAddress = AudioObjectPropertyAddress(
        mSelector: kAudioHardwarePropertyDefaultInputDevice,
        mScope: kAudioObjectPropertyScopeGlobal,
        mElement: kAudioObjectPropertyElementMaster)
    
    private var mutePropertyAddress = AudioObjectPropertyAddress(mSelector: kAudioDevicePropertyMute,
                                                                 mScope: kAudioDevicePropertyScopeInput,
                                                                 mElement: kAudioObjectPropertyElementMaster)
    
    private let systemInputDeviceID = AudioObjectID(kAudioObjectSystemObject)
    private var currentInputDeviceID = AudioObjectID(kAudioObjectUnknown)
    private var propertySize = UInt32(MemoryLayout<UInt32>.size)
    
    init() {
        setupCurrentInputDeviceID()
        startListener()
    }
    
    deinit {
        stopListener()
    }
    
    private func setupCurrentInputDeviceID() {
        AudioObjectGetPropertyData(systemInputDeviceID, &defaultInputDevicePropertyAddress, 0, nil, &propertySize, &currentInputDeviceID).handleError()
        assert(currentInputDeviceID != kAudioObjectUnknown)
    }
    
    func isMuted() -> Bool {
        var isMuted: DarwinBoolean = false
        AudioObjectGetPropertyData(currentInputDeviceID, &mutePropertyAddress, 0, nil, &propertySize, &isMuted).handleError()
        return isMuted.boolValue
    }
    
    func setMute(_ mute: Bool) {
        var toggleMute: UInt32 = mute ? 1 : 0
        AudioObjectSetPropertyData(currentInputDeviceID, &mutePropertyAddress, 0, nil, propertySize, &toggleMute).handleError()
    }
    
    func toogleMute() {
        assert(isMuteSettable())
        setMute(!isMuted())
    }
    
    private func isMuteSettable() -> Bool {
        var isSettable: DarwinBoolean = false
        AudioObjectIsPropertySettable(currentInputDeviceID, &mutePropertyAddress, &isSettable).handleError()
        return isSettable.boolValue
    }
    
    // MARK: - Listener
    
    private func startListener() {
        /// https://stackoverflow.com/a/33310021/5893286
        let selfPointer = Unmanaged.passUnretained(self).toOpaque()
        
        /// can be used AudioObjectRemovePropertyListenerBlock
        AudioObjectAddPropertyListener(systemInputDeviceID, &defaultInputDevicePropertyAddress, defaultInputDeviceListener, selfPointer).handleError()
        AudioObjectAddPropertyListener(currentInputDeviceID, &mutePropertyAddress, muteListener, selfPointer).handleError()
    }
    
    private func stopListener() {
        let selfPonter = Unmanaged.passUnretained(self).toOpaque()
        AudioObjectRemovePropertyListener(systemInputDeviceID, &defaultInputDevicePropertyAddress, defaultInputDeviceListener, selfPonter).handleError()
        AudioObjectRemovePropertyListener(currentInputDeviceID, &mutePropertyAddress, muteListener, selfPonter).handleError()
    }
    
    /// doesn't called on headphone connection
    private let defaultInputDeviceListener: AudioObjectPropertyListenerProc = { _, _, _, selfPointer in
        selfPointer.assertExecute {
            let audioManager = Unmanaged<MuteMicManager>.fromOpaque($0).takeUnretainedValue()
            audioManager.deviceDidChange()
        }
        return kAudioHardwareNoError
    }
    
    private let muteListener: AudioObjectPropertyListenerProc = { _, _, _, selfPointer in
        selfPointer.assertExecute {
            let audioManager = Unmanaged<MuteMicManager>.fromOpaque($0).takeUnretainedValue()
            audioManager.muteDidChange()
        }
        return kAudioHardwareNoError
    }
    
    private func deviceDidChange() {
        assert(currentInputDeviceID != kAudioObjectUnknown)
        let savedMute = isMuted()
        stopListener()
        
        setupCurrentInputDeviceID()
        
        setMute(savedMute)
        startListener()
        print("-",savedMute)
    }
    
    private func muteDidChange() {
        didChange?(isMuted())
    }
}
