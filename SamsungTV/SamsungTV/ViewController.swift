//
//  ViewController.swift
//  SamsungTV
//
//  Created by Bondar Yaroslav on 20/01/2018.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import UIKit
import Starscream
import MMLanScan

class ViewController: UIViewController {

    var socket: WebSocket!
    
    private lazy var lanScanner = MMLANScanner(delegate: self)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
        lanScanner?.start()
        
        
        
        let ip = "192.168.100.3"
        let port = "8001"
        let name = "SamsungTvRemote"
        let base64Name = Data(name.utf8).base64EncodedString()
        
        let str = "http://\(ip):\(port)/api/v2/channels/samsung.remote.control?name=\(base64Name)"
        print(str, "\n")
        
        let url = URL(string: str)!
        
        socket = WebSocket(url: url)
        
        //websocketDidConnect
        socket.onConnect = {
            
            print("websocket is connected")
        }
        //websocketDidDisconnect
        socket.onDisconnect = { (error: Error?) in
            print("websocket is disconnected: \(error?.localizedDescription ?? "111")")
        }
        //websocketDidReceiveMessage
        socket.onText = { (text: String) in
            
            if text.contains("ms.channel.connect") {
                print("- connected to TV")
            }
            
            
            print("got some text: \(text)")
        }
        
        //        got some text: {"data":{"clients":[{"attributes":{"name":"U2Ftc3VuZ1R2UmVtb3Rl"},"connectTime":1516483907701,"deviceName":"U2Ftc3VuZ1R2UmVtb3Rl","id":"c11b5de8-4f5a-44d0-a0bc-9125dcb39dc","isHost":false}],"id":"c11b5de8-4f5a-44d0-a0bc-9125dcb39dc"},"event":"ms.channel.connect"}
        
        //websocketDidReceiveData
        socket.onData = { (data: Data) in
            print("got some data: \(data.count)")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        

        //you could do onPong as well.
        socket.connect()

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        socket.disconnect(forceTimeout: 0)
    }
    
    @IBAction func actionMenuButton(_ sender: UIButton) {
        let key = "KEY_HOME"
        
        
        
        let q = "{\"method\":\"ms.remote.control\",\"params\":{\"Cmd\":\"Click\",\"DataOfCmd\":\"\(key)\",\"TypeOfRemote\":\"SendRemoteKey\",\"Option\":false}}"
        self.socket.write(string: q)
        
        //            let mp = MessageParams(Cmd: "Click", DataOfCmd: key, Option: false, TypeOfRemote: "SendRemoteKey")
        //            let message = Message(method: "ms.remote.control", params: mp)
        //
        //
        //            if let data = try? JSONEncoder().encode(message) {
        //                let str = String(data: data, encoding: .utf8)!
        //                self.socket.write(string: str)
        //            }
    }
    
    deinit {
        socket.delegate = nil
    }
}
//ws.send(JSON.stringify({
//    'method': 'ms.remote.control',
//    'params': {
//        'Cmd': 'Click',
//        'DataOfCmd': key,
//        'Option': 'false',
//        'TypeOfRemote': 'SendRemoteKey'
//    }
//}));

struct Message: Codable {
    var method: String
    var params: MessageParams
}

struct MessageParams: Codable {
    var Cmd: String
    var DataOfCmd: String
    var Option: Bool
    var TypeOfRemote: String
}


extension ViewController: MMLANScannerDelegate {
    func lanScanDidFindNewDevice(_ device: MMDevice!) {
        print("hostname", device!.hostname)
        print("ipAddress", device!.ipAddress)
        print("brand", device!.brand)
        print("isLocalDevice", device!.isLocalDevice)
        print("---------")
    }
    
    func lanScanDidFinishScanning(with status: MMLanScannerStatus) {
        
    }
    
    func lanScanDidFailedToScan() {
        
    }
    
    
}
