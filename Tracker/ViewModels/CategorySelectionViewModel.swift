import Foundation

struct CategorySelectionState {
    let categories: [String]
    let selectedCategory: String?
    
    var isEmpty: Bool {
        categories.isEmpty
    }
}

final class CategorySelectionViewModel {
    
    var onStateChange: ((CategorySelectionState) -> Void)?
    
    private(set) var state: CategorySelectionState {
        didSet {
            onStateChange?(state)
        }
    }
    
    init(categories: [String], selectedCategory: String?) {
        self.state = CategorySelectionState(categories: categories, selectedCategory: selectedCategory)
    }
    
    func bind() {
        onStateChange?(state)
    }
    
    func selectCategory(at index: Int) {
        guard index < state.categories.count else { return }
        let category = state.categories[index]
        state = CategorySelectionState(categories: state.categories, selectedCategory: category)
    }
    
    func addCategory(_ title: String) {
        let trimmed = title.trimmingCharacters(in: .whitespacesAndNewlines)
        guard trimmed.isEmpty == false else { return }
        
        if let existingIndex = state.categories.firstIndex(where: { $0.caseInsensitiveCompare(trimmed) == .orderedSame }) {
            selectCategory(at: existingIndex)
            return
        }
        
        var updated = state.categories
        updated.append(trimmed)
        state = CategorySelectionState(categories: updated, selectedCategory: trimmed)
    }
    
    func categories() -> [String] {
        state.categories
    }
    
    func selectedCategoryTitle() -> String? {
        state.selectedCategory
    }
}

