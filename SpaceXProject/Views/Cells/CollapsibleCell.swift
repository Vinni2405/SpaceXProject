//
//  CollapsibleCell.swift
//  SpaceXProject
//
//  Created by  Vinni on 09/19/22.
//

import UIKit

class CollapsibleCell: UITableViewCell {
    
    static let identifier = "CollapsibleCell"
    
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var expandImageView: UIImageView!
    @IBOutlet weak var leadingConstraint: NSLayoutConstraint!

    override func prepareForReuse() {
        super.prepareForReuse()
        leadingConstraint.constant = 0
        expandImageView.image = nil
    }
    
    func toggleExpandImage(isExpanded: Bool) {
        if isExpanded {
            expandImageView.image = UIImage(systemName: "minus")
        }
        else {
            expandImageView.image = UIImage(systemName: "plus")
        }
    }
    
    func configureCell(tier: Int, detailName: String, detailValue: String, isExpandable: Bool, isExpanded: Bool) {
        
        leadingConstraint.constant += CGFloat(tier*12)
        
        detailLabel.text = detailName
        detailLabel.textColor = tier == 1 ? .link : .darkGray
        detailLabel.font = tier == 1 ? .systemFont(ofSize: 17, weight: .semibold) : .systemFont(ofSize: 17, weight: .medium)
        
        valueLabel.text = detailValue
        valueLabel.textColor = .darkText
        
        if isExpandable {
            toggleExpandImage(isExpanded: isExpanded)
        }
        
        contentView.updateConstraintsIfNeeded()
    }
}
