//
// Created by Vova Stelmashchuk on 06.07.2022.
//

import Foundation
import SwiftUI

struct StartScreen: View {

    @State private var showSplash = true

    let dataSource = DataSource()

    var body: some View {
        if showSplash {
            Text("Start")
                    .onAppear {
                        dataSource.setOnReadyCallback { [self] in
                            print("DataSource is ready")
                            showSplash.toggle()
                        }
                    }
        } else {
            let filterSelectedStorage = FilterSelectedStorage()
            let filterSearchStorage = FilterSearchStorage()
            let filterDataSource = FilterDataSource(dataSource: dataSource)
            let filterExpandsStorage = FilterExpandsStorage()

            let cocktailsViewModel = CocktailsViewModel(
                    cocktailsProvider: CocktailsProvider(
                            cocktailsDataSource: CocktailsDataSource(dataSource: dataSource),
                            filterSelectedStorage: filterSelectedStorage
                    )
            )

            let filterViewModel = FilterViewModel(
                    selectedFilterStorage: filterSelectedStorage,
                    filterSearchStorage: filterSearchStorage,
                    filterExpandsStorage: filterExpandsStorage,
                    filterStateProvider: FilterStateProvider(
                            filterSearchStorage: filterSearchStorage,
                            filterDataSource: filterDataSource,
                            filterExpandsStorage: filterExpandsStorage,
                            filterSelectedStorage: filterSelectedStorage
                    )
            )

            let cocktailDetailViewModel = CocktailDetailsViewModel(
                    cocktailDetailsAggregator: CocktailDetailsAggregator()
            )

            CocktailsView()
                    .environmentObject(cocktailsViewModel)
                    .environmentObject(filterViewModel)
                    .environmentObject(cocktailDetailViewModel)
        }
    }
}