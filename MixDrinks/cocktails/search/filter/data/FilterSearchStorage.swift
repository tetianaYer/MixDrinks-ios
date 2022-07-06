//
// Created by Vova Stelmashchuk on 04.07.2022.
//

import Foundation

class FilterSearchStorage {

    private var queries: [Int: String] = [:]

    private var callbacks: [([Int: String]) -> Void] = []

    func set(query: String, for filterGroupId: Int) {
        queries[filterGroupId] = query
        notify()
    }

    func addCallback(callback: @escaping ([Int: String]) -> Void) {
        callbacks.append(callback)

        callback(queries)
    }

    private func notify() {
        callbacks.forEach { (closure: ([Int: String]) -> ()) in
            closure(queries)
        }
    }
}