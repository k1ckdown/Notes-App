//
//  NotesScreenViewController.swift
//  Notes
//
//  Created by Ivan Semenov on 09.02.2023.
//

import UIKit
import SnapKit

class NotesScreenViewController: UIViewController {
    
    private let headerLabel = UILabel()
    private let addNoteButton = UIButton(type: .system)
    
    lazy private var notesCollection: UICollectionView = {
        let layout = UICollectionViewLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collectionView
    }()
    
    private let viewModel: NotesScreenViewModel
    
    init(with viewModel: NotesScreenViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }
    
    private func setup() {
        setupSuperView()
        setupHeaderLabel()
        setupAddNoteButton()
    }
    
    private func setupSuperView() {
        view.backgroundColor = .backgroundApp
    }
    
    private func setupHeaderLabel() {
        view.addSubview(headerLabel)
        
        headerLabel.text = viewModel.textForHeaderLabel
        headerLabel.textColor = .headerText
        headerLabel.textAlignment = .left
        headerLabel.font = UIFont.systemFont(ofSize: 30, weight: .medium)
        
        headerLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(8)
            make.leading.equalToSuperview().offset(60)
        }
    }
    
    private func setupAddNoteButton() {
        view.addSubview(addNoteButton)
        
        addNoteButton.setImage(UIImage(systemName: "square.and.pencil"), for: .normal)
        addNoteButton.imageView?.layer.transform = CATransform3DMakeScale(1, 1, 1)
        addNoteButton.tintColor = .white
        addNoteButton.backgroundColor = .appColor
        addNoteButton.layer.cornerRadius = 65 / 2
        
        addNoteButton.snp.makeConstraints { make in
            make.height.width.equalTo(65)
            make.trailing.bottom.equalToSuperview().inset(40)
        }
    }
}
