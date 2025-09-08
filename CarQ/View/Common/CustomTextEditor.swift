//
//  CustomTextEditor.swift
//  CarQ
//
//  Created by Purvi Sancheti on 08/09/25.
//

import Foundation
import SwiftUI
import StoreKit

struct CustomTextEditor: UIViewRepresentable {
    @Binding var text: String
  

    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: .scaledFontSize(14))
        textView.backgroundColor = UIColor.clear
        textView.textColor = UIColor.white
        textView.tintColor = .white     
        textView.delegate = context.coordinator
        textView.isScrollEnabled = true
        
        textView.addDoneButtonOnKeyboard()
        return textView
    }

    func updateUIView(_ uiView: UITextView, context: Context) {
        if uiView.text != text {  // ✅ Update only when text actually changes
            uiView.text = text
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    

    class Coordinator: NSObject, UITextViewDelegate {
        var parent: CustomTextEditor

        init(_ parent: CustomTextEditor) {
            self.parent = parent
        }

        func textViewDidChange(_ textView: UITextView) {
            // ✅ Update SwiftUI text only if necessary
            if parent.text != textView.text {
                parent.text = textView.text
            }
        }
    }
}

// ✅ Extension to add a Done button
extension UITextView {
    func addDoneButtonOnKeyboard() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()

        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(dismissKeyboard))

        doneButton.tintColor = UIColor.black
        toolbar.items = [flexSpace, doneButton]
        self.inputAccessoryView = toolbar
    }

    @objc func dismissKeyboard() {
        self.resignFirstResponder()
    }
}
