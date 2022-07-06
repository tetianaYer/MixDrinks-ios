//
// Created by Vova Stelmashchuk on 06.07.2022.
//

import Foundation

class CocktailsDataSource {

    private let dataSource: DataSource

    private var last: [Cocktail]? = nil

    private var callback: [([Cocktail]) -> Void] = []

    init(dataSource: DataSource) {
        self.dataSource = dataSource

        last = dataSource.getCocktails().map { item -> Cocktail in
            Cocktail(id: item.id, name: item.name)
        }

        callback.forEach { (closure: ([Cocktail]) -> ()) in
            closure(last!)
        }
    }

    func addCallback(closure: @escaping ([Cocktail]) -> Void) {
        callback.append(closure)

        if let last = last {
            closure(last)
        }
    }
}

struct Cocktail {
    let id: Int
    let name: String
}
