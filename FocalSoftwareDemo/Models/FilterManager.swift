//
//  FilterManager.swift
//  FocalSoftwareDemo
//
//  Created by Colin Wong on 5/19/23.
//

import Foundation

struct FilterManager {
    
    var autoFocus = true {
        willSet {
            print("Autofocus changed to \(newValue)")
        }
    }
    
    var autoTint = true {
        willSet {
            print("Autotint changed to \(newValue)")
        }
    }
    
    var focusValue: Float = 0.3 {
        willSet {
            print("Focus changed to \(newValue)")
        }
    }
    
    var exposureValue: Float = 1.0 {
        willSet {
            print("Exposure changed to \(newValue)")
        }
    }
}
