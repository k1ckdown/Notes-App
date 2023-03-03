//
//  UIFont.swift
//  Notes-App
//
//  Created by Ivan Semenov on 03.03.2023.
//

import Foundation
import UIKit

extension UIFont {
    static var titleNote = UIFont(name: "KohinoorDevanagari-Semibold", size: 26)
    static var previewTitleNote = UIFont(name: "KohinoorDevanagari-Regular", size: 21)
    
    static var textNote = UIFont.systemFont(ofSize: 19, weight: .regular)
    static var previewTextNote = UIFont.systemFont(ofSize: 16)
}
