//
//  DiaryListViewModel.swift
//  Diary
//
//  Created by H on 5/2/24.
//

import Foundation
import CoreData

class DiaryListViewModel {
    var didChangeDiaries: ((DiaryListViewModel) -> Void)?
    var didOccurError: ((DiaryListViewModel) -> Void)?
    
    var diaries: [DiaryListDetailViewModel] = [] {
        didSet {
            didChangeDiaries?(self)
        }
    }
    
    var numberOfCells: Int {
        let diaries = CoreDataManager.shared.readDiaries()
        return diaries.count
    }
    
    func requestFetchData() {
        let diaries = CoreDataManager.shared.readDiaries()
        processFetchedDiary(diaries: diaries)
    }
    
//    func requestFetchData() {
//        let diaries = CoreDataManager.shared.readDiaries { diaries in
//            var detailviewModels = [DiaryListDetailViewModel]()
//            diaries.forEach { diary in
//                return detailviewModels.append(DiaryListDetailViewModel(diary: diary))
//            }
//        }
//    }
    
    func processFetchedDiary(diaries: [Diary]) {
        var detailviewModels = [DiaryListDetailViewModel]()
        diaries.forEach {
            detailviewModels.append(DiaryListDetailViewModel(diary: $0))
        }
        self.diaries = detailviewModels
    }
    
//    func createCellViewModel(diary: Diary) -> DiaryTableViewCellViewModel {
//        return DiaryTableViewCellViewModel(diary: diary)
//    }
    
    func getCellViewModel(index: Int) -> DiaryListDetailViewModel {
//        return diaries[index]
//        let diaries = CoreDataManager.shared.readDiaries { diaries in
////            return diaries.map { DiaryListDetailViewModel(diary: $0) }
//            return DiaryListDetailViewModel(diary: diaries[index])
//        }
        return DiaryListDetailViewModel(diary: CoreDataManager.shared.readDiaries()[index])
    }
    
    func getLatestCellViewModel() -> DiaryListDetailViewModel {
        let diaries = CoreDataManager.shared.readDiaries()
        let index = diaries.endIndex - 1
        return DiaryListDetailViewModel(diary: diaries[index])
    }
    
//    func addDiary() {
//        let diary = Diary(title: Date().description, body: String(repeating: Date().description, count: Int.random(in: 1...50)), editedDate: Date())
//        let diaryDetailViewModel = DiaryListDetailViewModel(diary: diary)
////        diaries.append(diaryDetailViewModel)
////        CoreDataManager.shared.createDiary(diary)
//        CoreDataManager.shared.createDiary(diary) { isSuccess in
//            if isSuccess {
//                self.diaries.append(diaryDetailViewModel)
//            }
//        }
//    }
    
    func addDiary() {
        let diary = Diary(title: "제목", body: "본문", editedDate: Date())
        let diaryDetailViewModel = DiaryListDetailViewModel(diary: diary)
        CoreDataManager.shared.createDiary(diary) { isSuccess in
            if isSuccess {
                self.diaries.append(diaryDetailViewModel)
            }
        }
    }
    
    func modifyDiary(index: Int) {
        guard let _ = diaries[safeIndex: index] else {
            return
        }
        
        let newDiary = Diary(title: "⭐️\(Date().description)", body: String(repeating: Date().description, count: Int.random(in: 1...50)), editedDate: Date())
//        diaries[index] = DiaryListDetailViewModel(diary: newDiary)
//        CoreDataManager.shared.updateDiary(index: index, newDiary: newDiary)
        CoreDataManager.shared.updateDiary(index: index, newDiary: newDiary) { isSuccess in
            if isSuccess {
                self.diaries[index] = DiaryListDetailViewModel(diary: newDiary)
            }
        }
    }
    
    func deleteDiary(index: Int) {
        guard let _ = diaries[safeIndex: index] else {
            return
        }
        
//        self.diaries.remove(at: index)
//        CoreDataManager.shared.deleteDiary(index)
        CoreDataManager.shared.deleteDiary(index) { isSuccess in
            if isSuccess {
                self.diaries.remove(at: index)
            }
        }
    }
}
