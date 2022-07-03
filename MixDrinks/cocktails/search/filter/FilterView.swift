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

                ForEach(filterViewModel.uiModel) { element in
                    FilterList(name: element.name, filterItems: element.filters) { (id: Int) -> () in
                        filterViewModel.filterClick(filterGroupId: element.id, filterId: id)
                    }
                }
            }
        }
    }
}

struct FilterList: View {

    var name: String
    var filterItems: [FilterItemUiModel]
    var onClick: (Int) -> Void

    var body: some View {
        Text(name)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                .font(.subheadline)
                .padding(.horizontal)

        ForEach(filterItems) { tag in
            HStack {
                Toggle(tag.name, isOn: .init(
                        get: {
                            tag.isSelected
                        },
                        set: { state in
                            onClick(tag.id)
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