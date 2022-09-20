//
//  MissionTableViewModel.swift
//  SpaceXProject
//
//  Created by  Vinni on 09/19/22.
//

import Foundation

// MARK: - Delegate
protocol MissionTableViewModelDelegate: AnyObject {
    func didGetData(error: Error?)
}

// MARK: - View Model
class MissionTableViewModel {
    
    // MARK: Properties
    private var missions: [Mission]?
    
    private var upcomingMissions: [Mission]?
    
    private var error: Error?
    
    private var handler: APIService
    
    private weak var delegate: MissionTableViewModelDelegate?
    
    
    // MARK: Lifecycle
    init(delegate: MissionTableViewModelDelegate, handler: APIService) {
        self.delegate = delegate
        self.handler = handler
    }
    
    // MARK: Methods
    
    /// Uses shared instance of APIHandler to fetch launch history from SpaceX API.
    func fetchMissions() {
        
        handler.fetchData(urlString: URLString.spaceXLaunches) { [weak self] (result: Result<[Mission], Error>) in
            guard let self = self else { return }
            
            switch result {
                
            case .success(let missions):
                self.missions = missions
                
                // Launches shall be listed and ordered from newest to oldest.
                self.missions?.sort(by: { $0.flightNumber ?? 0 > $1.flightNumber ?? 0 })
                
                self.upcomingMissions = self.missions?.filter({ $0.upcoming == true })
                self.missions?.removeAll(where: { $0.upcoming == true })
                                
            case .failure(let error):
                self.error = error
            }
            
            self.delegate?.didGetData(error: self.error)
            self.error = nil // resetting error
        }
    }
    
    /// Returns the number of missions to be represented as rows in the tableView.
    func getMissionCount(section: Int) -> Int {
        if section == 0 {
            return upcomingMissions?.count ?? 0
        }
        return missions?.count ?? 0
    }
    
    /// Returns the mission at the specified index; this method is used to pass a mission to the Detail View Controller.
    func returnMission(at index: Int, section: Int) -> Mission? {
        if section == 0 {
            return upcomingMissions?[index]
        }
        return missions?[index]
    }
    
    // MARK: Summary Details
    /// Summary details displayed in the list should include:
    ///    - Mission Name
    ///    - Rocket Name
    ///    - Launch Site Name
    ///    - Date of Launch
    ///    - Launch patch image, or default image when not provided by the API
    
    /// Returns imageURL for small mission image at the specified index.
    func getSmallMissionImageForMission(at index: Int, section: Int) -> String {
        if section == 0 {
            return upcomingMissions?[index].links?.missionPatchSmall ?? ""
        }
        return missions?[index].links?.missionPatchSmall ?? ""
    }
    
    /// Returns imageURL for large mission image at the specified index; this method is used to pass large mission image to the Detail View Controller.
    func getLargeMissionImageForMission(at index: Int, section: Int) -> String {
        if section == 0 {
            return upcomingMissions?[index].links?.missionPatch ?? ""
        }
        return missions?[index].links?.missionPatch ?? ""
    }
    
    /// Returns the name for the mission at the specified index.
    func getMissionNameForMission(at index: Int, section: Int) -> String {
        if section == 0 {
            return upcomingMissions?[index].missionName ?? ""
        }
        return missions?[index].missionName ?? ""
    }
    
    /// Returns the rocket name for the mission at the specified index.
    func getRocketNameForMission(at index: Int, section: Int) -> String {
        if section == 0 {
            return upcomingMissions?[index].rocket?.rocketName ?? ""
        }
        return missions?[index].rocket?.rocketName ?? ""
    }
    
    /// Returns String containing both the launch site and launch date for the mission at the specified index.
    func getLaunchSiteAndDateForMission(at index: Int, section: Int) -> String {
        
        let missionArray = section == 0 ? upcomingMissions : missions
        
        guard let site = missionArray?[index].launchSite?.siteName, var date = missionArray?[index].launchDateUtc, let start = date.firstIndex(of: "T") else {
            return ""
        }
        
        date.removeSubrange(start..<date.endIndex)
        return "Launched at \(site) on \(date)"
    }
}
