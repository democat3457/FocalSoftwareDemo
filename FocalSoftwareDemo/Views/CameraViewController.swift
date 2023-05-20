//
//  CameraViewController.swift
//  FocalSoftwareDemo
//
//  Created by Colin Wong on 5/19/23.
//

import Foundation
import AVFoundation
import UIKit
import SwiftUI

final class CameraViewController: UIViewController {
    var viewModel: ContentViewModel!
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    
    init(_ viewModel: ContentViewModel) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
        self.captureSession = viewModel.camera.captureSession
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private let sessionQueue = DispatchQueue(label: "session queue")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemTeal
        view.bounds.size.height = 400
        
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        let videoInput: AVCaptureDeviceInput
        
        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return
        }
        
        if captureSession.canAddInput(videoInput) {
            captureSession.addInput(videoInput)
        } else {
            return
        }
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        
        // filter does not work :(
        if let filter = CIFilter(name: "CIPointillize",
                                 parameters: ["inputRadius": 6]) {
            previewLayer.filters = [filter]
        } else {
            print("Filter could not be added.")
        }
        
        previewLayer.frame = view.layer.bounds//.applying(.init(scaleX: 1, y: 0.5))
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)
        
        sessionQueue.async {
            self.captureSession.startRunning()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if captureSession?.isRunning == false {
            sessionQueue.async {
                self.captureSession.startRunning()
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if captureSession?.isRunning == true {
            captureSession.stopRunning()
        }
    }
    
    override var prefersStatusBarHidden: Bool { true }
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask { .portrait }
}

struct CameraView: UIViewControllerRepresentable {
    
    @EnvironmentObject var viewModel: ContentViewModel
    
    public typealias UIViewControllerType = CameraViewController
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<CameraView>) -> CameraViewController {
        CameraViewController(viewModel)
    }
    
    func updateUIViewController(_ uiViewController: CameraViewController, context: UIViewControllerRepresentableContext<CameraView>) {
    }
}
