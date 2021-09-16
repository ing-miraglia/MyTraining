//
//  ReusableView.swift
//  Cloudy
//
//  Created by Bart Jacobs on 15/05/2020.
//  Copyright © 2020 Cocoacasts. All rights reserved.
//

import UIKit

protocol ReusableView {

    static var reuseIdentifier: String { get }

}

extension ReusableView {

    static var reuseIdentifier: String {
        String(describing: self)
    }

}

extension UITableViewCell: ReusableView {}
