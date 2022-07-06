//
// Created by Vova Stelmashchuk on 09.06.2022.
//

import Foundation
import Alamofire

typealias Filters = [FilterGroupData]

class FilterDataSource {

    private var dataSource: DataSource

    public init(dataSource: DataSource) {
        self.dataSource = dataSource
    }

    func getFilterGroups() -> [FilterGroupData] {
        [
            FilterGroupData(
                    id: 1,
                    queryName: "goods",
                    name: "Інгрідієнти",
                    items: getGoodsFilterItems()),
            FilterGroupData(
                    id: 2,
                    queryName: "tags",
                    name: "Інше",
                    items: getTagFilterItems()),
            FilterGroupData(
                    id: 3,
                    queryName: "tools",
                    name: "Інструменти",
                    items: getToolsFilterItems()),
        ]
    }

    private func getGoodsFilterItems() -> [FilterItemData] {
        dataSource.getGoods().map { item in
            FilterItemData(id: item.id, name: item.name)
        }
    }

    private func getToolsFilterItems() -> [FilterItemData] {
        dataSource.getGoods().map { item in
            FilterItemData(id: item.id, name: item.name)
        }
    }

    private func getTagFilterItems() -> [FilterItemData] {
        dataSource.getTags().map { tag in
            FilterItemData(id: tag.id, name: tag.name)
        }
    }
}

struct FilterGroupData: Decodable {
    let id: Int
    let queryName: String
    let name: String
    let items: [FilterItemData]
}

struct FilterItemData: Decodable {
    let id: Int
    let name: String
}
