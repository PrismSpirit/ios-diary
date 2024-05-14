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
        case viewWillDisappear
        case keyboardDidDismiss
    }
    
    enum Output {
        case updateTextView(body: String)
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
        input.sink { event in
            switch event {
            case .viewWillAppear:
                self.output.send(.updateTextView(body: self.body))
            case .viewWillDisappear:
                self.updateDiary(id: self.id, body: self.body)
            case .keyboardDidDismiss:
                break
            }
        }
        .store(in: &cancellables)
        return output.eraseToAnyPublisher()
    }
    
    func updateDiary(id: UUID, body: String) {
        diaryListDetailUseCase.updateDiary(diaryID: id, body: body).sink { completion in
            switch completion {
            case .finished: break
            case .failure(let error):
                break
            }
        } receiveValue: { _ in
            
        }
        .store(in: &cancellables)
    }
}
    
