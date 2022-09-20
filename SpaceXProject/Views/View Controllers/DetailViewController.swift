//
//  DetailViewController.swift
//  SpaceXProject
//
//  Created by  Vinni on 09/19/22.
//

import UIKit
import SDWebImage

class DetailViewController: UIViewController {
    
    static let nibName = "DetailViewController"
    
    private let noSelectionLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 25, weight: .semibold)
        label.text = "No Selection"
        return label
    }()
    
    @IBOutlet weak var missionImageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    private var missionImageUrl: String?
    private var missionName: String?
    private var missionIsLoaded = false
    
    private lazy var viewModel = MissionDetailViewModel(delegate: self)

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        reloadViews()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Mission Info"
        
        let nib = UINib(nibName: CollapsibleCell.identifier, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: CollapsibleCell.identifier)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        view.addSubview(noSelectionLabel)
        tableView.isHidden = true
        missionImageView.isHidden = true
        noSelectionLabel.isHidden = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        noSelectionLabel.frame = view.bounds
    }
    
    func setImage() {
        guard let urlString = missionImageUrl else {
            missionImageView.image = UIImage(named: "spaceXplaceholder")
            return
        }
        missionImageView.sd_setImage(with: URL(string: urlString))
    }
    
    func setMission(_ mission: Mission? = nil) {
        
        guard let mission = mission else {
            return
        }

        viewModel.setMission(mission)
        missionImageUrl = mission.links?.missionPatch
        missionName = mission.missionName?.formatAsTitle()
        missionIsLoaded = true
        
        if self.isViewLoaded {
            reloadViews()
        }
    }
    
    func reloadViews() {
        if missionIsLoaded {
            tableView.reloadData()
            setImage()
            tableView.isHidden = false
            missionImageView.isHidden = false
            noSelectionLabel.isHidden = true
        }
        
        else {
            tableView.isHidden = true
            missionImageView.isHidden = true
            noSelectionLabel.isHidden = false
        }
    }
}

extension DetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let missionName = missionName else { return "Info" }
        return "\(missionName) Info"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = viewModel.getDetailCount()
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CollapsibleCell.identifier, for: indexPath) as? CollapsibleCell else {
            return UITableViewCell()
        }
        
        cell.configureCell(tier: viewModel.getTierForRow(at: indexPath.row),
                           detailName: viewModel.getTitleForRow(at: indexPath.row),
                           detailValue: viewModel.getContentForRow(at: indexPath.row),
                           isExpandable: viewModel.cellIsExpandable(at: indexPath.row),
                           isExpanded: viewModel.cellIsExpanded(at: indexPath.row))
        
        return cell
    }
    
    // Drop down cells
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let cell = tableView.cellForRow(at: indexPath) as? CollapsibleCell else {
            return
        }
        
        if viewModel.cellIsExpandable(at: indexPath.row) {
            
            if viewModel.cellIsExpanded(at: indexPath.row) {
                viewModel.collapseAllChildRows(at: indexPath.row)
                cell.toggleExpandImage(isExpanded: false)
            }
            else {
                viewModel.expandRow(at: indexPath.row)
                cell.toggleExpandImage(isExpanded: true)
            }
        }
    }
}

extension DetailViewController: MissionDetailViewModelDelegate {
    
    func deleteRows(indexPaths: [IndexPath]) {
        tableView.beginUpdates()
        tableView.deleteRows(at: indexPaths, with: .fade)
        tableView.endUpdates()
    }
    
    func insertRows(indexPaths: [IndexPath]) {
        tableView.beginUpdates()
        tableView.insertRows(at: indexPaths, with: .automatic)
        tableView.endUpdates()
    }
}
