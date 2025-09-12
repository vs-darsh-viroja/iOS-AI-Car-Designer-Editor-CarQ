//
//  ResultView.swift
//  CarQ
//

import Foundation
import SwiftUI
import Kingfisher
import Photos
import CoreData
import OSLog

struct ResultView: View {
    private let resultLogger = Logger(subsystem: "CarQ", category: "ResultView")
    @ObservedObject var viewModel: GenerationViewModel
    var onBack: () -> Void

    @State private var showToast = false
    @State private var toastMessage = ""
    @State private var showDeleteConfirmation = false
    @State private var showPermissionAlert = false
    @State private var permissionDeniedOnce = false
    @State var generatedImage: UIImage?
    @State var buttonDisabled: Bool = true
    var onClose: () -> Void
    
    let notificationFeedback = UINotificationFeedbackGenerator()
    
    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: ScaleUtility.scaledSpacing(170)) {
                
                VStack(spacing: ScaleUtility.scaledSpacing(30)) {
                    
                    HeaderView(text: "Result", onBack: {
                        onBack()
                    }, onClose: {
                        onClose()
                    }, isCross: true)
                    .padding(.top, ScaleUtility.scaledSpacing(15))
                    
                    if let urlStr = viewModel.resultData?.bestImageURL,
                       let url = URL(string: urlStr) {
                        // Fallback to remote image
                        KFImage(url)
                            .placeholder {
                                ZStack {
                                    Image(.imageBg)
                                        .resizable()
                                        .scaledToFit()
                                    
                                    ProgressView()
                                        .tint(Color.primaryApp)
                                }
                            }
                            .onSuccess { result in
                                let uiImage = result.image
                                generatedImage = uiImage
                                buttonDisabled = false
                            }
                            .resizable()
                            .scaledToFit()
                            .padding(.horizontal, ScaleUtility.scaledSpacing(15))
                            .frame(minHeight: isIPad ? ScaleUtility.scaledValue(645) : ScaleUtility.scaledValue(345))
                            .overlay {
                                Image(.imageBg)
                                    .resizable()
                                    .scaledToFit()
                            }
                        
                    } else {
                        Text("No result found yet.")
                            .foregroundColor(.secondary)
                            .padding(.horizontal, ScaleUtility.scaledSpacing(15))
                    }
                }
                
                FooterView(
                    onSave: {
                        saveImageToGallery()
                    },
                    onDelete: {
                        showDeleteConfirmation = true
                    },
                    onShare: {
                        shareImage()
                    },
                    generatedImage: $generatedImage,
                    buttonDisabled: $buttonDisabled)
            }
            Spacer()
        }
        .overlay(alignment: .bottom) {
            Group {
                if showToast {
                    VStack {
                        Text(toastMessage)
                            .font(FontManager.ChakraPetchRegularFont(size: .scaledFontSize(13)))
                            .foregroundColor(Color.secondaryApp)
                            .padding()
                            .background(Color.primaryApp.opacity(0.7))
                            .cornerRadius(10)
                            .transition(.scale)
                    }
                    .offset(y: isIPad ? ScaleUtility.scaledSpacing(-250) : ScaleUtility.scaledSpacing(-150))
                }
            }
        }
        // Delete confirmation dialog
        .alert("Delete Image", isPresented: $showDeleteConfirmation) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                deleteImageFromHistory()
            }
        } message: {
            Text("This will permanently delete the image from your history. This action cannot be undone.")
        }
        .alert(isPresented: $showPermissionAlert) {
            Alert(
                title: Text("Photo Library Permission Denied"),
                message: Text("You need to enable photo library access to save the image. Would you like to open Settings?"),
                primaryButton: .default(Text("Open Settings")) {
                    notificationFeedback.notificationOccurred(.success)
                    if let appSettings = URL(string: UIApplication.openSettingsURLString) {
                        UIApplication.shared.open(appSettings)
                    }
                },
                secondaryButton: .cancel()
            )
        }
        .navigationBarHidden(true)
        .background(Color.secondaryApp.edgesIgnoringSafeArea(.all))
    }
    
    private func deleteImageFromHistory() {
        resultLogger.info("User confirmed delete in ResultView")
        do {
            try viewModel.deleteCurrentRecord()
            resultLogger.info("ResultView delete path completed; will pop after toast")
            toastMessage = "Image deleted successfully"
            showToast = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                showToast = false
                onBack()
            }
        } catch {
            resultLogger.error("ResultView delete failed: \(error.localizedDescription)")
            toastMessage = "Failed to delete image"
            showToast = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                showToast = false
            }
        }
    }
    
    // Function to save image to gallery
    private func saveImageToGallery() {
        guard let image = generatedImage else {
            toastMessage = "Failed to retrieve image."
            showToast = true
            return
        }
        
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            toastMessage = "Failed to process image."
            showToast = true
            return
        }

        PHPhotoLibrary.requestAuthorization { status in
            if status == .authorized {
                PHPhotoLibrary.shared().performChanges({
                    PHAssetCreationRequest.forAsset().addResource(with: .photo, data: imageData, options: nil)
                }) { success, error in
                    if success {
                        DispatchQueue.main.async {
                            toastMessage = "Image saved to gallery!"
                            showToast = true
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                showToast = false
                            }
                        }
                    } else {
                        DispatchQueue.main.async {
                            toastMessage = "Failed to save image."
                            showToast = true
                        }
                    }
                }
            } else if status == .denied || status == .restricted {
                DispatchQueue.main.async {
                    if !permissionDeniedOnce {
                        permissionDeniedOnce = true
                        showPermissionAlert = true
                    } else {
                        toastMessage = "Permission denied. Please enable gallery access in settings."
                        showToast = true
                    }
                }
            }
        }
    }
    
    private func shareImage() {
        guard let image = generatedImage else {
            toastMessage = "Failed to retrieve image."
            showToast = true
            return
        }
        
        DispatchQueue.main.async {
            let activityViewController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
            if let rootVC = UIApplication.shared.windows.first?.rootViewController {
                rootVC.present(activityViewController, animated: true, completion: nil)
            }
        }
    }
}

// ResultView.swift
extension Notification.Name {
    static let historyDidChange = Notification.Name("historyDidChange")
}
