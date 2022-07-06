//
// Created by Vova Stelmashchuk on 03.07.2022.
//

import Foundation
import Alamofire

class DataSource {

    private var cache: Snapshot? = nil

    private var onReady: (() -> Void)? = nil

    public init() {
        AF.request("https://api.mixdrinks.org/v2/snapshot")
                .responseDecodable(of: Snapshot.self) { response in
                    guard let value = response.value else {
                        fatalError("Cannot load snapshot")
                    }

                    self.cache = value
                    self.onReady!()
                }
    }

    func setOnReadyCallback(onReady: @escaping () -> Void) {
        if cache != nil {
            onReady()
        } else {
            self.onReady = onReady
        }
    }

    func getCocktails() -> [SnapShotCocktail] {
        cache!.cocktails
    }

    func getGoods() -> [SnapShotItem] {
        cache!.items.filter { item in
            item.relation == 1
        }
    }

    func getTools() -> [SnapShotItem] {
        cache!.items.filter { item in
            item.relation == 2
        }
    }

    func getTags() -> [SnapShotTag] {
        cache!.tags
    }
}

struct Snapshot: Decodable {
    let cocktails: [SnapShotCocktail]
    let items: [SnapShotItem]
    let tags: [SnapShotTag]
}

struct SnapShotCocktail: Decodable {
    let id: Int
    let name: String
    let steps: [String]
}

struct SnapShotItem: Decodable {
    let id: Int
    let name: String
    let relation: Int
}

struct SnapShotTag: Decodable {
    let id: Int
    let name: String
}