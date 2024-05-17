//
//  DiaryListDetailViewModel.swift
//  Diary
//
//  Created by Jaehun Lee on 5/10/24.
//

import Foundation
import Combine

final class DiaryListDetailViewModel {
    enum Input {
        case viewWillAppear
        case keyboardDidDismiss
        case didEnterBackground
        case diaryDeleteActionSheetDidTouchUp(id: UUID)
    }
    
    enum Output {
        case updateTextView(text: String)
        case diaryDidDelete
    }
    
    private let diaryListDetailUseCase: DiaryListDetailUseCase
    private var output: PassthroughSubject<Output, Never> = .init()
    private var cancellables: Set<AnyCancellable> = .init()
    
    let id: UUID
    var editedDate: String
    var body: String
    
    init(   
        diary: Diary,
        diaryListDetailUseCase: DiaryListDetailUseCase
    ) {
        self.id = diary.id
        self.editedDate = diary.editedDate.formatted(.defaultDateFormatStyle)
        self.body = diary.body
        self.diaryListDetailUseCase = diaryListDetailUseCase
    }
    
    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input.sink { [weak self] event in
            guard let self else { return }
            switch event {
            case .viewWillAppear:
                self.output.send(.updateTextView(text: self.body))
            case .keyboardDidDismiss, .didEnterBackground:
                self.updateDiary(id: self.id, body: self.body)
            case .diaryDeleteActionSheetDidTouchUp(let id):
                self.deleteDiary(id: id)
            }
        }
        .store(in: &cancellables)
        return output.eraseToAnyPublisher()
    }
    
    private func updateDiary(id: UUID, body: String) {
        diaryListDetailUseCase.updateDiary(diaryID: id, body: body).sink { completion in
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
    
    private func deleteDiary(id: UUID) {
        diaryListDetailUseCase.deleteDiary(diaryID: id).sink { completion in
            switch completion {
            case .finished: break
            case .failure(let error):
                // TODO: Alert Needed
                break
            }
        } receiveValue: { [weak self] _ in
            self?.output.send(.diaryDidDelete)
        }
        .store(in: &cancellables)
    }
}
