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
    let isPinned: Bool
    
    init(id: UUID,
         title: String,
         colorHex: String,
         emoji: String,
         schedule: [Weekday],
         isPinned: Bool = false) {
        self.id = id
        self.title = title
        self.colorHex = colorHex
        self.emoji = emoji
        self.schedule = schedule
        self.isPinned = isPinned
    }
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

extension Weekday {
    var localizedName: String {
        switch self {
        case .monday: return NSLocalizedString("Понедельник", comment: "Weekday Monday")
        case .tuesday: return NSLocalizedString("Вторник", comment: "Weekday Tuesday")
        case .wednesday: return NSLocalizedString("Среда", comment: "Weekday Wednesday")
        case .thursday: return NSLocalizedString("Четверг", comment: "Weekday Thursday")
        case .friday: return NSLocalizedString("Пятница", comment: "Weekday Friday")
        case .saturday: return NSLocalizedString("Суббота", comment: "Weekday Saturday")
        case .sunday: return NSLocalizedString("Воскресенье", comment: "Weekday Sunday")
        }
    }
    
    var shortTitle: String {
        switch self {
        case .monday: return NSLocalizedString("Пн", comment: "Weekday short Monday")
        case .tuesday: return NSLocalizedString("Вт", comment: "Weekday short Tuesday")
        case .wednesday: return NSLocalizedString("Ср", comment: "Weekday short Wednesday")
        case .thursday: return NSLocalizedString("Чт", comment: "Weekday short Thursday")
        case .friday: return NSLocalizedString("Пт", comment: "Weekday short Friday")
        case .saturday: return NSLocalizedString("Сб", comment: "Weekday short Saturday")
        case .sunday: return NSLocalizedString("Вс", comment: "Weekday short Sunday")
        }
    }
    
    static func from(date: Date, calendar: Calendar = Calendar.current) -> Weekday? {
        let weekday = calendar.component(.weekday, from: date)
        let isoWeekday = ((weekday + 5) % 7) + 1
        return Weekday(rawValue: isoWeekday)
    }
}

// MARK: - TrackerCategory

struct TrackerCategory {
    let title: String
    let trackers: [Tracker]
}

// MARK: - TrackerRecord

struct TrackerRecord: Hashable {
    let trackerId: UUID
    let date: Date
}
