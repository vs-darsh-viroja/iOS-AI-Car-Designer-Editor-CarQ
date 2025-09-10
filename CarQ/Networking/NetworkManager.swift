//
//  NetworkManager.swift
//  CarQ
//
//  Created by Purvi Sancheti on 10/09/25.
//

import Foundation
import UIKit

enum NetworkError: LocalizedError {
    case invalidURL
    case invalidResponse
    case serverError(Int)
    case decodingError

    var errorDescription: String? {
        switch self {
        case .invalidURL: return "Invalid URL"
        case .invalidResponse: return "Invalid response"
        case .serverError(let c): return "Server error \(c)"
        case .decodingError: return "Failed to decode response"
        }
    }
}

final class NetworkManager {
    static let shared = NetworkManager(); private init() {}
    
    private let baseURL = "https://api.carq-app.com"
    
    func uploadTextToImage(prompt: String) async throws -> ImageUploadResponse {
        guard let url = URL(string: "\(baseURL)/api/text-to-img") else { throw NetworkError.invalidURL }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        let boundary = "Boundary-\(UUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        var body = Data()
        func addField(_ name: String, _ value: String) {
            body.append("--\(boundary)\r\n")
            body.append("Content-Disposition: form-data; name=\"\(name)\"\r\n\r\n")
            body.append(value)
            body.append("\r\n")
        }

        addField("prompt", prompt)
        addField("device_id", "123")
        addField("is_paid", "\(false)")
        addCommonFields(&body, boundary: boundary)
        addField("aspect_ratio", "square")

        body.append("--\(boundary)--\r\n")
        request.httpBody = body

        let (data, response) = try await URLSession.shared.data(for: request)
        guard let http = response as? HTTPURLResponse else { throw NetworkError.invalidResponse }
        guard http.statusCode == 200 else { throw NetworkError.serverError(http.statusCode) }

        do { return try JSONDecoder().decode(ImageUploadResponse.self, from: data) }
        catch { throw NetworkError.decodingError }
    }
    
    func getResult(id: String) async throws -> ResultResponse {
        guard let url = URL(string: "\(baseURL)/api/get-result") else { throw NetworkError.invalidURL }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        let boundary = "Boundary-\(UUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        var body = Data()
        body.append("--\(boundary)\r\n")
        body.append("Content-Disposition: form-data; name=\"id\"\r\n\r\n")
        body.append(id)
        body.append("\r\n")
        body.append("--\(boundary)--\r\n")
        request.httpBody = body

        let (data, response) = try await URLSession.shared.data(for: request)
        guard let http = response as? HTTPURLResponse else { throw NetworkError.invalidResponse }
        guard http.statusCode == 200 else { throw NetworkError.serverError(http.statusCode) }

        do { return try JSONDecoder().decode(ResultResponse.self, from: data) }
        catch { throw NetworkError.decodingError }
    }
    
    private func addCommonFields(_ body: inout Data, boundary: String) {
        func addField(_ name: String, _ value: String) {
            body.append("--\(boundary)\r\n")
            body.append("Content-Disposition: form-data; name=\"\(name)\"\r\n\r\n")
            body.append(value)
            body.append("\r\n")
        }

//        // Pull userId from UserDefaults
//         let userId = UserSettings.shared.userId
//         addField("device_id", userId)
//        
//        let isPro = UserSettings.shared.isPaid
//        addField("is_paid", "\(isPro)")
    }
}


// MARK: - Data helper
private extension Data {
    mutating func append(_ string: String) {
        if let d = string.data(using: .utf8) { append(d) }
    }
}

