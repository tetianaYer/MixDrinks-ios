//
// Created by Vova Stelmashchuk on 15.06.2022.
//

import Foundation

class SelectedFilterStorage {

    private var tagIds: [Int] = []
    private var toolIds: [Int] = []
    private var goodIds: [Int] = []

    private var callbacks: [(SelectedFilters) -> Void] = []

    func tagChange(id: Int) {
        if (tagIds.contains(id)) {
            tagIds.removeAll { existId in
                existId == id
            }
        } else {
            tagIds.append(id)
        }
        notify()
    }

    func addCallback(callback: @escaping (SelectedFilters) -> Void) {
        callbacks.append(callback)
    }

    func get() -> SelectedFilters {
        SelectedFilters(tagIds: tagIds, toolId: toolIds, goodId: goodIds)
    }

    private func notify() {
        callbacks.forEach { (closure: (SelectedFilters) -> ()) in
            closure(SelectedFilters(tagIds: tagIds, toolId: toolIds, goodId: goodIds))
        }
    }

}

struct SelectedFilters {
    let tagIds: [Int]
    let toolId: [Int]
    let goodId: [Int]
}