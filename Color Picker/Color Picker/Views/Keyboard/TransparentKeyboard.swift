//
//  TransparentKeyboard.swift
//  Color Picker
//
//  Created by Jordan Christensen on 5/28/20.
//  Copyright © 2020 Mazjap Co. All rights reserved.
//

import UIKit

protocol KeyboardDelegate: AnyObject {
    func charPressed(key: String)
    func backspace()
}

class TransparentKeyboard: UIView {
    
    weak var delegate: KeyboardDelegate?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let top = ["q", "w", "e", "r", "t", "y", "u", "i", "o", "p"]
        let mid = ["a", "s", "d", "f", "g", "h", "j", "k", "l"]
        let bot = ["z","x","c","v","b","n","m"]
        
        let extra = [KeyboardLetter]()
        
        let rows = [UIStackView(arrangedSubviews: createViewArrays(from: top)), UIStackView(arrangedSubviews: createViewArrays(from: mid)),
                    UIStackView(arrangedSubviews: createViewArrays(from: bot)), UIStackView(arrangedSubviews: extra)]
        
        for row in rows {
            row.axis = .horizontal
        }
        
        let vStack = UIStackView(arrangedSubviews: rows)
        vStack.axis = .vertical
        
        addSubview(vStack)
        
        vStack.translatesAutoresizingMaskIntoConstraints = false
        vStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10).isActive = true
        vStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 10).isActive = true
        vStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0).isActive = true
        
    }
    
    
    private func createViewArrays(from arr: [String]) -> [KeyboardLetter] {
        var temp = [KeyboardLetter]()
        
        for str in arr {
            temp.append(KeyboardLetter(letter: str) {
                self.delegate?.charPressed(key: str)
            })
        }
        
        return temp
    }
}
