//
//  DiaryRepository.swift
//  Diary
//
//  Created by Jaehun Lee on 5/6/24.
//

import Foundation
import Combine

final class DiaryRepository: DiaryRepositoryProtocol {
    private let diaryPersistentStorage: DiaryStorage
    
    init(diaryPersistentStorage: DiaryStorage) {
        self.diaryPersistentStorage = diaryPersistentStorage
    }
    
    func loadDiaries() -> AnyPublisher<[Diary], any Error> {
        return Future {
            try await self.diaryPersistentStorage.loadDiaries()
        }
        .eraseToAnyPublisher()
    }
    
    func addDiary(diary: Diary) -> AnyPublisher<Void, any Error> {
        return Future {
            try await self.diaryPersistentStorage.addDiary(diary: diary)
        }
        .eraseToAnyPublisher()
    }
    
    func updateDiary(diaryID: UUID, body: String) -> AnyPublisher<Void, any Error> {
        return Future {
            try await self.diaryPersistentStorage.updateDiary(diaryID: diaryID, body: body)
        }
        .eraseToAnyPublisher()
    }
    
    func deleteDiary(diaryID: UUID) -> AnyPublisher<Void, any Error> {
        return Future {
            try await self.diaryPersistentStorage.deleteDiary(diaryID: diaryID)
        }
        .eraseToAnyPublisher()
    }
}
