//
// Created by Vova Stelmashchuk on 15.06.2022.
//

import Foundation

typealias SelectedFiltersSate = [Int: [Int]]

class SelectedFilterStorage {

    private var state: SelectedFiltersSate = [:]

    private var callbacks: [(SelectedFiltersSate) -> Void] = []

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

    func addCallback(callback: @escaping (SelectedFiltersSate) -> Void) {
        callbacks.append(callback)
    }

    func get() -> SelectedFiltersSate {
        state
    }

    private func notify() {
        callbacks.forEach { (closure: (SelectedFiltersSate) -> ()) in
            closure(state)
        }
    }
}
