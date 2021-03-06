import CoreBluetooth

private let serviceUUID = CBUUID(string: "A3E424F7-A3F2-4147-9EE2-3FD44656F29A")
private let someInfoCharacteristicUUID = CBUUID(string: "7CB2A626-808B-498C-BA9C-89869CDF520E")

// TODO: send any data

// TODO: check max
/// У нас в характеристику можно записать всего какие-то 500 байтов, а на каких-то устройствах вообще 20
/// https://stackoverflow.com/a/20321542

// TODO: L2CAP
/// https://habr.com/ru/company/raiffeisenbank/blog/452278/
/// https://www.google.com/search?q=CoreBluetooth+L2CAP

// TODO: distance calculation by RSSI
/// RSSI stands for Received Signal Strength Indicator
/// https://stackoverflow.com/a/55526881
/// https://stackoverflow.com/a/18886603
/// https://stackoverflow.com/a/13724027
/// https://stackoverflow.com/a/45431617

// TODO: CBCentralManagerScanOptionAllowDuplicatesKey

/// https://leocardz.com/practical-corebluetooth-191472148c66
/// https://github.com/LeonardoCardoso/BLE/blob/master/macOS/BLE/BluetoothManager.swift
final class Central: NSObject {
    
    private(set) lazy var centralManager: CBCentralManager = {
        var options: [String: Any] = [:]
        /// Privacy Flag - Bluetooth Peripheral Usage Description
        //options[CBCentralManagerOptionRestoreIdentifierKey] = ""
        options[CBCentralManagerOptionShowPowerAlertKey] = false
        let manager: CBCentralManager = CBCentralManager(delegate: self, queue: self.queue, options: options)
        manager.delegate = self
        return manager
    }()
    
    func start() {
        _ = centralManager
    }
    
    /// Queue
    private let queue: DispatchQueue = DispatchQueue(label: "central.queue")
    
    
    /// Discoverd peripherals
    private(set) var discoveredPeripherals: Set<CBPeripheral> = []
    
    /// Connected peripherals
    private(set) var connectedPeripherals: Set<CBPeripheral> = []
}

extension Central: CBCentralManagerDelegate {
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        
        /// https://stackoverflow.com/a/23604387
        guard central.state == .poweredOn else {
            assertionFailure("\(central.state.rawValue)")
            return
        }
        
        central.scanForPeripherals(withServices: [serviceUUID], options: nil)
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        /// We must keep a reference to the new discovered peripheral, which means we must retain it.
        discoveredPeripherals.insert(peripheral)
        central.connect(peripheral, options: nil)
        print("found name: ", peripheral.name ?? "nil", "RSSI:", RSSI)
        
        if let power = advertisementData[CBAdvertisementDataTxPowerLevelKey] as? Double {
            print("Distance is ", pow(10, ( (power - Double(truncating: RSSI)) / 20)) )
        }

    }
    
    //    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
    //
    //    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        peripheral.delegate = self
        peripheral.discoverServices([serviceUUID])
        //connectedPeripherals.insert(peripheral)
    }
}

extension Central: CBPeripheralDelegate {
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        print("- didDiscoverServices")
        peripheral.services?
            .filter { $0.uuid == serviceUUID }
            .forEach { peripheral.discoverCharacteristics([someInfoCharacteristicUUID], for: $0) }
    }
    
    
    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
        /// After we write data on peripheral, we disconnect it.
//        centralManager.cancelPeripheralConnection(peripheral)
        
        /// we work once for peripheral
//        centralManager.stopScan()
//        print("stopScan")
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        print("- didDiscoverCharacteristicsFor")
        
        if let error = error as NSError? {
            print(error.description)
            return
        }
        
        service.characteristics?
            .filter { $0.uuid == someInfoCharacteristicUUID }
            .forEach {
                // To read static values
                //peripheral.readValue(for: $0)
                
                // To listen and read dynamic values
                peripheral.setNotifyValue(true, for: $0)
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        print("- didUpdateValueFor")
        if let error = error as NSError? {
            print(error.description)
            return
        }
        
        /// we read
        if let data = characteristic.value, let text = String(data: data, encoding: .utf8){
            print(text)
        }
        
        /// we write
        discoveredPeripherals.forEach { peripheral in
            let textToSend = "text from central".data(using: .utf8)!
            peripheral.writeValue(textToSend, for: characteristic, type: .withResponse)
        }
    }
    
    /// without it we have warning
    func peripheral(_ peripheral: CBPeripheral, didModifyServices invalidatedServices: [CBService]) {
        print("didModifyServices invalidatedServices")
    }
}










/**
 https://habr.com/ru/company/raiffeisenbank/blog/452278/
 
 https://www.bluetooth.com/specifications/gatt/services/
 */
final class BluetoothManager: NSObject {
    
