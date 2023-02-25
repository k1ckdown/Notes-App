//
//  NoteListLayout.swift
//  Notes
//
//  Created by Ivan Semenov on 25.02.2023.
//

import UIKit

class NoteListLayout: UICollectionViewFlowLayout {
    override func prepare() {
        super.prepare()
        
        guard let collectionView = collectionView else { return }
        
        scrollDirection = .vertical
    
        minimumLineSpacing = 20
        
        let cvWidth = collectionView.bounds.width * 0.9;
        let cvHeight = collectionView.bounds.height;
        
        let cellWidth = cvWidth;
        let cellHeight = cvHeight / 6;
        
        itemSize = CGSize(width: cellWidth, height: cellHeight)
    }
}
