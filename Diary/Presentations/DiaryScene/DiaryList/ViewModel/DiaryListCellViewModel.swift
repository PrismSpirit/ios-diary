//
//  DiaryListCellViewModel.swift
//  Diary
//
//  Created by Jaehun Lee on 5/7/24.
//

import Foundation

struct DiaryListCellViewModel: Equatable {
    let id: UUID
    let title: String
    let subTitle: String
    let editedDate: String
}

extension DiaryListCellViewModel {
    init(diary: Diary) {
        let splittedBody = diary.body.split(separator: "\n").map { String($0) }
        
        self.id = diary.id
        self.title = !splittedBody.isEmpty ? splittedBody[0] : "No Title"
        self.subTitle = splittedBody.count > 1 ? splittedBody[1] : "No Additional Text"
        self.editedDate = diary.editedDate.formatted(.defaultDateFormatStyle)
    }
}
