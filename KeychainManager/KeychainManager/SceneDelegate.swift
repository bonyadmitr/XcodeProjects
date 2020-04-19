//
//  SceneDelegate.swift
//  KeychainManager
//
//  Created by Bondar Yaroslav on 4/3/20.
//  Copyright © 2020 Bondar Yaroslav. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        
                
                
                
        //let q = "0000111000101101001011110001010000001110001011100001101100001110001011110001101000001110001011110010111100010100000011100010111000011100000011100010111000101110000011100010111100011001000011100010111100101110"
                
        //let mirror = "0111010011110100011100001001100011110100011100000111010001110100011100000011100001110100011100000010100011110100111101000111000001011000111101000111000011011000011101000111000000101000111101001011010001110000"
        
        //"я вся горю"
        //let q = "11010001001000001101011111010011110100010010000011000111110011111101001011000000"
        let q = "11010001 00100000 11010111 11010011 11010001 00100000 11000111 11001111 11010010 11000000"
        let w = q.replacingOccurrences(of: " ", with: "")
        //print(q.split(by: 8).joined(separator: " "))
        
//        let encoding = BinaryCoder.koi8rtNSEncoding
        
        //let q = "11010001 10001111 00100000 11010000 10110010 11010001 10000001 11010001 10001111 00100000 11010000 10110011 11010000 10111110 11010001 10000000 11010001 10001110"
        //let q = "11111111 11111110 01001111 00000100 00100000 00000000 00110010 00000100 01000001 00000100 01001111 00000100 00100000 00000000 00110011 00000100 00111110 00000100 01000000 00000100 01001110 00000100"
        let encoding = String.Encoding.unicode
        
        print(
            "-|\n\(BinaryCoder().decode(w, from: encoding) ?? "nil")\n|-"
        )
        //print("-|\n\(BinaryCoder().decodeFromAll(w))\n|-")
        
        
        let encodingString = "я вся горю"
        print(
            //BinaryCoder().encodeInAll(encodingString).map({$0.replacingOccurrences(of: " ", with: "")}).map({$0.count}),
            //BinaryCoder().encodeInAll(encodingString),
            //"\n",
        )
        print(
            BinaryCoder().encode(encodingString, in: encoding) ?? "nil"
        )
        
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let _ = (scene as? UIWindowScene) else { return }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

