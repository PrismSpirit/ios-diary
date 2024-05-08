//
//  CoreDataManager.swift
//  Diary
//
//  Created by H on 5/6/24.
//

import UIKit
import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()
    
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    lazy var persistentContainer = appDelegate?.persistentContainer
    lazy var context = persistentContainer?.viewContext
    
    let dataModelName = "DiaryCoreData"
    
    func fetchCoreDataDiaries() -> [DiaryCoreDataEntity] {
        guard let context = context else {
            return []
        }
        
        do {
            let fetchRequest = DiaryCoreDataEntity.fetchRequest()
            let fetchRequestResult = try context.fetch(fetchRequest)
            return fetchRequestResult
        } catch {
            print(error.localizedDescription)
            return []
        }
    }
    
    func readDiaries() -> [Diary] {
        let fetchRequestResult = fetchCoreDataDiaries()
        
        var diaries: [Diary] = []
        for result in fetchRequestResult {
            let diary = Diary(title: result.title ?? "", body: result.body ?? "", editedDate: result.editedDate ?? Date())
            diaries.append(diary)
        }
        return diaries
    }
    
    func readDiaries(completion: @escaping ([Diary]) -> Void) {
        let fetchRequestResult = fetchCoreDataDiaries()
        
        var diaries: [Diary] = []
        for result in fetchRequestResult {
            let diary = Diary(title: result.title ?? "", body: result.body ?? "", editedDate: result.editedDate ?? Date())
            diaries.append(diary)
        }
        
        completion(diaries)
    }
    
    func createDiary(_ newDiary: Diary) {
        guard let context = context else {
            return
        }
        
        let newDiaryEntity = DiaryCoreDataEntity(context: context)
        newDiaryEntity.title = newDiary.title
        newDiaryEntity.body = newDiary.body
        newDiaryEntity.editedDate = newDiary.editedDate
        
        do {
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func createDiary(_ newDiary: Diary, completion: @escaping ((Bool)) -> Void) {
        guard let context = context else {
            return
        }
        
        let newDiaryEntity = DiaryCoreDataEntity(context: context)
        newDiaryEntity.title = newDiary.title
        newDiaryEntity.body = newDiary.body
        newDiaryEntity.editedDate = newDiary.editedDate
        
        do {
            try context.save()
            completion(true)
        } catch {
            print(error.localizedDescription)
            completion(false)
        }
    }
    
    func updateDiary(index: Int, newDiary: Diary) {
        guard let context = context else {
            return
        }
        
        let fetchResults = fetchCoreDataDiaries()
        let objectUpdate = fetchResults[index] as NSManagedObject
        objectUpdate.setValue(newDiary.title, forKey: "title")
        objectUpdate.setValue(newDiary.body, forKey: "body")
        objectUpdate.setValue(newDiary.editedDate, forKey: "editedDate")
        
        do {
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func updateDiary(index: Int, newDiary: Diary, completion: @escaping ((Bool) -> Void)) {
        guard let context = context else {
            return
        }
        
        let fetchResults = fetchCoreDataDiaries()
        let objectUpdate = fetchResults[index] as NSManagedObject
        objectUpdate.setValue(newDiary.title, forKey: "title")
        objectUpdate.setValue(newDiary.body, forKey: "body")
        objectUpdate.setValue(newDiary.editedDate, forKey: "editedDate")
        
        do {
            try context.save()
            completion(true)
        } catch {
            print(error.localizedDescription)
            completion(false)
        }
    }
    
    func deleteDiary(_ index: Int) {
        guard let context = context else {
            return
        }
        
        var fetchResults = fetchCoreDataDiaries()
        context.delete(fetchResults[index])
        
        do {
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func deleteDiary(_ index: Int, completion: @escaping ((Bool) -> Void)) {
        guard let context = context else {
            return
        }
        
        var fetchResults = fetchCoreDataDiaries()
        context.delete(fetchResults[index])
        
        do {
            try context.save()
            completion(true)
        } catch {
            print(error.localizedDescription)
            completion(false)
        }
    }
}
