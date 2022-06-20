//
// Created by Vova Stelmashchuk on 17.06.2022.
//

import Foundation
import Alamofire

struct CocktailFullUiModel {
    var id: Int
    var name: String
    var steps: [Step]
}

struct Step: Identifiable {
    var id: Int
    var name: String
}

enum CocktailDetailUiModel {
    case loading
    case content(CocktailFullUiModel)
}

final class CocktailDetailsViewModel: ObservableObject {

    var cocktailDetailsAggregator: CocktailDetailsAggregator

    @Published var cocktailUiModel: CocktailDetailUiModel

    public init(cocktailDetailsAggregator: CocktailDetailsAggregator) {
        cocktailUiModel = .loading
        self.cocktailDetailsAggregator = cocktailDetailsAggregator
    }

    func fetch(id: Int) {
        cocktailDetailsAggregator.loadCocktail(id: id) { detail in
            self.cocktailUiModel = CocktailDetailUiModel.content(
                    CocktailFullUiModel(
                            id: detail.cocktail.id,
                            name: detail.cocktail.name,
                            steps: self.buildStep(steps: detail.cocktail.receipt)
                    )
            )
        }
    }

    private func buildStep(steps: [String]) -> [Step] {
        zip(steps.indices, steps).map {
            let step = Step(id: $0, name: $1)
            return step
        }
    }
}
