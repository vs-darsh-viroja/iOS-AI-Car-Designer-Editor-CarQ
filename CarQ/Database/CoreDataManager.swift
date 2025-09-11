//
//  CoreDataManager.swift
//  CarQ
//
//  Enhanced with individual record deletion capabilities
//

import Foundation
import CoreData

final class CoreDataManager {
    static let shared = CoreDataManager()
    private init() {}
    private var ctx: NSManagedObjectContext { PersistenceController.shared.container.viewContext }

    @discardableResult
    func saveLocalHistory(
        locals: [URL],
        remotes: [URL?],
        isGenerated: Bool,
        isEdited: Bool,
        prompt: String?,
        source: String?
    ) throws -> [NSManagedObjectID] {
        let now = Date()
        var ids: [NSManagedObjectID] = []
        
        // Get the base folder to calculate relative paths
        let baseFolder = getImagesDirectory()
        
        for (idx, fileURL) in locals.enumerated() {
            let rec = NSEntityDescription.insertNewObject(forEntityName: "ImageRecord", into: ctx)
            rec.setValue(UUID().uuidString, forKey: "id")
            
            // Store relative path instead of full path
            let relativePath = fileURL.lastPathComponent // Just the filename
            rec.setValue(relativePath, forKey: "localPath")
            
            rec.setValue(remotes[idx]?.absoluteString, forKey: "remoteURL")
            rec.setValue(now,                 forKey: "createdAt")
            rec.setValue(isGenerated,         forKey: "isGenerated")
            rec.setValue(isEdited,            forKey: "isEdited")
            rec.setValue(prompt,              forKey: "prompt")
            rec.setValue(source,              forKey: "source")
            ids.append(rec.objectID)
        }
        if ctx.hasChanges { try ctx.save() }
        return ids
    }
    
    func fetchHistory(kind: HistoryKind?, newestFirst: Bool) throws -> [ImageRecord] {
        let req = NSFetchRequest<NSManagedObject>(entityName: "ImageRecord")
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
        return try (ctx.fetch(req) as? [ImageRecord]) ?? []
    }
    
    // NEW: Delete a specific record by its ObjectID
    func deleteRecord(objectID: NSManagedObjectID) throws {
        guard let record = try? ctx.existingObject(with: objectID) as? ImageRecord else {
            throw CoreDataError.recordNotFound
        }
        
        // Delete the local file if it exists
        if let localPath = record.localPath {
            let baseFolder = getImagesDirectory()
            let fileURL = baseFolder.appendingPathComponent(localPath)
            try? FileManager.default.removeItem(at: fileURL)
        }
        
        // Delete the CoreData record
        ctx.delete(record)
        if ctx.hasChanges { try ctx.save() }
    }
    
    // NEW: Delete multiple records by their ObjectIDs
    func deleteRecords(objectIDs: [NSManagedObjectID]) throws {
        for objectID in objectIDs {
            do {
                try deleteRecord(objectID: objectID)
            } catch {
                print("Failed to delete record with ID \(objectID): \(error)")
                // Continue with other deletions even if one fails
            }
        }
    }
    
    // NEW: Delete a record by finding it with specific criteria
    func deleteRecordByCriteria(localPath: String? = nil, remoteURL: String? = nil) throws {
        let req = NSFetchRequest<NSManagedObject>(entityName: "ImageRecord")
        var predicates: [NSPredicate] = []
        
        if let localPath = localPath {
            predicates.append(NSPredicate(format: "localPath == %@", localPath))
        }
        
        if let remoteURL = remoteURL {
            predicates.append(NSPredicate(format: "remoteURL == %@", remoteURL))
        }
        
        guard !predicates.isEmpty else {
            throw CoreDataError.invalidCriteria
        }
        
        req.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        
        let records = try (ctx.fetch(req) as? [ImageRecord]) ?? []
        
        for record in records {
            // Delete local file
            if let localPath = record.localPath {
                let baseFolder = getImagesDirectory()
                let fileURL = baseFolder.appendingPathComponent(localPath)
                try? FileManager.default.removeItem(at: fileURL)
            }
            
            // Delete CoreData record
            ctx.delete(record)
        }
        
        if ctx.hasChanges { try ctx.save() }
    }
    
    func deleteHistory(kind: HistoryKind?) throws {
         let req = NSFetchRequest<NSFetchRequestResult>(entityName: "ImageRecord")
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
         
         // First fetch the records to delete their local files
         let fetchReq = NSFetchRequest<NSManagedObject>(entityName: "ImageRecord")
         fetchReq.predicate = req.predicate
         let recordsToDelete = try (ctx.fetch(fetchReq) as? [ImageRecord]) ?? []
         
         // Delete local files
         let baseFolder = getImagesDirectory()
         for record in recordsToDelete {
             if let localPath = record.localPath {
                 let fileURL = baseFolder.appendingPathComponent(localPath)
                 try? FileManager.default.removeItem(at: fileURL)
             }
         }
         
         // Batch delete from CoreData
         let deleteRequest = NSBatchDeleteRequest(fetchRequest: req)
         try ctx.execute(deleteRequest)
         try ctx.save()
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
