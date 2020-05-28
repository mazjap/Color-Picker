//
//  KeyboardLetter.swift
//  Color Picker
//
//  Created by Jordan Christensen on 5/28/20.
//  Copyright © 2020 Mazjap Co. All rights reserved.
//

import UIKit

class KeyboardLetter: UIView {
    let letterLabel = UILabel()
    let action: () -> Void
    
    override func layoutSubviews() {
        letterLabel.translatesAutoresizingMaskIntoConstraints = false
        letterLabel.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        letterLabel.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        letterLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
    init(letter: String, action: @escaping () -> Void) {
        self.action = action
        super.init(frame: CGRect(origin: .zero, size: CGSize(width: 20, height: 40)))
        addSubview(letterLabel)
        letterLabel.text = letter
    }
    
    required init?(coder: NSCoder) {
        self.action = {}
        super.init(coder: coder)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        action()
    }
}
