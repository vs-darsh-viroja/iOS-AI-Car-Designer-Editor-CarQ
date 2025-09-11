//
//  ResultView.swift
//  CarQ
//
//  Enhanced with proper CoreData integration
//

import Foundation
import SwiftUI
import Kingfisher
import Photos
import CoreData

struct ResultView: View {
    @ObservedObject var viewModel: GenerationViewModel
    var onBack: () -> Void
    @State private var imageAspect: CGFloat? = nil
    @State private var showToast = false
    @State private var toastMessage = ""
    @State private var showDeleteConfirmation = false

    @State private var showPermissionAlert = false
    @State private var permissionDeniedOnce = false
    @State var generatedImage: UIImage?
    @State var buttonDisabled: Bool = true
    
    // NEW: Track the CoreData record ID for this result
    @State private var coreDataRecordIDs: [NSManagedObjectID] = []
    
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
                                
                                // NEW: Save to CoreData when image loads successfully
                                saveToHistoryIfNeeded(image: uiImage, remoteURL: url)
                            }
                            .resizable()
                            .scaledToFit()
                            .padding(.horizontal, ScaleUtility.scaledSpacing(15))
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
        // NEW: Delete confirmation dialog
        .alert("Delete Image", isPresented: $showDeleteConfirmation) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                deleteImageFromHistory()
            }
        } message: {
            Text("This will permanently delete the image from your history. This action cannot be undone.")
        }
        .navigationBarHidden(true)
        .background(Color.secondaryApp.edgesIgnoringSafeArea(.all))
    }
    
    // NEW: Save to CoreData history when image loads
    private func saveToHistoryIfNeeded(image: UIImage, remoteURL: URL) {
        // Only save if we haven't already saved this result
        guard coreDataRecordIDs.isEmpty else { return }
        
        do {
            // Save the image locally
            let localURL = try LocalImageStore.shared.saveUIImage(image)
            
            // Save to CoreData history
            let recordIDs = try CoreDataManager.shared.saveLocalHistory(
                locals: [localURL],
                remotes: [remoteURL],
                isGenerated: viewModel.currentKind == .generated,
                isEdited: viewModel.currentKind == .edited,
                prompt: viewModel.currentPrompt,
                source: viewModel.currentSource
            )
            
            self.coreDataRecordIDs = recordIDs
            
        } catch {
            print("Failed to save to history: \(error)")
        }
    }
    
    // NEW: Delete from both local storage and CoreData
    private func deleteImageFromHistory() {
        // Delete from CoreData
        for recordID in coreDataRecordIDs {
            do {
                let context = PersistenceController.shared.container.viewContext
                if let record = try? context.existingObject(with: recordID) as? ImageRecord {
                    // Delete local file if it exists
                    if let localPath = record.localPath {
                        let baseFolder = getImagesDirectory()
                        let fileURL = baseFolder.appendingPathComponent(localPath)
                        try? FileManager.default.removeItem(at: fileURL)
                    }
                    
                    // Delete CoreData record
                    context.delete(record)
                    try context.save()
                }
            } catch {
                print("Failed to delete record: \(error)")
            }
        }
        
        // Clear the tracking array
        coreDataRecordIDs = []
        
        // Show success message and go back
        toastMessage = "Image deleted successfully"
        showToast = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            showToast = false
            onBack()
        }
    }
    
    // Helper function to get images directory (same as LocalImageStore and CoreDataManager)
    private func getImagesDirectory() -> URL {
        let appSupport = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
        let folder = appSupport.appendingPathComponent("CarQ", isDirectory: true)
        try? FileManager.default.createDirectory(at: folder, withIntermediateDirectories: true)
        let images = folder.appendingPathComponent("Images", isDirectory: true)
        try? FileManager.default.createDirectory(at: images, withIntermediateDirectories: true)
        return images
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
