//
//  JSONService.swift
//  Diary
//
//  Created by H on 5/2/24.
//

import UIKit

class JSONService {
    func loadDiary(completion: @escaping (_ success: Bool, _ diaries: [Diary], _ error: Error?) -> ()) {
        guard let asset = NSDataAsset.init(name: Constants.jsonFileName) else {
            completion(false, [], CustomErorr.invalidFileName)
            return
        }
         
        do {
            let diaries = try JSONDecoder().decode([DiaryDTO].self, from: asset.data).map { $0.toModel() }
            completion(true, diaries, nil)
        } catch let decodingError as DecodingError {
            completion(false, [], decodingError)
        } catch {
            completion(false, [], error)
        }
    }
}
