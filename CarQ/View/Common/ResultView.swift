//
//  ResultView.swift
//  CarQ
//
//  Created by Purvi Sancheti on 10/09/25.
//

import Foundation
import SwiftUI
import Kingfisher
import Photos

struct ResultView: View {
    @ObservedObject var viewModel: GenerationViewModel
    var onBack: () -> Void
    @State private var imageAspect: CGFloat? = nil
    @State private var showToast = false
    @State private var toastMessage = ""

    @State private var showPermissionAlert = false
    @State private var permissionDeniedOnce = false
    @State var generatedImage: UIImage?
    @State var buttonDisabled: Bool = true
    
    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: ScaleUtility.scaledSpacing(170)) {
                
                VStack(spacing: ScaleUtility.scaledSpacing(30)) {
                    
                    HeaderView(text: "Result", onBack: {
                        onBack()
                    })
                    .padding(.top, ScaleUtility.scaledSpacing(15))
                    
                    
                    // Fixed container with consistent sizing like ImagePreview
                    if let urlStr = viewModel.resultData?.bestImageURL,
                       let url = URL(string: urlStr) {
                        
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
                            .scaledToFit() // This ensures proper aspect ratio within the container
                            .padding(.horizontal, ScaleUtility.scaledSpacing(15)) // Same as ImagePreview
                            .frame(minHeight: isIPad ?  ScaleUtility.scaledValue(645) : ScaleUtility.scaledValue(345))
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
                    }, onDelete: {
                        
                    }, onShare: {
                        shareImage()
                    },
                    generatedImage: $generatedImage,
                    buttonDisabled: $buttonDisabled)
             
                
            }
            Spacer()
        }
        .overlay(alignment:.bottom){
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
        .navigationBarHidden(true)
        .background(Color.secondaryApp.edgesIgnoringSafeArea(.all))
    }
    
    // Function to save image to gallery
    private func saveImageToGallery() {
        guard let urlStr = viewModel.resultData?.bestImageURL, let url = URL(string: urlStr) else {
            toastMessage = "Failed to retrieve image."
            showToast = true
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data, let image = UIImage(data: data) {
                PHPhotoLibrary.requestAuthorization { status in
                    if status == .authorized {
                        PHPhotoLibrary.shared().performChanges({
                            PHAssetCreationRequest.forAsset().addResource(with: .photo, data: data, options: nil)
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
            } else {
                DispatchQueue.main.async {
                    toastMessage = "Error loading image."
                    showToast = true
                }
            }
        }.resume()
    }

    
    private func shareImage() {
        guard let urlStr = viewModel.resultData?.bestImageURL, let url = URL(string: urlStr) else {
            toastMessage = "Failed to retrieve image."
            showToast = true
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    let activityViewController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
                    if let rootVC = UIApplication.shared.windows.first?.rootViewController {
                        rootVC.present(activityViewController, animated: true, completion: nil)
                    }
                }
            } else {
                DispatchQueue.main.async {
                    toastMessage = "Error sharing image."
                    showToast = true
                }
            }
        }.resume()
    }
    
}
