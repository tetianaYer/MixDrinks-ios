//
// Created by Vova Stelmashchuk on 04.07.2022.
//

import Foundation

class FilterExpandsStorage {

    private var cache: [Int] = []

    private var callbacks: [([Int]) -> Void] = []

    func changeExpand(filterGroupId: Int) {
        if cache.contains(filterGroupId) {
            cache.removeAll { existId in
                existId == filterGroupId
            }
        } else {
            cache.append(filterGroupId)
        }

        callbacks.forEach { callback in
            callback(cache)
        }
    }

    func addCallback(callback: @escaping ([Int]) -> Void) {
        callbacks.append(callback)
        callback(cache)
    }
}
