//
//  GenerationViewModel.swift
//  CarQ
//
//  Created by Purvi Sancheti on 10/09/25.
//
import UIKit
import CoreData
import OSLog

@MainActor
final class GenerationViewModel: ObservableObject {
    
    private let genLogger = Logger(subsystem: "CarQ", category: "GenerationViewModel")
    
    @Published var errorMessage: String?
    @Published var shouldNavigateToResult = false
    @Published var resultData: ResultData?
    @Published var shouldReturn = false
    
    // NEW: Track the saved CoreData record for ResultView
    @Published var savedRecord: ImageRecord?
    
    private let network = NetworkManager.shared
    private var taskID: String?
    
    var currentKind: HistoryKind = .generated
    var currentPrompt: String? = nil
    var currentSource: String? = nil
    
    // MARK: - Image-to-Image flow (single input image)
    func startImageJob(image: UIImage, prompt: String) async -> Bool {
        errorMessage = nil
        shouldReturn = false

        
        do {
            let resp = try await network.uploadImageToImage(image: image, prompt: prompt)
            guard resp.status, let id = resp.data?.id else {
                errorMessage = "Failed to start processing."
                return false
            }
            taskID = id
            return true
        } catch {
            errorMessage = error.localizedDescription
            return false
        }
    }
    
    func startMagicalModificationJob(image: UIImage, maskImage: UIImage, prompt: String) async -> Bool {
        errorMessage = nil
        shouldReturn = false

        
        do {
            let resp = try await network.uploadMagicalModification(image: image, maskImage: maskImage, prompt: prompt)
            guard resp.status, let id = resp.data?.id else {
                errorMessage = "Failed to start processing."
                return false
            }
            taskID = id
            return true
        } catch {
            errorMessage = error.localizedDescription
            return false
        }
    }
    
    
    
    // MARK: - Text-to-Image flow (no input image)
    func startTextJob(prompt: String) async -> Bool {
        errorMessage = nil
        shouldReturn = false
        
        do {
            let resp = try await network.uploadTextToImage(prompt: prompt)
            guard resp.status, let id = resp.data?.id else {
                errorMessage = "Failed to start processing."
                return false
            }
            taskID = id
            return true
        } catch {
            errorMessage = error.localizedDescription
            return false
        }
    }
    
    
    func startRemoveJob(/*image: UIImage,*/ maskImage: UIImage, prompt: String) async -> Bool {
        errorMessage = nil
        shouldReturn = false

        
        do {
            let resp = try await network.uploadRemoveObject(/*image: image,*/ maskImage: maskImage, prompt: prompt)
            guard resp.status, let id = resp.data?.id else {
                errorMessage = "Failed to start processing."
                return false
            }
            taskID = id
            return true
        } catch {
            errorMessage = error.localizedDescription
            return false
        }
    }
    
    func startMultiImageJob(
        image: UIImage,
        maskImage: UIImage,
        referenceImage: UIImage?,
        prompt: String
    ) async -> Bool {
        errorMessage = nil
        shouldReturn = false
        do {
            let resp = try await network.uploadMultipleImage(
                image: image,
                maskImage: maskImage,
                referenceImage: referenceImage,
                prompt: prompt
            )
            guard resp.status, let id = resp.data?.id else {
                errorMessage = "Failed to start processing."
                return false
            }
            taskID = id
            return true
        } catch {
            errorMessage = error.localizedDescription
            return false
        }
    }

    func pollUntilReady(
        pollInterval: TimeInterval = 15,
        overallTimeout: TimeInterval = 300
    ) async {
        guard let id = taskID else { return }
        errorMessage = nil

        let start = Date()
        while true {
            // 1) Hard timeout
            if Date().timeIntervalSince(start) >= overallTimeout {
                self.errorMessage = "Took longer than 5 minutes. Please try again."
                self.shouldReturn = true
                return
            }

            do {
                // Ask server for status/urls
                let r = try await network.getResult(id: id)

                // ✅ Success: cache locally and save to CoreData
                if r.status, let remoteStrings = r.data, !remoteStrings.isEmpty {
                    let remoteURLs = remoteStrings.compactMap { URL(string: $0) }
                    let kind = self.currentKind
                    let prompt = self.currentPrompt
                    let source = self.currentSource

                    // Cache the first image locally and save to CoreData
                    if let firstRemoteURL = remoteURLs.first {
                        // GenerationViewModel.swift (inside the success branch after saveLocalHistory)
                        do {
                            let store = LocalImageStore.shared
                            let localURL = try await store.cacheRemoteImage(firstRemoteURL)

                            let recordIDs = try CoreDataManager.shared.saveLocalHistory(
                                locals: [localURL],
                                remotes: [firstRemoteURL],
                                isGenerated: (kind == .generated),
                                isEdited: (kind == .edited),
                                prompt: prompt,
                                source: source
                            )

                            if let recordID = recordIDs.first {
                                let context = PersistenceController.shared.container.viewContext
                                // Primary path: fetch by permanent ID
                                if let rec = try? context.existingObject(with: recordID) as? ImageRecord {
                                    self.savedRecord = rec
                                } else {
                                    // Fallback: fetch by remoteURL in case something went odd
                                    let req = NSFetchRequest<ImageRecord>(entityName: "ImageRecord")
                                    req.fetchLimit = 1
                                    req.predicate = NSPredicate(format: "remoteURL == %@", firstRemoteURL.absoluteString)
                                    self.savedRecord = try? context.fetch(req).first
                                }
                            }

                            self.resultData = ResultData(id: id, imageURLs: remoteStrings)
                            self.shouldNavigateToResult = true

                        } catch {
                            // If caching/saving fails we’ll only have remote; deletion won’t be possible in ResultView
                            print("Failed to cache and save image:", error.localizedDescription)
                            self.resultData = ResultData(id: id, imageURLs: remoteStrings)
                            self.shouldNavigateToResult = true
                        }

                    }

                    return
                }

                // ❌ Server reported failure
                if r.status == false {
                    self.errorMessage = "Generation failed. Please try again."
                    self.shouldReturn = true
                    return
                }

            } catch {
                // Network/decoding issue – keep polling until timeout
                self.errorMessage = "Network issue: \(error.localizedDescription)"
            }

            // 2) Sleep between polls without overshooting timeout
            let timeLeft = overallTimeout - Date().timeIntervalSince(start)
            guard timeLeft > 0 else { continue }
            let sleepFor = min(pollInterval, timeLeft)
            try? await Task.sleep(nanoseconds: UInt64(sleepFor * 1_000_000_000))
        }
    }
    
    // MARK: - Helper method to delete the saved record
    @MainActor
    // GenerationViewModel.swift
    func deleteCurrentRecord() throws {
        if let record = savedRecord {
            try CoreDataManager.shared.deleteRecord(objectID: record.objectID)
            savedRecord = nil
            NotificationCenter.default.post(name: .historyDidChange, object: nil)
            return
        }

        // Remote-only fallback (record wasn’t set)
        if let urlStr = resultData?.bestImageURL {
            let ctx = PersistenceController.shared.container.viewContext
            let req = NSFetchRequest<ImageRecord>(entityName: "ImageRecord")
            req.fetchLimit = 1
            req.predicate = NSPredicate(format: "remoteURL == %@", urlStr)
            if let rec = try? ctx.fetch(req).first {
                try CoreDataManager.shared.deleteRecord(objectID: rec.objectID)
                NotificationCenter.default.post(name: .historyDidChange, object: nil)
            } else {
                // Nothing to delete; just notify to refresh UI
                NotificationCenter.default.post(name: .historyDidChange, object: nil)
            }
        }
    }

}
