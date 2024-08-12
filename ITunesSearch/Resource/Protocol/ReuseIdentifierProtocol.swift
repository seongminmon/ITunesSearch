//
//  ReuseIdentifierProtocol.swift
//  ITunesSearch
//
//  Created by 김성민 on 8/12/24.
//

import UIKit

protocol ReuseIdentifierProtocol {
    static var identifier: String { get }
}

extension UITableViewCell: ReuseIdentifierProtocol {
    static var identifier: String {
        return String(describing: self)
    }
}
