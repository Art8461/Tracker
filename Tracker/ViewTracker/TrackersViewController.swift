//
//  ViewController.swift
//  Tracker
//
//  Created by Artem Kuzmenko on 16.11.2025.
//

import UIKit

class TrackersViewController: UIViewController{
 
    // MARK: - UI Elements
    
    private let plusButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "Plus"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.preferredDatePickerStyle = .compact
        picker.locale = Locale(identifier: "ru_RU")
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Трекеры"
        label.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        label.textColor = UIColor(red: 26/255, green: 27/255, blue: 34/255, alpha: 1.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let searchBar: UISearchBar = {
        let sb = UISearchBar()
        sb.placeholder = "Поиск"
        sb.searchBarStyle = .minimal
        sb.translatesAutoresizingMaskIntoConstraints = false
        
        sb.searchTextField.textColor = UIColor(red: 60/255, green: 60/255, blue: 67/255, alpha: 1.0)
        sb.searchTextField.attributedPlaceholder = NSAttributedString(
            string: "Поиск",
            attributes: [
                .foregroundColor: UIColor(red: 60/255, green: 60/255, blue: 67/255, alpha: 0.6),
                .font: UIFont.systemFont(ofSize: 17)
            ]
        )
        
        return sb
    }()
    
    private let emptyImageView: UIImageView = {
        let iv = UIImageView(image: UIImage(named: "Star"))
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private let emptyLabel: UILabel = {
        let label = UILabel()
        label.text = "Что будем отслеживать?"
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textColor = UIColor(red: 26/255, green: 27/255, blue: 34/255, alpha: 1.0)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Коллекция трекеров
    private var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 12
        layout.minimumInteritemSpacing = 9
        layout.sectionInset = UIEdgeInsets(top: 12, left: 16, bottom: 12, right: 16)
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    private var filteredCategories: [TrackerCategory] = []
    private var searchText: String = ""
    private let calendar = Calendar.current

    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.setNavigationBarHidden(true, animated: false)
        view.backgroundColor = .white
        
        setupLayout()
        searchBar.delegate = self
        
        plusButton.addTarget(self, action: #selector(addTapped), for: .touchUpInside)
        datePicker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
        
        loadMockData()
        applyFilters()
        
    }
    
    
    // MARK: - Layout
    private func setupLayout() {
        
        view.addSubview(plusButton)
        view.addSubview(titleLabel)
        view.addSubview(searchBar)
        view.addSubview(datePicker)
        view.addSubview(collectionView)

        
        NSLayoutConstraint.activate([
            datePicker.centerYAnchor.constraint(equalTo: plusButton.centerYAnchor),
            datePicker.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            datePicker.widthAnchor.constraint(equalToConstant: 90),
            datePicker.heightAnchor.constraint(equalToConstant: 40),
            
            plusButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 1),
            plusButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 7),
            plusButton.widthAnchor.constraint(equalToConstant: 42),
            plusButton.heightAnchor.constraint(equalToConstant: 42),
            
            titleLabel.topAnchor.constraint(equalTo: plusButton.bottomAnchor, constant: 1),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            searchBar.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 7),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            searchBar.heightAnchor.constraint(equalToConstant: 36)
        ])
        
        view.addSubview(emptyImageView)
        view.addSubview(emptyLabel)
        
        NSLayoutConstraint.activate([
            emptyImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emptyImageView.widthAnchor.constraint(equalToConstant: 80),
            emptyImageView.heightAnchor.constraint(equalToConstant: 80),
            
            emptyLabel.topAnchor.constraint(equalTo: emptyImageView.bottomAnchor, constant: 8),
            emptyLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            emptyLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(TrackerCell.self, forCellWithReuseIdentifier: TrackerCell.identifier)
        collectionView.register(TrackersSectionHeader.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: TrackersSectionHeader.reuseIdentifier)

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 8),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func updateEmptyState() {
        let hasTrackers = filteredCategories.flatMap { $0.trackers }.isEmpty == false
        emptyImageView.isHidden = hasTrackers
        emptyLabel.isHidden = hasTrackers
        collectionView.isHidden = !hasTrackers
    }
    
    private func applyFilters() {
        let selectedDate = datePicker.date
        let normalizedSearch = searchText.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        guard let weekday = Weekday.from(date: selectedDate, calendar: calendar) else {
            filteredCategories = []
            collectionView.reloadData()
            updateEmptyState()
            return
        }
        
        filteredCategories = categories.compactMap { category in
            let trackers = category.trackers.filter { tracker in
                let matchesSearch = normalizedSearch.isEmpty || tracker.title.lowercased().contains(normalizedSearch)
                let matchesSchedule = tracker.schedule.isEmpty || tracker.schedule.contains(weekday)
                return matchesSearch && matchesSchedule
            }
            return trackers.isEmpty ? nil : TrackerCategory(title: category.title, trackers: trackers)
        }
        
        collectionView.reloadData()
        updateEmptyState()
    }

    // MARK: - Actions
    
    @objc private func addTapped() {
          let vc = CreateTrackerTypeViewController()
          vc.creationDelegate = self
          vc.availableCategories = categories.reduce(into: [String]()) { result, category in
              if !result.contains(category.title) {
                  result.append(category.title)
              }
          }
          let nav = UINavigationController(rootViewController: vc)
          nav.modalPresentationStyle = .pageSheet
          present(nav, animated: true)
      }
      
      @objc private func dateChanged() {
          applyFilters()
      }
    
    // MARK: - Data
    var categories: [TrackerCategory] = []
    var completedTrackers: [TrackerRecord] = []

    func complete(tracker: Tracker, on date: Date) {
        let normalizedDate = normalized(date: date)
        guard !isTrackerCompleted(tracker, on: normalizedDate) else { return }
        let record = TrackerRecord(trackerId: tracker.id, date: normalizedDate)
        completedTrackers.append(record)
    }

    func uncomplete(tracker: Tracker, on date: Date) {
        let normalizedDate = normalized(date: date)
        completedTrackers.removeAll {
            $0.trackerId == tracker.id && calendar.isDate($0.date, inSameDayAs: normalizedDate)
        }
    }

    // Для теста 
    func loadMockData() {
        let plants = Tracker(
            id: UUID(),
            title: "Поливать растения",
            colorHex: "#34C759",
            emoji: "😪",
            schedule: Weekday.allCases
        )
        let running = Tracker(
            id: UUID(),
            title: "Бег 3 км",
            colorHex: "#FD4C49",
            emoji: "🏃‍♂️",
            schedule: [.monday, .wednesday, .friday]
        )
        let reading = Tracker(
            id: UUID(),
            title: "Чтение 30 мин",
            colorHex: "#4ECDC4",
            emoji: "📖",
            schedule: [.tuesday, .thursday, .saturday]
        )
        let cozyCategory = TrackerCategory(title: "Домашний уют", trackers: [plants])
        let healthCategory = TrackerCategory(title: "Здоровье", trackers: [running])
        let hobbyCategory = TrackerCategory(title: "Саморазвитие", trackers: [reading])
        categories = [cozyCategory, healthCategory, hobbyCategory]
    }
    
    private func normalized(date: Date) -> Date {
        return calendar.startOfDay(for: date)
    }

    private func isTrackerCompleted(_ tracker: Tracker, on date: Date) -> Bool {
        return completedTrackers.contains {
            $0.trackerId == tracker.id && calendar.isDate($0.date, inSameDayAs: date)
        }
    }
    
    private func completedCount(for tracker: Tracker) -> Int {
        return completedTrackers.filter { $0.trackerId == tracker.id }.count
    }
    
    private func isFuture(date: Date) -> Bool {
        let today = normalized(date: Date())
        let selected = normalized(date: date)
        return selected > today
    }
    
    private func formattedDaysText(for count: Int) -> String {
        let remainder10 = count % 10
        let remainder100 = count % 100
        let suffix: String
        if remainder100 >= 11 && remainder100 <= 14 {
            suffix = "дней"
        } else {
            switch remainder10 {
            case 1:
                suffix = "день"
            case 2...4:
                suffix = "дня"
            default:
                suffix = "дней"
            }
        }
        return "\(count) \(suffix)"
    }
    
    private func color(for tracker: Tracker) -> UIColor {
        return UIColor(hex: tracker.colorHex) ?? UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1.0)
    }

  }

extension TrackersViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return filteredCategories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredCategories[section].trackers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TrackerCell.identifier, for: indexPath) as? TrackerCell else {
            return UICollectionViewCell()
        }
        
        let tracker = filteredCategories[indexPath.section].trackers[indexPath.item]
        let selectedDate = datePicker.date
        let normalizedDate = normalized(date: selectedDate)
        let isCompleted = isTrackerCompleted(tracker, on: normalizedDate)
        let count = completedCount(for: tracker)
        let daysText = formattedDaysText(for: count)
        let color = color(for: tracker)
        let buttonEnabled = !isFuture(date: selectedDate)
        
        cell.configure(with: tracker,
                       daysText: daysText,
                       color: color,
                       isCompleted: isCompleted,
                       isButtonEnabled: buttonEnabled)
        
        cell.plusAction = { [weak self, weak collectionView] in
            guard let self = self else { return }
            guard !self.isFuture(date: self.datePicker.date) else { return }
            let targetDate = self.normalized(date: self.datePicker.date)
            if self.isTrackerCompleted(tracker, on: targetDate) {
                self.uncomplete(tracker: tracker, on: targetDate)
            } else {
                self.complete(tracker: tracker, on: targetDate)
            }
            guard let collectionView = collectionView else {
                self.collectionView.reloadData()
                return
            }
            if indexPath.section < self.filteredCategories.count,
               indexPath.item < self.filteredCategories[indexPath.section].trackers.count {
                collectionView.reloadItems(at: [indexPath])
            } else {
                self.collectionView.reloadData()
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let availableWidth = collectionView.bounds.width
        let inset: CGFloat = 16 * 2
        let spacing: CGFloat = 9
        let columns: CGFloat = 2
        let width = (availableWidth - inset - spacing) / columns
        return CGSize(width: floor(width), height: 148)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader else {
            return UICollectionReusableView()
        }
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                           withReuseIdentifier: TrackersSectionHeader.reuseIdentifier,
                                                                           for: indexPath) as? TrackersSectionHeader else {
            return UICollectionReusableView()
        }
        header.configure(title: filteredCategories[indexPath.section].title)
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        guard section < filteredCategories.count else { return .zero }
        return CGSize(width: collectionView.bounds.width, height: 42)
    }
}

extension TrackersViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchText = searchText
        applyFilters()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

extension TrackersViewController: TrackerCreationDelegate {
    func trackerCreationDidCreate(_ tracker: Tracker, in categoryTitle: String) {
        if let index = categories.firstIndex(where: { $0.title == categoryTitle }) {
            categories[index].trackers.append(tracker)
        } else {
            categories.append(TrackerCategory(title: categoryTitle, trackers: [tracker]))
        }
        applyFilters()
    }
}
