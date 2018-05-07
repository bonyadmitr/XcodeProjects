//
//  BluetoothManager.swift
//  iOSComponents
//
//  Created by Bondar Yaroslav on 07/05/2018.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import Foundation
import CoreBluetooth

final class BluetoothManager: NSObject {
    
    /// will never be nil
    private var bluetoothManager: CBCentralManager!
    
    override init() {
        super.init()
        bluetoothManager = CBCentralManager(delegate: self,
                                            queue: nil,
                                            options: [CBCentralManagerOptionShowPowerAlertKey: 0])
    }
}

extension BluetoothManager: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        // This delegate method will monitor for any changes in bluetooth state and respond accordingly
        let bluetoothState: String
        switch bluetoothManager.state {
        case .unknown:
            bluetoothState = "off"
        case .resetting:
            bluetoothState = "off"
        case .unsupported:
            bluetoothState = "off"
        case .unauthorized:
            bluetoothState = "no permission"
        case .poweredOff:
            bluetoothState = "off"
        case .poweredOn:
            bluetoothState = "on"
        }
        print(bluetoothState)
    }
}
