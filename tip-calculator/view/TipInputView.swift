//
//  TipInputView.swift
//  tip-calculator
//
//  Created by COMATOKI on 2023-08-16.
//

import Foundation
import UIKit

class TipInputView: UIView {
    init() {
        super.init(frame: .zero)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout() {
        backgroundColor = .red
    }
}
