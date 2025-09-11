//
//  HistoryCardView.swift
//  CarQ
//
//  Created by Purvi Sancheti on 11/09/25.
//

import Foundation
import SwiftUI
import Kingfisher

struct HistoryCardView: View {
    let record: ImageRecord
    let onDelete: () -> Void
    
    @State private var imageURL: URL?
    
    var body: some View {
        ZStack {
            // Image content
         
            
            Group {
                if let imageURL = imageURL {
                    KFImage(imageURL)
                        .placeholder {
                            ZStack {
                                Color.primaryApp.opacity(0.1)
                                ProgressView()
                                    .tint(Color.primaryApp)
                            }
                        }
                        .onFailure { error in
                            print("Failed to load image: \(error)")
                        }
                        .resizable()
                        .frame(width: ScaleUtility.scaledValue(165), height: ScaleUtility.scaledValue(170))
                        .overlay {
                            Image(.cardBg)
                                .resizable()
                                .frame(width: ScaleUtility.scaledValue(166.00098), height: ScaleUtility.scaledValue(172.00098))
                               
                        }
                        
                    
                } else {
                    // Fallback when no image URL is available
                    Rectangle()
                        .fill(Color.primaryApp.opacity(0.1))
                        .frame(width: ScaleUtility.scaledValue(165), height: ScaleUtility.scaledValue(170))
                        .overlay {
                            VStack {
                                Image(systemName: "photo")
                                    .foregroundColor(Color.primaryApp.opacity(0.5))
                                    .font(.system(size: 24))
                                Text("No Image")
                                    .font(FontManager.ChakraPetchRegularFont(size: .scaledFontSize(12)))
                                    .foregroundColor(Color.primaryApp.opacity(0.5))
                            }
                        }
                }
            }
            
       
            
            // Delete button
            VStack {
                HStack {
                    Spacer()
                    Button(action: onDelete) {
                        Image(.deleteIcon2)
                            .resizable()
                            .frame(width: ScaleUtility.scaledValue(16), height: ScaleUtility.scaledValue(16))
                            .padding(.all, ScaleUtility.scaledSpacing(6))
                            .background {
                                Circle()
                                    .fill(Color.secondaryApp.opacity(0.1))
                            }
                            .cornerRadius(30)
                            .overlay {
                                RoundedRectangle(cornerRadius: 30)
                                    .stroke(Color.primaryApp.opacity(0.2), lineWidth: 1)
                            }
                    }
                    .offset(x: -10, y: 10)
                }
                Spacer()
            }
            
//            // Optional: Show prompt/source info at bottom
//            if let prompt = record.prompt, !prompt.isEmpty {
//                VStack {
//                    Spacer()
//                    HStack {
//                        Text(prompt)
//                            .font(FontManager.ChakraPetchRegularFont(size: .scaledFontSize(10)))
//                            .foregroundColor(Color.secondaryApp)
//                            .lineLimit(2)
//                            .padding(.horizontal, 8)
//                            .padding(.vertical, 4)
//                            .background {
//                                Color.primaryApp.opacity(0.8)
//                                    .cornerRadius(6)
//                            }
//                        Spacer()
//                    }
//                    .padding(.bottom, 8)
//                    .padding(.leading, 8)
//                }
//            }
        }
    
        .onAppear {
            setupImageURL()
        }
    }
    
    private func setupImageURL() {
        // Priority: Try remote URL first, then local file
        if let remoteURLString = record.remoteURL,
           let remoteURL = URL(string: remoteURLString) {
            imageURL = remoteURL
        } else if let localPath = record.localPath {
            let baseFolder = getImagesDirectory()
            let localURL = baseFolder.appendingPathComponent(localPath)
            if FileManager.default.fileExists(atPath: localURL.path) {
                imageURL = localURL
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
}
