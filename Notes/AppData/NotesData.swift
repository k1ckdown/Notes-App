//
//  NotesData.swift
//  Notes
//
//  Created by Ivan Semenov on 09.02.2023.
//

import Foundation

final class NotesData {
    
    static let shared = NotesData()
    
    private init() {}
    
    let defaults = UserDefaults.standard
    
    private enum NotesDataKeys: String {
        case notes
    }
    
//    var notes: [Note] {
//        get {
//            let key = NotesDataKeys.notes.rawValue
//            guard let notes = defaults.stri
//        }
//    }
//
//    var titleAnswer: String {
//        get {
//            let key = CalculatorDataKeys.titleAnswer.rawValue
//            guard let titleAnswer = defaults.string(forKey: key) else {
//                defaults.set("20810", forKey: key)
//                return "20810"
//            }
//            return titleAnswer
//        } set {
//            defaults.set(newValue, forKey: CalculatorDataKeys.titleAnswer.rawValue)
//        }
//    }
    
}
