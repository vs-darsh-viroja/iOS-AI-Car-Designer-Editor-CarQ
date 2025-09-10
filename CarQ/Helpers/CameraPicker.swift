//
//  CameraPicker.swift
//  CarQ
//
//  Created by Purvi Sancheti on 10/09/25.
//


import Foundation
import SwiftUI

struct CameraPicker: UIViewControllerRepresentable {
    @Environment(\.presentationMode) private var presentationMode
    @Binding var image: Image?
    @Binding var uiImage: UIImage?   // Add this

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: CameraPicker

        init(_ parent: CameraPicker) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController,
                                   didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                parent.uiImage = uiImage                  // Save UIImage
                parent.image = Image(uiImage: uiImage)    // Save SwiftUI.Image
            }
            parent.presentationMode.wrappedValue.dismiss()
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.presentationMode.wrappedValue.dismiss()
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
}

import AVFoundation
import PhotosUI
import SwiftUI

// 1) Little helper
enum CameraAuth {
    static func status() -> AVAuthorizationStatus {
        AVCaptureDevice.authorizationStatus(for: .video)
    }
    
    static func requestIfNeeded() async -> Bool {
        let status = status()
        if status == .notDetermined {
            return await AVCaptureDevice.requestAccess(for: .video)
        } else {
            return status == .authorized
        }
    }
}
