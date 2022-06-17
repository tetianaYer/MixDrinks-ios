//
// Created by Vova Stelmashchuk on 09.06.2022.
//

import Foundation
import Alamofire

enum CocktailListUiModel {
    case loading
    case content([Cocktail])
}

final class CocktailsViewModel: ObservableObject {


    @Published var state: CocktailListUiModel = CocktailListUiModel.loading
    @Published var query: String = ""

    init() {
        fetchCocktails()
    }

    func fetchCocktails() {
        state = CocktailListUiModel.loading
        let parameters: Parameters = [
            "query": query,
            "limit": 20,
            "tags": SelectedFilterStorage.shared.get().tagIds.map { item in
                        String(item)
                    }
                    .joined(separator: ",")
        ]

        AF.request("https://api.mixdrinks.org/cocktails/filter",
                        method: .get,
                        parameters: parameters,
                        encoding: URLEncoding(destination: .queryString))
                .responseDecodable(of: CocktailResponse.self) { response in
                    guard let value = response.value else {
                        fatalError("guard failure handling has not been implemented")
                    }

                    self.state = CocktailListUiModel.content(value.cocktails)
                }
    }
}
