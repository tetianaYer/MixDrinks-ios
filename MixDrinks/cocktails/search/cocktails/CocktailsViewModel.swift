//
// Created by Vova Stelmashchuk on 09.06.2022.
//

import Foundation
import Alamofire


final class CocktailsViewModel: ObservableObject {

    @Published var cocktails: [CocktailUiModel] = []

    private var cocktailsProvider: CocktailsProvider

    init(cocktailsProvider: CocktailsProvider) {
        self.cocktailsProvider = cocktailsProvider

        cocktailsProvider.addCallback { cocktails in
            self.cocktails = cocktails.map { cocktail -> CocktailUiModel in
                CocktailUiModel(
                        id: cocktail.id,
                        name: cocktail.name
                )
            }
        }
    }
}

struct CocktailUiModel: Identifiable {
    let id: Int
    let name: String
}
