//
// Created by Vova Stelmashchuk on 09.06.2022.
//

import Foundation

final class FilterViewModel: ObservableObject {

    private var selectedFilterStorage: SelectedFilterStorage

    @Published var uiModel: [FilterGroupUiModel] = []

    private var expandGroups: [Int] = []

    private var filterData: Filters = []

    private var selected: SelectedFiltersState = [:]

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
            var filters: Array<FilterItemUiModel> = filterGroup.items.map { filterItem in
                FilterItemUiModel(id: filterItem.id, name: filterItem.name, isSelected: selectedFilterStorage.isSelected(filterGroupId: filterGroup.id, filterId: filterItem.id))
            }

            if (!expandGroups.contains(filterGroup.id)) {
                filters = filters[range: 0..<5]
            }

            return FilterGroupUiModel(id: filterGroup.id, name: filterGroup.name, filters: filters)
        }
    }

    func moreLessClick(id: Int) {
        if (expandGroups.contains(id)) {
            expandGroups.removeAll { existId in
                existId == id
            }
        } else {
            expandGroups.append(id)
        }

        updateUi()
    }

    func filterClick(filterGroupId: Int, filterId: Int) {
        selectedFilterStorage.change(filterGroupId: filterGroupId, filterId: filterId)
    }
}

struct FilterGroupUiModel: Identifiable, Decodable {
    var id: Int
    var name: String
    var filters: [FilterItemUiModel]
}

struct FilterItemUiModel: Identifiable, Decodable {
    var id: Int
    var name: String
    var isSelected: Bool
}

extension Array {

    subscript(range r: Range<Int>) -> Array {
        return Array(self[r])
    }


    subscript(range r: ClosedRange<Int>) -> Array {
        return Array(self[r])
    }
}
