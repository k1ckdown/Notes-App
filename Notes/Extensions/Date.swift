//
//  Date.swift
//  Notes
//
//  Created by Ivan Semenov on 11.02.2023.
//

import Foundation

extension Date {
    func format() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.current
        
        if Calendar.current.isDateInToday(self) {
            dateFormatter.dateFormat = "HH:mm"
        } else {
            dateFormatter.dateFormat = "MMM d, yyyy"
        }
        
        return dateFormatter.string(from: self)
    }
}
