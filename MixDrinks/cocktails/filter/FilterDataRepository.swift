//
// Created by Vova Stelmashchuk on 09.06.2022.
//

import Foundation
import Alamofire

class FilterDataRepository {

    static let shared = FilterDataRepository()

    private var callbacks: [(MetaResponse) -> Void] = []

    private init() {
        print("init data repository")
        AF.request("https://api.mixdrinks.org/meta/all")
                .responseDecodable(of: MetaResponse.self) { response in
                    guard let value = response.value else {
                        fatalError("guard failure handling has not been implemented")
                    }

                    self.callbacks.forEach { (closure: (MetaResponse) -> ()) in
                        closure(value)
                    }
                }
    }

    func addCallback(callback: @escaping (MetaResponse) -> Void) {
        callbacks.append(callback)
    }
}

struct MetaResponse: Decodable {
    let tags: [Int: String]
    let goods: [Int: String]
    let tools: [Int: String]
}
