//
//  CalculatorVM.swift
//  tip-calculator
//
//  Created by COMATOKI on 2023-08-30.
//

import Foundation
import Combine

class CalculatorVM {
    private var cancellables = Set<AnyCancellable>()
    struct Input {
        let billPublisher: AnyPublisher<Double, Never>
        let tipPublisher: AnyPublisher<Tip, Never>
        let splitPublisher: AnyPublisher<Int, Never>
    }
    
    struct Output {
        let updateViewPublisher: AnyPublisher<Result, Never>
    }
    
    func transform(input: Input) -> Output {
        
        input.tipPublisher.sink { tip in
            print("The tip: \(tip)")
        }.store(in: &cancellables)
        
        input.billPublisher.sink { bill in
            print("the bill: \(bill)")
        }.store(in: &cancellables)
        
        let result = Result(amountPerPerson: 500, totalBill: 1000, totalTip: 50.0)
        return Output(updateViewPublisher: Just(result).eraseToAnyPublisher())
    }
    
}
