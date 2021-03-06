//
//  BTKeyboard.swift
//  Keyboard Connect
//
//  Created by Arthur Yidi on 4/11/16.
//  Copyright © 2016 Arthur Yidi. All rights reserved.
//

import AppKit
import Foundation
import IOBluetooth

enum BTMessageType: UInt8 {
    case handshake = 0,
         hidControl
    case getReport = 4,
         setReport,
         getProtocol,
         setProtocol
    case data = 0xA
}

enum BTHandshake: UInt8 {
    case successful = 0,
         notReady,
         errorInvalidReport,
         errorUnsupportedRequest,
         errorInvalidParameter
    case errorUnknown = 0xE
    case errorFatal = 0xF
}

enum BTHIDControl: UInt8 {
    case Suspend = 3,
         ExitSuspend,
         VirtualCableUnplug
}

struct BTChannels {
    static let Control = BluetoothL2CAPPSM(kBluetoothL2CAPPSMHIDControl)
    static let Interrupt = BluetoothL2CAPPSM(kBluetoothL2CAPPSMHIDInterrupt)
}

private final class CallbackWrapper: IOBluetoothDeviceAsyncCallbacks {
    var callback: ((_ device: IOBluetoothDevice?, _ status: IOReturn) -> Void)? = nil
    @objc func connectionComplete(_ device: IOBluetoothDevice, status: IOReturn) {
        if let callback = self.callback {
            callback(device, status)
        }
    }
    @objc func remoteNameRequestComplete(_ device: IOBluetoothDevice?, status: IOReturn) {}
    @objc func sdpQueryComplete(_ device: IOBluetoothDevice?, status: IOReturn) {}
}

final class BTDevice {
    var device: IOBluetoothDevice?
    var interruptChannel: IOBluetoothL2CAPChannel?
    var controlChannel: IOBluetoothL2CAPChannel?
}

/// https://github.com/ArthurYidi/Bluetooth-Keyboard-Emulator
final class BTKeyboard {
    var curDevice: BTDevice?
    var service: IOBluetoothSDPServiceRecord?

    init() {
        let bluetoothHost = IOBluetoothHostController()

        // Detect if bluetooth is on using: bluetoothHost.powerState

        // Make the computer look like a keyboard device
        // 1 00101 010000 00
        // 3 21098 765432 10
        // Minor Device Class - Keyboard
        // Major Device Class - Peripheral
        // Limited Discoverable Mode
        /// search 0x002540 in http://domoticx.com/bluetooth-class-of-device-lijst-cod/
        let appleWirelessKeyboard: BluetoothClassOfDevice = 0x002540
        bluetoothHost.setClassOfDevice(appleWirelessKeyboard, forTimeInterval: 60)

        // Bluetooth SDP Service
        guard
            let dictPath = Bundle.main.path(forResource: "SerialPortDictionary", ofType: "plist"),
            let sdpDict = NSDictionary(contentsOfFile: dictPath) as? [AnyHashable: Any]
        else {
            assertionFailure()
            return
        }
        
        service = IOBluetoothSDPServiceRecord.publishedServiceRecord(with: sdpDict)

        // Open Channels for Incoming Connections
        guard IOBluetoothL2CAPChannel
            .register(forChannelOpenNotifications: self,
                      selector: #selector(newL2CAPChannelOpened),
                      withPSM: BTChannels.Control,
                      direction: kIOBluetoothUserNotificationChannelDirectionIncoming) != nil else
        {
            assertionFailure("failed to register: \(BTChannels.Control)")
            return
        }
        guard IOBluetoothL2CAPChannel
            .register(forChannelOpenNotifications: self,
                      selector: #selector(newL2CAPChannelOpened),
                      withPSM: BTChannels.Interrupt,
                      direction: kIOBluetoothUserNotificationChannelDirectionIncoming) != nil else
        {
            assertionFailure("failed to register: \(BTChannels.Interrupt)")
            return
        }
    }
    
    @objc private func newL2CAPChannelOpened(notification: IOBluetoothUserNotification, channel: IOBluetoothL2CAPChannel) {
        channel.setDelegate(self)
    }

