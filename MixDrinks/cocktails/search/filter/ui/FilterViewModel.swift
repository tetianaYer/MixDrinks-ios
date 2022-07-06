//
// Created by Vova Stelmashchuk on 09.06.2022.
//

import Foundation

final class FilterViewModel: ObservableObject {

    private var selectedFilterStorage: FilterSelectedStorage
    private var filterSearchStorage: FilterSearchStorage
    private var filterExpandsStorage: FilterExpandsStorage

    @Published var uiModel: [FilterGroupUiModel] = []

    private var filterData: Filters = []

    public init(
            selectedFilterStorage: FilterSelectedStorage,
            filterSearchStorage: FilterSearchStorage,
            filterExpandsStorage: FilterExpandsStorage,
            filterStateProvider: FilterStateProvider
    ) {
        self.selectedFilterStorage = selectedFilterStorage
        self.filterSearchStorage = filterSearchStorage
        self.filterExpandsStorage = filterExpandsStorage

        filterStateProvider.addCallback { groups in
            self.updateUi(groups: groups)
        }
    }

    private func updateUi(groups: [FilterGroup]) {
        uiModel = groups.map { group -> FilterGroupUiModel in
            FilterGroupUiModel(
                    id: group.id,
                    name: group.name,
                    filters: group.filters.map { model -> FilterItemUiModel in
                        FilterItemUiModel(filterId: model.filterId, name: model.name, isSelected: model.isSelected)
                    }, filterGroupButtonState: .less
            )
        }
    }

    func filterGroupTextChange(id: Int, text: String) {
        filterSearchStorage.set(query: text, for: id)
    }

    func moreLessClick(id: Int) {
        filterExpandsStorage.changeExpand(filterGroupId: id)
    }

    func filterClick(filterGroupId: Int, filterId: Int) {
        selectedFilterStorage.change(filterGroupId: filterGroupId, filterId: filterId)
    }
}

struct FilterGroupUiModel: Identifiable {
    var id: Int
    var name: String
    var searchText: String = ""
    var filters: [FilterItemUiModel]
    var filterGroupButtonState: FilterGroupButtonState
}

enum FilterGroupButtonState {
    case more
    case less
}

struct FilterItemUiModel: Identifiable {
    let id = UUID()
    let filterId: Int
    let name: String
    let isSelected: Bool
}

