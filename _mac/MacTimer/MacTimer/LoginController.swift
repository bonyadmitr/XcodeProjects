//
//  LoginController.swift
//  MacTimer
//
//  Created by zdaecqze zdaecq on 03.07.16.
//  Copyright © 2016 Bondar Yaroslav. All rights reserved.
//

import Cocoa

class LoginController: NSViewController {

    @IBOutlet weak var emailTextField: NSTextField!
    
    let segueIdent = "Timer"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SocketIOManager.sharedInstance.establishConnection()
        SocketIOManager.sharedInstance.connectToServerWithNickname("zdaecq") { (userList) in
            print(userList)
        }
        
        SocketIOManager.sharedInstance.socket.onAny {
            print("Got event: \($0.event), with items: \($0.items)")
        }
    }
    
    @IBAction func actionLoginButton(sender: NSButton) {
        
        if emailTextField.stringValue.characters.count == 0 {
            let alert = NSAlert()
            alert.alertStyle = .InformationalAlertStyle
            alert.informativeText = "informativeText"
            alert.messageText = "messageText"
            //alert.addButtonWithTitle("OK")
            alert.runModal()
        } else {
            performSegueWithIdentifier(segueIdent, sender: self)
        }
        
        
    }
    
    override func prepareForSegue(segue: NSStoryboardSegue, sender: AnyObject?) {
        close()
        //if segue.identifier == segueIdent {
            
        //}
    }
}

extension NSViewController {
    func close() {
        if let _ = presentingViewController {
            dismissViewController(self)
        } else {
            view.window?.close()
        }
    }
}