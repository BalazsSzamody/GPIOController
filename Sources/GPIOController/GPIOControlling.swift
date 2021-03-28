//
//  GPIOControlling.swift
//  
//
//  Created by Balazs Szamody on 18/9/19.
//

import Foundation
import SwiftyGPIO

public protocol GPIOControlling {
    func main() -> (() throws -> Void)
}

extension GPIOControlling {
    
    public func run() {
        do {
            try main()()
        } catch {
            print(error)
        }
    }
    
    public static func setup(_ name: GPIOName = .P25, for direction: GPIODirection = .OUT) throws -> GPIO {
        let gpios = SwiftyGPIO.GPIOs(for: .RaspberryPiPlusZero)
        guard let myGpio = gpios[name] else {
            throw GPIOError.notFound(name)
        }
        myGpio.direction = direction
        return myGpio
    }
    
    public func switcher(_ gp: GPIO, closure: @escaping (Bool) -> Void) throws {
        closure(gp.value == 0)
        gp.onFalling { (_) in
            closure(false)
        }
        
        gp.onRaising { (_) in
            closure(true)
        }
    }
    
    public func blink(_ gp: GPIO, with timeInterval: TimeInterval = 0.5) {
        gp.value = 1
        Thread.sleep(forTimeInterval: timeInterval)
        gp.value = 0
        Thread.sleep(forTimeInterval: timeInterval)
    }
    
    public func deadline(_ semaphore: Semaphore? = nil, time timeInterval: TimeInterval? = nil, cleanUp closure: (() -> Void)? = nil) {
        let defaultSemaphore = Semaphore()
        let endSemaphore = semaphore ?? defaultSemaphore
        
        let deadmanSwitch = GPIO(name: "P2", id: 2)
        deadmanSwitch.direction = .IN
        
        deadmanSwitch.onRaising { (_) in
            defaultSemaphore.isOn = false
        }
        
        if let timeInterval = timeInterval {
            DispatchQueue.global().asyncAfter(deadline: .now() + timeInterval) {
                endSemaphore.isOn.toggle()
            }
        }
        
        while endSemaphore.isOn {
            
        }
        closure?()
    }
}
