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

                       // ✅ Success: show remote fast, cache in background (NO CoreData saving here)
                       if r.status, let remoteStrings = r.data, !remoteStrings.isEmpty {
                           // (a) Fast path for ResultView (remote)
                           self.resultData = ResultData(id: id, imageURLs: remoteStrings)
                           self.shouldNavigateToResult = true

                           // (b) Background: ONLY cache to disk (NO CoreData saving)
                           let remoteURLs = remoteStrings.compactMap { URL(string: $0) }

                           Task.detached {
                               let store = LocalImageStore.shared
                               for remote in remoteURLs {
                                   do {
                                       let _ = try await store.cacheRemoteImage(remote)
                                   } catch {
                                       // Skip a failed item; continue with others
                                       print("Cache failed for \(remote):", error.localizedDescription)
                                   }
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
