//
// Created by Vova Stelmashchuk on 09.06.2022.
//

import Foundation

final class FilterViewModel: ObservableObject {

    private var selectedFilterStorage: SelectedFilterStorage

    @Published var tagUiModels: [TagUiModel] = []

    private var tags: [FilterItem] = []

    private var selected: SelectedFilters = SelectedFilters(tagIds: [], toolId: [], goodId: [])

    public init(
            filterDataRepository: FilterDataRepository,
            selectedFilterStorage: SelectedFilterStorage
    ) {
        self.selectedFilterStorage = selectedFilterStorage

        filterDataRepository.addCallback { metaInfo in
            self.tags = metaInfo.tags
            self.updateUi()
        }

        self.selectedFilterStorage.addCallback { filters in
            self.selected = filters
            self.updateUi()
        }
    }

    private func updateUi() {
        tagUiModels = tags.map { filterItem in
            TagUiModel(
                    id: filterItem.id,
                    name: filterItem.name,
                    isSelected: selected.tagIds.contains(filterItem.id)
            )
        }
    }

    func tagClick(tagId: Int) {
        selectedFilterStorage.tagChange(id: tagId)
    }
}

struct TagUiModel: Identifiable, Decodable {
    var id: Int
    var name: String
    var isSelected: Bool
}