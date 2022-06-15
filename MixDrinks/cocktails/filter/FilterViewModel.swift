//
// Created by Vova Stelmashchuk on 09.06.2022.
//

import Foundation

final class FilterViewModel: ObservableObject {

    @Published var tagUiModels: [TagUiModel] = []

    private var tags: [Int: String] = [:]

    private var selected: SelectedFilters = SelectedFilters(tagIds: [], toolId: [], goodId: [])

    public init() {
        FilterDataRepository.shared.addCallback { metaInfo in
            self.tags = metaInfo.tags
            self.updateUi()
        }
        SelectedFilterStorage.shared.addCallback { filters in
            self.selected = filters
            self.updateUi()
        }
    }

    private func updateUi() {
        tagUiModels = tags.map { key, value in
            TagUiModel(id: key, name: value, isSelected: selected.tagIds.contains(key))
        }
    }

    func tagClick(tagId: Int) {
        SelectedFilterStorage.shared.tagChange(id: tagId)
    }
}

struct TagUiModel: Identifiable, Decodable {
    var id: Int
    var name: String
    var isSelected: Bool
}