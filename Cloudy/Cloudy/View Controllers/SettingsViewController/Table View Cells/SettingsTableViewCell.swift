//
//  SettingsTableViewCell.swift
//  Cloudy
//
//  Created by Bart Jacobs on 03/10/16.
//  Copyright © 2016 Cocoacasts. All rights reserved.
//

import UIKit
import Combine

final class SettingsTableViewCell: UITableViewCell {

    // MARK: - Properties

    @IBOutlet private var mainLabel: UILabel!
    private var subscriptions: Set<AnyCancellable> = []
    // MARK: - Initialization

    override func awakeFromNib() {
        super.awakeFromNib()

        // Configure Cell
        selectionStyle = .none
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        subscriptions.removeAll()
    }

    // MARK: - Public API
    func bind(to presentablePublisher: AnyPublisher<SettingsPresentable,Never>) {
        presentablePublisher.sink { [weak self] presentable in
            self?.mainLabel.text = presentable.text
            self?.accessoryType = presentable.accessoryType
        }.store(in: &subscriptions)
    }
    
}
