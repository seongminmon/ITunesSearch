//
//  UIViewController+.swift
//  ITunesSearch
//
//  Created by 김성민 on 8/8/24.
//

import UIKit
import Toast

extension UIViewController {
    
    func showFailureToast(_ message: String?) {
        view.makeToast(message, duration: 1, position: .center)
    }
    
    func showLoadingToast() {
        view.makeToastActivity(.center)
    }
    
    func hideToast() {
        view.hideToastActivity()
    }
}
