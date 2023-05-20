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
                Text("Focal [Software Demo]")
                    .bold()
                    .font(.title)
                CameraView()
                    .background(.brown)
                VStack {
                    Slider(value: $viewModel.manualFocus, in: 0...1, step: 0.05, label: {Text("Focus Amount")}, minimumValueLabel: {Text("0%")}, maximumValueLabel: {Text("100%")}, onEditingChanged: { editing in
                        if !viewModel.filterManager.autoFocus {
                            viewModel.changeFocus()
                        }
                    })
                    Text(String(format: "Focus Amount: %.2f", viewModel.filterManager.focusValue))
                        .bold()
                    Slider(value: $viewModel.manualExposure, in: ClosedRange(uncheckedBounds: (lower: log2(viewModel.isoAsSliderRange.lower), upper: log2(viewModel.isoAsSliderRange.upper))), label: {Text("Exposure (ISO)")}, minimumValueLabel: {Text("\(Int(viewModel.isoAsSliderRange.lower))")}, maximumValueLabel: {Text("\(Int(viewModel.isoAsSliderRange.upper))")}, onEditingChanged: { editing in
                        if !viewModel.filterManager.autoTint {
                            viewModel.changeExposure()
                        }
                    })
                    Text(String(format: "Exposure (ISO): %.3f", viewModel.filterManager.exposureValue))
                        .bold()
                    Toggle("Auto-focus", isOn: $viewModel.autofocus)
                    Toggle("Auto-tint", isOn: $viewModel.autotint)
                }
                .bold()
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                .border(AppColors.accent, width: 4)
                .padding(.horizontal, 10)
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
