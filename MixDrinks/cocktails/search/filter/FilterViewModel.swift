//
// Created by Vova Stelmashchuk on 09.06.2022.
//

import Foundation

final class FilterViewModel: ObservableObject {

    private var selectedFilterStorage: SelectedFilterStorage

    @Published var tagUiModels: [FilterItemUiModel] = []
    @Published var goodUiModels: [FilterItemUiModel] = []

    private var tags: [FilterItem] = []
    private var goods: [FilterItem] = []

    private var selected: SelectedFilters = SelectedFilters(tagIds: [], toolId: [], goodId: [])

    public init(
            filterDataRepository: FilterDataRepository,
            selectedFilterStorage: SelectedFilterStorage
    ) {
        self.selectedFilterStorage = selectedFilterStorage

        filterDataRepository.addCallback { metaInfo in
            self.tags = metaInfo.tags
            self.goods = metaInfo.goods
            self.updateUi()
        }

        self.selectedFilterStorage.addCallback { filters in
            self.selected = filters
            self.updateUi()
        }
    }

    private func updateUi() {
        tagUiModels = tags.map { tag in
            FilterItemUiModel(
                    id: tag.id,
                    name: tag.name,
                    isSelected: selected.tagIds.contains(tag.id)
            )
        }

        goodUiModels = goods.map { goods in
            FilterItemUiModel(
                    id: goods.id,
                    name: goods.name,
                    isSelected: selected.goodId.contains(goods.id)
            )
        }
    }

    func tagClick(tagId: Int) {
        selectedFilterStorage.tagChange(id: tagId)
    }

    func goodClick(goodId: Int) {
        selectedFilterStorage.goodChange(id: goodId)
    }
}

struct FilterItemUiModel: Identifiable, Decodable {
    var id: Int
    var name: String
    var isSelected: Bool
}