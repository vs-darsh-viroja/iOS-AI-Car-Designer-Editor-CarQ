//
//  APIModels.swift
//  CarQ
//
//  Created by Purvi Sancheti on 10/09/25.
//

import Foundation

// MARK: - Image Upload Response

struct ImageUploadResponse: Codable {
    let status: Bool
    let data: ImageUploadData?
}

struct ImageUploadData: Codable {
    let id: String
}

// MARK: - Result Response

struct ResultResponse: Codable {
    let status: Bool
    let data: [String]?
}

struct ResultData {
    let id: String
    let imageURLs: [String]
    var bestImageURL: String? { imageURLs.first }
}
