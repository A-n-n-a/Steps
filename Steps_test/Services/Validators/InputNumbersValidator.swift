//
//  InputNumbersValidator.swift
//  Steps_test
//
//  Created by Anna on 9/19/21.
//

import Foundation

enum NumbersValidationResult {
    case notNumbers
    case over500
    case equal
    case firstNumberIsGreater
    case valid
    
    var errorText: String? {
        switch self {
        case .notNumbers:
            return "Wrong input format"
        case .over500:
            return "Second value should be less or equal 500"
        case .equal:
            return "Values should not be equal"
        case .firstNumberIsGreater:
            return "Second value should be greater than the first one."
        case .valid:
            return nil
        }
    }
}

class InputNumbersValidator {
    
    static func validateNumbers(first: Int, second: Int) -> NumbersValidationResult {
        
        if second > 500 {
            return .over500
        }
        
        if first == second {
            return .equal
        }
        
        if first > second {
            return .firstNumberIsGreater
        }
        
        return .valid
    }
}
