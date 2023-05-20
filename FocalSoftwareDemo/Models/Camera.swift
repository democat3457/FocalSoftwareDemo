//
//  Camera.swift
//  FocalSoftwareDemo
//
//  Created by Colin Wong on 5/19/23.
//

import Foundation
import AVFoundation

struct Camera {
    var captureSession = AVCaptureSession()
    
    var deviceInput: AVCaptureDeviceInput? {
        captureSession.inputs.last as? AVCaptureDeviceInput
    }
    
    var captureDevice: AVCaptureDevice? {
        deviceInput?.device
    }
    
    var minMaxISO: (minISO: Float, maxISO: Float)? {
        let format = captureDevice?.activeFormat
        return format == nil ? nil : (format!.minISO, format!.maxISO)
    }
}
