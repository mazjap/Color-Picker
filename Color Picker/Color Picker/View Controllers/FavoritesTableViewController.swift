//
//  FavoritesTableViewController.swift
//  Color Picker
//
//  Created by Jordan Christensen on 5/27/20.
//  Copyright © 2020 Mazjap Co. All rights reserved.
//

import UIKit
import CoreData

protocol FavoriteColorDelegate: AnyObject {
    func colorUpdated(hex: String)
}

class FavoritesTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - Variables
    
    var colorController: ColorController?
    var color: UIColor? {
        didSet {
            update()
        }
    }
    weak var delegate: FavoriteColorDelegate?
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
        
        NSLog("FavoritesTableViewController: Colors fetched: \(String(describing: frc.fetchedObjects?.count))")
        return frc
    }()
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    
    // MARK: - Lifecycle Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUp()
    }
    
    // MARK: - Private Functions
    
    private func setUp() {
        tableView.rowHeight = 60
        tableView.tableFooterView = UIView()
        update()
    }
    
    private func update() {
        guard let color = color else { return }
        view.backgroundColor = color
        tableView.backgroundColor = color
        titleLabel.textColor = color.textColor
        backButton.tintColor = color.textColor
    }
    
    private func popVC() {
        navigationController?.popViewController(animated: false)
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - TableView Functions
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return frc.fetchedObjects?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FavoriteCell", for: indexPath) as? FavoriteTableViewCell, let colorObj = frc.fetchedObjects?[indexPath.row] else { return UITableViewCell() }
        cell.color = colorObj
        cell.backgroundColor = color
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let color = (tableView.cellForRow(at: indexPath) as? FavoriteTableViewCell)?.color else { return }
        delegate?.colorUpdated(hex: color.hexString)
        popVC()
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let color = (tableView.cellForRow(at: indexPath) as? FavoriteTableViewCell)?.color else { return }
            colorController?.delete(color: color)
        }
    }
    
    // MARK: - IBActions
    
    @IBAction func backPressed(_ sender: UIButton) {
        popVC()

    }
}

// MARK: - NSFetchedResultsControllerDelegate

extension FavoritesTableViewController: NSFetchedResultsControllerDelegate {
    
    internal func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    internal func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    internal func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange sectionInfo: NSFetchedResultsSectionInfo,
                    atSectionIndex sectionIndex: Int,
                    for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            tableView.insertSections(IndexSet(integer: sectionIndex), with: .automatic)
        case .delete:
            tableView.deleteSections(IndexSet(integer: sectionIndex), with: .automatic)
        default:
            break
        }
    }
    
    internal func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            guard let newIndexPath = newIndexPath else { return }
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        case .update:
            guard let indexPath = indexPath else { return }
            tableView.reloadRows(at: [indexPath], with: .automatic)
        case .move:
            guard let oldIndexPath = indexPath,
                let newIndexPath = newIndexPath else { return }
            tableView.deleteRows(at: [oldIndexPath], with: .automatic)
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        case .delete:
            guard let indexPath = indexPath else { return }
            tableView.deleteRows(at: [indexPath], with: .automatic)
        @unknown default:
            fatalError("Unknown Change Type occured")
        }
    }
}
