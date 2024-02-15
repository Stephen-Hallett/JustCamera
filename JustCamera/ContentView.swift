//
//  ContentView.swift
import SwiftUI
//  JustCamera
//
//  Created by Stephen Hallett on 15/02/24.
//

import SwiftUI
import AVFoundation

struct ContentView: View {
    @State private var isShowingCamera = true
    
    var body: some View {
        VStack {
            if isShowingCamera {
                CameraPreview()
                    .edgesIgnoringSafeArea(.all)
            } else {
                Text("Camera not available")
            }
        }
        .onAppear {
            AVCaptureDevice.requestAccess(for: .video) { granted in
                DispatchQueue.main.async {
                    isShowingCamera = granted
                }
            }
        }
    }
}

struct CameraPreview: UIViewRepresentable {
    func makeUIView(context: Context) -> some UIView {
        let previewView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        
        let captureSession = AVCaptureSession()
        
        guard let backCamera = AVCaptureDevice.default(for: .video) else { return previewView }
        
        do {
            let input = try AVCaptureDeviceInput(device: backCamera)
            if captureSession.canAddInput(input) {
                captureSession.addInput(input)
            }
        } catch let error {
            print("Error setting up camera input:", error.localizedDescription)
            return previewView
        }
        
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.videoGravity = .resizeAspectFill
        previewLayer.frame = previewView.bounds
        previewView.layer.addSublayer(previewLayer)
        
        captureSession.startRunning()
        
        return previewView
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        // Update the view if needed
        print("Updating now")
    }
}
