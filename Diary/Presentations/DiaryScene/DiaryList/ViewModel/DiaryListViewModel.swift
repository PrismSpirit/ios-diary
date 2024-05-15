//
//  DiaryListViewModel.swift
//  Diary
//
//  Created by Jaehun Lee on 5/7/24.
//

import Foundation
import Combine

final class DiaryListViewModel: ObservableObject {
    enum Input {
        case viewIsAppearing
        case diaryAddButtonDidTouchUp
        case diaryDeleteButtonDidTouchUp(index: Int)
    }
    
    enum Output {
        case diaryDidLoad
        case diaryDidAdd(diary: Diary)
        case diaryDidDelete(at: Int)
    }
    
    private let diaryListUseCase: DiaryListUseCase
    private let output: PassthroughSubject<Output, Never> = .init()
    private var cancellables: Set<AnyCancellable> = .init()
    
    private(set) var diaries: [Diary] = []
    
    init(diaryListUseCase: DiaryListUseCase) {
        self.diaryListUseCase = diaryListUseCase
    }
    
    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input.sink { event in
            switch event {
            case .viewIsAppearing:
                self.loadDiaries()
            case .diaryAddButtonDidTouchUp:
                let newDiary = Diary(id: UUID(), body: "", editedDate: Date())
                self.diaries.insert(newDiary, at: 0)
                self.addDiary(diary: newDiary)
            case .diaryDeleteButtonDidTouchUp(let index):
                self.deleteDiary(at: index)
            }
        }
        .store(in: &cancellables)
        return output.eraseToAnyPublisher()
    }
    
    private func loadDiaries() {
        diaryListUseCase.loadDiaries().sink { completion in
            switch completion {
            case .finished: break
            case .failure(let error):
                // TODO: Alert Needed
                break
            }
        } receiveValue: { diaries in
            self.diaries = diaries
            self.output.send(.diaryDidLoad)
        }
        .store(in: &cancellables)
    }
    
    private func addDiary(diary: Diary) {
        diaryListUseCase.addDiary(diary: diary).sink { completion in
            switch completion {
            case .finished: break
            case .failure(let error):
                // TODO: Alert Needed
                break
            }
        } receiveValue: { _ in
            self.output.send(.diaryDidAdd(diary: diary))
        }
        .store(in: &cancellables)
    }
    
    private func deleteDiary(at index: Int) {
        let diaryID = self.diaries[index].id
        diaries.remove(at: index)
        
        diaryListUseCase.deleteDiary(diaryID: diaryID).sink { completion in
            switch completion {
            case .finished: break
            case .failure(let error):
                // TODO: Alert Needed
                break
            }
        } receiveValue: { _ in
            self.output.send(.diaryDidDelete(at: index))
        }
        .store(in: &cancellables)
    }
}
