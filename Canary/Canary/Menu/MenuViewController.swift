//
//  MenuViewController.swift
//
//  Copyright 2018-2021 Twitter, Inc.
//  Licensed under the MoPub SDK License Agreement
//  http://www.mopub.com/legal/sdk-license-agreement/
//

import UIKit
import MoPubSDK

class MenuViewController: UIViewController {
    // MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var sdkVersionLabel: UILabel!
    
    // MARK: - Properties
    
    fileprivate let dataSource: MenuDataSource = MenuDataSource()
    
    fileprivate var notificationToken: NSObjectProtocol?
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Make the background of the table transparent
        tableView.backgroundView = nil
        tableView.backgroundColor = .clear
        
        // Clear out empty cells by added an empty footer to the table.
        tableView.tableFooterView = UIView()
        
        // Populate the SDK version label
        sdkVersionLabel.text = "SDK version \(MoPub.sharedInstance().version())"
        
        // Reload table view when rotating device
        notificationToken = NotificationCenter.default.addObserver(forName: UIDevice.orientationDidChangeNotification, object: nil, queue: OperationQueue.main) { [weak self] (notification) in
            self?.tableView.reloadData()
        }
    }
    
    deinit {
        guard let notificationToken = notificationToken else { return }
        NotificationCenter.default.removeObserver(notificationToken)
    }
    
    // MARK: - Data Source
    
    /**
     Adds a new menu and its associated data source if it doesn't already exist.
     - Parameter menu: Menu item to add.
     */
    func add(menu: MenuDisplayable) {
        dataSource.add(menu: menu)
    }
    
    /**
     Updates the data source if needed.
     */
    func updateIfNeeded() {
        if dataSource.updateIfNeeded() {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
}

extension MenuViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource.sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.items(forSection: section)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = .clear
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return dataSource.cell(forIndexPath: indexPath, inTableView: tableView)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return dataSource.sections[section]
    }
}

extension MenuViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        let canSelectRow: Bool = dataSource.canSelect(itemAtIndexPath: indexPath, inTableView: tableView)
        return (canSelectRow ? indexPath : nil)
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        defer {
            // Always deselect the row
            tableView.deselectRow(at: indexPath, animated: true)
        }
        
        // If the menu item was successfully selected, close the menu after presentation
        if let containerViewController = containerViewController,
            let presentingController = containerViewController.mainTabBarController {
            let shouldCloseMenu: Bool = dataSource.didSelect(itemAtIndexPath: indexPath, inTableView: tableView, presentingFrom: presentingController)
            if shouldCloseMenu {
                containerViewController.closeMenu()
            }
        }
    }
}
