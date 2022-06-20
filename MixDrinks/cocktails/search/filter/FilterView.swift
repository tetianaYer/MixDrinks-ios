//
// Created by Vova Stelmashchuk on 09.06.2022.
//

import SwiftUI

struct FilterView: View {

    @EnvironmentObject var filterViewModel: FilterViewModel

    var body: some View {
        ScrollView {
            LazyVStack {
                Text("Фільтр")
                        .font(.headline)
                        .padding(.vertical)

                Text("Інгрідієнти")
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                        .font(.subheadline)
                        .padding(.horizontal)

                ForEach(filterViewModel.goodUiModels) { good in
                    HStack {
                        Toggle(good.name, isOn: .init(
                                get: {
                                    good.isSelected
                                },
                                set: { state in
                                    filterViewModel.goodClick(goodId: good.id)
                                }
                        ))
                                .toggleStyle(CheckBoxToggleStyle.checkbox)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.horizontal)
                    }
                            .padding(.vertical)
                }

                Text("Інше")
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                        .font(.subheadline)
                        .padding(.horizontal)

                ForEach(filterViewModel.tagUiModels) { tag in
                    HStack {
                        Toggle(tag.name, isOn: .init(
                                get: {
                                    tag.isSelected
                                },
                                set: { state in
                                    filterViewModel.tagClick(tagId: tag.id)
                                }
                        ))
                                .toggleStyle(CheckBoxToggleStyle.checkbox)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.horizontal)
                    }
                            .padding(.vertical)
                }
            }
        }
    }
}