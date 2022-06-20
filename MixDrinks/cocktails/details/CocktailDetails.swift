//
// Created by Vova Stelmashchuk on 17.06.2022.
//

import Foundation
import SwiftUI

struct CocktailDetails: View {

    @EnvironmentObject var viewModel: CocktailDetailsViewModel
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    var cocktailId: Int
    var cocktailName: String

    var body: some View {
        ScrollView {
            switch viewModel.cocktailUiModel {
            case .loading:
                ProgressView()
            case .content(let cocktailData):
                CocktailDetailContent(cocktail: cocktailData)
            }
        }
                .onAppear {
                    viewModel.fetch(id: cocktailId)
                }
                .navigationBarTitle(cocktailName, displayMode: .inline)
                .navigationBarBackButtonHidden(true)
                .navigationBarItems(leading: backButton)
    }

    var backButton: some View {
        Button(action: {
            presentationMode.wrappedValue.dismiss()
        }, label: {
            HStack {
                Image(systemName: "chevron.left")
                Text("Back")
            }
        })
    }
}

struct CocktailDetailContent: View {
    var cocktail: CocktailFullUiModel

    var body: some View {
        VStack {
            AsyncImage(
                    url: URL(string: "https://image.mixdrinks.org/cocktails/\(cocktail.id)/560/\(cocktail.id).jpg"),
                    content: { image in
                        image.resizable()
                                .aspectRatio(contentMode: .fit)
                    },
                    placeholder: {
                        ProgressView()
                    }
            )
                    .frame(width: .infinity)

            ForEach(cocktail.steps) { element in
                HStack(spacing: 8) {
                    Text("\(element.id)")
                            .padding(8)
                            .background(.green)
                            .cornerRadius(4)

                    Text(element.name)
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                }
                        .padding(.horizontal)
                Divider()
            }
        }
                .frame(height: .infinity)
    }
}