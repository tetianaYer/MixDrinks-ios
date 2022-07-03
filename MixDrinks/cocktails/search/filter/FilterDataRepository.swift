//
// Created by Vova Stelmashchuk on 09.06.2022.
//

import Foundation
import Alamofire

typealias Filters = [FilterGroup]

class FilterDataRepository {

    private var callbacks: [(Filters) -> Void] = []

    private var cache: Filters? = nil

    public init() {
        AF.request("https://api.mixdrinks.org/v2/filters")
                .responseDecodable(of: Filters.self) { response in
                    guard let value = response.value else {
                        fatalError("guard failure handling has not been implemented")
                    }

                    self.callbacks.forEach { (closure: (Filters) -> ()) in
                        closure(value)
                    }
                }
    }

    func addCallback(callback: @escaping (Filters) -> Void) {
        callbacks.append(callback)

        if let cache = cache {
            callback(cache)
        }
    }
}

struct FilterGroup: Decodable {
    let id: Int
    let queryName: String
    let name: String
    let items: [FilterItem]
}

struct FilterItem: Decodable {
    let id: Int
    let name: String
}
