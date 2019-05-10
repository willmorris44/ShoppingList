//
//  ButtonTableViewCell.swift
//  ShoppingList
//
//  Created by Will morris on 5/10/19.
//  Copyright © 2019 devmtn. All rights reserved.
//

import UIKit

protocol ButtonTableViewCellDelegate: class {
    func buttonCellButtonTapped(_ sender: ButtonTableViewCell)
}

class ButtonTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var isCompleteButton: UIButton!
    
    weak var delegate: ButtonTableViewCellDelegate?
    
    @IBAction func isCompleteButtonTapped(_ sender: Any) {
        delegate?.buttonCellButtonTapped(self)
    }
    
    func updateButton(_ isComplete: Bool) {
        
        // Set the image for the button
        let image = isComplete ? "complete" : "incomplete"
        isCompleteButton.setImage(UIImage(named: image), for: .normal)
    }
}

extension ButtonTableViewCell {
    
    func update(item: Item) {
        
        // Update cell contents
        nameLabel.text = item.name
        updateButton(item.isComplete)
    }
    
}
