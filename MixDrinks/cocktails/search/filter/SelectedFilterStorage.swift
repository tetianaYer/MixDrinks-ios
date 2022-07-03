//
// Created by Vova Stelmashchuk on 15.06.2022.
//

import Foundation

typealias SelectedFiltersState = [Int: [Int]]

class SelectedFilterStorage {

    private var state: SelectedFiltersState = [:]

    private var callbacks: [(SelectedFiltersState) -> Void] = []

    func change(filterGroupId: Int, filterId: Int) {
        var filters: [Int] = state[filterGroupId] ?? []

        if (filters.contains(filterId)) {
            filters.removeAll { existId in
                existId == filterId
            }
        } else {
            filters.append(filterId)
        }

        state[filterGroupId] = filters

        notify()
    }

    func addCallback(callback: @escaping (SelectedFiltersState) -> Void) {
        callbacks.append(callback)

        callback(state)
    }

    func isSelected(filterGroupId: Int, filterId: Int) -> Bool {
        (state[filterGroupId] ?? []).contains(filterId)
    }

    func get() -> SelectedFiltersState {
        state
    }

    private func notify() {
        callbacks.forEach { (closure: (SelectedFiltersState) -> ()) in
            closure(state)
        }
    }
}
