//
//  CreateIrregularViewController.swift
//  Tracker
//
//  Created by Artem Kuzmenko on 19.11.2025.
//

import UIKit

final class CreateIrregularViewController: UIViewController {
    
    // MARK: - UI Elements
    
    private let scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        return scroll
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Новая привычка"
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textAlignment = .center
        label.textColor = UIColor(red: 26/255, green: 27/255, blue: 34/255, alpha: 1.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var nameTextView: UITextView = {
        let textView = UITextView()
        textView.font = .systemFont(ofSize: 17)
        textView.textColor = UIColor(red: 26/255, green: 27/255, blue: 34/255, alpha: 1.0)
        textView.backgroundColor = UIColor(red: 230/255, green: 232/255, blue: 235/255, alpha: 0.3)
        textView.layer.cornerRadius = 16
        textView.textContainerInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 45)
        textView.delegate = self
        textView.isScrollEnabled = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    private let placeholderLabel: UILabel = {
        let label = UILabel()
        label.text = "Введите название трекера"
        label.font = .systemFont(ofSize: 17)
        label.textColor = UIColor(red: 174/255, green: 175/255, blue: 180/255, alpha: 1.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var clearTextViewButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "xmark.circle"), for: .normal)
        button.tintColor = UIColor(red: 174/255, green: 175/255, blue: 180/255, alpha: 1.0)
        button.addTarget(self, action: #selector(clearTextViewText), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()


    
    private let characterLimitLabel: UILabel = {
        let label = UILabel()
        label.text = "Ограничение 38 символов"
        label.font = .systemFont(ofSize: 17)
        label.textColor = UIColor(red: 245/255, green: 107/255, blue: 108/255, alpha: 1.0)
        label.textAlignment = .center
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let nameContainer: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 8
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var categoryButton: UIButton = {
        let button = createSelectionButton(title: "Категория", subtitle: nil)
        button.addTarget(self, action: #selector(categoryTapped), for: .touchUpInside)
        button.backgroundColor = UIColor(red: 230/255, green: 232/255, blue: 235/255, alpha: 0.3)
        button.layer.cornerRadius = 16
        button.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        return button
    }()
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Отменить", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.setTitleColor(.systemRed, for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 16
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.systemRed.cgColor
        button.addTarget(self, action: #selector(cancelTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var createButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Создать", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor.systemGray
        button.layer.cornerRadius = 16
        button.isEnabled = false
        button.addTarget(self, action: #selector(createTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Properties
    
    weak var creationDelegate: TrackerCreationDelegate?
    var availableCategories: [String] = []
    
    private var selectedCategory: String? {
        didSet { updateCategorySubtitle() }
    }
    
    private let emojiOptions = ["🙂", "😌", "😎", "😴", "🧘‍♂️", "📚", "🌿", "🏃‍♂️", "😺"]
    private let colorOptions = ["#FD4C49", "#34C759", "#FF9500", "#AF52DE", "#007AFF", "#4ECDC4"]
    
    private let nameLimit = 38
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureUI()
        setupKeyboardObservers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    
    // MARK: - UI Setup
    
    private func configureUI() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        view.addSubview(cancelButton)
        view.addSubview(createButton)
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(nameContainer)
        contentView.addSubview(categoryButton)
        
        nameContainer.addArrangedSubview(nameTextView)
        nameContainer.addArrangedSubview(characterLimitLabel)
        
        nameTextView.addSubview(placeholderLabel)
        
        contentView.addSubview(clearTextViewButton)
        clearTextViewButton.isHidden = true
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: cancelButton.topAnchor, constant: -16),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 27),
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            nameContainer.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 38),
            nameContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            nameContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            nameTextView.heightAnchor.constraint(equalToConstant: 75),
            
            placeholderLabel.leadingAnchor.constraint(equalTo: nameTextView.leadingAnchor, constant: nameTextView.textContainerInset.left + 2),
            placeholderLabel.topAnchor.constraint(equalTo: nameTextView.topAnchor, constant: nameTextView.textContainerInset.top),
            
            clearTextViewButton.trailingAnchor.constraint(equalTo: nameTextView.trailingAnchor, constant: -12),
            clearTextViewButton.centerYAnchor.constraint(equalTo: nameTextView.centerYAnchor),
            clearTextViewButton.widthAnchor.constraint(equalToConstant: 17),
            clearTextViewButton.heightAnchor.constraint(equalToConstant: 17),
            
            categoryButton.topAnchor.constraint(equalTo: characterLimitLabel.bottomAnchor, constant: 24),
            categoryButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            categoryButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            categoryButton.heightAnchor.constraint(equalToConstant: 75),
            categoryButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            
            
            cancelButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            cancelButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            cancelButton.heightAnchor.constraint(equalToConstant: 60),
            cancelButton.widthAnchor.constraint(equalTo: createButton.widthAnchor),
            
            createButton.leadingAnchor.constraint(equalTo: cancelButton.trailingAnchor, constant: 8),
            createButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            createButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            createButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    func centerTextViewTextVertically(_ textView: UITextView) {
        let fittingSize = CGSize(width: textView.bounds.width, height: CGFloat.greatestFiniteMagnitude)
        let size = textView.sizeThatFits(fittingSize)
        let topOffset = max(0, (textView.bounds.height - size.height * textView.zoomScale) / 2)
        textView.contentOffset = CGPoint(x: 0, y: -topOffset)
    }
    
    
    private func createSelectionButton(title: String, subtitle: String?) -> UIButton {
        let button = UIButton(type: .system)
        button.contentHorizontalAlignment = .left
        button.translatesAutoresizingMaskIntoConstraints = false
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 2
        stackView.isUserInteractionEnabled = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        let mainTitle = UILabel()
        mainTitle.text = title
        mainTitle.font = .systemFont(ofSize: 17)
        mainTitle.textColor = UIColor(red: 26/255, green: 27/255, blue: 34/255, alpha: 1.0)
        
        stackView.addArrangedSubview(mainTitle)
        
        if let subtitle = subtitle {
            let s = UILabel()
            s.text = subtitle
            s.font = .systemFont(ofSize: 17)
            s.textColor = .systemGray
            stackView.addArrangedSubview(s)
        }
        
        button.addSubview(stackView)
        
        let chevron = UIImageView(image: UIImage(named: "Right"))
        chevron.tintColor = UIColor(red: 174/255, green: 175/255, blue: 180/255, alpha: 1.0)
        chevron.translatesAutoresizingMaskIntoConstraints = false
        button.addSubview(chevron)
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: button.leadingAnchor, constant: 16),
            stackView.centerYAnchor.constraint(equalTo: button.centerYAnchor),
            stackView.trailingAnchor.constraint(lessThanOrEqualTo: chevron.leadingAnchor, constant: -8),
            
            chevron.trailingAnchor.constraint(equalTo: button.trailingAnchor, constant: -16),
            chevron.centerYAnchor.constraint(equalTo: button.centerYAnchor),
            chevron.widthAnchor.constraint(equalToConstant: 24),
            chevron.heightAnchor.constraint(equalToConstant: 24)
        ])
        
        return button
    }
    
    
    // MARK: - Subtitle updates
    
