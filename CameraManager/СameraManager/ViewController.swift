//
//  ViewController.swift
//  CameraManager
//
//  Created by Bondar Yaroslav on 05/06/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let cameraManager3rd = CameraManager3rdParty()
    
    let cameraManager = CameraManager()
    @IBOutlet weak var resizeView: LayerResizeView!
    @IBOutlet weak var camera3rdView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad")
        
        cameraManager.prepare {
//            LayerResizeView(layer: self.cameraManager.previewLayer).add(to: self.view)
            self.resizeView.resizingLayer = self.cameraManager.previewLayer
        }
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(saveToCamera(_:)))
        view.addGestureRecognizer(gesture)
        
//        _ = cameraManager3rd.addPreviewLayerToView(camera3rdView)
    }
    
    func saveToCamera(_ sender: UITapGestureRecognizer) {
//        cameraManager3rd.capturePictureWithCompletion { (image, error) in
//            print(image ?? "")
//        }
        cameraManager.getImage { image in
            guard let image = image else { return }
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        }
    }
}
