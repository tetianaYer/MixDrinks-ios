//
// Created by Vova Stelmashchuk on 17.06.2022.
//

import Foundation
import Alamofire

struct FullCocktailResponse: Decodable {
    var id: Int
    var name: String
    var receipt: [String]
}

struct CocktailDetail {
    var cocktail: FullCocktailResponse
}

final class CocktailDetailsAggregator {

    var cocktailInfo: FullCocktailResponse? = nil

    func loadCocktail(id: Int, onData: @escaping (CocktailDetail) -> Void) {
        fetchCocktail(id: id, onData: onData)
    }

    private func fetchCocktail(id: Int, onData: @escaping (CocktailDetail) -> Void) {
        let parameters: Parameters = [
            "id": id
        ]

        AF.request("https://api.mixdrinks.org/cocktails/full",
                        method: .get,
                        parameters: parameters,
                        encoding: URLEncoding(destination: .queryString))
                .responseDecodable(of: FullCocktailResponse.self) { response in
                    guard let value = response.value else {
                        fatalError("Full cocktail has not been implemented")
                    }

                    self.cocktailInfo = value
                    self.sendIfReady(onData: onData)
                }
    }

    private func sendIfReady(onData: (CocktailDetail) -> Void) {
        if (cocktailInfo != nil) {
            onData(CocktailDetail(cocktail: cocktailInfo!))
        }
    }

}