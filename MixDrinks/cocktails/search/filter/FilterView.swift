//
// Created by Vova Stelmashchuk on 09.06.2022.
//

import SwiftUI

struct FilterView: View {

    @EnvironmentObject var viewModel: FilterViewModel

    var body: some View {
        ScrollView {
            LazyVStack {
                Text("Фільтр")
                        .font(.headline)
                        .padding(.vertical)

                ForEach(viewModel.uiModel) { element in
                    FilterGroupList(filterGroup: element, onFilterClick: { (id: Int) -> () in
                        viewModel.filterClick(filterGroupId: element.id, filterId: id)
                    }, onMoreLessClick: { filterGroupId in viewModel.moreLessClick(id: filterGroupId) })
                }
            }
        }
    }
}

struct FilterGroupList: View {

    var filterGroup: FilterGroupUiModel
    var onFilterClick: (Int) -> Void
    var onMoreLessClick: (Int) -> Void

    var body: some View {
        Text(filterGroup.name)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                .font(.subheadline)
                .padding(.horizontal)

        ForEach(filterGroup.filters) { filterItem in
            HStack {
                Toggle(filterItem.name, isOn: .init(
                        get: {
                            filterItem.isSelected
                        },
                        set: { state in
                            onFilterClick(filterItem.id)
                        }
                ))
                        .toggleStyle(CheckBoxToggleStyle.checkbox)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
            }
                    .padding(.vertical)
        }

        Button(action: { onMoreLessClick(filterGroup.id) }) {
            Text("More/Less")
        }
    }
}