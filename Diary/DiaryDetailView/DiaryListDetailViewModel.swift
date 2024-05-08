//
//  DiaryListDetailViewModel.swift
//  Diary
//
//  Created by H on 5/2/24.
//

import Foundation

class DiaryListDetailViewModel {
    var diary: Diary
//    {
////        didSet {
////            didChangedDiary?(self)
////        }
//    }
    
    var didChangedDiary: ((Diary) -> Void)?
    
//    func update(model: Diary) {
//        diary = model
//    }
    
    init(diary: Diary) {
        self.diary = diary
    }
}
