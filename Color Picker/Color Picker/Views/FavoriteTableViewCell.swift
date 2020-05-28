//
//  FavoriteTableViewCell.swift
//  Color Picker
//
//  Created by Jordan Christensen on 5/27/20.
//  Copyright © 2020 Mazjap Co. All rights reserved.
//

import UIKit

class FavoriteTableViewCell: UITableViewCell {
    var color: Color? {
        didSet {
            setUp()
        }
    }
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var hexLabel: UILabel!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.layer.cornerRadius = 12
        contentView.layer.borderColor = color?.color.textColor.cgColor
        contentView.layer.borderWidth = 3
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 3, left: 10, bottom: 3, right: 10))
    }
    
    private func setUp() {
        guard let color = color else { return }
        contentView.backgroundColor = color.color
        titleLabel.textColor = color.color.textColor
        hexLabel.textColor = color.color.textColor
        
        titleLabel.text = color.name
        hexLabel.text = "#\(color.hexString)"
    }
}
