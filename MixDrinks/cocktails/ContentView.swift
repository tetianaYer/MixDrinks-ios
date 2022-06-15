//
//  ContentView.swift
//  MixDrinks
//
//  Created by Vova Stelmashchuk on 09.06.2022.
//
//

import SwiftUI

struct ContentView: View {

    @EnvironmentObject var viewModel: CocktailsViewModel

    @State private var showingFilter = false

    var body: some View {
        VStack(spacing: 30) {
            HStack {
                TextField("Search", text: $viewModel.query)
                        .font(.body)
                        .padding()
                        .background(Color(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 0.2662717301)))
                        .cornerRadius(20)
                        .onChange(of: viewModel.query) { text in
                            viewModel.fetchCocktails()
                        }

                Button(action: { showingFilter.toggle() }) {
                    Image(systemName: "line.3.horizontal.decrease.circle")
                }
                        .sheet(isPresented: $showingFilter, onDismiss: { viewModel.fetchCocktails() }) {
                            FilterView()
                        }
            }
                    .padding(.horizontal)


            switch viewModel.state {
            case .content(let cocktails):
                ScrollView {
                    ForEach(cocktails) { cocktail in
                        CocktailCard(cocktail: cocktail)
                    }
                }
            case .loading:
                ProgressView()
            }
        }
    }
}

struct CocktailCard: View {
    var cocktail: Cocktail

    var body: some View {
        HStack {
            AsyncImage(
                    url: URL(string: "https://image.mixdrinks.org/cocktails/\(cocktail.id)/320/\(cocktail.id).jpg"),
                    content: { image in
                        image.resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(maxWidth: 100, maxHeight: 100)
                    },
                    placeholder: {
                        ProgressView()
                    }
            )
                    .frame(maxWidth: 100, alignment: .leading)

            Text(cocktail.name)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
        }
                .frame(height: 100)
                .padding(.horizontal)
    }
}