    private let userInfoCharacteristicUUID = CBUUID(string: "7CB2A626-808B-498C-BA9C-89869CDF520E")
    private let sendInfoCharacteristicUUID = CBUUID(string: "A5148E54-CE2F-40E3-B1A9-F131F3B099C5")
    
    private lazy var peripheralManager = CBPeripheralManager(delegate: self, queue: nil)
    private lazy var centralManager = CBCentralManager(delegate: self, queue: nil)
    //private lazy var centralManager = CBCentralManager(delegate: self, queue: nil, options: [CBCentralManagerOptionRestoreIdentifierKey: "restoreKey"])
    
    private var availablePeripheral = [CBPeripheral]()
    
    func start() {
        _ = peripheralManager
        _ = centralManager
    }
    
    func send(text: String) {
        //        guard let data = text.data(using: .utf8) else {
        //            assertionFailure()
        //            return
        //        }
        //        availablePeripheral.forEach { $0.writeValue(data, for: CBCharacteristic, type: .withResponse)}
        
        /// https://stackoverflow.com/a/28256568
        //        availablePeripheral.forEach { $0.setNotifyValue(true, for: CBCharacteristic)}
    }
}

extension BluetoothManager: CBPeripheralManagerDelegate {
    
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        
        guard peripheral.state == .poweredOn else {
            print(peripheral.state.rawValue)
            return
        }
        
        //        let userInfoData = "userInfoData".data(using: .utf8)
        //        let sendInfoData = "sendInfoData".data(using: .utf8)
        
        let userInfoCharacteristic = CBMutableCharacteristic(type: userInfoCharacteristicUUID,
                                                             properties: .read,
                                                             value: nil,
                                                             permissions: .readable)
        let sendInfoCharacteristic = CBMutableCharacteristic(type: sendInfoCharacteristicUUID,
                                                             properties: .write,
                                                             value: nil,
                                                             permissions: .writeable)
        
        let service = CBMutableService(type: serviceUUID, primary: true)
        service.characteristics = [userInfoCharacteristic, sendInfoCharacteristic]
        
        peripheralManager.add(service)
        //peripheralManager.stopAdvertising()
        
        let advertisingData: [String: Any] = [CBAdvertisementDataLocalNameKey: peripheralName,
                                              CBAdvertisementDataServiceUUIDsKey: [serviceUUID]]
        peripheralManager.startAdvertising(advertisingData)
    }
    
    //    func peripheralManagerDidStartAdvertising(_ peripheral: CBPeripheralManager, error: Error?) {
    //
    //    }
    
    func peripheralManager(_ peripheral: CBPeripheralManager, didReceiveWrite requests: [CBATTRequest]) {
        requests
            .filter { $0.characteristic.uuid == sendInfoCharacteristicUUID }
            .forEach { request in
                peripheralManager.respond(to: request, withResult: .success)
                
                print(request.characteristic.value ?? "nil")
                print(request.value ?? "nil")
                guard let data = request.value, let text = String(data: data, encoding: .utf8) else {
                    assertionFailure()
                    return
                }
                print(text)
        }
    }
}

extension BluetoothManager: CBCentralManagerDelegate {
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        
        /// https://stackoverflow.com/a/23604387
        guard central.state == .poweredOn else {
            print(central.state.rawValue)
            return
        }
        
        central.scanForPeripherals(withServices: [serviceUUID], options: nil)
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        print("found name: ", peripheral.name ?? "nil", "RSSI:", RSSI)
        availablePeripheral.append(peripheral)
        //central.stopScan()
        central.connect(peripheral, options: nil)
    }
    
    //    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
    //
    //    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        peripheral.delegate = self
        peripheral.discoverServices([serviceUUID])
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        print("didDisconnectPeripheral")
        availablePeripheral.removeAll(where: { $0 == peripheral })
    }
}

extension BluetoothManager: CBPeripheralDelegate {
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        peripheral.services?
            .filter { $0.uuid == serviceUUID }
            .forEach { peripheral.discoverCharacteristics(nil, for: $0) }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        if let error = error as NSError? {
            print(error.description)
            return
        }
        //CBATTError.Code.init(rawValue: <#T##Int#>)
        //        service.characteristics?
        //            .filter { $0.uuid == userInfoCharacteristicUUID }
        //            .forEach {
        //                peripheral.readValue(for: $0)
        //                //peripheral.setNotifyValue(true, for: $0)
        //        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        if let error = error as NSError? {
            print(error.description)
            return
        }
        
        guard let data = characteristic.value, let text = String(data: data, encoding: .utf8) else {
            return
        }
        print(text)
    }
    
    func peripheral(_ peripheral: CBPeripheral, didModifyServices invalidatedServices: [CBService]) {
        print("didModifyServices invalidatedServices")
    }
}
