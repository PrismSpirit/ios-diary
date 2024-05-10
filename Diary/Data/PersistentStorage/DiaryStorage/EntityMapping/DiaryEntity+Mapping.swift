//
//  DiaryEntity+Mapping.swift
//  Diary
//
//  Created by Jaehun Lee on 5/6/24.
//

import Foundation
import CoreData

extension DiaryEntity {
    convenience init(diary: Diary, insertInto context: NSManagedObjectContext) {
        self.init(context: context)
        id = diary.id
        body = diary.body
        editedDate = diary.editedDate
    }
}

extension DiaryEntity {
    func toDomain() -> Diary {
        return .init(
            id: id ?? UUID(),
            body: body ?? "",
            editedDate: editedDate ?? Date()
        )
    }
}
