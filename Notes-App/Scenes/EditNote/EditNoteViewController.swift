//
//  EditNoteViewController.swift
//  Notes-App
//
//  Created by Ivan Semenov on 10.02.2023.
//

import UIKit

class EditNoteViewController: UIViewController {
    
    // MARK: - Private properties
    
    private let titleNoteTextField = UITextField()
    private let textNoteTextView = UITextView()
    private let contentBorderView = UIView()
    private let hideKeyboardButton = UIButton()

    lazy private var doneBarButton: UIBarButtonItem = {
        let barButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(handleDoneBarButton))
        barButton.tintColor = .appColor
        return barButton
    }()
    
    lazy private var deleteBarButton: UIBarButtonItem = {
        let barButton = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteNoteFromEditScreen))
        barButton.tintColor = .deleteBarButton
        return barButton
    }()
    
    private let viewModel: EditNoteViewModel
    
    // MARK: - Inits
    
    init(with viewModel: EditNoteViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = deleteBarButton
        
        setup()
        bindToViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.shouldShowContentPlaceholder(content: textNoteTextView.text)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.shouldShowKeyboard()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewModel.shouldDeleteNote(with: titleNoteTextField.text, and: textNoteTextView.text)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    // MARK: - Actions
    
    @objc
    private func handleDoneBarButton() {
        view.endEditing(true)
    }
    
    @objc
    private func handleHideKeyboardButton() {
        view.endEditing(true)
    }
    
    @objc
    private func deleteNoteFromEditScreen() {
        viewModel.didDeleteNote()
    }
    
    @objc
    private func keyboardWillHide(_ sender: NSNotification) {
        textNoteTextView.contentInset = .zero
        textNoteTextView.scrollRangeToVisible(textNoteTextView.selectedRange)
        
        hideKeyboardButton.isHidden = true
        hideKeyboardButton.frame.origin.y = view.bounds.height
        hideKeyboardButton.frame.origin.x = view.bounds.width - 60
    }
    
    @objc
    private func keyboardWillShow(_ sender: NSNotification) {
        guard let userInfo = sender.userInfo else { return }
        guard let getKeyboardRect = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }

        let keyboardFrame = self.view.convert(getKeyboardRect, to: view.window)
        
        textNoteTextView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardFrame.height, right: 0)
        textNoteTextView.scrollIndicatorInsets = textNoteTextView.contentInset
        textNoteTextView.scrollRangeToVisible(textNoteTextView.selectedRange)
        
        hideKeyboardButton.frame.origin.y = view.bounds.height - keyboardFrame.height - 50
        hideKeyboardButton.frame.origin.x = view.bounds.width - 60
        hideKeyboardButton.isHidden = false
    }
    
    // MARK: - Private methods
    
    private func endEditingOfNote() {
        viewModel.shouldSaveNote(with: titleNoteTextField.text, and: textNoteTextView.text)
    }
    
    private func showDoneBarButton() {
        self.navigationItem.rightBarButtonItem = doneBarButton
    }
    
    private func showDeleteBarButton() {
        self.navigationItem.rightBarButtonItem = deleteBarButton
    }
    
    //  MARK: - Setup
    
    private func setup() {
        setupSuperView()
        setupTitleNoteTextField()
        setupTextNoteTextView()
        setupContentBorderView()
        setupHideKeyboardButton()
    }
    
    private func setupSuperView() {
        view.backgroundColor = .backgroundApp
    }
    
    private func setupTitleNoteTextField() {
        view.addSubview(titleNoteTextField)
        
        titleNoteTextField.text = viewModel.getTitle()
        titleNoteTextField.textColor = .white
        titleNoteTextField.tintColor = .appColor
        titleNoteTextField.font = .titleNote
        titleNoteTextField.backgroundColor = .clear
        titleNoteTextField.adjustsFontSizeToFitWidth = true
        titleNoteTextField.minimumFontSize = 0.6
        titleNoteTextField.borderStyle = .none
        titleNoteTextField.attributedPlaceholder = NSAttributedString(string: "New Note", attributes: [NSAttributedString.Key.foregroundColor: UIColor.previewText])
        titleNoteTextField.enablesReturnKeyAutomatically = true
        titleNoteTextField.keyboardAppearance = .dark
        titleNoteTextField.delegate = self

        titleNoteTextField.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(100)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(40)
        }
    }
    
    private func setupTextNoteTextView() {
        view.addSubview(textNoteTextView)
        
        textNoteTextView.text = viewModel.getText()
        textNoteTextView.textColor = #colorLiteral(red: 0.8374180198, green: 0.8374378085, blue: 0.8374271393, alpha: 1)
        textNoteTextView.tintColor = .appColor
        textNoteTextView.font = .textNote
        textNoteTextView.backgroundColor = .clear
        textNoteTextView.enablesReturnKeyAutomatically = true
        textNoteTextView.keyboardAppearance = .dark
        textNoteTextView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        textNoteTextView.keyboardDismissMode = .onDrag
        textNoteTextView.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        textNoteTextView.snp.makeConstraints { make in
            make.top.equalTo(titleNoteTextField.snp.bottom).offset(5)
            make.leading.trailing.equalToSuperview().inset(15)
            make.bottom.equalToSuperview()
        }        
    }
    
    private func setupContentBorderView() {
        view.addSubview(contentBorderView)
        
        contentBorderView.backgroundColor = .appColor
        contentBorderView.layer.cornerRadius = 5
        
        contentBorderView.snp.makeConstraints { make in
            make.top.equalTo(titleNoteTextField.snp.bottom).offset(10)
            make.leading.equalTo(textNoteTextView)
            make.height.equalTo(110)
            make.width.equalTo(4)
        }
    }
    
    private func setupHideKeyboardButton() {
        view.addSubview(hideKeyboardButton)
        
        let config = UIImage.SymbolConfiguration(pointSize: 20, weight: .light)
        hideKeyboardButton.setImage(UIImage(systemName: "keyboard.chevron.compact.down", withConfiguration: config), for: .normal)
        hideKeyboardButton.frame = CGRect(x: view.bounds.width - 60, y: view.bounds.height, width: 50, height: 30)
        hideKeyboardButton.tintColor = .hideKeyboardButtonButton
        hideKeyboardButton.backgroundColor = .appColor
        hideKeyboardButton.layer.cornerRadius = 10
        hideKeyboardButton.isHidden = true
        hideKeyboardButton.addTarget(self, action: #selector(handleHideKeyboardButton), for: .touchUpInside)
    }
}

// MARK: - UITextFieldDelegate

extension EditNoteViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        showDoneBarButton()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        showDeleteBarButton()
        endEditingOfNote()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

// MARK: - UITextViewDelegate

extension EditNoteViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        viewModel.shouldShowContentPlaceholder(content: textView.text)
        showDoneBarButton()
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        viewModel.shouldShowContentPlaceholder(content: textView.text)
        endEditingOfNote()
        showDeleteBarButton()
    }
}

// MARK: - Building ViewModel

private extension EditNoteViewController {
    private func bindToViewModel() {
        viewModel.didGoBackHomeScreen = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        
        viewModel.showKeyboard = { [weak self] in
            self?.titleNoteTextField.becomeFirstResponder()
        }
        
        viewModel.hideContentPlaceholder = { [weak self] in
            self?.textNoteTextView.text = ""
            self?.textNoteTextView.textColor = .white
        }
        
        viewModel.showContentPlaceholder = { [weak self] placeholder in
            self?.textNoteTextView.text = placeholder
            self?.textNoteTextView.textColor = .previewText
        }
    }
}
