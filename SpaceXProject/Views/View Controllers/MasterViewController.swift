//
//  MasterViewController.swift
//  SpaceXProject
//
//  Created by  Vinni on 09/19/22.
//

import UIKit

protocol PrimaryViewControllerDelegate: AnyObject {
    func didSelectMission(_ mission: Mission)
}

class MasterViewController: UISplitViewController {
    
    private var primaryViewController: MissionTableViewController!
    private var detailViewController: DetailViewController!

    override func viewDidLoad() {
        super.viewDidLoad()

        loadViewControllers()
    }
    
    func loadViewControllers() {
        primaryViewController = MissionTableViewController()
        
        primaryViewController.setDelegate(delegate: self)
        
        detailViewController = DetailViewController(nibName: DetailViewController.nibName, bundle: nil)
        
        let navController = UINavigationController(rootViewController: primaryViewController)
        
        viewControllers = [navController, detailViewController]
    }
}

extension MasterViewController: PrimaryViewControllerDelegate {
    func didSelectMission(_ mission: Mission) {
        detailViewController.setMission(mission)
        showDetailViewController(detailViewController, sender: self)
    }
}
