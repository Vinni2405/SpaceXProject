//
//  MissionTableContainerView.swift
//  SpaceXProject
//
//  Created by  Vinni on 09/19/22.
//

import UIKit

// MARK: - Delegate
protocol MissionTableContainerViewDelegate: AnyObject {
    func getNumberOfRows(section: Int) -> Int
    func getMissionImageForCell(at index: Int, section: Int) -> String
    func getMissionNameForCell(at index: Int, section: Int) -> String
    func getRocketNameForCell(at index: Int, section: Int) -> String
    func getLaunchSiteAndDateForCell(at index: Int, section: Int) -> String
    func cellWasSelected(at index: Int, section: Int)
}

// MARK: View
class MissionTableContainerView: UIView {
    
    let nibName = "MissionTableContainerView"
    
    private weak var delegate: MissionTableContainerViewDelegate?
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        nibInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func nibInit() {
        Bundle.main.loadNibNamed(nibName, owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        tableView.delegate = self
        tableView.dataSource = self
        
        let nib = UINib(nibName: MissionCell.identifier, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: MissionCell.identifier)
    }
    
    func setDelegate(delegate: MissionTableContainerViewDelegate) {
        self.delegate = delegate
    }
    
    func refresh() {
        tableView.reloadData()
    }
}

extension MissionTableContainerView: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "Upcoming Launches" : "Past Launches"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return delegate?.getNumberOfRows(section: section) ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MissionCell.identifier, for: indexPath) as? MissionCell else {
            return UITableViewCell()
        }
        
        cell.configureCell(missionImage: delegate?.getMissionImageForCell(at: indexPath.row, section: indexPath.section) ?? "",
                           missionName: delegate?.getMissionNameForCell(at: indexPath.row, section: indexPath.section) ?? "",
                           rocketName: delegate?.getRocketNameForCell(at: indexPath.row, section: indexPath.section) ?? "",
                           launchSiteAndDate: delegate?.getLaunchSiteAndDateForCell(at: indexPath.row, section: indexPath.section) ?? "")
        
        return cell
    }
    
    // Each summary item should be clickable. When clicked the full mission details provided by the API should be displayed.
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        delegate?.cellWasSelected(at: indexPath.row, section: indexPath.section)
    }
}
