//
//  ContentView.swift
//  FocalSoftwareDemo
//
//  Created by Colin Wong on 5/19/23.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var viewModel = ContentViewModel()
    
    var body: some View {
        ZStack {
            AppColors.main.ignoresSafeArea()
            VStack {
                Spacer()
                Text("hello")
                    .bold()
                CameraView()
                    .background(.brown)
                Slider(value: $viewModel.manualFocus, in: 0...1, step: 0.05, label: {Text("Focus Amount")}, minimumValueLabel: {Text("0%")}, maximumValueLabel: {Text("100%")}, onEditingChanged: { editing in
                    if !viewModel.filterManager.autoFocus {
                        viewModel.changeFocus()
                    }
                    })
                Text("Focus Amount: \(viewModel.filterManager.focusValue)")
                Slider(value: $viewModel.manualExposure, in: ClosedRange(uncheckedBounds: (lower: log2(viewModel.isoAsSliderRange.lower), upper: log2(viewModel.isoAsSliderRange.upper))), label: {Text("Exposure (ISO)")}, minimumValueLabel: {Text("\(viewModel.isoAsSliderRange.lower)")}, maximumValueLabel: {Text("\(viewModel.isoAsSliderRange.upper)")}, onEditingChanged: { editing in
                    if !viewModel.filterManager.autoTint {
                        viewModel.changeExposure()
                    }
                    })
                Text("Exposure (ISO): \(viewModel.filterManager.exposureValue)")
                Toggle("Auto-focus", isOn: $viewModel.autofocus)
                Toggle("Auto-tint", isOn: $viewModel.autotint)
                Spacer()
            }
            .foregroundColor(AppColors.text)
            .environmentObject(viewModel)
        }
//        .onAppear(perform: {
//            viewModel.updateFocus(to: viewModel.camera.captureDevice?.lensPosition);
//            viewModel.updateExposure(to: viewModel.camera.captureDevice?.iso);
//        })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
