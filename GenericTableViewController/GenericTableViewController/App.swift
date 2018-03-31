//
//  App.swift
//  GenericTableViewController
//
//  Created by zdaecqze zdaecq on 03.10.16.
//  Copyright © 2016 Bondar Yaroslav. All rights reserved.
//

import UIKit

final class App {
    
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let navigationController: UINavigationController
    
    
    init(window: UIWindow) {
        
        navigationController = window.rootViewController as! UINavigationController
        let mainController = navigationController.topViewController as! ViewController
        mainController.didTapProfile = showProfile
        mainController.didSelectSeason =  {_ in self.showProfile()}
        
    }
    
    
    func showProfile() {
        
        let profileNC = storyboard.instantiateViewController(withIdentifier: "ProfileNav") as! UINavigationController
        let profileVC = profileNC.topViewController as! ProfileController
        profileVC.didTapClose = {
            profileVC.dismiss(animated: true, completion: nil)
        }
        navigationController.present(profileNC, animated: true, completion: nil)
        
    }
    
    
    func showSeason(season: Season) {

        let sampleEpisodes = [
            Episode(title: "First Episode"),
            Episode(title: "Second Episode"),
            Episode(title: "Third Episode")
        ]
        
        let episodesVC = GenericTableViewController(items: sampleEpisodes) { cell, episode in
            cell.textLabel?.text = episode.title
        }
        episodesVC.title = season.title
        episodesVC.didSelect = showEpisode
        navigationController.pushViewController(episodesVC, animated: true)
        
    }
    
    
    func showEpisode(episode: Episode) {

        let detailController = storyboard.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        detailController.episode = episode
        navigationController.pushViewController(detailController, animated: true)
        
    }
}
