//
//  HistoryView.swift
//  CarQ
//

import Foundation
import SwiftUI
import Kingfisher

struct HistoryView: View {
    @State var selectedFilter: String = "Generated"
    @State private var historyRecords: [ImageRecord] = []
    @State private var showDeleteConfirmation = false
    @State private var recordToDelete: ImageRecord?
    @State private var showToast = false
    @State private var toastMessage = ""
    
    @State private var selectedRecord: ImageRecord?
    @State private var showPreview = false
    @State private var previewImageURL: URL?
    
    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: ScaleUtility.scaledSpacing(20)) {
                TopView(title: "History")
                    .padding(.top, ScaleUtility.scaledSpacing(9))
                
                HistoryFilterView(selectedFilter: $selectedFilter)
            }
            
            if historyRecords.isEmpty {
                EmptyHistoryView()
            } else {
                ScrollView {
                  
                    Spacer()
                        .frame(height: ScaleUtility.scaledValue(20))
                    
                    VStack(spacing: ScaleUtility.scaledSpacing(15)) {
                        ForEach(0..<(historyRecords.count + 1) / 2, id: \.self) { rowIndex in
                            HStack(spacing: ScaleUtility.scaledSpacing(15)) {
                                let startIndex = rowIndex * 2
                                let endIndex = min(startIndex + 2, historyRecords.count)
                                
                                ForEach(startIndex..<endIndex, id: \.self) { index in
                                    let record = historyRecords[index]
                                    
                                    Button(action: {
                                        selectedRecord = record
                                        previewImageURL = computePreviewURL(for: record)
                                        showPreview = true
                                    }) {
                                        HistoryCardView(
                                            record: record,
                                            onDelete: {
                                                recordToDelete = record
                                                showDeleteConfirmation = true
                                            }
                                        )
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                    .frame(maxWidth: .infinity)
                                }
                                
                                // Add spacer for odd number of items in last row
                                if endIndex - startIndex == 1 {
                                    Spacer()
                                        .frame(maxWidth: .infinity)
                                }
                            }
                        }
                    }
                    .padding(.horizontal, ScaleUtility.scaledSpacing(15))
                    
                    Spacer()
                        .frame(height: ScaleUtility.scaledValue(150))
              
                }
            }
            
            Spacer()
        }
        .background(Color.secondaryApp.edgesIgnoringSafeArea(.all))
        .onReceive(NotificationCenter.default.publisher(for: .NSManagedObjectContextObjectsDidChange)) { _ in
            loadHistory()
        }
        .onReceive(NotificationCenter.default.publisher(for: .historyDidChange)) { _ in
            loadHistory()
        }
        .onAppear {
            loadHistory()
        }
        .onChange(of: selectedFilter) { _ in
            loadHistory()
        }
        .alert("Delete Image", isPresented: $showDeleteConfirmation) {
            Button("Cancel", role: .cancel) {
                recordToDelete = nil
            }
            Button("Delete", role: .destructive) {
                if let record = recordToDelete {
                    deleteRecord(record)
                }
            }
        } message: {
            Text("This will permanently delete the image from your history. This action cannot be undone.")
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
        .navigationDestination(isPresented: $showPreview) {
             if let rec = selectedRecord {
                 ImagePreview(
                     record: rec,
                     imageURL: $previewImageURL,
                     onDelete: {
                         recordToDelete = rec
                         showDeleteConfirmation = true
                     },
                     onBack: {
                         showPreview = false
                     }
                 )
                 .background(Color.secondaryApp.edgesIgnoringSafeArea(.all))
             } else {
                 EmptyView()
             }
         }
    }
    
    private func loadHistory() {
        do {
            let kind: HistoryKind? = {
                 selectedFilter == "Generated" ? .generated :
                selectedFilter == "Edited" ? .edited : nil }()
            historyRecords = try CoreDataManager.shared.fetchHistory(kind: kind, newestFirst: true)
        } catch {
            print("Failed to load history: \(error)")
            historyRecords = []
        }
    }
    
    private func deleteRecord(_ record: ImageRecord) {
        do {
            try CoreDataManager.shared.deleteRecord(objectID: record.objectID)

            DispatchQueue.main.async {
                loadHistory()
            }

            toastMessage = "Image deleted successfully"
            showToast = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                showToast = false
            }
        } catch {
            print("Failed to delete record: \(error)")
            toastMessage = "Failed to delete image"
            showToast = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                showToast = false
            }
        }
        recordToDelete = nil
    }

    private func computePreviewURL(for record: ImageRecord) -> URL? {
        if let localPath = record.localPath {
            let base = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
                .appendingPathComponent("CarQ", isDirectory: true)
                .appendingPathComponent("Images", isDirectory: true)
            let local = base.appendingPathComponent(localPath)
            if FileManager.default.fileExists(atPath: local.path) {
                return local
            }
        }
        if let s = record.remoteURL, let u = URL(string: s) { return u }
        return nil
    }
}
