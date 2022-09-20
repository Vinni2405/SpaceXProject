//
//  MissionDetailViewModel.swift
//  SpaceXProject
//
//  Created by  Vinni on 09/19/22.
//

import Foundation

// MARK: - Delegate
protocol MissionDetailViewModelDelegate: AnyObject {
    func insertRows(indexPaths: [IndexPath])
    func deleteRows(indexPaths: [IndexPath])
}


// MARK: - View Model
class MissionDetailViewModel {
    
    // MARK: Properties
    private var details = [Detail]()
    
    private weak var delegate: MissionDetailViewModelDelegate?
    
    
    // MARK: Lifecycle
    init(delegate: MissionDetailViewModelDelegate) {
        self.delegate = delegate
    }
    
    
    // MARK: Methods
    
    /// This function is called whenever the user selects to change the mission that the Detail View Controller is displaying
    func setMission(_ mission: Mission) {
        details = []
        
        do {
            let details = try mission.allProperties()
            let detailKeys = details.keys.compactMap({ $0 }).sorted()
            for key in detailKeys {
                self.details.append(Detail(title: key.formatAsTitle(),
                                           rawContent: details[key] as Any))
            }
        }
        
        catch(let error) {
            print(error)
        }
    }
    
    /// Returns the number of Details to be represented as rows in the tableView
    func getDetailCount() -> Int {
        return details.count
    }
    
    /// Returns the title corresponding to the Detail at the specified index
    func getTitleForRow(at index: Int) -> String {
        return details[index].title
    }
    
    /// Returns the content corresponding to the Detail at the specified index
    func getContentForRow(at index: Int) -> String {
        return details[index].content
    }
    
    /// Returns the tier of the Detail at the specified index
    func getTierForRow(at index: Int) -> Int {
        return details[index].tier
    }
    
    /// Returns a Bool indicating whether the row at the specified index is expandable
    func cellIsExpandable(at index: Int) -> Bool {
        return !getChildrenForRow(at: index).isEmpty
    }
    
    /// Returns a Bool indicating whether the row at the specified index is expanded
    func cellIsExpanded(at index: Int) -> Bool {
        return details[index].isExpanded
    }
    
    /// Returns the children for a Detail at the specified index
    func getChildrenForRow(at index: Int) -> [Detail] {
        return details[index].children
    }
    
    /// Expands all rows for the cell at the specified index
    func expandRow(at index: Int) {
        
        let children = getChildrenForRow(at: index)
        details.insert(contentsOf: children, at: index+1)
        details[index].isExpanded = true
        
        let range = index+1...index+children.count
        let indexPaths = range.compactMap({ IndexPath(row: $0, section: 0) })

        delegate?.insertRows(indexPaths: indexPaths)
    }
    
    /// Collapses all rows (and child rows, if any) at the specified index
    func collapseAllChildRows(at index: Int) {
        
        let children = getChildrenForRow(at: index)
                
        let range = index+1...index+children.count
        let indexPaths = range.compactMap({ IndexPath(row: $0, section: 0) })
        
        for (childIndex, child) in children.enumerated() {
            if child.isExpanded {
                collapseAllChildRows(at: index+childIndex+1)
            }
        }
        
        details[index].isExpanded = false
        details.removeSubrange(range)
        
        delegate?.deleteRows(indexPaths: indexPaths)
    }
}
