//
//  DiaryListViewModel.swift
//  Diary
//
//  Created by Jaehun Lee on 5/7/24.
//

import Foundation
import Combine

final class DiaryListViewModel {
    enum Input {
        case viewWillAppear
        case diaryAddDidTouchUp
        case diaryShareDidTouchUp(index: Int)
        case diaryDeleteDidTouchUp(id: UUID)
        case diaryDidSelect(index: Int)
    }
    
    enum Output {
        case loadDiaryDidFail(error: Error)
        case loadDiaryDidSuccess
        case addDiaryDidSuccess
    }
    
    private let diaryListUseCase: DiaryListUseCase
    private let output: PassthroughSubject<Output, Never> = .init()
    private var cancellables: Set<AnyCancellable> = .init()
    
    var items: [DiaryListCellViewModel] = []
    
    init(diaryListUseCase: DiaryListUseCase) {
        self.diaryListUseCase = diaryListUseCase
    }
    
    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input.sink { [weak self] event in
            switch event {
            case .viewWillAppear:
                self?.loadDiaries()
            case .diaryAddDidTouchUp:
                self?.addDiary()
            case .diaryShareDidTouchUp:
                break
            case .diaryDeleteDidTouchUp(let diaryID):
                self?.deleteDiary(id: diaryID)
            case .diaryDidSelect(let index):
                break
            }
        }
        .store(in: &cancellables)
        return output.eraseToAnyPublisher()
    }
    
    private func loadDiaries() {
        diaryListUseCase.loadDiaries()
            .catch { [weak self] _ in
                Just([])
            }
            .sink { [weak self] in
                self?.items = $0.map { DiaryListCellViewModel(diary: $0) }
                self?.output.send(.loadDiaryDidSuccess)
            }
            .store(in: &cancellables)
    }
    
    private func addDiary() {
        let newDiary = Diary(id: UUID(), body: "default body", editedDate: Date())
        
        diaryListUseCase.addDiary(diary: newDiary).sink { [weak self] completion in
            if case .failure(let error) = completion {
                
            }
        } receiveValue: { [weak self] in
            self?.loadDiaries()
            self?.output.send(.addDiaryDidSuccess)
        }
        .store(in: &cancellables)
    }
    
    private func deleteDiary(id: UUID) {
        diaryListUseCase.deleteDiary(diaryID: id).sink { [weak self] completion in
            if case .failure(let error) = completion {
                
            }
        } receiveValue: { [weak self] in
            self?.loadDiaries()
        }
        .store(in: &cancellables)
    }
}
