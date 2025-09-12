//
//  SystemColorPicker.swift
//  CarQ
//
//  Created by Purvi Sancheti on 09/09/25.
//

import Foundation
import SwiftUI

struct SystemColorPicker: UIViewControllerRepresentable {
    @Binding var uiColor: UIColor
    var onDismiss: (() -> Void)? = nil
    var onColorSelected: ((UIColor) -> Void)? = nil

    func makeUIViewController(context: Context) -> UIColorPickerViewController {
        let vc = UIColorPickerViewController()
        vc.selectedColor = uiColor
        vc.supportsAlpha = false
        vc.delegate = context.coordinator

        // Force dark theme always
        vc.overrideUserInterfaceStyle = .dark
        vc.view.tintColor = .white   // makes controls visible in dark mode

        return vc
    }

    func updateUIViewController(_ uiViewController: UIColorPickerViewController, context: Context) {
        if uiViewController.selectedColor != uiColor {
            uiViewController.selectedColor = uiColor
        }
        uiViewController.overrideUserInterfaceStyle = .dark
        uiViewController.view.tintColor = .white
    }

    func makeCoordinator() -> Coordinator { Coordinator(self) }

    final class Coordinator: NSObject, UIColorPickerViewControllerDelegate {
        let parent: SystemColorPicker
        init(_ parent: SystemColorPicker) { self.parent = parent }

        func colorPickerViewControllerDidSelectColor(_ vc: UIColorPickerViewController) {
            parent.uiColor = vc.selectedColor
            parent.onColorSelected?(vc.selectedColor)
        }
        func colorPickerViewControllerDidFinish(_ vc: UIColorPickerViewController) {
            parent.onDismiss?()
        }
    }
}


