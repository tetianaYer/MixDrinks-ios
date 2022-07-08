//
// Created by Vova Stelmashchuk on 09.06.2022.
//

import SwiftUI

struct FilterView: View {

    @EnvironmentObject var viewModel: FilterViewModel

    var close: () -> ()

    var body: some View {
        ScrollView {
            LazyVStack {
                ZStack {
                    Text("Фільтр")
                            .font(.headline)
                            .padding(.vertical)

                    HStack {
                        Spacer()
                        Button(action: { close() }, label: { Text("Застосувати") })
                    }
                }
                        .frame(width: .infinity)
                        .padding(.horizontal)

                ForEach(viewModel.uiModel) { element in
                    FilterGroupList(filterGroup: element,
                            onFilterClick: { (id: Int) -> () in
                                viewModel.filterClick(filterGroupId: element.id, filterId: id)
                            },
                            onMoreLessClick: { filterGroupId in viewModel.moreLessClick(id: filterGroupId) },
                            onFilterGroupTextChange: { (id: Int, text: String) -> () in
                                viewModel.filterGroupTextChange(id: id, text: text)
                            }
                    )
                }
            }
        }
    }
}

struct FilterGroupList: View {

    var filterGroup: FilterGroupUiModel
    var onFilterClick: (Int) -> Void
    var onMoreLessClick: (Int) -> Void
    var onFilterGroupTextChange: (Int, String) -> Void

    var body: some View {
        Text(filterGroup.name)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                .font(.subheadline)
                .padding(.horizontal)

        TextField("Пошук", text: .init(
                get: { () -> String in filterGroup.searchText },
                set: { query in onFilterGroupTextChange(filterGroup.id, query) })
        )
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                .font(.subheadline)
                .padding()
                .background(Color(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 0.2662717301)))
                .cornerRadius(20)

        ForEach(filterGroup.filters) { filterItem in
            HStack {
                Toggle(filterItem.name, isOn: .init(
                        get: {
                            filterItem.isSelected
                        },
                        set: { state in
                            onFilterClick(filterItem.filterId)
                        }
                ))
                        .toggleStyle(CheckBoxToggleStyle.checkbox)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)

                if filterItem.futureCount > 0 {
                    Text("\(filterItem.futureCount)")
                            .frame(maxWidth: .infinity, alignment: .trailing)
                            .padding(.horizontal)
                }
            }
                    .padding(.vertical)
        }

        Button(action: { onMoreLessClick(filterGroup.id) }) {
            Text("More/Less")
        }
    }
}