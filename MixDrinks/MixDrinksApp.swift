//
//  MixDrinksApp.swift
//  MixDrinks
//
//  Created by Vova Stelmashchuk on 09.06.2022.
//
//

import SwiftUI

@main
struct MixDrinksApp: App {

    var selectedFilterStorage: SelectedFilterStorage
    var cocktailsViewModel: CocktailsViewModel
    var filterViewModel: FilterViewModel
    var filterDataRepository: FilterDataRepository

    init() {
        selectedFilterStorage = SelectedFilterStorage()
        filterDataRepository = FilterDataRepository()

        cocktailsViewModel = CocktailsViewModel(
                selectedFilterStorage: selectedFilterStorage, filterDataRepository: filterDataRepository
        )

        filterViewModel = FilterViewModel(
                filterDataRepository: filterDataRepository,
                selectedFilterStorage: selectedFilterStorage
        )
    }

    var cocktailDetailViewModel = CocktailDetailsViewModel(
            cocktailDetailsAggregator: CocktailDetailsAggregator()
    )

    var body: some Scene {
        WindowGroup {
            CocktailsView()
                    .environmentObject(cocktailsViewModel)
                    .environmentObject(filterViewModel)
                    .environmentObject(cocktailDetailViewModel)
        }
    }
}
