//
// Created by Vova Stelmashchuk on 09.06.2022.
//

import Foundation

struct CocktailResponse: Decodable {
    var totalCount: Int
    var cocktails: [Cocktail]
}

struct Cocktail: Identifiable, Decodable {
    var id: Int
    var name: String
}
