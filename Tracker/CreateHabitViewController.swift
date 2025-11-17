//
//  CreateHabitViewController.swift
//  Tracker
//
//  Created by Artem Kuzmenko on 16.11.2025.
//

import UIKit

final class CreateHabitViewController: UIViewController {
    
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
        textView.textContainerInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 45) // Оставляем место справа
        textView.delegate = self
        textView.isScrollEnabled = false // Чтобы размер ячейки менялся под текст
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
    
    private lazy var scheduleButton: UIButton = {
        let button = createSelectionButton(title: "Расписание", subtitle: nil)
        button.addTarget(self, action: #selector(scheduleTapped), for: .touchUpInside)
        button.backgroundColor = UIColor(red: 230/255, green: 232/255, blue: 235/255, alpha: 0.3)
        button.layer.cornerRadius = 16
        button.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        return button
    }()
    
    private let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 174/255, green: 175/255, blue: 180/255, alpha: 1.0)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
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
    
    private var selectedCategory: String? {
        didSet { updateCategorySubtitle() }
    }
    
    private var selectedSchedule: [String]? {
        didSet { updateScheduleSubtitle() }
    }
    
    private let nameLimit = 38
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureUI()
        setupKeyboardObservers()
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
        contentView.addSubview(separatorView)
        contentView.addSubview(scheduleButton)
        
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
            
            separatorView.centerYAnchor.constraint(equalTo: categoryButton.bottomAnchor),
            separatorView.leadingAnchor.constraint(equalTo: categoryButton.leadingAnchor, constant: 16),
            separatorView.trailingAnchor.constraint(equalTo: categoryButton.trailingAnchor, constant: -16),
            separatorView.heightAnchor.constraint(equalToConstant: 0.5),
            
            scheduleButton.topAnchor.constraint(equalTo: categoryButton.bottomAnchor),
            scheduleButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            scheduleButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            scheduleButton.heightAnchor.constraint(equalToConstant: 75),
            scheduleButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            
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
    
    private func updateScheduleSubtitle() {
        let text = selectedSchedule?.joined(separator: ", ")
        updateButton(scheduleButton, subtitle: text)
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
        print("Переход к выбору категории")
        
        selectedCategory = "Здоровье"   // DEMO
    }
    
    @objc private func scheduleTapped() {
        print("Переход к выбору расписания")
        
        selectedSchedule = ["Пн", "Ср", "Пт"] // DEMO
    }
    
    @objc private func cancelTapped() {
        dismiss(animated: true)
    }
    
    @objc private func createTapped() {
        print("Создание привычки")
        dismiss(animated: true)
    }
    
    
    private func validateForm() {
        let nameValid = !(nameTextView.text?.isEmpty ?? true)
        let categoryValid = selectedCategory != nil
        let scheduleValid = selectedSchedule?.isEmpty == false
        
        let valid = nameValid && categoryValid && scheduleValid
        
        createButton.isEnabled = valid
        createButton.backgroundColor = valid ? UIColor.systemBlue : UIColor.systemGray
    }
}


// MARK: - UITextFieldDelegate

extension CreateHabitViewController: UITextViewDelegate {
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
