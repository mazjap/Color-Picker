//
//  MainViewController.swift
//  Color Picker
//
//  Created by Jordan Christensen on 5/26/20.
//  Copyright © 2020 Mazjap Co. All rights reserved.
//

import UIKit
import CoreData

class MainViewController: UIViewController, NSFetchedResultsControllerDelegate {
    
    // MARK: - Variables
    
    let colorController = ColorController()
    let cellSpacerHeight: CGFloat = 3
    var buttons = [UIButton]()
    var isCreatingColor: String? {
        didSet {
            updateCreatingColor()
        }
    }
    private lazy var frc: NSFetchedResultsController<Color>! = {
        let fetchRequest: NSFetchRequest<Color> = Color.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest,
                                             managedObjectContext: CoreDataStack.shared.mainContext,
                                             sectionNameKeyPath: nil,
                                             cacheName: nil)
        frc.delegate = self
        
        do {
            try frc.performFetch()
        } catch {
            fatalError("NSFetchedResultsController failed: \(error)")
        }
        
        NSLog("MainViewController: Colors fetched: \(String(describing: frc.fetchedObjects?.count))")
        return frc
    }()
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var hexColorTextField: UITextField!
    @IBOutlet private weak var imagesButton: UIButton!
    @IBOutlet private weak var starButton: UIButton!
    @IBOutlet private weak var hexColorTextField: UITextField!
    @IBOutlet weak var nameLabel: UILabel!
    
    
    // MARK: - Lifecycle Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUp()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updateStar()
    }
    
    // MARK: - Public Functions
    
    func updateBackground(hex: String = "333333") {
        let str = hex.remove(char: "#".first!)
        guard str.isValidateHex else { return }
        
        hexColorTextField.delegate = self
        hexColorTextField.text = "#\(str)"
        let color = UIColor(hex: str)
        nameLabel.textColor = color.textColor
        UIView.animate(withDuration: hex == "333333" ? 0 : 0.5) {
            self.view.backgroundColor = color
            self.starButton.tintColor = color.textColor
        }
        
        setTextColor(using: color)
    }
    
    // MARK: - Private Functions
    
    private func setUp() {
        let starTapGesture = UITapGestureRecognizer(target: self, action: #selector(starTapped(sender:)))
        let starHoldGesture = UILongPressGestureRecognizer(target: self, action: #selector(starHold(sender:)))
        starTapGesture.numberOfTapsRequired = 1
        starButton.addGestureRecognizer(starTapGesture)
        starButton.addGestureRecognizer(starHoldGesture)
        updateStar()
        
        let imageTapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped(sender:)))
        imagesButton.addGestureRecognizer(imageTapGesture)
        
        hexColorTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        updateBackground()
        
        nameLabel.isHidden = true
        buttons.append(contentsOf: [imagesButton, starButton])
        for button in buttons {
            button.tintColor = .white
            button.imageView?.contentMode = .scaleAspectFit
        }
    }
    
    private func setTextColor(using: UIColor) {
        UIView.animate(withDuration: 0.5) {
            self.hexColorTextField.textColor = using.textColor
        }
    }
    
    private func updateStar(bool: Bool? = nil) {
        if let text = hexColorTextField.text {
            let boolean = bool == nil ? isFav(hex: text) : bool!
            NSLog("MainViewController.updateStar boolean value: \(boolean)")
            starButton.setImage(UIImage(systemName: boolean ? "star.fill" : "star"), for: .normal)
        }
    }
    
    private func isFav(hex: String) -> Bool {
        guard let colors = frc.fetchedObjects else { return false }
        for color in colors {
            if hex.hexUInt == UInt32(color.hex) {
                return true
            }
        }
        
        return false
    }
    
    private func updateCreatingColor() {
        if let _ = isCreatingColor {
            nameLabel.isHidden = false
            hexColorTextField.text = ""
            hexColorTextField.placeholder = "Name"
        } else {
            nameLabel.isHidden = true
            hexColorTextField.placeholder = "#333333"
        }
    }

    // MARK: - Objective-C Functions
    
    @objc
    private func starTapped(sender: UITapGestureRecognizer) {
        guard let hex = hexColorTextField.text, hex.isValidateHex else { return } // TODO: - Alert user that hex is invalid
        updateStar()
        isCreatingColor = hex
    }
    
    @objc
    private func starHold(sender: UILongPressGestureRecognizer) {
        performSegue(withIdentifier: "ShowFavoritesVCSegue", sender: self)
    }
    
    @objc
    private func imageTapped(sender: UITapGestureRecognizer) {
        performSegue(withIdentifier: "ShowImageVCSegue", sender: self)
    }
    
    @objc
    private func textFieldDidChange(_ textField: UITextField) {
        guard let text = textField.text else { return }
        if isCreatingColor == nil {
            updateBackground(hex: text)
            updateStar()
            
            if !text.isValidateHex {
                textField.text = "#"
            }
        }
    }
    
    // MARK: - Segues
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowFavoritesVCSegue" {
            guard let destinationVC = segue.destination as? FavoritesTableViewController else { return }
            destinationVC.delegate = self
            destinationVC.colorController = colorController
            destinationVC.color = view.backgroundColor
        } else if segue.identifier == "ShowImageVCSegue" {
            guard let destinationVC = segue.destination as? ImageViewController else { return }
            destinationVC.viewDidLoad()
        }
    }
}

// MARK: - FavoriteColorDelegate Extension

extension MainViewController: FavoriteColorDelegate {
    func colorUpdated(hex: String) {
        updateBackground(hex: hex)
    }
}

// MARK: - UITextFieldDelegate Extension

extension MainViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        starButton.isHidden = false
        guard let hex = isCreatingColor, let text = hexColorTextField.text, !text.isEmpty else { return }
        colorController.add(name: text, hex: hex.hexUInt)
        isCreatingColor = nil
        updateStar(bool: true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        starButton.isHidden = true
    }
}
