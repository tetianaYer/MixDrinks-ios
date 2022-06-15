//
// Created by Vova Stelmashchuk on 09.06.2022.
//

import SwiftUI

struct FilterView: View {

    @EnvironmentObject var filterViewModel: FilterViewModel

    var body: some View {
        ScrollView {
            VStack {
                Text("Фільт")
                        .font(.body)
                        .padding(.vertical)
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