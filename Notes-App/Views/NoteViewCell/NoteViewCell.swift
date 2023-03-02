//
//  NoteViewCell.swift
//  Notes-App
//
//  Created by Ivan Semenov on 09.02.2023.
//

import UIKit

final class NoteViewCell: UICollectionViewCell {
    
    static let identifier = "NoteViewCell"
    
    var isSwiped: Bool = false {
        didSet {
            updateAppearance()
        }
    }
    
    // MARK: - Private properties
    
    private let previewTitleNoteLabel = UILabel()
    private let previewTextNoteLabel = UILabel()
    
    private let separatorView = UIView()
    private let dateCreatedNoteLabel = UILabel()
    private let dateModifiedNoteLabel = UILabel()
    
    // MARK: - Inits
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        layer.borderColor = UIColor.borderNote.cgColor
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updatNumberOfLinesText()
    }
    
    // MARK: - Configure
    
    func configure(with viewModel: NoteViewCellViewModel) {
        previewTitleNoteLabel.text = viewModel.titleNote
        previewTextNoteLabel.text = viewModel.textNote
        dateCreatedNoteLabel.text = viewModel.dateCreated
        dateModifiedNoteLabel.text = viewModel.dateModified
        layer.borderColor = viewModel.isSelect ? UIColor.borderSelectedNote.cgColor : UIColor.borderNote.cgColor
    }
    
    // MARK: - Private methods
    
    private func updateAppearance() {
        layer.borderColor = isSwiped ? UIColor.borderSelectedNote.cgColor : UIColor.borderNote.cgColor
    }
    
    private func updatNumberOfLinesText() {
        previewTextNoteLabel.numberOfLines = previewTextNoteLabel.frame.maxY >= frame.height * 0.9 ? 1 : 0
    }
    
    // MARK: - Setup
    
    private func setup() {
        setupSuperView()
        setupPreviewTitleNoteLabel()
        setupPreviewTextNoteLabel()
        setupDateModifiedNoteLabel()
        setupDateCreatedNoteLabel()
        setupSeparatorView()
    }
    
    private func setupSuperView() {
        backgroundColor = .backgroundNote
        layer.masksToBounds = true
        layer.borderWidth = 1
        layer.cornerRadius = 10
        clipsToBounds = true
    }
    
    private func setupPreviewTitleNoteLabel() {
        addSubview(previewTitleNoteLabel)
        
        previewTitleNoteLabel.font = UIFont.systemFont(ofSize: 22, weight: .regular)
        previewTitleNoteLabel.textColor = .previewTitle
        previewTitleNoteLabel.textAlignment = .left
        
        previewTitleNoteLabel.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(15)
        }
    }
    
    private func setupPreviewTextNoteLabel() {
        addSubview(previewTextNoteLabel)
        
        previewTextNoteLabel.textColor = .previewText
        previewTextNoteLabel.textAlignment = .left
        previewTextNoteLabel.font = UIFont.systemFont(ofSize: 16)
        previewTextNoteLabel.sizeToFit()
        previewTextNoteLabel.numberOfLines = 0
        
        previewTextNoteLabel.frame.size.height = frame.height / 2
        
        previewTextNoteLabel.snp.makeConstraints { make in
            make.top.equalTo(previewTitleNoteLabel.snp.bottom).offset(2)
            make.trailing.leading.equalTo(previewTitleNoteLabel)
            make.height.equalToSuperview().multipliedBy(0.5)
        }
    }
    
    private func setupDateModifiedNoteLabel() {
        addSubview(dateModifiedNoteLabel)
        
        dateModifiedNoteLabel.textColor = .lightGray
        dateModifiedNoteLabel.textAlignment = .left
        dateModifiedNoteLabel.adjustsFontSizeToFitWidth = true
        dateModifiedNoteLabel.minimumScaleFactor = 0.5
        dateModifiedNoteLabel.font = UIFont.systemFont(ofSize: 10)
        
        dateModifiedNoteLabel.snp.makeConstraints { make in
            make.leading.equalTo(previewTitleNoteLabel)
            make.bottom.equalToSuperview().inset(8)
            make.width.equalToSuperview().multipliedBy(0.38)
        }
    }
    
    private func setupDateCreatedNoteLabel() {
        addSubview(dateCreatedNoteLabel)
        
        dateCreatedNoteLabel.textColor = .lightGray
        dateCreatedNoteLabel.textAlignment = .right
        dateCreatedNoteLabel.adjustsFontSizeToFitWidth = true
        dateCreatedNoteLabel.minimumScaleFactor = 0.5
        dateCreatedNoteLabel.font = UIFont.systemFont(ofSize: 10)
        
        dateCreatedNoteLabel.snp.makeConstraints { make in
            make.trailing.equalTo(previewTitleNoteLabel)
            make.bottom.equalTo(dateModifiedNoteLabel)
            make.width.equalToSuperview().multipliedBy(0.38)
        }
    }
    
    private func setupSeparatorView() {
        addSubview(separatorView)
        separatorView.backgroundColor = .appColor
        
        separatorView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(previewTitleNoteLabel)
            make.bottom.equalTo(dateCreatedNoteLabel.snp.top).offset(-5)
            make.height.equalTo(1)
        }
    }
}
