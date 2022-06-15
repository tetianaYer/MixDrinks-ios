//
// Created by Vova Stelmashchuk on 09.06.2022.
//

import Foundation
import Alamofire

final class CocktailsViewModel: ObservableObject {

    @Published var searchResult: [Cocktail] = []
    @Published var query: String = ""

    init() {
        fetchCocktails()
    }

    func fetchCocktails() {
        print("Fetch \(SelectedFilterStorage.shared.get().tagIds)")
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
                    self.searchResult = value.cocktails
                    print("updates \(self.searchResult)")
                }
    }
}
