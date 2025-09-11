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
                    LazyVGrid(columns: [
                        GridItem(.flexible(), spacing: ScaleUtility.scaledSpacing(15)),
                        GridItem(.flexible(), spacing: ScaleUtility.scaledSpacing(15))
                    ], spacing: ScaleUtility.scaledSpacing(20)) {
                        ForEach(historyRecords, id: \.objectID) { record in
                            HistoryCardView(
                                record: record,
                                onDelete: {
                                    recordToDelete = record
                                    showDeleteConfirmation = true
                                }
                            )
                        }
                    }
                    .padding(.horizontal, ScaleUtility.scaledSpacing(15))
                    .padding(.top, ScaleUtility.scaledSpacing(25))
                }
            }
            
            Spacer()
        }
        .background(Color.secondaryApp.edgesIgnoringSafeArea(.all))
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
    }
    
    private func loadHistory() {
        do {
            let kind: HistoryKind? = selectedFilter == "Generated" ? .generated :
                                    selectedFilter == "Edited" ? .edited : nil
            historyRecords = try CoreDataManager.shared.fetchHistory(kind: kind, newestFirst: true)
        } catch {
            print("Failed to load history: \(error)")
            historyRecords = []
        }
    }
    
    private func deleteRecord(_ record: ImageRecord) {
        do {
            try CoreDataManager.shared.deleteRecord(objectID: record.objectID)
            loadHistory() // Refresh the list
            
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
}

