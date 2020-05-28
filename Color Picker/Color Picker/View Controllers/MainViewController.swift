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
    
    @IBOutlet private weak var starButton: UIButton!
    @IBOutlet private weak var hexColorTextField: UITextField!
    
    
    // MARK: - Lifecycle Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUp()
    }
    
    // MARK: - Public Functions
    
    func updateBackground(hex: String = "333333") {
        let str = hex.remove(char: "#".first!)
        guard str.isValidateHex else { return }
        
        hexColorTextField.text = "#\(str)"
        let color = UIColor(hex: str)
        UIView.animate(withDuration: hex == "333333" ? 0 : 0.5) {
            self.view.backgroundColor = color
            self.starButton.tintColor = color.textColor
        }
        
        setTextColor(using: color)
    }
    
    // MARK: - Private Functions
    
    private func setUp() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(starTapped(sender:)))
        let holdGesture = UILongPressGestureRecognizer(target: self, action: #selector(starHold(sender:)))
        tapGesture.numberOfTapsRequired = 1
        starButton.addGestureRecognizer(tapGesture)
        starButton.addGestureRecognizer(holdGesture)
        
        hexColorTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        updateBackground()
        
        starButton.tintColor = .white
        starButton.imageView?.contentMode = .scaleAspectFit
        updateStar()
    }
    
    private func setTextColor(using: UIColor) {
        UIView.animate(withDuration: 0.5) {
            self.hexColorTextField.textColor = using.textColor
        }
    }
    
    private func updateStar() {
        if let text = hexColorTextField.text {
            starButton.setImage(UIImage(systemName: isFav(hex: text) ? "star.fill" : "star"), for: .normal)
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

    // MARK: - Objective-C Functions
    
    @objc
    private func starTapped(sender: UITapGestureRecognizer) {
        guard let hex = hexColorTextField.text, hex.isValidateHex else { return } // TODO: - Alert user that hex is invalid
        colorController.add(name: "TEST", hex: hex.hexUInt)
        updateStar()
    }
    
    @objc
    private func starHold(sender: UILongPressGestureRecognizer) {
        performSegue(withIdentifier: "ShowFavoritesVCSegue", sender: self)
    }
    
    @objc
    private func textFieldDidChange(_ textField: UITextField) {
        guard let text = textField.text else { return }
        updateBackground(hex: text)
        updateStar()
    }
    
    // MARK: - Segues
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowFavoritesVCSegue" {
            guard let destinationVC = segue.destination as? FavoritesTableViewController else { return }
            destinationVC.delegate = self
            destinationVC.colorController = colorController
            destinationVC.color = view.backgroundColor
        }
    }
}

// MARK: - FavoriteColorDelegate Extension

extension MainViewController: FavoriteColorDelegate {
    func colorUpdated(hex: String) {
        updateBackground(hex: hex)
    }
}
