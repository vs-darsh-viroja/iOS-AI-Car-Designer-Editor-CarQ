//
//  LocalImageStore.swift
//  CarQ
//
//  Created by Purvi Sancheti on 11/09/25.
//



import Foundation
import Foundation
import UIKit

enum LocalImageStoreError: Error { case badResponse, writeFailed }

final class LocalImageStore {
    static let shared = LocalImageStore()
    private init() {}

    private let folderName = "Images"

    private var baseFolder: URL {
        let appSupport = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
        let folder = appSupport.appendingPathComponent("CarQ", isDirectory: true)
        try? FileManager.default.createDirectory(at: folder, withIntermediateDirectories: true)
        let images = folder.appendingPathComponent(folderName, isDirectory: true)
        try? FileManager.default.createDirectory(at: images, withIntermediateDirectories: true)
        return images
    }
    

    /// Downloads a remote image URL and persists it as JPEG (quality 0.95). Returns local file URL.
    func cacheRemoteImage(_ remote: URL, as filename: String = UUID().uuidString) async throws -> URL {
        let (data, resp) = try await URLSession.shared.data(from: remote)
        guard let http = resp as? HTTPURLResponse, (200..<300).contains(http.statusCode) else {
            throw LocalImageStoreError.badResponse
        }
        return try save(data: data, suggestedName: filename, ext: "jpg")
    }

    /// Saves a UIImage locally (used if you already have a rendered image).
    func saveUIImage(_ image: UIImage, as filename: String = UUID().uuidString, quality: CGFloat = 0.95) throws -> URL {
        guard let data = image.jpegData(compressionQuality: quality) else { throw LocalImageStoreError.writeFailed }
        return try save(data: data, suggestedName: filename, ext: "jpg")
    }

    private func save(data: Data, suggestedName: String, ext: String) throws -> URL {
        var url = baseFolder.appendingPathComponent("\(suggestedName).\(ext)")
        do {
            try data.write(to: url, options: [.atomic])
            var resValues = URLResourceValues()
            resValues.isExcludedFromBackup = true
            try url.setResourceValues(resValues)
            return url
        } catch {
            throw LocalImageStoreError.writeFailed
        }
    }
}
