//
//  MissionTableViewController.swift
//  SpaceXProject
//
//  Created by  Vinni on 09/19/22.
//

import UIKit

class MissionTableViewController: UIViewController {
    
    // MARK: Properties
    
    private let tableContainer = MissionTableContainerView()
    
    private var loadingView: LoadingView?
    
    private lazy var viewModel = MissionTableViewModel(delegate: self, handler: APIHandler())
    
    private weak var delegate: PrimaryViewControllerDelegate?
    
    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Missions"
        
        view.addSubview(tableContainer)
        loadingView = LoadingView(frame: tableContainer.frame)
        tableContainer.addSubview(loadingView!)
                
        tableContainer.setDelegate(delegate: self)
        viewModel.fetchMissions()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableContainer.frame = view.bounds
        loadingView?.center = tableContainer.center
    }
    
    // MARK: Methods
    
    /// Sets the PrimaryViewControllerDelegate for this view controller.
    func setDelegate(delegate: PrimaryViewControllerDelegate) {
        self.delegate = delegate
    }
}

// MARK: ViewModelDelegate Methods
extension MissionTableViewController: MissionTableViewModelDelegate {
    func didGetData(error: Error?) {
        if let error = error {
            print(error) // present alert here
        }
        else {
            DispatchQueue.main.async { [weak self] in
                self?.tableContainer.refresh()
                self?.loadingView?.isHidden = true
            }
        }
    }
}

// MARK: TableContainerDelegate Methods
extension MissionTableViewController: MissionTableContainerViewDelegate {
    func getNumberOfRows(section: Int) -> Int {
        return viewModel.getMissionCount(section: section)
    }
    
    func getMissionImageForCell(at index: Int, section: Int) -> String {
        return viewModel.getSmallMissionImageForMission(at: index, section: section)
    }
    
    func getMissionNameForCell(at index: Int, section: Int) -> String {
        return viewModel.getMissionNameForMission(at: index, section: section)
    }
    
    func getRocketNameForCell(at index: Int, section: Int) -> String {
        return viewModel.getRocketNameForMission(at: index, section: section)
    }
    
    func getLaunchSiteAndDateForCell(at index: Int, section: Int) -> String {
        return viewModel.getLaunchSiteAndDateForMission(at: index, section: section)
    }
    
    func cellWasSelected(at index: Int, section: Int) {
        // show super cool details
        guard let mission = viewModel.returnMission(at: index, section: section) else {
            print("faied to return mission")
            return
        }
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            delegate?.didSelectMission(mission)
        }
        
        else {
            let vc = DetailViewController(nibName: DetailViewController.nibName, bundle: nil)
            vc.setMission(mission)
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

