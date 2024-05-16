//
//  AppDIContainer.swift
//  Diary
//
//  Created by Prism, Gama on 5/16/24.
//

import UIKit

final class AppDIContainer {
    static let shared = AppDIContainer()
    
    lazy var coreDataStorage: CoreDataStorage = CoreDataStorage()
    lazy var diaryStorage: DiaryStorage = DiaryStorage(coreDataStorage: coreDataStorage)
    
    // MARK: - Repository
    
    func makeDiaryRepository() -> DiaryRepository {
        return DiaryRepository(diaryPersistentStorage: diaryStorage)
    }
    
    // MARK: - UseCase
    
    func makeDiaryListDetailUseCase() -> DiaryListDetailUseCase {
        return DiaryListDetailUseCase(diaryRepository: makeDiaryRepository())
    }
    
    func makeDiaryListUseCase() -> DiaryListUseCase {
        return DiaryListUseCase(diaryRepository: makeDiaryRepository())
    }
    
    // MARK: - ViewController
    
    func makeDiaryListViewController() -> DiaryListViewController {
        return DiaryListViewController(viewModel: makeDiaryListViewModel())
    }
    
    func makeDiaryDetailViewController(diary: Diary, isEditModeActivated: Bool = false) -> DiaryListDetailViewController {
        return DiaryListDetailViewController(viewModel: makeDiaryListDetailViewModel(diary: diary), isEditModeActivated: isEditModeActivated)
    }
    
    func makeDiaryTableViewCell() -> DiaryTableViewCell {
        return DiaryTableViewCell()
    }
    
    // MARK: - ViewModel
    
    func makeDiaryListViewModel() -> DiaryListViewModel {
        return DiaryListViewModel(diaryListUseCase: makeDiaryListUseCase())
    }
    
    func makeDiaryListDetailViewModel(diary: Diary) -> DiaryListDetailViewModel {
        return DiaryListDetailViewModel(diary: diary, diaryListDetailUseCase: makeDiaryListDetailUseCase())
    }
    
    func makeDiaryCellViewModel(diary: Diary) -> DiaryListCellViewModel {
        return DiaryListCellViewModel(diary: diary)
    }
}
