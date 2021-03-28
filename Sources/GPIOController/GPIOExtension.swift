//
//  File.swift
//  
//
//  Created by Balazs Szamody on 22/9/19.
//

import Foundation
import SwiftyGPIO

public extension GPIO {
    enum State: Int {
        case off
        case on
    }
    func on() {
        value = 1
    }
    
    func off() {
        value = 0
    }
    
    func shouldBe(_ state: State, switch closure: ((State) -> Void)? = nil) {
        if state.rawValue != value {
            value = state.rawValue
            closure?(state)
        }
    }
    
    func on(for time: TimeInterval) {
        self.on()
        Thread.sleep(forTimeInterval: time)
        self.off()
    }
}

extension GPIO: Equatable {
    public static func == (lhs: GPIO, rhs: GPIO) -> Bool {
        return lhs.id == rhs.id
    }
}
