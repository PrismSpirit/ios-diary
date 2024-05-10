//
//  DiaryListDetailUseCase.swift
//  Diary
//
//  Created by Jaehun Lee on 5/7/24.
//

import Foundation
import Combine

final class DiaryListDetailUseCase {
    private let diaryRepository: DiaryRepositoryProtocol
    
    init(diaryRepository: DiaryRepositoryProtocol) {
        self.diaryRepository = diaryRepository
    }
    
    func updateDiary(diaryID: UUID, body: String) -> AnyPublisher<Void, Error> {
        return diaryRepository.updateDiary(diaryID: diaryID, body: body)
    }
    
    func deleteDiary(diaryID: UUID) -> AnyPublisher<Void, Error> {
        return diaryRepository.deleteDiary(diaryID: diaryID)
    }
}
