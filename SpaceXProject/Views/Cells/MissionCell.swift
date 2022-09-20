//
//  MissionCell.swift
//  SpaceXProject
//
//  Created by  Vinni on 09/19/22.
//

import UIKit
import SDWebImage

class MissionCell: UITableViewCell {
    
    static let identifier = "MissionCell"
    
    @IBOutlet weak var missionImageView: UIImageView!
    
    @IBOutlet weak var missionLabel: UILabel!
    
    @IBOutlet weak var rocketLabel: UILabel!
    
    @IBOutlet weak var launchLabel: UILabel!
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.style = .medium
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        missionImageView.addSubview(activityIndicator)
        activityIndicator.frame = missionImageView.bounds
        activityIndicator.startAnimating()
    }

    func configureCell(missionImage: String, missionName: String, rocketName: String, launchSiteAndDate: String) {
        if let url = URL(string: missionImage) {
            missionImageView.sd_setImage(with: url) { [weak self] _,_,_,_ in
                self?.activityIndicator.stopAnimating()
            }
        } else {
            missionImageView.image = UIImage(named: "spaceXplaceholder")
            activityIndicator.stopAnimating()
        }
        
        missionLabel.text = missionName
        rocketLabel.text = rocketName
        launchLabel.text = launchSiteAndDate
    }
}
