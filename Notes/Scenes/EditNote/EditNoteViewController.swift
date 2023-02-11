//
//  EditNoteViewController.swift
//  Notes
//
//  Created by Ivan Semenov on 10.02.2023.
//

import UIKit

class EditNoteViewController: UIViewController {
    
    // MARK: - Private properties
    
    private let titleNoteTextField = UITextField()
    private let textNoteTextView = UITextView()
    
    private let viewModel: EditNoteViewModel
    
    // MARK: - Inits
    
    init(with viewModel: EditNoteViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        bindToViewModel()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.shouldShowKeyboard()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if self.isMovingFromParent {
            viewModel.shouldSaveNote(with : titleNoteTextField.text, and: textNoteTextView.text)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    // MARK: - Actions
    
    @objc
    private func handleDoneButton() {
        view.endEditing(true)
    }
    
    @objc
    func updateTextView(param: Notification) {
        let userInfo = param.userInfo

        guard let getKeyboardRect = (userInfo![UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        let keyboardFrame = self.view.convert(getKeyboardRect, to: view.window)

        if param.name == UIResponder.keyboardWillHideNotification {
            textNoteTextView.contentInset = UIEdgeInsets.zero
        } else {
            textNoteTextView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardFrame.height, right: 0)
            textNoteTextView.scrollIndicatorInsets = textNoteTextView.contentInset
        }
        textNoteTextView.scrollRangeToVisible(textNoteTextView.selectedRange)
    }
    
    // MARK: - Private methods
    
    private func showDoneButton() {
        self.navigationItem.rightBarButtonItem?.isEnabled = true
        self.navigationItem.rightBarButtonItem?.tintColor = .appColor
    }
    
    private func hideDoneButton() {
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        self.navigationItem.rightBarButtonItem?.tintColor = .clear
    }
    
    //  MARK: - Setup
    
    private func setup() {
        setupSuperView()
        setupDoneButton()
        setupTitleNoteTextField()
        setupTextNoteTextView()
    }
    
    private func setupSuperView() {
        view.backgroundColor = .backgroundApp
    }
    
    private func setupDoneButton() {
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(handleDoneButton))
        self.navigationItem.rightBarButtonItem = doneButton
        hideDoneButton()
    }
    
    private func setupTitleNoteTextField() {
        view.addSubview(titleNoteTextField)
        
        titleNoteTextField.text = viewModel.getTitle()
        titleNoteTextField.textColor = .white
        titleNoteTextField.tintColor = .appColor
        titleNoteTextField.font = UIFont.systemFont(ofSize: 25, weight: .semibold)
        titleNoteTextField.backgroundColor = .clear
        titleNoteTextField.adjustsFontSizeToFitWidth = true
        titleNoteTextField.minimumFontSize = 0.6
        titleNoteTextField.borderStyle = .none
        titleNoteTextField.placeholder = "New Note"
        titleNoteTextField.enablesReturnKeyAutomatically = true
        titleNoteTextField.keyboardAppearance = .dark
        titleNoteTextField.delegate = self

        titleNoteTextField.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(100)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }
    }
    
    private func setupTextNoteTextView() {
        view.addSubview(textNoteTextView)
        
        textNoteTextView.text = viewModel.getText()
        textNoteTextView.textColor = viewModel.getTextColor()
        textNoteTextView.tintColor = .appColor
        textNoteTextView.font = UIFont.systemFont(ofSize: 21)
        textNoteTextView.backgroundColor = .clear
        textNoteTextView.enablesReturnKeyAutomatically = true
        textNoteTextView.keyboardAppearance = .dark
        textNoteTextView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        textNoteTextView.keyboardDismissMode = .onDrag
        textNoteTextView.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateTextView), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateTextView), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        textNoteTextView.snp.makeConstraints { make in
            make.top.equalTo(titleNoteTextField.snp.bottom).offset(13)
            make.leading.trailing.equalToSuperview().inset(23)
            make.bottom.equalToSuperview()
        }        
    }
}

// MARK: - UITextFieldDelegate

extension EditNoteViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        showDoneButton()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        hideDoneButton()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

// MARK: - UITextViewDelegate

extension EditNoteViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        viewModel.beginEditingOfNote(content: textView.text)
        showDoneButton()
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        viewModel.endEditingOfNote(content: textView.text)
        hideDoneButton()
    }
}

// MARK: - Building ViewModel

private extension EditNoteViewController {
    private func bindToViewModel() {
        viewModel.didBeginEditingNote = { [weak self] in
            self?.textNoteTextView.text = ""
            self?.textNoteTextView.textColor = .white
        }
        
        viewModel.didEndEditingNote = { [weak self] placeholder in
            self?.textNoteTextView.text = placeholder
            self?.textNoteTextView.textColor = .lightGray
        }
        
        viewModel.didShowKeyboard = { [weak self] in
            self?.titleNoteTextField.becomeFirstResponder()
        }
    }
}
