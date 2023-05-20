//
//  ContentViewModel.swift
//  FocalSoftwareDemo
//
//  Created by Colin Wong on 5/19/23.
//

import Foundation
import CoreMedia

class ContentViewModel: ObservableObject {
    @Published var filterManager = FilterManager()
    @Published var camera = Camera()
    
    var isoAsSliderRange: (lower: Float, upper: Float) {
        (lower: camera.minMaxISO?.minISO ?? 0.1, upper: camera.minMaxISO?.maxISO ?? 1.0)
    }
    
    var exposureLogarithmic: Float {
        get {
            log2(filterManager.exposureValue)
        }
        set {
            filterManager.exposureValue = pow(2, newValue)
        }
    }
    
    var autofocus: Bool {
        get {
            filterManager.autoFocus
        }
        set {
            filterManager.autoFocus = newValue
            enableAutofocus(newValue)
        }
    }
    
    var autotint: Bool {
        get {
            filterManager.autoTint
        }
        set {
            filterManager.autoTint = newValue
            enableAutotint(newValue)
        }
    }
    
    var manualFocus: Float {
        get {
            filterManager.focusValue
        }
        set {
            if !filterManager.autoFocus {
                filterManager.focusValue = newValue
            }
        }
    }
    
    var manualExposure: Float {
        get {
            exposureLogarithmic
        }
        set {
            if !filterManager.autoTint {
                exposureLogarithmic = newValue
            }
        }
    }
    
    private let autoUpdateQueue = DispatchQueue(label: "autoupdate queue")
    
    init(filterManager: FilterManager = FilterManager(), camera: Camera = Camera()) {
        self.filterManager = filterManager
        self.camera = camera
        
        autoUpdateQueue.async {
            while true {
                if self.autofocus {
                    self.updateFocus(to: self.camera.captureDevice?.lensPosition)
                }
                if self.autotint {
                    self.updateExposure(to: self.camera.captureDevice?.iso)
                }
                Thread.sleep(forTimeInterval: 0.1)
            }
        }
    }
    
    func changeFocus() {
        if let device = camera.captureDevice {
            do {
                try device.lockForConfiguration()
                device.setFocusModeLocked(lensPosition: min(max(filterManager.focusValue, 0), 1))
                
                device.unlockForConfiguration()
            } catch { }
        }
    }
    
    func changeExposure() {
        if let device = camera.captureDevice {
            do {
                try device.lockForConfiguration()
                
                device.setExposureModeCustom(duration: device.exposureDuration, iso: min(max(filterManager.exposureValue, device.activeFormat.minISO), device.activeFormat.maxISO))
                
                device.unlockForConfiguration()
            } catch { }
        }
    }
    
    func enableAutofocus(_ enable: Bool) {
        if let device = camera.captureDevice {
            do {
                try device.lockForConfiguration()
                device.focusMode = enable ? .continuousAutoFocus : .locked
                
                device.unlockForConfiguration()
            } catch { }
        }
    }
    
    func enableAutotint(_ enable: Bool) {
        if let device = camera.captureDevice {
            do {
                try device.lockForConfiguration()
                device.exposureMode = enable ? .continuousAutoExposure : .locked
                
                device.unlockForConfiguration()
            } catch { }
        }
    }
    
    func updateFocus(to value: Float?) {
        if let _ = value {
            filterManager.focusValue = value!
        }
    }
    
    func updateExposure(to value: Float?) {
        if let _ = value {
            filterManager.exposureValue = value!
        }
    }
}
