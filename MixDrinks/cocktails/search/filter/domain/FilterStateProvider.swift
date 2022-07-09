//
// Created by Vova Stelmashchuk on 04.07.2022.
//

import Foundation


class FilterStateProvider {

    private let dataSource: DataSource
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
            dataSource: DataSource,
            filterSearchStorage: FilterSearchStorage,
            filterDataSource: FilterDataSource,
            filterExpandsStorage: FilterExpandsStorage,
            filterSelectedStorage: FilterSelectedStorage
    ) {
        self.dataSource = dataSource
        self.filterSearchStorage = filterSearchStorage
        self.filterExpandsStorage = filterExpandsStorage
        self.filterSelectedStorage = filterSelectedStorage

        filterGroups = filterDataSource.getFilterGroups()

        filterExpandsStorage.addCallback { expandGroups in
            self.expandedGroups = expandGroups
            self.recalculate()
        }
        filterSelectedStorage.addCallback { state in
            self.selectedFilters = state
            self.recalculate()
        }
        filterSearchStorage.addCallback { dictionary in
            self.queries = dictionary
            self.recalculate()
        }
    }

    private func recalculate() {
        Task {
            lastState = await getNewState(withCount: false)
            notify()
            lastState = await getNewState(withCount: true)
            notify()
        }
    }

    private func notify() {
        callbacks.forEach { (closure: ([FilterGroup]) -> ()) in
            closure(lastState!)
        }
    }

    private func getNewState(withCount: Bool) async -> [FilterGroup] {
        filterGroups.map { (group) -> FilterGroup in
            let isExpanded = expandedGroups.contains(group.id)

            var filterToShow = group.items

            let query = queries[group.id]
            if (query != nil && !query!.isEmpty) {
                filterToShow = filterToShow.filter { (filter) -> Bool in
                    filter.name.lowercased().contains(query!.lowercased())
                }
            }

            var items = filterToShow.map { (item) -> FilterItem in
                let isSelected = selectedFilters[group.id]?.contains(item.id) ?? false
                var futureCount = 0

                if (!isSelected && withCount) {
                    futureCount = dataSource.getCocktailsByFilters(selectedFilters: getFutureFilters(group: group.id, filterId: item.id)).count
                }

                return FilterItem(
                        id: item.id,
                        name: item.name,
                        isSelected: isSelected,
                        futureCount: futureCount
                )
            }

            items = items.sorted { (lhs, rhs) in
                if (lhs.isSelected == rhs.isSelected) {
                    return lhs.futureCount > rhs.futureCount
                } else {
                    return lhs.isSelected
                }
            }

            let itemToShowCount = items.filter { (item) -> Bool in
                        item.isSelected
                    }
                    .count + 5

            items = isExpanded ? items : items[range: 0...min(group.items.count, itemToShowCount)]

            return FilterGroup(id: group.id, name: group.name, filters: items, searchText: query ?? "", isExpanded: isExpanded)
        }
    }

    private func getFutureFilters(group: Int, filterId: Int) -> SelectedFiltersState {
        var futureState = selectedFilters
        var selectedFilter = futureState[group] ?? []

        selectedFilter.append(filterId)
        futureState[group] = selectedFilter

        return futureState
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
    var filters: [FilterItem]
    var searchText: String = ""
    var isExpanded: Bool
}

struct FilterItem {
    let id: Int
    let name: String
    let isSelected: Bool
    let futureCount: Int
}

extension Array {

    subscript(range r: Range<Int>) -> Array {
        Array(self[r])
    }


    subscript(range r: ClosedRange<Int>) -> Array {
        Array(self[r])
    }
}
