//
// Created by Vova Stelmashchuk on 09.06.2022.
//

import Foundation

final class FilterViewModel: ObservableObject {

    private var selectedFilterStorage: SelectedFilterStorage

    @Published var uiModel: [FilterListUiModel] = []

    private var expandList: [Int] = []

    private var filterData: Filters = []

    private var selected: SelectedFiltersSate = [:]

    public init(
            filterDataRepository: FilterDataRepository,
            selectedFilterStorage: SelectedFilterStorage
    ) {
        self.selectedFilterStorage = selectedFilterStorage

        filterDataRepository.addCallback { metaInfo in
            self.filterData = metaInfo
            self.updateUi()
        }

        self.selectedFilterStorage.addCallback { filters in
            self.selected = filters
            self.updateUi()
        }
    }

    private func updateUi() {
        uiModel = filterData.map { filterGroup in
            FilterListUiModel(id: filterGroup.id, name: filterGroup.name, filters: filterGroup.items.map { filterItem in
                FilterItemUiModel(id: filterItem.id, name: filterItem.name, isSelected: false)
            })
        }
    }

    func moreLessClick(id: Int) {
        if (expandList.contains(id)) {
            expandList.removeAll { existId in
                existId == id
            }
        } else {
            expandList.append(id)
        }
    }

    func filterClick(filterGroupId: Int, filterId: Int) {
        selectedFilterStorage.change(filterGroupId: filterGroupId, filterId: filterId)
    }
}

struct FilterListUiModel: Identifiable, Decodable {
    var id: Int
    var name: String
    var filters: [FilterItemUiModel]
}

struct FilterItemUiModel: Identifiable, Decodable {
    var id: Int
    var name: String
    var isSelected: Bool
}