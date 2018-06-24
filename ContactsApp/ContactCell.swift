//
//  ContactCell.swift
//  ContactsApp
//
//  Created by Admin on 6/24/18.
//  Copyright © 2018 Serhii. All rights reserved.
//

import UIKit

protocol ContactCellDelegate {
    func starButtonPressed(cell: UITableViewCell)
}

class ContactCell: UITableViewCell {

    var delegate: ContactCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let starButton = UIButton(type: .system)
        starButton.setImage(#imageLiteral(resourceName: "Star"), for: .normal)
        starButton.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        starButton.tintColor = .red
        starButton.addTarget(self, action: #selector(handleMarkAsFavorite), for: .touchUpInside)
        accessoryView = starButton
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @objc private func handleMarkAsFavorite() {
        delegate?.starButtonPressed(cell: self)
    }
    
}