    // TODO: kAXMovedNotification
    private func setupDevice(_ device: IOBluetoothDevice) -> Bool {
        var didfail = true
        var deviceWrapper = BTDevice()
        deviceWrapper.device = device
        self.curDevice = deviceWrapper

        let isOpenedForControl = device.openL2CAPChannelSync(&deviceWrapper.controlChannel,
                                                               withPSM: BTChannels.Control,
                                                               delegate: self)
        
        guard isOpenedForControl == kIOReturnSuccess else {
            /// failed -536870195
            if isOpenedForControl != kIOReturnNotOpen {
                assertionFailure("\(isOpenedForControl)")
            } else {
                print("- isOpenedForControl failed with: \(isOpenedForControl)")
            }
            
            return didfail
        }

        defer {
            if didfail {
                deviceWrapper.controlChannel?.close()
            }
        }
        
        let isOpenedForInterrupt = device.openL2CAPChannelSync(&deviceWrapper.interruptChannel,
                                                               withPSM: BTChannels.Interrupt,
                                                               delegate: self)

        guard isOpenedForInterrupt == kIOReturnSuccess else {
            assertionFailure("\(isOpenedForInterrupt)")
            return didfail
        }

        didfail = false
        return didfail
    }

    private func sendBytes(channel: IOBluetoothL2CAPChannel, _ bytes: [UInt8]) {
        let opaquePointer = OpaquePointer(bytes)
        let unsafePointer = UnsafeMutablePointer<UInt8>(opaquePointer)
        let ioResult = channel.writeAsync(unsafePointer, length: UInt16(bytes.count), refcon: nil)
        if ioResult != kIOReturnSuccess {
            /// 19 was one.
            print("Buff Data Failed \(channel.psm)")
        }
    }

    private func sendHandshake(channel: IOBluetoothL2CAPChannel, _ status: BTHandshake) {
        guard channel.psm == BTChannels.Control else {
            assertionFailure("Passing wrong channel to handshake")
            return
        }
        sendBytes(channel: channel, [0x0 | status.rawValue])
    }

    private func sendData(bytes: [UInt8]) {
        if let interruptChannel = curDevice?.interruptChannel {
            sendBytes(channel: interruptChannel, bytes)
        }
    }


    private func hidReport(keyCode: UInt8, _ modifier: UInt8) -> [UInt8] {
        let bytes: [UInt8] = [
            0xA1,      // 0 DATA | INPUT (HIDP Bluetooth)

            0x01,      // 0 Report ID
            modifier,  // 1 Modifier Keys
            0x00,      // 2 Reserved
            keyCode,   // 3 Keys ( 6 keys can be held at the same time )
            0x00,      // 4
            0x00,      // 5
            0x00,      // 6
            0x00,      // 7
            0x00,      // 8
            0x00       // 9
        ]

        return bytes
    }

    /**
     Sends a key by converting virtual key codes to HID key codes

     - Parameters:
     - vkeyCode: virtual keycode provided by NSEvent
     - modifierRawValue: raw modifier provided by NSEvent
     */
    func sendKey(keyCode: UInt8, modifier: UInt8) {
        sendData(bytes: hidReport(keyCode: keyCode, modifier))
    }

    func terminate() {
        curDevice?.device?.closeConnection()
    }
}

extension BTKeyboard: IOBluetoothL2CAPChannelDelegate {
    
    func l2capChannelData(_ channel: IOBluetoothL2CAPChannel!, data dataPointer: UnsafeMutableRawPointer, length dataLength: Int) {
        let opaquePointer = OpaquePointer(dataPointer)
        let unsafePointer = UnsafeMutablePointer<UInt8>(opaquePointer)
        let data = UnsafeBufferPointer<UInt8>(start: unsafePointer, count: dataLength)
        
        guard channel.psm == BTChannels.Control else {
            return
        }
        
        guard !data.isEmpty else {
            assertionFailure()
            return
        }
        
        guard let messageType = BTMessageType(rawValue: data[0] >> 4) else {
            assertionFailure()
            return
        }
        
        switch messageType {
        case .handshake:
            return
        case .hidControl:
            channel.device.closeConnection()
        case .setReport:
            sendHandshake(channel: channel, .successful)
        case .setProtocol:
            sendHandshake(channel: channel, .successful)
        default:
            //assertionFailure()
            break
        }
    }
    
    func l2capChannelOpenComplete(_ channel: IOBluetoothL2CAPChannel!, status error: IOReturn) {
        if !setupDevice(channel.device) {
            //            assertionFailure()
            return
        }
        
        switch channel.psm {
        case BTChannels.Control:
            curDevice?.controlChannel = channel
        case BTChannels.Interrupt:
            curDevice?.interruptChannel = channel
        default:
            print("failed channel.psm \(channel.psm)")
            return
            //            assertionFailure()
        }
    }
    
    //    @objc func l2capChannelClosed(_ channel: IOBluetoothL2CAPChannel!) {
    //
    //    }
    //
    //    @objc func l2capChannelWriteComplete(_ channel: IOBluetoothL2CAPChannel!, refcon: UnsafeMutableRawPointer, status error: IOReturn) {
    //
    //    }
}
