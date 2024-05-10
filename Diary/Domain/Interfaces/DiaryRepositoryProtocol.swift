//
//  DiaryRepositoryProtocol.swift
//  Diary
//
//  Created by Jaehun Lee on 5/7/24.
//

import Foundation
import Combine

protocol DiaryRepositoryProtocol {
    func loadDiaries() -> AnyPublisher<[Diary], Error>
    func addDiary(diary: Diary) -> AnyPublisher<Void, Error>
    func updateDiary(diaryID: UUID, body: String) -> AnyPublisher<Void, Error>
    func deleteDiary(diaryID: UUID) -> AnyPublisher<Void, Error>
}
