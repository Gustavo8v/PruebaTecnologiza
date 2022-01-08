//
//  StringExtension.swift
//  PruebaTecnologiza
//
//  Created by Gustavo on 07/01/22.
//

import Foundation

extension String {
    
    enum ValidateType {
        case email
    }
    
    enum Regex: String {
        case email = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9-]+\\.[A-Za-z]{2,64}"
    }
    
    func isValida(_ validityType: ValidateType) -> Bool {
        let format = "SELF MATCHES %@"
        var regex = ""
        switch validityType {
        case .email:
            regex = Regex.email.rawValue
        }
        return NSPredicate(format: format, regex).evaluate(with: self)
    }
}
