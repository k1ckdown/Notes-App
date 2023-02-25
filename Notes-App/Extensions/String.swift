//
//  String.swift
//  Notes-App
//
//  Created by Ivan Semenov on 12.02.2023.
//

import Foundation

extension String {
    var isBlank: Bool {
        let replaced = self.trimmingCharacters(in: .whitespaces)
        return replaced.isEmpty
    }
}
