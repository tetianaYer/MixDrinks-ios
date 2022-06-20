//
// Created by Vova Stelmashchuk on 09.06.2022.
//

import Foundation
import Alamofire

class FilterDataRepository {

    private var callbacks: [(FiltersResponse) -> Void] = []

    private var cache: FiltersResponse? = nil

    public init() {
        AF.request("https://api.mixdrinks.org/meta/all")
                .responseDecodable(of: FiltersResponse.self) { response in
                    guard let value = response.value else {
                        fatalError("guard failure handling has not been implemented")
                    }

                    self.callbacks.forEach { (closure: (FiltersResponse) -> ()) in
                        closure(value)
                    }
                }
    }

    func addCallback(callback: @escaping (FiltersResponse) -> Void) {
        callbacks.append(callback)

        if let cache = cache {
            callback(cache)
        }
    }
}

struct FiltersResponse: Decodable {
    let goods: [FilterItem]
    let tags: [FilterItem]
    let tools: [FilterItem]
}

struct FilterItem: Decodable {
    let id: Int
    let name: String
}
