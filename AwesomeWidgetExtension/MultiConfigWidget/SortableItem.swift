import AppIntents
import SwiftUI
import Foundation


// 这个类是系统生成的
@available(iOS 16.0, macOS 13.0, watchOS 9.0, tvOS 16.0, *)
struct CarControlAppEntity: AppEntity {
    static var typeDisplayRepresentation = TypeDisplayRepresentation(name: "Car Control")

    @Property(title: "Name")
    var name: String?

    struct CarControlAppEntityQuery: EntityStringQuery {
        func entities(for identifiers: [CarControlAppEntity.ID]) async throws -> [CarControlAppEntity] {
            return allCarControls
        }

        func entities(matching string: String) async throws -> [CarControlAppEntity] {
            var carControlTypes = CarControlType.allCases
            carControlTypes = carControlTypes.filter { $0.name.contains(string) }
            let carControls = carControlTypes.map { CarControlAppEntity(id: $0.rawValue, displayString: $0.name) }
            return carControls
        }

        func suggestedEntities() async throws -> [CarControlAppEntity] {
            let carControlTypes = CarControlType.allCases
            let carControls = carControlTypes.map { CarControlAppEntity(id: $0.rawValue, displayString: $0.name) }
            return carControls
        }
    }
    static var defaultQuery = CarControlAppEntityQuery()

    let id: String // if your identifier is not a String, conform the entity to EntityIdentifierConvertible.
    var displayString: String
    var displayRepresentation: DisplayRepresentation {
        DisplayRepresentation(title: "\(displayString)")
    }

    init(id: String, displayString: String) {
        self.id = id
        self.displayString = displayString
    }
}

extension CarControlAppEntity {
    static var allCarControls: [CarControlAppEntity] {
        CarControlType.allCases.map { CarControlAppEntity(id: $0.rawValue, displayString: $0.name) }
    }
    
    static var defaultCarControls: [CarControlAppEntity] {
        Array(allCarControls.prefix(4))
    }
}

struct AuthorNameItem: AppEntity, Hashable {
    
    let id: String
    var name: String
    static var typeDisplayRepresentation: TypeDisplayRepresentation = "操作项"
    static var defaultQuery = AuthorNameQuery()
    var displayRepresentation: DisplayRepresentation {
        DisplayRepresentation(
            title: LocalizedStringResource(stringLiteral: name)
        )
    }
}

struct AuthorNameQuery: EntityStringQuery {
    func entities(for identifiers: [String]) async throws -> [AuthorNameItem] {
        return []
    }
    
    func entities(matching string: String) async throws -> IntentItemCollection<AuthorNameItem> {
        // 未实现搜索功能
        let sections: [IntentItemSection<AuthorNameItem>] = [IntentItemSection<AuthorNameItem>(
            "Italian Authors",
            items: [IntentItem(AuthorNameItem(id: "0", name: "Alessandro Manzoni")),
                    IntentItem(AuthorNameItem(id: "1", name: "Blessandro Manzoni")),]
        ),
                                                             IntentItemSection<AuthorNameItem>(
            "Russian Authors",
            items: [IntentItem(AuthorNameItem(id: "2", name: "Anton Chekhov")),
                    IntentItem(AuthorNameItem(id: "3", name: "Fyodor Dostoevsky")),]
        )]
        return IntentItemCollection(sections: sections)
    }
    
    
    func suggestedEntities() async throws -> IntentItemCollection<AuthorNameItem> {
        let sections: [IntentItemSection<AuthorNameItem>] = [IntentItemSection<AuthorNameItem>(
            "Italian Authors",
            items: [IntentItem(AuthorNameItem(id: "0", name: "Alessandro Manzoni")),
                    IntentItem(AuthorNameItem(id: "1", name: "Blessandro Manzoni")),]
        ),
                                                             IntentItemSection<AuthorNameItem>(
            "Russian Authors",
            items: [IntentItem(AuthorNameItem(id: "2", name: "Anton Chekhov")),
                    IntentItem(AuthorNameItem(id: "3", name: "Fyodor Dostoevsky")),]
        )]

        return IntentItemCollection(sections: sections)
        
    }
}

extension AuthorNameItem {
    static var allAuthors: [AuthorNameItem] = [
        AuthorNameItem(id: "0", name: "Alessandro Manzoni"),
        AuthorNameItem(id: "1", name: "Blessandro Manzoni"),
        AuthorNameItem(id: "2", name: "Anton Chekhov"),
        AuthorNameItem(id: "3", name: "Fyodor Dostoevsky"),
    ]
    
    
}


// 可排序的操作项
struct SortableItem: AppEntity, Hashable {
    let id: String
    var title: String
    var icon: String?
    
