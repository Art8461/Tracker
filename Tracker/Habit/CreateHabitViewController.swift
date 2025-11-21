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
        label.textColor = UIColor(named: "Black")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var nameTextView: UITextView = {
        let textView = UITextView()
        textView.font = .systemFont(ofSize: 17)
        textView.textColor = UIColor(named: "Black")
        textView.backgroundColor = UIColor(named: "GrayOsn")
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
        label.textColor = UIColor(named: "Gray")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var clearTextViewButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "xmark.circle"), for: .normal)
        button.tintColor = UIColor(named: "Gray")
        button.addTarget(self, action: #selector(clearTextViewText), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let emojiTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Emoji"
        label.font = .systemFont(ofSize: 19, weight: .semibold)
        label.textColor = UIColor(named: "Black")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var emojiCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = gridSpacing
        layout.minimumInteritemSpacing = gridSpacing
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.backgroundColor = .clear
        collection.delegate = self
        collection.dataSource = self
        collection.showsVerticalScrollIndicator = false
        collection.allowsMultipleSelection = false
        collection.register(EmojiCollectionViewCell.self,
                            forCellWithReuseIdentifier: EmojiCollectionViewCell.reuseIdentifier)
        return collection
    }()

    private let colorTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Цвет"
        label.font = .systemFont(ofSize: 19, weight: .semibold)
        label.textColor = UIColor(named: "Black")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var colorCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = gridSpacing
        layout.minimumInteritemSpacing = gridSpacing
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.backgroundColor = .clear
        collection.delegate = self
        collection.dataSource = self
        collection.showsVerticalScrollIndicator = false
        collection.allowsMultipleSelection = false
        collection.register(ColorCollectionViewCell.self,
                            forCellWithReuseIdentifier: ColorCollectionViewCell.reuseIdentifier)
        return collection
    }()


    
    private let characterLimitLabel: UILabel = {
        let label = UILabel()
        label.text = "Ограничение 38 символов"
        label.font = .systemFont(ofSize: 17)
        label.textColor = UIColor(named: "Red")
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
        button.backgroundColor = UIColor(named: "GrayOsn")
        button.layer.cornerRadius = 16
        button.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        return button
    }()
    
    private lazy var scheduleButton: UIButton = {
        let button = createSelectionButton(title: "Расписание", subtitle: nil)
        button.addTarget(self, action: #selector(scheduleTapped), for: .touchUpInside)
        button.backgroundColor = UIColor(named: "GrayOsn")
        button.layer.cornerRadius = 16
        button.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        return button
    }()
    
    private let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "Gray")
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
        button.backgroundColor = UIColor(named: "GrayButton")
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
    
    private var selectedSchedule: [Weekday] = [] {
        didSet { updateScheduleSubtitle() }
    }
    
    private var selectedEmoji: String? {
        didSet { validateForm() }
    }
    
    private var selectedColorHex: String? {
        didSet { validateForm() }
    }
    
    private let emojiOptions = ["🙂", "😻", "🌺", "🐶", "❤️", "😱",
                                "😇", "😡", "🥶", "🤔", "🙌", "🍔",
                                "🥦", "🏓", "🥇", "🎸", "🏝", "😪"]
    
    private let colorOptions = ["#FD4C49", "#FF881E", "#007BFA", "#6E44FF", "#34C759", "#20BF6B",
                                "#FFD426", "#FF6EB6", "#AF52DE", "#8E8E93", "#5856D6", "#34AADC",
                                "#FF2D55", "#5AC8FA", "#4ECDC4", "#5851DB", "#A2845E", "#C0C0C0"]
    
    private let nameLimit = 38
    private let gridItemsPerRow = 6
    private let gridSpacing: CGFloat = 12
    
    private var emojiHeightConstraint: NSLayoutConstraint?
    private var colorHeightConstraint: NSLayoutConstraint?
    private var selectedEmojiIndexPath: IndexPath?
    private var selectedColorIndexPath: IndexPath?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "White")
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
        contentView.addSubview(separatorView)
        contentView.addSubview(scheduleButton)
        contentView.addSubview(emojiTitleLabel)
        contentView.addSubview(emojiCollectionView)
        contentView.addSubview(colorTitleLabel)
        contentView.addSubview(colorCollectionView)
        
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
            
            emojiTitleLabel.topAnchor.constraint(equalTo: scheduleButton.bottomAnchor, constant: 32),
            emojiTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            emojiTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            emojiCollectionView.topAnchor.constraint(equalTo: emojiTitleLabel.bottomAnchor, constant: 16),
            emojiCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            emojiCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            colorTitleLabel.topAnchor.constraint(equalTo: emojiCollectionView.bottomAnchor, constant: 32),
            colorTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            colorTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            colorCollectionView.topAnchor.constraint(equalTo: colorTitleLabel.bottomAnchor, constant: 16),
            colorCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            colorCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            colorCollectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -32),
            
            cancelButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            cancelButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            cancelButton.heightAnchor.constraint(equalToConstant: 60),
            cancelButton.widthAnchor.constraint(equalTo: createButton.widthAnchor),
            
            createButton.leadingAnchor.constraint(equalTo: cancelButton.trailingAnchor, constant: 8),
            createButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            createButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            createButton.heightAnchor.constraint(equalToConstant: 60)
        ])
        
        emojiHeightConstraint = emojiCollectionView.heightAnchor.constraint(equalToConstant: 0)
        emojiHeightConstraint?.isActive = true
        colorHeightConstraint = colorCollectionView.heightAnchor.constraint(equalToConstant: 0)
        colorHeightConstraint?.isActive = true
    }
    
    private func updateCollectionViewHeights() {
        emojiHeightConstraint?.constant = calculatedHeight(for: emojiCollectionView, itemCount: emojiOptions.count)
        colorHeightConstraint?.constant = calculatedHeight(for: colorCollectionView, itemCount: colorOptions.count)
    }
    
    private func calculatedHeight(for collectionView: UICollectionView, itemCount: Int) -> CGFloat {
        guard itemCount > 0 else { return 0 }
        let rows = Int(ceil(Double(itemCount) / Double(max(gridItemsPerRow, 1))))
        let itemWidth = calculateItemWidth(for: collectionView)
        let spacing = CGFloat(max(rows - 1, 0)) * gridSpacing
        return CGFloat(rows) * itemWidth + spacing
    }
    
    private func calculateItemWidth(for collectionView: UICollectionView) -> CGFloat {
        let items = CGFloat(max(gridItemsPerRow, 1))
        let totalSpacing = CGFloat(max(gridItemsPerRow - 1, 0)) * gridSpacing
        let availableWidth = collectionView.bounds.width - totalSpacing
        guard availableWidth > 0 else { return 44 }
        return floor(availableWidth / items)
    }
    
    private func handleEmojiSelection(at indexPath: IndexPath) {
        if selectedEmojiIndexPath == indexPath { return }
        let previous = selectedEmojiIndexPath
        selectedEmojiIndexPath = indexPath
        selectedEmoji = emojiOptions[indexPath.item]
        var toReload = [indexPath]
        if let previous = previous {
            toReload.append(previous)
        }
        emojiCollectionView.reloadItems(at: toReload)
    }
    
    private func handleColorSelection(at indexPath: IndexPath) {
        if selectedColorIndexPath == indexPath { return }
        let previous = selectedColorIndexPath
        selectedColorIndexPath = indexPath
        selectedColorHex = colorOptions[indexPath.item]
        var toReload = [indexPath]
        if let previous = previous {
            toReload.append(previous)
        }
        colorCollectionView.reloadItems(at: toReload)
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
        mainTitle.textColor = UIColor(named: "Black")
        
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
        chevron.tintColor = UIColor(named: "Gray")
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
        guard !selectedSchedule.isEmpty else {
            updateButton(scheduleButton, subtitle: nil)
            return
        }
        if selectedSchedule.count == Weekday.allCases.count {
            updateButton(scheduleButton, subtitle: "Каждый день")
        } else {
            let text = selectedSchedule
                .sorted { $0.rawValue < $1.rawValue }
                .map { $0.shortTitle }
                .joined(separator: ", ")
            updateButton(scheduleButton, subtitle: text)
        }
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
    
    @objc private func scheduleTapped() {
        let controller = ScheduleViewController(selectedWeekdays: Set(selectedSchedule))
        controller.delegate = self
        let nav = UINavigationController(rootViewController: controller)
        present(nav, animated: true)
    }
    
    @objc private func cancelTapped() {
        dismissCreationFlow()
    }
    
    @objc private func createTapped() {
        guard
            let title = nameTextView.text?.trimmingCharacters(in: .whitespacesAndNewlines),
            !title.isEmpty,
            let category = selectedCategory,
            !selectedSchedule.isEmpty,
            let emoji = selectedEmoji,
            let colorHex = selectedColorHex
        else { return }
        
        let tracker = Tracker(id: UUID(),
                              title: title,
                              colorHex: colorHex,
                              emoji: emoji,
                              schedule: selectedSchedule)
        creationDelegate?.trackerCreationDidCreate(tracker, in: category)
        dismissCreationFlow()
    }
    
    
    private func validateForm() {
        let nameValid = !(nameTextView.text?.isEmpty ?? true)
        let categoryValid = selectedCategory != nil
        let scheduleValid = !selectedSchedule.isEmpty
        let emojiValid = selectedEmoji != nil
        let colorValid = selectedColorHex != nil
        
        let valid = nameValid && categoryValid && scheduleValid && emojiValid && colorValid
        
        createButton.isEnabled = valid
        createButton.backgroundColor = valid
            ? UIColor(named: "Black")
            : UIColor(named: "Gray")
    }
    
    private func dismissCreationFlow() {
        if let nav = navigationController {
            nav.dismiss(animated: true)
        } else {
            dismiss(animated: true)
        }
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
        updateCollectionViewHeights()
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

extension CreateHabitViewController: CategorySelectionViewControllerDelegate {
    func categorySelection(_ viewController: CategorySelectionViewController,
                           didSelect category: String,
                           categories: [String]) {
        availableCategories = categories
        selectedCategory = category
    }
}

// MARK: - ScheduleViewControllerDelegate

extension CreateHabitViewController: ScheduleViewControllerDelegate {
    func scheduleViewController(_ viewController: ScheduleViewController,
                                didUpdate weekdays: [Weekday]) {
        selectedSchedule = weekdays
    }
}

// MARK: - UICollectionViewDataSource & Delegate

extension CreateHabitViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == emojiCollectionView {
            return emojiOptions.count
        }
        return colorOptions.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == emojiCollectionView {
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: EmojiCollectionViewCell.reuseIdentifier,
                for: indexPath
            ) as? EmojiCollectionViewCell else {
                return UICollectionViewCell()
            }
            let emoji = emojiOptions[indexPath.item]
            cell.configure(with: emoji, isSelected: indexPath == selectedEmojiIndexPath)
            return cell
        }
        
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ColorCollectionViewCell.reuseIdentifier,
            for: indexPath
        ) as? ColorCollectionViewCell else {
            return UICollectionViewCell()
        }
        let hex = colorOptions[indexPath.item]
        cell.configure(hex: hex, isSelected: indexPath == selectedColorIndexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == emojiCollectionView {
            handleEmojiSelection(at: indexPath)
        } else {
            handleColorSelection(at: indexPath)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = calculateItemWidth(for: collectionView)
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return gridSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return gridSpacing
    }
}

