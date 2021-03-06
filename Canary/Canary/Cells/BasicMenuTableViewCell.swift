//
//  BasicMenuTableViewCell.swift
//
//  Copyright 2018-2021 Twitter, Inc.
//  Licensed under the MoPub SDK License Agreement
//  http://www.mopub.com/legal/sdk-license-agreement/
//

import UIKit

final class BasicMenuTableViewCell: UITableViewCell, TableViewCellRegisterable {
    @IBOutlet weak var title: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        // Clean up accessoryType
        accessoryType = .none
        
        // Clean up accessibilityIdentifier
        accessibilityIdentifier = nil
        
        // Clean up accessibilityValue
        accessibilityValue = nil
    }
}