    static var typeDisplayRepresentation: TypeDisplayRepresentation = "操作项"
    static var defaultQuery = SortableItemQuery()
    
    var displayRepresentation: DisplayRepresentation {
        DisplayRepresentation(
            title: LocalizedStringResource(stringLiteral: title),
            image: icon.flatMap { .init(systemName: $0) }
        )
    }
}

// 查询实现
struct SortableItemQuery: EntityQuery {
    func entities(for identifiers: [String]) async throws -> [SortableItem] {
        SortableItem.allItems.filter { identifiers.contains($0.id) }
    }
    
    func suggestedEntities() async throws -> [SortableItem] {
        SortableItem.defaultItems
    }
}

// 示例数据
extension SortableItem {
    static var allItems: [SortableItem] = [
        SortableItem(id: "weather", title: "天气", icon: "cloud.sun"),
        SortableItem(id: "calendar", title: "日历", icon: "calendar"),
        SortableItem(id: "reminders", title: "提醒", icon: "list.bullet"),
        SortableItem(id: "news", title: "新闻", icon: "newspaper")
    ]
    
    static var defaultItems: [SortableItem] {
        Array(allItems.prefix(2))
    }
}

// 背景样式枚举
enum WidgetBackground: String, AppEnum {
    case system, light, dark, accent
    
    static var typeDisplayRepresentation: TypeDisplayRepresentation = "背景样式"
    
    static var caseDisplayRepresentations: [WidgetBackground: DisplayRepresentation] = [
        .system: "系统默认",
        .light: "浅色",
        .dark: "深色",
        .accent: "强调色"
    ]
    
    var color: Color {
        switch self {
        case .system: return Color(.systemBackground)
        case .light: return .white
        case .dark: return .black
        case .accent: return .blue
        }
    }
}

struct ProvinceOption: AppEntity, Hashable {
    let id: String
    let name: String
    
    static var typeDisplayRepresentation: TypeDisplayRepresentation = "省份"
    static var defaultQuery = ProvinceOptionQuery()
    
    var displayRepresentation: DisplayRepresentation {
        DisplayRepresentation(
            title: LocalizedStringResource(stringLiteral: name)
        )
    }
}

struct ProvinceOptionQuery: EntityStringQuery {
    func entities(matching string: String) async throws -> [ProvinceOption] {
        ProvinceOption.allProvinces.filter { string.contains($0.id) }
    }
    
    func entities(for identifiers: [String]) async throws -> [ProvinceOption] {
        ProvinceOption.allProvinces.filter { identifiers.contains($0.id) }
    }

    func suggestedEntities() async throws -> [ProvinceOption] {
        ProvinceOption.allProvinces
    }
}

extension ProvinceOption {
    static var allProvinces: [ProvinceOption] = [
        .init(id: "zhejiang", name: "浙江"),
        .init(id: "jiangsu", name: "江苏"),
    ]
}

struct CityOption: AppEntity, Hashable {
    let id: String
    let name: String
    let province: String
    
    static var typeDisplayRepresentation: TypeDisplayRepresentation = "城市"
    static var defaultQuery = CityOptionQuery()
    
    var displayRepresentation: DisplayRepresentation {
        DisplayRepresentation(
            title: LocalizedStringResource(stringLiteral: "\(name)")
        )
    }
}

struct CityOptionQuery: EntityStringQuery {
    
    @IntentParameterDependency<SortableWidgetConfigIntent>(
        \.$province
    )
    var configIntent
    
    func entities(matching string: String) async throws -> [CityOption] {
        CityOption.allCities.filter { string.contains($0.id) }
    }
    
    func entities(for identifiers: [String]) async throws -> [CityOption] {
        CityOption.allCities.filter { identifiers.contains($0.id) }
    }

    func suggestedEntities() async throws -> [CityOption] {
        guard let configIntent else { return [] }
        return CityOption.allCities.filter { $0.province == configIntent.province.name }
    }
    
}


extension CityOption {
    static var allCities: [CityOption] = [
        // 浙江
        .init(id: "hz", name: "杭州", province: "浙江"),
        .init(id: "nb", name: "宁波", province: "浙江"),
        .init(id: "wz", name: "温州", province: "浙江"),
        
        // 江苏
        .init(id: "nj", name: "南京", province: "江苏"),
        .init(id: "sz", name: "苏州", province: "江苏"),
        .init(id: "wx", name: "无锡", province: "江苏")
    ]
    
    static var defaultCities: [CityOption] {
        [.init(id: "hz", name: "杭州", province: "浙江"),
         .init(id: "nb", name: "宁波", province: "浙江"),
         .init(id: "wz", name: "温州", province: "浙江")]
    }
}
