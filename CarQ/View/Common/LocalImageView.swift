//
//  LocalImageView.swift
//  CarQ
//
//  Created by Purvi Sancheti on 12/09/25.
//

import Foundation
import SwiftUI

// MARK: - Local Image View Component
struct LocalImageView: View {
    let record: ImageRecord
    let onImageLoaded: (UIImage) -> Void
    @State private var loadedImage: UIImage?
    @State private var isLoading = true
    
    var body: some View {
        Group {
            if let image = loadedImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .overlay {
                        
                        if isIPad {
                            
                            Image(.imageBg)
                                .resizable()
                                .frame(width: ScaleUtility.scaledValue(647.01) ,
                                       height: ScaleUtility.scaledValue(346.99463))
   
                            
                        }
                        else {
                            
                            Image(.imageBg)
                                .resizable()
                                .scaledToFit()
                               
                        }
                    }
            } else if isLoading {
                ZStack {
                    
                    if isIPad {
                        
                        Image(.imageBg)
                            .resizable()
                            .frame(width: ScaleUtility.scaledValue(647.01) ,
                                   height: ScaleUtility.scaledValue(346.99463))
        
                        
                    }
                    else {
                        
                        Image(.imageBg)
                            .resizable()
                            .scaledToFit()
     
                    }
                    
                    ProgressView()
                        .tint(Color.primaryApp)
                }
            } else {
                ZStack {
                    
                    if isIPad {
                        
                        Image(.imageBg)
                            .resizable()
                            .frame(width: ScaleUtility.scaledValue(647.01) ,
                                   height: ScaleUtility.scaledValue(346.99463))
   
                    }
                    else {
                        
                        Image(.imageBg)
                            .resizable()
                            .scaledToFit()
                     
                    }
                    
                    Text("Failed to load image")
                        .foregroundColor(.secondary)
                }
            }
        }
        .onAppear {
            loadLocalImage()
        }
    }
    
    private func loadLocalImage() {
        guard let localPath = record.localPath else {
            isLoading = false
            return
        }
        
        // Try current folder first (CarQ/Images)
        let currentFolder = getImagesDirectory()
        let currentFileURL = currentFolder.appendingPathComponent(localPath)
        
        // Try legacy folder if current doesn't exist (EveCraft/Images)
        let legacyFolder = getLegacyImagesDirectory()
        let legacyFileURL = legacyFolder.appendingPathComponent(localPath)
        
        DispatchQueue.global(qos: .userInitiated).async {
            var imageData: Data?
            var image: UIImage?
            
            // Try current location first
            if let data = try? Data(contentsOf: currentFileURL) {
                imageData = data
            }
            // Fallback to legacy location
            else if let data = try? Data(contentsOf: legacyFileURL) {
                imageData = data
                // Optionally migrate the file to the new location
                try? data.write(to: currentFileURL)
                try? FileManager.default.removeItem(at: legacyFileURL)
            }
            
            if let data = imageData {
                image = UIImage(data: data)
            }
            
            DispatchQueue.main.async {
                if let finalImage = image {
                    self.loadedImage = finalImage
                    self.isLoading = false
                    self.onImageLoaded(finalImage)
                } else {
                    self.isLoading = false
                }
            }
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
    
    private func getLegacyImagesDirectory() -> URL {
        let appSupport = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
        let folder = appSupport.appendingPathComponent("EveCraft", isDirectory: true)
        let images = folder.appendingPathComponent("Images", isDirectory: true)
        return images
    }
}
