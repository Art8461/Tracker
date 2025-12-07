import Foundation

enum TrackerCreationType {
    case habit
    case irregular
    
    var requiresSchedule: Bool {
        switch self {
        case .habit:
            return true
        case .irregular:
            return false
        }
    }
}

struct TrackerCreationState {
    let type: TrackerCreationType
    var name: String
    var category: String?
    var emoji: String?
    var colorHex: String?
    var schedule: [Weekday]
    var availableCategories: [String]
    let nameCharacterLimit: Int
    
    var trimmedName: String {
        name.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    var isNameValid: Bool {
        trimmedName.isEmpty == false
    }

    var isNameLengthValid: Bool {
        name.count <= nameCharacterLimit
    }

    var shouldShowNameLimitWarning: Bool {
        name.count >= nameCharacterLimit
    }
    
    var isScheduleValid: Bool {
        type.requiresSchedule ? schedule.isEmpty == false : true
    }
    
    var isValid: Bool {
        isNameValid
        && isNameLengthValid
        && category != nil
        && emoji != nil
        && colorHex != nil
        && isScheduleValid
    }
    
    var scheduleSummary: String? {
        guard type.requiresSchedule, isScheduleValid else { return nil }
        if schedule.count == Weekday.allCases.count {
            return "Каждый день"
        }
        let sorted = schedule.sorted { $0.rawValue < $1.rawValue }
        return sorted.map { $0.shortTitle }.joined(separator: ", ")
    }

    var nameLimitText: String {
        "Ограничение \(nameCharacterLimit) символов"
    }
}

final class TrackerCreationViewModel {
    
    var onStateChange: ((TrackerCreationState) -> Void)?
    private let nameCharacterLimit = 38
    
    private(set) var state: TrackerCreationState {
        didSet {
            onStateChange?(state)
        }
    }
    
    init(type: TrackerCreationType, availableCategories: [String] = []) {
        self.state = TrackerCreationState(type: type,
                                          name: "",
                                          category: nil,
                                          emoji: nil,
                                          colorHex: nil,
                                          schedule: [],
                                          availableCategories: availableCategories,
                                          nameCharacterLimit: nameCharacterLimit)
    }
    
    func bind() {
        onStateChange?(state)
    }
    
    func updateAvailableCategories(_ categories: [String]) {
        var newState = state
        newState.availableCategories = categories
        state = newState
    }
    
    func updateName(_ name: String) {
        var newState = state
        newState.name = name
        state = newState
    }
    
    func updateCategory(_ category: String, categories: [String]) {
        var newState = state
        newState.category = category
        newState.availableCategories = categories
        state = newState
    }
    
    func updateEmoji(_ emoji: String) {
        var newState = state
        newState.emoji = emoji
        state = newState
    }
    
    func updateColor(hex: String) {
        var newState = state
        newState.colorHex = hex
        state = newState
    }
    
    func updateSchedule(_ schedule: [Weekday]) {
        var newState = state
        newState.schedule = schedule
        state = newState
    }
    
    func makeTracker() -> (tracker: Tracker, categoryTitle: String)? {
        guard state.isValid,
              let category = state.category,
              let emoji = state.emoji,
              let colorHex = state.colorHex else {
            return nil
        }
        
        let tracker = Tracker(id: UUID(),
                              title: state.trimmedName,
                              colorHex: colorHex,
                              emoji: emoji,
                              schedule: state.schedule)
        return (tracker, category)
    }
}

