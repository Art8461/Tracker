//
//  Tracker.swift
//  Tracker
//
//  Created by Artem Kuzmenko on 18.11.2025.
//


import Foundation

// MARK: - Tracker

struct Tracker {
    let id: UUID
    let title: String
    let colorHex: String
    let emoji: String
    let schedule: [Weekday]
}

// MARK: - Weekday

enum Weekday: Int, CaseIterable, Codable {
    case monday = 1
    case tuesday
    case wednesday
    case thursday
    case friday
    case saturday
    case sunday
}

// MARK: - TrackerCategory

struct TrackerCategory {
    let title: String
    let trackers: [Tracker]
}

// MARK: - TrackerRecord

struct TrackerRecord {
    let trackerId: UUID
    let date: Date
}
