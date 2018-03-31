//
//  ViewController.swift
//  RealmInvalidGuardStorage
//
//  Created by Bondar Yaroslav on 27/02/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

import UIKit
import PromiseKit

class ViewController: UITableViewController {
    
    
    let service = EventService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("Started")
        
        let objects = (0..<10000).map {
             Ev(id: $0)
        }
        
        service.save(objects).asVoid().then {
            print("Done")
        }.then{
            self.tableView.reloadData()
        }.catch { (error) in
            dump(error)
        }
        
        service.save(objects).asVoid().then {
            print("Done")
            }.then{
                self.tableView.reloadData()
            }.catch { (error) in
                dump(error)
        }
        
        service.save(objects).asVoid().then {
            print("Done")
            }.then{
                self.tableView.reloadData()
            }.catch { (error) in
                dump(error)
        }
        
        service.save(objects).asVoid().then {
            print("Done")
            }.then{
                self.tableView.reloadData()
            }.catch { (error) in
                dump(error)
        }
        
        service.save(objects).asVoid().then {
            print("Done")
            }.then{
                self.tableView.reloadData()
            }.catch { (error) in
                dump(error)
        }
        
        service.save(objects).asVoid().then {
            print("Done")
            }.then{
                self.tableView.reloadData()
            }.catch { (error) in
                dump(error)
        }
        
        service.save(objects).asVoid().then {
            print("Done")
            }.then{
                self.tableView.reloadData()
            }.catch { (error) in
                dump(error)
        }
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return service.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
//        service.get(at: indexPath.row).then { (event) -> Void in
//            cell.textLabel?.text = event.title
//            cell.detailTextLabel?.text = String(event.id)
//        }.catch { (error) in
//            dump(error)
//        }
        
        if let event = service.repo[indexPath.row] {
            cell.textLabel?.text = event.title
            cell.detailTextLabel?.text = String(event.id)
        }
        
        return cell
    }
}
