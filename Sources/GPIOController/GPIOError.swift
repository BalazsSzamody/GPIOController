//
//  File.swift
//  
//
//  Created by Balazs Szamody on 18/9/19.
//

import Foundation
import SwiftyGPIO

public enum GPIOError: Error {
    case notFound(GPIOName)
    
    var localizedDescription: String {
        switch self {
        case .notFound(let name):
            return "\(name.rawValue) GPIO not found"
        }
    }
}
