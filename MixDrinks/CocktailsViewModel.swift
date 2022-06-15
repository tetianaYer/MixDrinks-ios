//
// Created by Vova Stelmashchuk on 09.06.2022.
//

import Foundation

final class CocktailsViewModel: ObservableObject {

    @Published var searchResult: [Cocktail] = []
    @Published var query: String = ""

    init() {
        fetchCocktails()
    }

    func fetchCocktails() {
        var url = URL(string: "https://api.mixdrinks.org/cocktails/filter")!
        url.appendQueryItem(name: "query", value: query)
        url.appendQueryItem(name: "limit", value: "20")

        let urlRequest = URLRequest(url: url)

        let dataTask = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if let error = error {
                print("Request error: ", error)
                return
            }

            guard let response = response as? HTTPURLResponse else {
                return
            }

            if response.statusCode == 200 {
                guard let data = data else {
                    return
                }
                DispatchQueue.main.async {
                    do {
                        self.searchResult = (try JSONDecoder().decode(CocktailResponse.self, from: data)).cocktails
                    } catch let error {
                        print("Error decoding: ", error)
                    }
                }
            }
        }

        dataTask.resume()
    }
}

extension URL {

    mutating func appendQueryItem(name: String, value: String?) {

        guard var urlComponents = URLComponents(string: absoluteString) else { return }

        // Create array of existing query items
        var queryItems: [URLQueryItem] = urlComponents.queryItems ??  []

        // Create query item
        let queryItem = URLQueryItem(name: name, value: value)

        // Append the new query item in the existing query items array
        queryItems.append(queryItem)

        // Append updated query items array in the url component object
        urlComponents.queryItems = queryItems

        // Returns the url from new url components
        self = urlComponents.url!
    }
}

