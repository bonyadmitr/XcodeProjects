//
//  ViewController.swift
//  CoreDataWithoutDataModel
//
//  Created by Bondar Yaroslav on 4/24/20.
//  Copyright © 2020 Bondar Yaroslav. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        CoreDataStack.shared.performBackgroundTask { context in
            
            let note = NoteMO(context: context)
            note.body = "body 123 eurwieur"
            note.date = Date()
            
            context.safeSave()
            
            CoreDataStack.shared.performBackgroundTask { context in
                
                let request: NSFetchRequest<NoteMO> = NoteMO.fetchRequest()
                //try! request.execute()
                //context.execute(request)
                let items = try! context.fetch(request)
                print(items.count)
                print()

            }
        }
        
        
    }

}
