//
//  ViewController.swift
//  tip-calculator
//
//  Created by COMATOKI on 2023-08-16.
//

import UIKit
import SnapKit
import Combine
import CombineCocoa

class CalculatorVC: UIViewController {
    
    private let logoView = LogoView()
    private let resultView = ResultView()
    private let billnputView = BillInputView()
    private let tipInputView = TipInputView()
    private let spliteInputView = SpliteInputView()
    
    private let vm = CalculatorVM()
    private var cancellables = Set<AnyCancellable>()
    
    private lazy var viewTapPublisher: AnyPublisher<Void, Never> = {
        let tapGesture = UITapGestureRecognizer(target: self, action: nil)
        view.addGestureRecognizer(tapGesture)
        return tapGesture.tapPublisher.flatMap { _ in
            Just(())
        }.eraseToAnyPublisher()
    }()
    
    private lazy var logoviewTapPublisher: AnyPublisher<Void, Never> = {
        let tapGesture = UITapGestureRecognizer(target: self, action: nil)
        tapGesture.numberOfTapsRequired = 2
        logoView.addGestureRecognizer(tapGesture)
        return tapGesture.tapPublisher.flatMap { _ in
            Just(())
        }.eraseToAnyPublisher()
    }()
    
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
        observe()
    }
    
    private func bind() {
        let input = CalculatorVM.Input(
            billPublisher: billnputView.valuePublisher,
            tipPublisher: tipInputView.valuePublisher,
            splitPublisher: spliteInputView.valuePublisher,
            logoviewTapPublisher : logoviewTapPublisher)

        let output = vm.transform(input: input)
        output.updateViewPublisher.sink { [unowned self] result in
            resultView.configure(result: result)
        }.store(in: &cancellables)
        output.resetCalculatorPublisher.sink { [unowned self] _ in
            billnputView.reset()
            tipInputView.reset()
            spliteInputView.reset()
            
            UIView.animate(withDuration: 0.1, delay: 0, usingSpringWithDamping: 5.0, initialSpringVelocity: 0.5, options: .curveEaseInOut) {
                self.logoView.transform = .init(scaleX: 1.5, y: 1.5)
            } completion: { _ in
                UIView.animate(withDuration: 0.1) {
                    self.logoView.transform = .identity
                }
            }
        }.store(in: &cancellables)
    }
    
    private func observe() {
        viewTapPublisher.sink { _ in
            self.view.endEditing(true)
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



