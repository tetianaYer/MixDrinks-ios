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
                    print(response)
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

    func getCocktailTagIds(cocktailId: Int) -> [Int] {
        cache!.cocktailToTags
                .filter { tag in
                    tag.cocktailId == cocktailId
                }
                .map { tag in
                    tag.tagId
                }
    }

    func getCocktailGoodIds(cocktailId: Int) -> [Int] {
        cache!.cocktailToGoods
                .filter { item in
                    item.cocktailId == cocktailId
                }
                .map { item in
                    item.goodId
                }
    }

    func getCocktailToolIds(cocktailId: Int) -> [Int] {
        cache!.cocktailToTools
                .filter { item in
                    item.cocktailId == cocktailId
                }
                .map { tool in
                    tool.toolId
                }
    }
}

struct Snapshot: Decodable {
    let cocktails: [SnapShotCocktail]
    let items: [SnapShotItem]
    let tags: [SnapShotTag]
    let cocktailToTags: [SnapShotCocktailToTag]
    let cocktailToGoods: [SnapShotCocktailToGood]
    let cocktailToTools: [SnapShotCocktailToTool]
}

struct SnapShotCocktail: Decodable {
    let id: Int
    let name: String
    let steps: [String]
    let relation: SnapRelation
}

struct SnapRelation: Decodable {
    let tagIds: [Int]
    let goodIds: [Int]
    let toolIds: [Int]
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

struct SnapShotCocktailToTag: Decodable {
    let cocktailId: Int
    let tagId: Int
}

struct SnapShotCocktailToTool: Decodable {
    let cocktailId: Int
    let toolId: Int
}

struct SnapShotCocktailToGood: Decodable {
    let cocktailId: Int
    let goodId: Int
}