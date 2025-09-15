//
//  CoreDataManager.swift
//  CarQ
//
//  Enhanced with individual record deletion capabilities
//

import Foundation
import CoreData
import OSLog

final class CoreDataManager {
    static let shared = CoreDataManager()
    private init() {}
    private var ctx: NSManagedObjectContext { PersistenceController.shared.container.viewContext }
    private let coreLogger = Logger(subsystem: "CarQ", category: "CoreDataManager")
    @discardableResult
    // CoreDataManager.swift
    func saveLocalHistory(
        locals: [URL],
        remotes: [URL?],
        isGenerated: Bool,
        isEdited: Bool,
        prompt: String?,
        source: String?
    ) throws -> [NSManagedObjectID] {
        var inserted: [NSManagedObject] = []

        for (idx, fileURL) in locals.enumerated() {
            let rec = NSEntityDescription.insertNewObject(forEntityName: "ImageRecord", into: ctx)
            rec.setValue(UUID().uuidString, forKey: "id")
            rec.setValue(fileURL.lastPathComponent, forKey: "localPath")
            rec.setValue(remotes[idx]?.absoluteString, forKey: "remoteURL")
            rec.setValue(Date(), forKey: "createdAt")
            rec.setValue(isGenerated, forKey: "isGenerated")
            rec.setValue(isEdited, forKey: "isEdited")
            rec.setValue(prompt, forKey: "prompt")
            rec.setValue(source, forKey: "source")
            inserted.append(rec)
        }

        // 🔑 Make objectIDs permanent, then save
        if !inserted.isEmpty {
            try ctx.obtainPermanentIDs(for: inserted)
        }
        if ctx.hasChanges { try ctx.save() }

        // Now their objectID values are permanent & valid to use outside
        return inserted.map { $0.objectID }
    }

    
    func fetchHistory(kind: HistoryKind?, newestFirst: Bool) throws -> [ImageRecord] {
        let req = NSFetchRequest<ImageRecord>(entityName: "ImageRecord")  // ✅ Correct type
        var preds: [NSPredicate] = []

        if let kind {
            switch kind {
            case .generated:
                preds.append(NSPredicate(format: "isGenerated == YES"))
            case .edited:
                preds.append(NSPredicate(format: "isEdited == YES"))
            }
        }
        if !preds.isEmpty {
            req.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: preds)
        }
        req.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: !newestFirst)]
        return try ctx.fetch(req)  // ✅ No casting needed
    }
    // NEW: Delete a specific record by its ObjectID
    func deleteRecord(objectID: NSManagedObjectID) throws {
        let beforeCount = try fetchHistory(kind: nil, newestFirst: true).count
        coreLogger.info("deleteRecord start. Total before: \(beforeCount)")

        guard let record = try? ctx.existingObject(with: objectID) as? ImageRecord else {
            coreLogger.error("deleteRecord: record not found for \(String(describing: objectID))")
            throw CoreDataError.recordNotFound
        }

        if let localPath = record.localPath {
            let fileURL = getImagesDirectory().appendingPathComponent(localPath)
            let existed = FileManager.default.fileExists(atPath: fileURL.path)
            try? FileManager.default.removeItem(at: fileURL)
            coreLogger.info("Tried removing file '\(fileURL.lastPathComponent)'. Existed before? \(existed, privacy: .public)")
        }

        ctx.delete(record)
        if ctx.hasChanges { try ctx.save() }

        let afterCount = try fetchHistory(kind: nil, newestFirst: true).count
        coreLogger.info("deleteRecord done. Total after: \(afterCount)")
    }


    func deleteHistory(kind: HistoryKind?) throws {
        let req = NSFetchRequest<NSFetchRequestResult>(entityName: "ImageRecord")
        var preds: [NSPredicate] = []
        if let kind {
            switch kind {
            case .generated: preds.append(NSPredicate(format: "isGenerated == YES"))
            case .edited:    preds.append(NSPredicate(format: "isEdited == YES"))
            }
        }
        if !preds.isEmpty { req.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: preds) }

        // delete files first
        let fetchReq = NSFetchRequest<NSManagedObject>(entityName: "ImageRecord")
        fetchReq.predicate = req.predicate
        let recordsToDelete = try (ctx.fetch(fetchReq) as? [ImageRecord]) ?? []
        let base = getImagesDirectory()
        for record in recordsToDelete {
            if let localPath = record.localPath {
                try? FileManager.default.removeItem(at: base.appendingPathComponent(localPath))
            }
        }

        // batch delete records
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: req)
        try ctx.execute(deleteRequest)
        try ctx.save()
        coreLogger.info("deleteHistory completed. Removed \(recordsToDelete.count) records")
    }

    
    // Helper function to get the images directory
    private func getImagesDirectory() -> URL {
        let appSupport = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
        let folder = appSupport.appendingPathComponent("CarQ", isDirectory: true)
        try? FileManager.default.createDirectory(at: folder, withIntermediateDirectories: true)
        let images = folder.appendingPathComponent("Images", isDirectory: true)
        try? FileManager.default.createDirectory(at: images, withIntermediateDirectories: true)
        return images
    }
}

// NEW: Custom error types for better error handling
enum CoreDataError: Error {
    case recordNotFound
    case invalidCriteria
    case saveFailed
    case deleteFailed(String)
    
    var localizedDescription: String {
        switch self {
        case .recordNotFound:
            return "Record not found in database"
        case .invalidCriteria:
            return "Invalid search criteria provided"
        case .saveFailed:
            return "Failed to save to database"
        case .deleteFailed(let reason):
            return "Failed to delete record: \(reason)"
        }
    }
}
