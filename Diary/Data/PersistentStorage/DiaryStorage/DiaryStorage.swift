//
//  CoreDataStorage.swift
//  Diary
//
//  Created by Jaehun Lee on 5/6/24.
//

import Foundation
import CoreData

final class DiaryStorage {
    private let coreDataStorage: CoreDataStorage
    
    init(coreDataStorage: CoreDataStorage = CoreDataStorage.shared) {
        self.coreDataStorage = coreDataStorage
    }
    
    func loadDiaries() async throws -> [Diary] {
        let taskContext = coreDataStorage.newTaskContext()
        let request: NSFetchRequest<DiaryEntity> = DiaryEntity.fetchRequest()
        
        request.predicate = NSPredicate(format: "TRUEPREDICATE")
        
        return try await taskContext.perform {
            try taskContext.fetch(request).map { $0.toDomain() }
        }
    }
    
    func addDiary(diary: Diary) async throws {
        let taskContext = coreDataStorage.newTaskContext()
        let diaryEntity = DiaryEntity(diary: diary, insertInto: taskContext)
        
        try await taskContext.perform {
            try taskContext.save()
        }
    }
    
    func updateDiary(diaryID: UUID, body: String) async throws {
        let taskContext = coreDataStorage.newTaskContext()
        let request: NSFetchRequest<DiaryEntity> = DiaryEntity.fetchRequest()
        
        request.predicate = NSPredicate(format: "id == %@", diaryID as CVarArg)
        
        try await taskContext.perform {
            if let result = try taskContext.fetch(request).first {
                result.setValue(body, forKey: "body")
                result.setValue(Date(), forKey: "editedDate")
                try taskContext.save()
            }
        }
    }
    
    func deleteDiary(diaryID: UUID) async throws {
        let taskContext = coreDataStorage.newTaskContext()
        let request: NSFetchRequest<DiaryEntity> = DiaryEntity.fetchRequest()
        
        request.predicate = NSPredicate(format: "id == %@", diaryID as CVarArg)
        
        try await taskContext.perform {
            if let result = try taskContext.fetch(request).first {
                taskContext.delete(result)
                try taskContext.save()
            }
        }
    }
}
