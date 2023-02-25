//
//  NotesScreenViewController.swift
//  Notes
//
//  Created by Ivan Semenov on 09.02.2023.
//

import UIKit
import SnapKit

class NotesScreenViewController: UIViewController {
    
    // MARK: - Private properties
    
    private let headerLabel = UILabel()
    private let createNoteButton = UIButton(type: .system)
    
    private let listNotesButton = UIButton(type: .system)
    private let galleryNotesButton = UIButton(type: .system)
    
    lazy private var notesCollection: UICollectionView = {
        let layout = viewModel.getLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collectionView
    }()
    
    private let viewModel: NotesScreenViewModel
    
    // MARK: - Inits
    
    init(with viewModel: NotesScreenViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
        bindToViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.updateHeader()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupBackBarButtonItem()
    }
    
    // MARK: - Actions
    
    @objc
    private func handleAddNoteButton() {
        viewModel.createNote()
    }
    
    @objc
    private func handleListNotesButton() {
        viewModel.setListLayout()
    }
    
    @objc
    private func handleGalleryNotesButton() {
        viewModel.setGalleryLayout()
    }
    
    //  MARK: - Setup
    
    private func setup() {
        setupSuperView()
        setupHeaderLabel()
        setupListNotesButton()
        setupGalleryNotesButton()
        setupNotesCollection()
        setupCreateNoteButton()
    }
    
    private func setupSuperView() {
        view.backgroundColor = .backgroundApp
    }
    
    private func setupHeaderLabel() {
        view.addSubview(headerLabel)
        
        headerLabel.textColor = .headerText
        headerLabel.textAlignment = .left
        headerLabel.font = UIFont.systemFont(ofSize: 30, weight: .medium)
        
        headerLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(80)
            make.leading.equalToSuperview().offset(50)
        }
    }
    
    private func setupListNotesButton() {
        view.addSubview(listNotesButton)
        
        listNotesButton.setImage(UIImage(systemName: "list.bullet"), for: .normal)
        listNotesButton.tintColor = .layoutButton
        listNotesButton.addTarget(self, action: #selector(handleListNotesButton), for: .touchUpInside)
        
        listNotesButton.snp.makeConstraints { make in
            make.bottom.equalTo(headerLabel).inset(1.5)
            make.trailing.equalToSuperview().inset(20)
        }
    }
    
    private func setupGalleryNotesButton() {
        view.addSubview(galleryNotesButton)

        galleryNotesButton.setImage(UIImage(systemName: "square.grid.2x2"), for: .normal)
        galleryNotesButton.tintColor = .layoutButton
        galleryNotesButton.addTarget(self, action: #selector(handleGalleryNotesButton), for: .touchUpInside)
        
        galleryNotesButton.snp.makeConstraints { make in
            make.bottom.equalTo(headerLabel)
            make.trailing.equalTo(listNotesButton.snp.leading).offset(-13)
        }
    }
    
    private func setupNotesCollection() {
        view.addSubview(notesCollection)
        
        notesCollection.backgroundColor = .clear
        notesCollection.clipsToBounds = true
        notesCollection.showsVerticalScrollIndicator = false
        notesCollection.dataSource = self
        notesCollection.delegate = self
        notesCollection.register(NoteViewCell.self, forCellWithReuseIdentifier: NoteViewCell.identifier)
        
        notesCollection.snp.makeConstraints { make in
            make.top.equalTo(headerLabel.snp.bottom).offset(20)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    private func setupCreateNoteButton() {
        view.addSubview(createNoteButton)
        
        createNoteButton.setImage(UIImage(systemName: "square.and.pencil"), for: .normal)
        createNoteButton.imageView?.layer.transform = CATransform3DMakeScale(1, 1, 1)
        createNoteButton.tintColor = .white
        createNoteButton.backgroundColor = .appColor
        createNoteButton.layer.cornerRadius = 65 / 2
        createNoteButton.addTarget(self, action: #selector(handleAddNoteButton), for: .touchUpInside)
        
        createNoteButton.snp.makeConstraints { make in
            make.height.width.equalTo(65)
            make.trailing.bottom.equalToSuperview().inset(40)
        }
    }
    
    private func setupBackBarButtonItem() {
        let backBarButtonItem = UIBarButtonItem(title: "Notes", style: .plain, target: self, action: nil)
        backBarButtonItem.tintColor = .appColor
        self.navigationItem.backBarButtonItem = backBarButtonItem
    }
}

// MARK: - UICollectionViewDataSource

extension NotesScreenViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.cellViewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NoteViewCell.identifier, for: indexPath) as? NoteViewCell else {
            return NoteViewCell()
        }
        
        cell.configure(with: viewModel.cellViewModels[indexPath.item])
        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension NotesScreenViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.editNote(at: indexPath.item)
    }
}

// MARK: - Building ViewModel

private extension NotesScreenViewController {
    private func bindToViewModel() {
        viewModel.didGoToNextScreen = { [weak self] viewController in
            self?.navigationController?.pushViewController(viewController, animated: true)
        }
        
        viewModel.didUpdateCollection = { [weak self] in
            self?.notesCollection.reloadData()
        }
        
        viewModel.didUpdateHeader = { [weak self] header in
            self?.headerLabel.text = header
        }
        
        viewModel.didUpdateNoteLayout = { [weak self] layout in
            UIView.animate(withDuration: 0.5) {
                self?.notesCollection.collectionViewLayout = layout
            }
        }
        
        viewModel.showReceivedError = { [weak self] errorDescription in
            let alertController = UIAlertController(title: "Error", message: errorDescription, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default))
            self?.present(alertController, animated: true)
        }
    }
}

