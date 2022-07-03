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

    private var selectedFilterStorage: SelectedFilterStorage
    private var filterDataRepository: FilterDataRepository

    init(selectedFilterStorage: SelectedFilterStorage, filterDataRepository: FilterDataRepository) {
        self.selectedFilterStorage = selectedFilterStorage
        self.filterDataRepository = filterDataRepository
        fetchCocktails()
    }

    private func fetchCocktails() {
        var parameters: Parameters = [
            "page": 0,
        ]

        filterDataRepository.addCallback { filters in
            self.selectedFilterStorage.addCallback { selectedFilterState in
                selectedFilterState.forEach { key, value in
                    let filterGroup = filters.first { group in
                        group.id == key
                    }

                    parameters[filterGroup!.queryName] = value.map { item in
                                String(item)
                            }
                            .joined(separator: ",")
                }

                self.state = CocktailListUiModel.loading

                AF.request("https://api.mixdrinks.org/v2/search/cocktails",
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
    }
}
