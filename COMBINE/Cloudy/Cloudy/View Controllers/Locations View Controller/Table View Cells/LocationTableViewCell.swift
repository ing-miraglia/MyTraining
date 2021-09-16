//
//  LocationTableViewCell.swift
//  Cloudy
//
//  Created by Bart Jacobs on 10/07/2017.
//  Copyright © 2017 Cocoacasts. All rights reserved.
//

import UIKit

final class LocationTableViewCell: UITableViewCell {

    // MARK: - Properties

    @IBOutlet private var mainLabel: UILabel!

    // MARK: - Configuration

    func configure(with title: String) {
        mainLabel.text = title
    }
    
    func configure(with presentable: LocationPresentable) {
        mainLabel.text = presentable.text
    }

}
