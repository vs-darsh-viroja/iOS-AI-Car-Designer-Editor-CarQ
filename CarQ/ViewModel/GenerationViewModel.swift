//
//  File.swift
//  CarQ
//
//  Created by Purvi Sancheti on 10/09/25.
//
import UIKit

@MainActor
final class GenerationViewModel: ObservableObject {
    @Published var errorMessage: String?
    @Published var shouldNavigateToResult = false
    @Published var resultData: ResultData?
    @Published var shouldReturn = false
    
    private let network = NetworkManager.shared
    private var taskID: String?
    
    
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

                    // ✅ Success: show remote fast, then cache & save in background
                    if r.status, let remoteStrings = r.data, !remoteStrings.isEmpty {
                        // (a) Fast path for ResultView (remote)
                        self.resultData = ResultData(id: id, imageURLs: remoteStrings)
                        self.shouldNavigateToResult = true

                        // (b) Background: cache to disk and save to Core Data for History
                        let remoteURLs = remoteStrings.compactMap { URL(string: $0) }
//                        let kind = self.currentKind
//                        let prompt = self.currentPrompt
//                        let source = self.currentSource

//                        Task.detached {
//                            let store = LocalImageStore.shared
//                            var localURLs: [URL] = []
//                            for remote in remoteURLs {
//                                do {
//                                    let local = try await store.cacheRemoteImage(remote)
//                                    localURLs.append(local)
//                                } catch {
//                                    // Skip a failed item; continue with others
//                                    print("Cache failed for \(remote):", error.localizedDescription)
//                                }
//                            }
//                            guard !localURLs.isEmpty else { return }
//
//                            // Save to Core Data (main-context)
//                            await MainActor.run {
//                                do {
//                                    try CoreDataManager.shared.saveLocalHistory(
//                                        locals: localURLs,
//                                        remotes: remoteURLs.map { Optional($0) },
//                                        isGenerated: (kind == .generated),
//                                        isEdited: (kind == .edited),
//                                        prompt: prompt,
//                                        source: source
//                                    )
//                                } catch {
//                                    print("History save failed:", error.localizedDescription)
//                                }
//                            }
//                        }

                        return
                    }

                    // ❌ Server reported failure
                    if r.status == false {
                        self.errorMessage = "Generation failed. Please try again."
                        self.shouldReturn = true
                        return
                    }

                } catch {
                    // Network/decoding issue → keep polling until timeout
                    self.errorMessage = "Network issue: \(error.localizedDescription)"
                }

                // 2) Sleep between polls without overshooting timeout
                let timeLeft = overallTimeout - Date().timeIntervalSince(start)
                guard timeLeft > 0 else { continue }
                let sleepFor = min(pollInterval, timeLeft)
                try? await Task.sleep(nanoseconds: UInt64(sleepFor * 1_000_000_000))
            }
        }

    
}
