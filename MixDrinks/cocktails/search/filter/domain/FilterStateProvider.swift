//
// Created by Vova Stelmashchuk on 04.07.2022.
//

import Foundation


class FilterStateProvider {

    private let filterSearchStorage: FilterSearchStorage
    private let filterExpandsStorage: FilterExpandsStorage
    private let filterSelectedStorage: FilterSelectedStorage

    private var callbacks: [([FilterGroup]) -> Void] = []

    private let filterGroups: [FilterGroupData]

    private var expandedGroups: [Int] = []
    private var selectedFilters: SelectedFiltersState = [:]
    private var queries: [Int: String] = [:]

    private var lastState: [FilterGroup]? = nil

    public init(
            filterSearchStorage: FilterSearchStorage,
            filterDataSource: FilterDataSource,
            filterExpandsStorage: FilterExpandsStorage,
            filterSelectedStorage: FilterSelectedStorage
    ) {
        self.filterSearchStorage = filterSearchStorage
        self.filterExpandsStorage = filterExpandsStorage
        self.filterSelectedStorage = filterSelectedStorage

        filterGroups = filterDataSource.getFilterGroups()

        filterExpandsStorage.addCallback { expandGroups in
            self.expandedGroups = expandGroups
            self.notify()
        }
        filterSelectedStorage.addCallback { state in
            self.selectedFilters = state
            self.notify()
        }
        filterSearchStorage.addCallback { dictionary in
            self.queries = dictionary
            self.notify()
        }
    }

    private func notify() {
        lastState = filterGroups.map { (group) -> FilterGroup in
            let isExpanded = expandedGroups.contains(group.id)

            var filterToShow = group.items

            let query = queries[group.id]
            if (query != nil && !query!.isEmpty) {
                filterToShow = filterToShow.filter { (filter) -> Bool in
                    filter.name.lowercased().contains(query!.lowercased())
                }
            }

            filterToShow = isExpanded ? group.items : group.items[range: 0...min(group.items.count, 5)]

            let items = filterToShow.map { (item) -> FilterItemUiModel in
                let isSelected = selectedFilters[group.id]?.contains(item.id) ?? false
                return FilterItemUiModel(filterId: item.id, name: item.name, isSelected: isSelected)
            }

            return FilterGroup(id: group.id, name: group.name, filters: items, searchText: query ?? "", isExpanded: isExpanded)
        }

        callbacks.forEach { (closure: ([FilterGroup]) -> ()) in
            closure(lastState!)
        }
    }

    func addCallback(callback: @escaping ([FilterGroup]) -> Void) {
        callbacks.append(callback)

        if let state = lastState {
            callback(state)
        }
    }
}

struct FilterGroup {
    var id: Int
    var name: String
    var filters: [FilterItemUiModel]
    var searchText: String = ""
    var isExpanded: Bool
}

struct FilterItem {
    var id: Int
    var name: String
    var isSelected: Bool
}

extension Array {

    subscript(range r: Range<Int>) -> Array {
        Array(self[r])
    }


    subscript(range r: ClosedRange<Int>) -> Array {
        Array(self[r])
    }
}
