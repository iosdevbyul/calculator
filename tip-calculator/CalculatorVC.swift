//
//  ViewController.swift
//  tip-calculator
//
//  Created by COMATOKI on 2023-08-16.
//

import UIKit
import SnapKit
import Combine

class CalculatorVC: UIViewController {
    
    private let logoView = LogoView()
    private let resultView = ResultView()
    private let billnputView = BillInputView()
    private let tipInputView = TipInputView()
    private let spliteInputView = SpliteInputView()
    
    private let vm = CalculatorVM()
    private var cancellables = Set<AnyCancellable>()
    
    private lazy var vStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            logoView,
            resultView,
            billnputView,
            tipInputView,
            spliteInputView,
            UIView()
        ])
        stackView.axis = .vertical
        stackView.spacing = 36
        return stackView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        layout()
        bind()
        
    }
    
    private func bind() {
        let input = CalculatorVM.Input(
            billPublisher: billnputView.valuePublisher,
            tipPublisher: tipInputView.valuePublisher,
            splitPublisher: spliteInputView.valuePublisher)

        let output = vm.transform(input: input)
        output.updateViewPublisher.sink { [unowned self] result in
            resultView.configure(result: result)
        }.store(in: &cancellables)
    }
    
    private func layout() {
        view.backgroundColor = ThemeColor.bg
        view.addSubview(vStackView)
        vStackView.snp.makeConstraints { make in
            make.leading.equalTo(view.snp.leadingMargin).offset(16)
            make.trailing.equalTo(view.snp.trailingMargin).offset(-16)
            make.bottom.equalTo(view.snp.bottomMargin).offset(-16)
            make.top.equalTo(view.snp.topMargin).offset(16)
        }
        
        logoView.snp.makeConstraints { make in
            make.height.equalTo(48)
        }
        
        resultView.snp.makeConstraints { make in
            make.height.equalTo(224)
        }
        
        billnputView.snp.makeConstraints { make in
            make.height.equalTo(56)
        }
        
        tipInputView.snp.makeConstraints { make in
            make.height.equalTo(56 + 56 + 15)
        }
        
        spliteInputView.snp.makeConstraints { make in
            make.height.equalTo(56)
        }
    }


}