    private func updateCategorySubtitle() {
        updateButton(categoryButton, subtitle: selectedCategory)
    }
    
    private func updateButton(_ button: UIButton, subtitle: String?) {
        guard let stack = button.subviews.first(where: { $0 is UIStackView }) as? UIStackView else { return }
        
        // Оставляем первый label (title), остальные убираем
        while stack.arrangedSubviews.count > 1 {
            stack.arrangedSubviews.last?.removeFromSuperview()
        }
        
        if let subtitle = subtitle {
            let s = UILabel()
            s.font = .systemFont(ofSize: 17)
            s.textColor = .systemGray
            s.text = subtitle
            stack.addArrangedSubview(s)
        }
        
        validateForm()
    }
    
    
    // MARK: - Keyboard
    
    private func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        guard let frame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        scrollView.contentInset.bottom = frame.height
        scrollView.verticalScrollIndicatorInsets.bottom = frame.height
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        scrollView.contentInset.bottom = 0
        scrollView.verticalScrollIndicatorInsets.bottom = 0
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    
    // MARK: - Actions
    
    @objc private func textFieldDidChange() {
        validateForm()
    }
    
    @objc private func clearTextViewText() {
        nameTextView.text = ""
        placeholderLabel.isHidden = false
        characterLimitLabel.isHidden = true
        clearTextViewButton.isHidden = true
        validateForm()
    }
    
    @objc private func categoryTapped() {
        let controller = CategorySelectionViewController(categories: availableCategories,
                                                         selectedCategory: selectedCategory)
        controller.delegate = self
        let nav = UINavigationController(rootViewController: controller)
        present(nav, animated: true)
    }
    
    @objc private func cancelTapped() {
        dismiss(animated: true)
    }
    
    @objc private func createTapped() {
        guard
            let title = nameTextView.text?.trimmingCharacters(in: .whitespacesAndNewlines),
            !title.isEmpty,
            let category = selectedCategory
        else { return }
        
        let emoji = emojiOptions.randomElement() ?? "🙂"
        let colorHex = colorOptions.randomElement() ?? "#34C759"
        let tracker = Tracker(id: UUID(),
                              title: title,
                              colorHex: colorHex,
                              emoji: emoji,
                              schedule: [])
        creationDelegate?.trackerCreationDidCreate(tracker, in: category)
        dismiss(animated: true)
    }
    
    
    private func validateForm() {
        let nameValid = !(nameTextView.text?.isEmpty ?? true)
        let categoryValid = selectedCategory != nil
        
        let valid = nameValid && categoryValid
        
        createButton.isEnabled = valid
        createButton.backgroundColor = valid
            ? UIColor(red: 26/255, green: 27/255, blue: 34/255, alpha: 1.0)
            : UIColor(red: 174/255, green: 175/255, blue: 180/255, alpha: 1.0)
    }
}


// MARK: - UITextFieldDelegate

extension CreateIrregularViewController: UITextViewDelegate {
    // Показывать кнопку только если редактируешь И текст не пустой
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = !textView.text.isEmpty
        clearTextViewButton.isHidden = textView.text.isEmpty || !textView.isFirstResponder
        centerTextViewTextVertically(textView)
        validateForm()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        centerTextViewTextVertically(nameTextView)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        placeholderLabel.isHidden = !textView.text.isEmpty
        clearTextViewButton.isHidden = textView.text.isEmpty
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        placeholderLabel.isHidden = !textView.text.isEmpty
        clearTextViewButton.isHidden = true
    }

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
            let current = textView.text ?? ""
            guard let stringRange = Range(range, in: current) else { return false }
            let updatedText = current.replacingCharacters(in: stringRange, with: text)
            characterLimitLabel.isHidden = updatedText.count <= nameLimit
            return updatedText.count <= nameLimit
        }
}

// MARK: - CategorySelectionViewControllerDelegate

extension CreateIrregularViewController: CategorySelectionViewControllerDelegate {
    func categorySelection(_ viewController: CategorySelectionViewController,
                           didSelect category: String,
                           categories: [String]) {
        availableCategories = categories
        selectedCategory = category
    }
}
