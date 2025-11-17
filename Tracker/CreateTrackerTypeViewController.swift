//
//  CreateTrackerTypeViewController.swift
//  Tracker
//
//  Created by Artem Kuzmenko on 16.11.2025.
//

import UIKit

final class CreateTrackerTypeViewController: UIViewController {

    // MARK: - UI Elements

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Создание трекера"
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor(red: 26/255, green: 27/255, blue: 34/255, alpha: 1.0)
        return label
    }()

    private lazy var habitButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Привычка", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.setTitleColor(UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0), for: .normal)
        button.backgroundColor = UIColor.systemGray6
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(habitTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var irregularButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Нерегулярное событие", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.setTitleColor(UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0), for: .normal)
        button.backgroundColor = UIColor.systemGray6
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(irregularTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.layer.cornerRadius = 16
        view.clipsToBounds = true
        configureUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupSheet()
    }

    // MARK: - Setup UI

    private func configureUI() {
        view.addSubview(titleLabel)
        view.addSubview(habitButton)
        view.addSubview(irregularButton)

        NSLayoutConstraint.activate([
            // Заголовок сверху
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 27),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            // Кнопки по центру экрана
            habitButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -30),
            habitButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            habitButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            habitButton.heightAnchor.constraint(equalToConstant: 60),

            irregularButton.topAnchor.constraint(equalTo: habitButton.bottomAnchor, constant: 16),
            irregularButton.leadingAnchor.constraint(equalTo: habitButton.leadingAnchor),
            irregularButton.trailingAnchor.constraint(equalTo: habitButton.trailingAnchor),
            irregularButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }

    private func setupSheet() {
        if let sheet = sheetPresentationController {
            sheet.detents = [.large()]
            sheet.prefersGrabberVisible = false
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
            sheet.preferredCornerRadius = 16
        }
    }

    // MARK: - Actions

    @objc private func habitTapped() {
        let vc = CreateHabitViewController()
        vc.modalPresentationStyle = .pageSheet
        present(vc, animated: true)
    }

    @objc private func irregularTapped() {
        Router.shared.presentCreateIrregular()
        dismiss(animated: true)
    }

    // MARK: - Router

    final class Router {
        static let shared = Router()
        private init() {}

        func presentCreateHabit() {
            print("Router: открыть экран привычки")
        }

        func presentCreateIrregular() {
            print("Router: открыть экран нерегулярного события")
        }
    }
}
