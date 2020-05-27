//
//  ViewController.swift
//  Color Picker
//
//  Created by Jordan Christensen on 5/26/20.
//  Copyright © 2020 Mazjap Co. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var starButton: UIButton!
    @IBOutlet private weak var hexColorTextField: UITextField!
    
    // MARK: - Lifecycle Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(starTapped(sender:)))
        let holdGesture = UILongPressGestureRecognizer(target: self, action: #selector(starHold(sender:)))
        tapGesture.numberOfTapsRequired = 1
        starButton.addGestureRecognizer(tapGesture)
        starButton.addGestureRecognizer(holdGesture)
        
        hexColorTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        updateBackground()
    }
    
    // MARK: - Public Functions
    
    func updateBackground(hex: String = "333333") {
        let str = hex.remove(char: "#".first!)
        guard str.isValidateHex else { return }
        
        hexColorTextField.text = "#\(str)"
        let color = UIColor(hex: str)
        UIView.animate(withDuration: hex == "333333" ? 0 : 0.5) {
            self.view.backgroundColor = color
        }
        
        setTextColor(using: color)
    }
    
    // MARK: - Private Functions
    
    private func setTextColor(using: UIColor) {
        UIView.animate(withDuration: 0.5) {
            self.hexColorTextField.textColor = using.textColor
        }
    }

    // MARK: - Objective-C Functions
    
    @objc
    private func starTapped(sender: UITapGestureRecognizer) {
        
    }
    
    @objc
    private func starHold(sender: UILongPressGestureRecognizer) {
        performSegue(withIdentifier: "ShowFavoritesSegue", sender: self)
    }
    
    @objc
    private func textFieldDidChange(_ textField: UITextField) {
        guard let text = textField.text else { return }
        updateBackground(hex: text)
    }
}

// MARK: - Extensions
