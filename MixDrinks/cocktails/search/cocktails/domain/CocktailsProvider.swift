//
// Created by Vova Stelmashchuk on 06.07.2022.
//

import Foundation

class CocktailsProvider {

    private var callbacks: [([Cocktail]) -> Void] = []
    private var lastCocktails: [Cocktail] = []

    private var selectedFilters: SelectedFiltersState = [:]

    private let dataSource: DataSource

    public init(dataSource: DataSource,
                filterSelectedStorage: FilterSelectedStorage) {
        self.dataSource = dataSource

        filterSelectedStorage.addCallback { state in
            self.selectedFilters = state
            self.notify()
        }
        notify()
    }

    private func notify() {
        lastCocktails = dataSource.getCocktails()
                .filter { cocktail in
                    let cocktailTags: [Int] = cocktail.relation.tagIds

                    let newTag = (selectedFilters[tagRelationId] ?? []).first { filterId in
                        !cocktailTags.contains(filterId)
                    }

                    if (newTag != nil) {
                        return false
                    }

                    let cocktailGoods: [Int] = cocktail.relation.goodIds

                    let newGood = (selectedFilters[goodRelationId] ?? []).first { filterId in
                        !cocktailGoods.contains(filterId)
                    }

                    if (newGood != nil) {
                        return false
                    }

                    let cocktailTools: [Int] = cocktail.relation.toolIds

                    let newTool = (selectedFilters[toolRelationId] ?? []).first { filterId in
                        !cocktailTools.contains(filterId)
                    }

                    if (newTool != nil) {
                        return false
                    }

                    return true
                }
                .map { cocktail -> Cocktail in
                    Cocktail(id: cocktail.id, name: cocktail.name)
                }

        callbacks.forEach { callback in
            callback(lastCocktails)
        }
    }

    func addCallback(closure: @escaping ([Cocktail]) -> Void) {
        callbacks.append(closure)
        closure(lastCocktails)
    }
}

struct Cocktail {
    let id: Int
    let name: String
}
