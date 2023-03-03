//
//  NoteLayoutType.swift
//  Notes-App
//
//  Created by Ivan Semenov on 26.02.2023.
//

import UIKit

enum NoteLayoutType {
    case list, gallery
    
    var layout: UICollectionViewFlowLayout {
        switch self {
        case .list:
            return NoteListLayout()
        case .gallery:
            return NoteGalleryLayout()
        }
    }
}
