//
//  LaunchTableViewController.swift
//  SpaceXProject
//
//  Created by David Jabech on 8/11/22.
//

import UIKit

class LaunchTableViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        APIHandler.shared.fetchData(urlString: URLString.spaceXLaunches) { (result: Result<[Mission], Error>) in
            switch result {
            case .success(let missions):
                print(missions[0..<10])
            case .failure(let failure):
                print(failure)
            }
        }
    }
}

