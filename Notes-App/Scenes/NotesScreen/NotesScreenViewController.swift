//
//  NotesScreenViewController.swift
//  Notes-App
//
//  Created by Ivan Semenov on 09.02.2023.
//

import UIKit
import SnapKit

class NotesScreenViewController: UIViewController {
    
    // MARK: - Private properties
    
    private let headerLabel = UILabel()
    private let createNoteButton = UIButton(type: .system)
    
    private let startDisplayView = UIView()
    private let startImageView = UIImageView()
    private let startLabel = UILabel()
    
    private let listNotesButton = UIButton(type: .system)
    private let galleryNotesButton = UIButton(type: .system)
    
    private let optionsMenuToolbar = UIToolbar()
    
    lazy private var notesCollection: UICollectionView = {
        let layout = viewModel.noteLayoutType.layout
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collectionView
    }()
    
    lazy private var deleteNoteImageView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.image = UIImage(systemName: "trash.fill")
        imageView.tintColor = .systemRed
        
        return imageView
    }()
    
    lazy private var deleteNoteLabel: UILabel = {
        let label = UILabel()
        
        label.text = "Delete"
        label.textColor = .systemRed
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        
        return label
    }()
    
    lazy private var deleteNoteStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [deleteNoteImageView, deleteNoteLabel])
        
        stackView.axis = .horizontal
        stackView.spacing = 8
        
        let deleteTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleDeleteNoteFromToolbar))
        stackView.addGestureRecognizer(deleteTapGesture)
        
        return stackView
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
        listNotesButton.tintColor = .selectedLayoutButton
        galleryNotesButton.tintColor = .layoutButton
        viewModel.setListLayout()
    }
    
    @objc
    private func handleGalleryNotesButton() {
        galleryNotesButton.tintColor = .selectedLayoutButton
        listNotesButton.tintColor = .layoutButton
        viewModel.setGalleryLayout()
    }

    @objc
    private func handleDeleteSwipe(_ gesture: UISwipeGestureRecognizer) {
        let location = gesture.location(in: notesCollection)
        let indexPath = notesCollection.indexPathForItem(at: location)
        viewModel.swipeNote(with: indexPath)
    }
    
    @objc
    private func handleDeleteNoteFromToolbar() {
        viewModel.shouldDeleteNote()
    }
    
    // MARK: - Private methods
    
    private func deleteNote() {
        viewModel.deleteNoteFromHomeScreen()
    }
    
    private func animateCollectionCell(with indexPath: IndexPath) {
        UIView.animateKeyframes(withDuration: 0.5, delay: 0) {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.5) {
                self.notesCollection.cellForItem(at: indexPath)?.frame.origin.x -= 30
            }
            UIView.addKeyframe(withRelativeStartTime: 0.25, relativeDuration: 0.5) {
                self.notesCollection.cellForItem(at: indexPath)?.frame.origin.x += 30
            }
        }
    }
    
    //  MARK: - Setup
    
    private func setup() {
        setupSuperView()
        setupHeaderLabel()
        setupListNotesButton()
        setupGalleryNotesButton()
        setupNotesCollection()
        setupCreateNoteButton()
        setupStartDisplayView()
        setupStartImageView()
        setupStartLabel()
        setupOptionsMenuToolbar()
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
        galleryNotesButton.tintColor = .selectedLayoutButton
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
        
        let deleteSwipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleDeleteSwipe))
        deleteSwipeGesture.direction = .left
        notesCollection.addGestureRecognizer(deleteSwipeGesture)
        
        notesCollection.snp.makeConstraints { make in
            make.top.equalTo(headerLabel.snp.bottom).offset(25)
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
            make.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(40)
        }
    }
    
    private func setupStartDisplayView() {
        view.addSubview(startDisplayView)
        
        startDisplayView.backgroundColor = .clear
        
        startDisplayView.snp.makeConstraints { make in
            make.top.equalTo(headerLabel.snp.bottom).offset(20)
            make.left.trailing.equalToSuperview().inset(20)
            make.height.equalToSuperview().multipliedBy(0.7)
        }
    }
    
    private func setupStartImageView() {
        startDisplayView.addSubview(startImageView)
        
        startImageView.image = UIImage(named: "startimage")
        startImageView.contentMode = .scaleAspectFit
        
        startImageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.7)
        }
    }
    
    private func setupStartLabel() {
        startDisplayView.addSubview(startLabel)
        
        startLabel.text = viewModel.startHeader
        startLabel.textColor = .startHeader
        startLabel.font = UIFont.systemFont(ofSize: 25)
        startLabel.textAlignment = .center
        
        startLabel.snp.makeConstraints { make in
            make.top.equalTo(startImageView.snp.bottom)
            make.leading.trailing.equalToSuperview()
        }
    }
    
    private func setupOptionsMenuToolbar() {
        view.addSubview(optionsMenuToolbar)
        
        let width = view.bounds.width * 0.4
        let height: CGFloat = 50
        
        optionsMenuToolbar.frame.size.width = width
        optionsMenuToolbar.frame.size.height = height
        optionsMenuToolbar.frame.origin.x = view.bounds.width / 2 - width / 2
        optionsMenuToolbar.frame.origin.y = view.bounds.height * 0.88
        optionsMenuToolbar.layer.masksToBounds = true
        optionsMenuToolbar.layer.cornerRadius = 10
        optionsMenuToolbar.isHidden = true
        
        let flexibleSpaceBarButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let deleteBarButton = UIBarButtonItem(customView: deleteNoteStackView)
        optionsMenuToolbar.items = [flexibleSpaceBarButton, deleteBarButton, flexibleSpaceBarButton]
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
        viewModel.didUpdateHeader = { [weak self] header in
            self?.headerLabel.text = header
        }
        
        viewModel.didUpdateCollection = { [weak self] in
            self?.notesCollection.reloadData()
        }
        
        viewModel.didSwipeCell = { [weak self] indexPath in
            self?.animateCollectionCell(with: indexPath)
        }
        
        viewModel.didDeleteCollectionItems = { [weak self] indexes in
            self?.notesCollection.deleteItems(at: indexes)
        }
        
        viewModel.didGoToNextScreen = { [weak self] viewController in
            self?.navigationController?.pushViewController(viewController, animated: true)
        }
        
        viewModel.showAppearanceSelectedCell = { [weak self] indexPath in
            guard let cell = self?.notesCollection.cellForItem(at: indexPath) as? NoteViewCell else { return }
            cell.isSwiped = true
        }
        
        viewModel.hideAppearanceSelectedCell = { [weak self] indexPath in
            guard let cell = self?.notesCollection.cellForItem(at: indexPath) as? NoteViewCell else { return }
            cell.isSwiped = false
        }
        
        viewModel.showToolBar = { [weak self] in
            self?.optionsMenuToolbar.isHidden = false
            self?.createNoteButton.isHidden = true
        }
        
        viewModel.hideToolbar = { [weak self] in
            self?.optionsMenuToolbar.isHidden = true
            self?.createNoteButton.isHidden = false
        }
        
        viewModel.showStartDisplay = { [weak self] in
            self?.startDisplayView.isHidden = false
            self?.galleryNotesButton.isHidden = true
            self?.listNotesButton.isHidden = true
        }
        
        viewModel.hideStartDisplay = { [weak self] in
            self?.startDisplayView.isHidden = true
            self?.galleryNotesButton.isHidden = false
            self?.listNotesButton.isHidden = false
        }
        
        viewModel.didUpdateNoteLayout = { [weak self] noteLayout in
            UIView.animate(withDuration: 0.5) {
                self?.notesCollection.collectionViewLayout = noteLayout.layout
            }
        }
        
        viewModel.showReceivedError = { [weak self] errorDescription in
            let alertController = UIAlertController(title: "Error", message: errorDescription, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default))
            self?.present(alertController, animated: true)
        }
        
        viewModel.showDeleteNoteAlert = { [weak self] title, message in
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
            alertController.overrideUserInterfaceStyle = .dark

            let deleteNoteAction = UIAlertAction(title: "Delete Note", style: .destructive) {_ in
                self?.deleteNote()
            }
            let closeAlertAction = UIAlertAction(title: "Cancel", style: .cancel)

            alertController.addAction(deleteNoteAction)
            alertController.addAction(closeAlertAction)

            self?.present(alertController, animated: true)
        }
    }
}

