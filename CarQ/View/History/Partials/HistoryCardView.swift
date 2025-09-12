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
    @State var showPreview: Bool = false
    
    @State  var imageURL: URL?
    
    var body: some View {
        ZStack {
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
                                    .fill(Color.secondaryApp.opacity(0.56))
                            }
                            .cornerRadius(30)
                            .overlay {
                                RoundedRectangle(cornerRadius: 30)
                                    .inset(by: -0.5)
                                    .stroke(Color.primaryApp.opacity(0.1), lineWidth: 1)
                            }
                    }
                    .offset(x: -10, y: 10)
                }
                Spacer()
            }
            
        }
        .onAppear {
            setupImageURL()
        }

    }
    
    // HistoryCardView.swift
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
}