// MARK: - Collection View Cells

private final class EmojiCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = "EmojiCollectionViewCell"
    
    private let emojiLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 30)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.layer.cornerRadius = 16
        contentView.backgroundColor = UIColor(named: "White")
        contentView.addSubview(emojiLabel)
        
        NSLayoutConstraint.activate([
            emojiLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            emojiLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with emoji: String, isSelected: Bool) {
        emojiLabel.text = emoji
        updateSelectionAppearance(isSelected: isSelected)
    }
    
    private func updateSelectionAppearance(isSelected: Bool) {
        contentView.backgroundColor = isSelected
            ? UIColor(named: "GrayOsn100")
            : UIColor(named: "White")
    }
}

private final class ColorCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = "ColorCollectionViewCell"
    
    private let colorView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 8
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .clear
        contentView.addSubview(colorView)
        
        NSLayoutConstraint.activate([
            colorView.topAnchor.constraint(equalTo: contentView.topAnchor),
            colorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            colorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            colorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(hex: String, isSelected: Bool) {
        colorView.backgroundColor = UIColor(hex: hex) ?? UIColor(named: "GrayOsn100")
        updateSelectionAppearance(isSelected: isSelected)
    }
    
    private func updateSelectionAppearance(isSelected: Bool) {
        colorView.layer.borderWidth = isSelected ? 2 : 0
        colorView.layer.borderColor = UIColor(red: 26/255, green: 27/255, blue: 34/255, alpha: 1.0).cgColor
    }
}
