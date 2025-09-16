//
//  ImagePreview.swift
//  CarQ
//
//  Created by Purvi Sancheti on 12/09/25.
//

import Foundation
import SwiftUI
import Kingfisher
import Photos

struct ImagePreview: View {
    let record: ImageRecord
    @Binding var imageURL: URL?
    let onDelete: () -> Void
    var onBack: () -> Void
    @State var img: UIImage?
    @State var buttonDisabled: Bool = false
    
    @State private var showToast = false
    @State private var toastMessage = ""
    
    @State private var showPermissionAlert = false
    @State private var permissionDeniedOnce = false
    
    let notificationFeedback = UINotificationFeedbackGenerator()
    
    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: ScaleUtility.scaledSpacing(170)) {
                VStack(spacing: ScaleUtility.scaledSpacing(25)) {
                    
                    HStack(spacing: ScaleUtility.scaledSpacing(15)) {
                        Button {
                            onBack()
                        } label: {
                            Image(.backIcon)
                                .resizable()
                                .frame(width: ScaleUtility.scaledValue(24), height: ScaleUtility.scaledValue(24))
                        }
                        
                        Text("Preview")
                            .font(FontManager.ChakraPetchSemiBoldFont(size: .scaledFontSize(24)))
                            .foregroundColor(Color.primaryApp)
                        
                        Spacer()
                    }
                    .padding(.leading, ScaleUtility.scaledSpacing(15))
                    .padding(.top, ScaleUtility.scaledSpacing(15))
                    
                    if let imageURL = imageURL {
                        KFImage(imageURL)
                            .placeholder {
                                ZStack {
                                    
                                    if isIPad {
                                        
                                        Image(.imageBg)
                                            .resizable()
                                            .frame(width: 707 * ipadWidthRatio ,
                                                   height: 813.99463 * ipadHeightRatio)
                                         
                                        
                                    }
                                    else {
                                        
                                        Image(.imageBg)
                                            .resizable()
                                            .scaledToFit()
                                     
                                    }
                                    
                                    ProgressView()
                                        .tint(Color.primaryApp)
                                }
                            }
                            .onFailure { error in
                                print("Failed to load image: \(error)")
                            }
                            .resizable()
                            .scaledToFit()
                            .padding(.horizontal, ScaleUtility.scaledSpacing(15))
                            .frame(minHeight: isIPad
                                   ? ScaleUtility.scaledValue(480.99463)
                                   : ScaleUtility.scaledValue(345))
                            .overlay {
                                
                                if isIPad {
                                    
                                    Image(.imageBg)
                                        .resizable()
                                        .frame(width: 707 * ipadWidthRatio ,
                                               height: 813.99463 * ipadHeightRatio)
                        
                                }
                                else {
                                    
                                    Image(.imageBg)
                                        .resizable()
                                        .scaledToFit()
                             
                                }
                            }
                    }
                    
                }
                
                
                if let img {
                    FooterView(onSave: {
                        saveImageToGallery()
                    },
                               onDelete: {
                        onDelete()
                       
                    },
                               onShare: {
                        shareImage()
                        
                    },
                               generatedImage: $img,
                               buttonDisabled: $buttonDisabled)
                }
                
            }
            
            Spacer()
            
            
        }
        .navigationBarHidden(true)
        .background(Color.secondaryApp.ignoresSafeArea(.all))
        .onAppear {
            if let relativePath = record.value(forKey: "localPath") as? String {
                let fullURL = getImagesDirectory().appendingPathComponent(relativePath)
                
                if let data = try? Data(contentsOf: fullURL),
                   let uiImage = UIImage(data: data) {
                    img = uiImage
                }
            }
        }
        .overlay(alignment: .bottom) {
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
                .offset(y: ScaleUtility.scaledSpacing(-100))
            }
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
    }
    
    private func setupImageURL() {
        if let localPath = record.localPath {
            let base = getImagesDirectory()
            let local = base.appendingPathComponent(localPath)
            if FileManager.default.fileExists(atPath: local.path) {
                imageURL = local
                return
            }
        }
        if let remoteURLString = record.remoteURL,
           let remote = URL(string: remoteURLString) {
            imageURL = remote
        }
    }

    
    private func getImagesDirectory() -> URL {
        let appSupport = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
        let folder = appSupport.appendingPathComponent("CarQ", isDirectory: true)
        try? FileManager.default.createDirectory(at: folder, withIntermediateDirectories: true)
        let images = folder.appendingPathComponent("Images", isDirectory: true)
        try? FileManager.default.createDirectory(at: images, withIntermediateDirectories: true)
        return images
    }
    
    private func saveImageToGallery() {
        guard let image = img else {
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
        guard let image = img else {
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
