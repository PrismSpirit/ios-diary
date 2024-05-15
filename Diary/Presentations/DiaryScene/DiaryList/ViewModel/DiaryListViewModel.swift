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
        case diaryShareButtonDidTouchUp(id: UUID)
        case diaryDeleteButtonDidTouchUp(id: UUID)
    }
    
    enum Output {
        case diaryDidLoad
        case diaryDidAdd(diary: Diary)
    }
    
    private let diaryListUseCase: DiaryListUseCase
    private let output: PassthroughSubject<Output, Never> = .init()
    private var cancellables: Set<AnyCancellable> = .init()
    
    var diaries: [Diary] = []
    
    init(diaryListUseCase: DiaryListUseCase) {
        self.diaryListUseCase = diaryListUseCase
    }
    
    func addDiaryToMemory(_ diary: Diary) {
        diaries.insert(diary, at: 0)
    }
    
    func deleteDiaryFromMemory(at index: Int) {
        diaries.remove(at: index)
    }
    
    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input.sink { event in
            switch event {
            case .viewIsAppearing:
                self.loadDiaryFromDisk()
            case .diaryAddButtonDidTouchUp:
                self.addDiaryToDisk()
            case .diaryShareButtonDidTouchUp(let diaryID):
                break
            case .diaryDeleteButtonDidTouchUp(let diaryID):
                self.deleteDiaryFromDisk(id: diaryID)
            }
        }
        .store(in: &cancellables)
        return output.eraseToAnyPublisher()
    }
    
    private func loadDiaryFromDisk() {
        diaryListUseCase.loadDiaries()
            .sink { completion in
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
    
    private func addDiaryToDisk() {
        let newDiary = Diary(id: UUID(), body: "", editedDate: Date())
        
        diaryListUseCase.addDiary(diary: newDiary).sink { completion in
            switch completion {
            case .finished: break
            case .failure(let error):
                // TODO: Alert Needed
                break
            }
        } receiveValue: { _ in
            self.output.send(.diaryDidAdd(diary: newDiary))
        }
        .store(in: &cancellables)
    }
    
    private func deleteDiaryFromDisk(id: UUID) {
        diaryListUseCase.deleteDiary(diaryID: id).sink { completion in
            switch completion {
            case .finished: break
            case .failure(let error):
                // TODO: Alert Needed
                break
            }
        } receiveValue: { _ in
            
        }
        .store(in: &cancellables)
    }
}
