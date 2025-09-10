//
//  ShareablePhoto.swift
//  CarQ
//
//  Created by Purvi Sancheti on 10/09/25.
//

import Foundation
import UniformTypeIdentifiers
import CoreTransferable
import UIKit


struct ShareablePhoto: Transferable {
    let uiImage: UIImage

    static var transferRepresentation: some TransferRepresentation {
        DataRepresentation(exportedContentType: .png) { photo in
            guard let data = photo.uiImage.pngData() else {
                throw NSError(domain: "ShareablePhoto", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to encode PNG"])
            }
            return data
        }

    }
}
