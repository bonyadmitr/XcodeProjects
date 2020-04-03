//
//  ViewController.swift
//  COVID
//
//  Created by Bondar Yaroslav on 4/1/20.
//  Copyright © 2020 Bondar Yaroslav. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private let globalInfoLabel: UILabel = {
        let label = UILabel()
        //label.textAlignment = .natural
        label.text = "Loading..."
        label.numberOfLines = 0
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        view.addSubview(globalInfoLabel)
        globalInfoLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            globalInfoLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            globalInfoLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            globalInfoLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16)
        ])
        

        
        
        globalInfo { [weak self] result in
            switch result {
            case .success(let globalInfo):
                
                let date = Date(timeIntervalSince1970: TimeInterval(globalInfo.updated / 1000))
                DispatchQueue.main.async {
                    self?.globalInfoLabel.text = """
                    Total: \(globalInfo.cases)
                    Deaths: \(globalInfo.deaths)
                    Active: \(globalInfo.active)
                    Recovered: \(globalInfo.recovered)
                    
                    Date: \(globalDateFormater.string(from: date))
                    """
                }
                
            case .failure(let error):
                print(error.description)
            }
        }
        
    }
    
    func globalInfo(handler: @escaping (Result<GlobalInfo, Error>) -> Void) {
        URLSession.shared.codableDataTask(with: URLs.all, completionHandler: handler)
    }
    
}

let globalDateFormater: DateFormatter = {
    let formater = DateFormatter()
    formater.dateStyle = .short
    formater.timeStyle = .short
    #if DEBUG
    formater.locale = Locale(identifier: "ru")
    #endif
    return formater
}()
