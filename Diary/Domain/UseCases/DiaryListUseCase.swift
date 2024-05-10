//
//  DiaryListUseCase.swift
//  Diary
//
//  Created by Jaehun Lee on 5/7/24.
//

import Foundation
import Combine

final class DiaryListUseCase {
    private let diaryRepository: DiaryRepositoryProtocol
    
    init(diaryRepository: DiaryRepositoryProtocol) {
        self.diaryRepository = diaryRepository
    }
    
    func loadDiaries() -> AnyPublisher<[Diary], Error> {
        return diaryRepository.loadDiaries()
    }
    
    func addDiary(diary: Diary) -> AnyPublisher<Void, Error> {
        return diaryRepository.addDiary(diary: diary)
    }
    
    func deleteDiary(diaryID: UUID) -> AnyPublisher<Void, Error> {
        return diaryRepository.deleteDiary(diaryID: diaryID)
    }
}
