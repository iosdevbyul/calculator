//
//  UIResponder+Extension.swift
//  tip-calculator
//
//  Created by COMATOKI on 2023-09-11.
//

import Foundation
import UIKit

extension UIResponder {
    var parentViewController: UIViewController? {
        return next as? UIViewController ?? next?.parentViewController
    }
}
