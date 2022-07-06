//
// Created by Vova Stelmashchuk on 06.07.2022.
//

import Foundation

class CocktailsProvider {

    private var callbacks: [([Cocktail]) -> Void] = []

    private var cocktails: [Cocktail] = []
    private var selectedFilters: SelectedFiltersState = [:]

    public init(cocktailsDataSource: CocktailsDataSource,
                filterSelectedStorage: FilterSelectedStorage) {
        cocktailsDataSource.addCallback { cocktails in
            self.cocktails = cocktails
            self.notify()
        }

        filterSelectedStorage.addCallback { state in
            self.selectedFilters = state
            self.notify()
        }
    }

    private func notify() {
        let filteredCocktails = filterCocktails(cocktails: cocktails, selectedFilters: selectedFilters)
        callbacks.forEach { callback in
            callback(filteredCocktails)
        }
    }

    private func filterCocktails(cocktails: [Cocktail], selectedFilters: [Int: [Int]]) {
        let filteredCocktails = cocktails.filter { cocktail in
            for (filterGroupId, filterId) in selectedFilters {
                cocktail.name
                if !filterValues.contains(cocktailFilters[filterId]) {
                    return false
                }
            }
            return true
        }
        return filteredCocktails
    }

    func addCallback(closure: @escaping ([Cocktail]) -> Void) {
        callbacks.append(closure)
        closure(cocktails)
    }
}
